defmodule Pipsqueak.Repo do
  use Ecto.Repo,
    otp_app: :pipsqueak,
    adapter: Ecto.Adapters.Postgres
end
