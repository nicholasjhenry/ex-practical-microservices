defmodule VideoTutorialsData.Repo.Migrations.CreateAdminUsers do
  use Ecto.Migration

  def change do
    create table(:admin_users) do
      add :email, :binary
      add :registration_email_sent, :boolean, default: false
      add :last_identity_event_global_position, :integer, default: 0
      add :login_count, :integer, default: 0
      add :last_authentication_event_global_position, :integer, default: 0
    end

    create index(:admin_users, :email)
  end
end
