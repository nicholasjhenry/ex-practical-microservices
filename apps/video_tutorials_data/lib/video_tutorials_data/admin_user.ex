defmodule VideoTutorialsData.AdminUser do
  use VideoTutorialsData.Schema

  schema "admin_users" do
    field :email, :string
    field :registration_email_sent, :boolean
    field :last_identity_event_global_position, :integer
    field :login_count, :integer
    field :last_authentication_event_global_position, :integer
  end
end
