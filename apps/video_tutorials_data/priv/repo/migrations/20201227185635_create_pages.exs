defmodule VideoTutorialsData.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :name, :string, null: false
      add :data, :jsonb, null: false
    end

    create unique_index(:pages, :name)
  end
end
