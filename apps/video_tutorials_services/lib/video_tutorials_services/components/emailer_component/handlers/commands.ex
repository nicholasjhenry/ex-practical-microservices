defmodule VideoTutorialsServices.EmailerComponent.Handlers.Commands do
  import Verity.Messaging.Handle
  import Verity.Messaging.StreamName
  import Verity.Messaging.Write

  alias VideoTutorialsServices.Mailer
  alias VideoTutorialsServices.EmailerComponent.Messages.Events.Failed
  alias VideoTutorialsServices.EmailerComponent.Messages.Events.Sent
  alias VideoTutorialsServices.EmailerComponent.Store

  import Bamboo.Email

  defmodule Context do
    defstruct email: nil,
              send_command: nil,
              system_sender_email_address: "foo@example.com",
              just_send_it: nil
  end

  def handle_message(%{type: "Send"} = command), do: send_email(command)

  defp send_email(command) do
    context = %Context{send_command: command, just_send_it: &send/1}

    with context <- load_email(context),
         {:ok, context} <- ensure_email_has_not_been_sent(context),
         {:ok, context} <- send_it(context),
         _context <- write_sent_event(context) do
      {:ok, :email_sent}
    else
      {:error, {:already_sent_error, _context}} -> {:ok, :noop}
      {:error, {:send_error, context, payload}} -> write_failed_event(context, payload)
    end
  end

  defp load_email(%{send_command: send_command} = context) do
    Map.put(context, :email, Store.fetch(send_command.data["email_id"]))
  end

  defp ensure_email_has_not_been_sent(context) do
    if context.email.sent? do
      {:error, {:already_sent_error, context}}
    else
      {:ok, context}
    end
  end

  defp send_it(context) do
    send_command = context.send_command
    just_send_it = context.just_send_it

    email =
      new_email(
        from: context.system_sender_email_address,
        to: Map.fetch!(send_command.data, "to"),
        subject: Map.fetch!(send_command.data, "subject"),
        text_body: Map.fetch!(send_command.data, "text"),
        html_body: Map.fetch!(send_command.data, "html")
      )

    _sent_email = just_send_it.(email)

    {:ok, context}
  end

  defp send(email) do
    Mailer.deliver_now(email)
  end

  defp write_sent_event(%{send_command: send_command}) do
    stream_name = stream_name(send_command.data["email_id"], :sendEmail)

    event =
      Sent.new(
        %{
          origin_stream_name: Map.fetch!(send_command.metadata, "origin_stream_name"),
          trace_id: Map.fetch!(send_command.metadata, "trace_id"),
          user_id: Map.fetch!(send_command.metadata, "user_id")
        },
        send_command.data
      )

    write(event, stream_name)
  end

  defp write_failed_event(%{send_command: send_command}, error) do
    stream_name = stream_name(send_command.data["email_id"], :sendEmail)

    event =
      Failed.new(
        %{
          original_stream_name: Map.fetch!(send_command.metadata, "original_stream_name"),
          trace_id: Map.fetch!(send_command.metadata, "trace_id"),
          user_id: Map.fetch!(send_command.metadata, "user_id")
        },
        Map.put(send_command.data, :reason, error.message)
      )

    write(event, stream_name)
  end
end
