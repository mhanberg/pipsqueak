const core = require('@actions/core');
const exec = require('@actions/exec');
const path = require('path');

function wait(milliseconds) {
  return new Promise(resolve => {
    if (typeof(milliseconds) !== 'number') { 
      throw new Error('milleseconds not a number'); 
    }

    setTimeout(() => resolve("done!"), milliseconds)
  });
}

async function waitForNewRelease(oldRelease, app) {
  const currentRelease = await getCurrentRelease(app);

  if (oldRelease === currentRelease) {
    await wait(500);

    waitForNewRelease(oldRelease, app);
  } 
}

async function getCurrentRelease(app) {
  let releasesOutput = '';

  const options = {
    listeners: {
      stdout: data => {
        releasesOutput += data.toString();
      }
    }
  };

  await exec.exec(`gigalixir releases -a ${app}`, [], options);


  const currentRelease = JSON.parse(releasesOutput)[0].version;

  return currentRelease;
}

async function run() {
  try { 
    const gigalixirUsername = core.getInput('GIGALIXIR_USERNAME', { required: true });
    const gigalixirPassword = core.getInput('GIGALIXIR_PASSWORD', { required: true });
    const sshPrivateKey = core.getInput('SSH_PRIVATE_KEY', { required: true });
    const gigalixirApp = core.getInput('GIGALIXIR_APP', { required: true });

    core.info("Installing gigalixir");
    await exec.exec('sudo pip install gigalixir --ignore-installed six')
    core.info("Logging in to gigalixir");
    await exec.exec(`gigalixir login -e "${gigalixirUsername}" -y -p "${gigalixirPassword}"`)
    core.info("Setting git remote for gigalixir");
    await exec.exec(`gigalixir git:remote ${gigalixirApp}`);

    core.info("Getting current release");
    const currentRelease = await getCurrentRelease(gigalixirApp);
    core.info(`The current release is ${currentRelease}`);

    core.info("Deploying to gigalixir");
    await exec.exec("git push -f gigalixir HEAD:refs/heads/master");

    core.info("Fiddling with SSH stuff");
    await exec.exec(path.join(__dirname, "../bin/add-private-key"), [sshPrivateKey]),

    core.info("Waiting for new release to deploy");
    await waitForNewRelease(currentRelease, gigalixirApp);

    try {
      core.info("Running migrations");
      await exec.exec(`gigalixir ps:migrate -a ${gigalixirApp}`)
    } catch (error) {
      core.warning(`Migration failed, rolling back to the previous release: ${currentRelease}`);
      await exec.exec(`gigalixir releases:rollback -a ${gigalixirApp}`)

      core.setFailed(error.message);
    }
  } 
  catch (error) {
    core.setFailed(error.message);
  }
}

run();
