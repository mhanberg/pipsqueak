defmodule Pipsqueak.Repo.Migrations.TestMigration do
  use Ecto.Migration

  def change do
    unless Enum.member?([:dev, :test], Mix.env()) do
      raise "BOOM"
    end
  end
end
