defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.RegistrationEmailSent do
  alias MessageStore.MessageData

  def follow(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "RegistrationEmailSent",
      metadata: %{
        "traceId" => Map.fetch!(message.metadata, "traceId"),
        "userId" => nil
      },
      data: %{
        "emailId" => Map.fetch!(message.data, "emailId"),
        "userId" => nil
      },
      # TODO
      expected_version: nil
    )
  end

  def put_user_id(message, user_id) do
    %{
      message
      | metadata: %{message.metadata | "userId" => user_id},
        data: %{message.data | "userId" => user_id}
    }
  end
end
