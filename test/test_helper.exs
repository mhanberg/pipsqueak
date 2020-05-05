ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Pipsqueak.Repo, :manual)

Application.put_env(:wallaby, :base_url, PipsqueakWeb.Endpoint.url())

{:ok, _} = Application.ensure_all_started(:wallaby)
