defmodule VideoTutorialsData.Repo.Migrations.CreateUserCredentials do
  use Ecto.Migration

  def change do
    create table(:user_credentials) do
      add :email, :string, null: false
      add :password_hash, :string, null: false
    end

    create index(:user_credentials, :email)
  end
end
