defmodule Pipsqueak.Repo.Migrations.TestMigration2 do
  use Ecto.Migration

  def change do
    IO.puts("migration 2")

    unless Enum.member?([:dev, :test], Mix.env()) do
      raise "BOOM 2"
    end
  end
end
