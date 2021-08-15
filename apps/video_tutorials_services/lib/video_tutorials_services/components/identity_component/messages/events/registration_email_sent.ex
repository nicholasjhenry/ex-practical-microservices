defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.RegistrationEmailSent do
  alias MessageStore.MessageData

  def follow(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "RegistrationEmailSent",
      metadata: %{
        trace_id: Map.fetch!(message.metadata, "trace_id"),
        user_id: nil
      },
      data: %{
        email_id: Map.fetch!(message.data, "email_id"),
        user_id: nil
      },
      # TODO
      expected_version: nil
    )
  end

  def put_user_id(message, user_id) do
    %{
      message
      | metadata: %{message.metadata | user_id: user_id},
        data: %{message.data | user_id: user_id}
    }
  end
end
