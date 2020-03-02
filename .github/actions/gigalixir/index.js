const core = require('@actions/core');
const exec = require('@actions/exec');
const path = require('path');

function wait(seconds) {
  return new Promise(resolve => {
    if (typeof(seconds) !== 'number') { 
      throw new Error('seconds not a number'); 
    }

    core.info(`Waiting ${seconds} seconds...`);

    setTimeout(() => resolve("done!"), seconds * 1000)
  });
}

async function isNextReleaseHealthy(release, app) {
  let releasesOutput = '';

  const options = {
    listeners: {
      stdout: data => {
        releasesOutput += data.toString();
      }
    }
  };

  await exec.exec(`gigalixir ps -a ${app}`, [], options);

  const pods = JSON.parse(releasesOutput).pods;
  const pod = pods[0];

  return pods.length === 1 && parseInt(pod.version) === release && pod.status === "Healthy";
}

async function waitForNewRelease(oldRelease, app, multiplier) {
  if (await isNextReleaseHealthy(oldRelease + 1, app)) {
    return await Promise.resolve(true);
  } else {
    if (multiplier <= 5) {
      await wait(Math.pow(2, multiplier));

      await waitForNewRelease(oldRelease, app, multiplier + 1);
    } else {
      throw "Taking too long for new release to deploy";
    }
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

  const currentRelease = parseInt(JSON.parse(releasesOutput)[0].version);

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
    await waitForNewRelease(currentRelease, gigalixirApp, 1);

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
