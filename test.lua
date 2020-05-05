local counter = 0
local endpoints = {
  "/foo",
  "/bar",
  "/baz",
  "/alice",
  "/bob",
  "/carol"
}

function request()
  counter = counter + 1

  return wrk.format("GET", endpoints[(counter % #endpoints) + 1])
end
