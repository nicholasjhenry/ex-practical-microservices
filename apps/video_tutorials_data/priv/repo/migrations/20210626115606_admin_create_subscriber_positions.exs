defmodule VideoTutorialsData.Repo.Migrations.CreateAdminSubscriberPositions do
  use Ecto.Migration

  def change do
    create table(:admin_subscriber_positions, primary_key: false) do
      add :subscriber_id, :string, primary_key: true
      add :position, :integer, default: 0, null: false
      add :last_message_global_position, :integer, default: 0, null: false
    end
  end
end
