defmodule Pipsqueak.Repo.Migrations.TestMigration do
  use Ecto.Migration

  def change do
    IO.puts("migration 1")
  end
end
