defmodule VideoTutorialsData.Repo.Migrations.CreateAdminStreams do
  use Ecto.Migration

  def change do
    create table(:admin_streams, primary_key: false) do
      add :stream_name, :string, primary_key: true
      add :message_count, :integer, default: 0, null: false
      add :last_message_id, :uuid
      add :last_message_global_position, :integer, default: 0, null: false
    end
  end
end
