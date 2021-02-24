defmodule VideoTutorialsData.Repo.Migrations.AddCreatorsPortalVideoOperations do
  use Ecto.Migration

  def change do
    create table(:creators_portal_video_operations) do
      add :trace_id, :binary, null: false
      add :video_id, :binary, null: false
      add :succeeded, :boolean, null: false
      add :failure_reason, :jsonb, null: true
    end

    create index(:creators_portal_video_operations, :trace_id)
    create index(:creators_portal_video_operations, :video_id)
  end
end
