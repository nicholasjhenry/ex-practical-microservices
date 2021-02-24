defmodule CreatorsPortal.Repo.Migrations.AddCreatorsPortalVideos do
  use Ecto.Migration

  def change do
    create table(:creators_portal_videos) do
      add :owner_id, :uuid, null: false
      add :name, :string, null: false
      add :description, :string, null: false
      add :views, :integer, null: false, default: 0
      add :source_uri, :string, null: false
      add :transcoded_uri, :string, null: false
      add :position, :integer, null: false, default: 0
    end

    create index(:creators_portal_videos, :owner_id)
  end
end
