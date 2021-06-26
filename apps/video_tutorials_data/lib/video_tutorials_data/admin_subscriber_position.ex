defmodule VideoTutorialsData.AdminSubscriberPosition do
  use VideoTutorialsData.Schema

  @primary_key false

  schema "admin_subscriber_positions" do
    field :subscriber_id, :string, primary_key: true
    field :position, :integer
    field :last_message_global_position, :integer
  end
end
