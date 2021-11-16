defmodule VideoTutorialsServices.EmailerComponent.Handlers.Commands do
  use Verity.Messaging.Handler

  alias VideoTutorialsServices.EmailerComponent.Messages.Commands.Send
  alias VideoTutorialsServices.EmailerComponent.Messages.Events.Failed
  alias VideoTutorialsServices.EmailerComponent.Messages.Events.Sent
  alias VideoTutorialsServices.EmailerComponent.Store
  alias VideoTutorialsServices.Mailer

  import Bamboo.Email

  defmodule Context do
    defstruct email: nil,
              send_command: nil,
              system_sender_email_address: "foo@example.com",
              just_send_it: nil
  end

  def handle_message(%Send{} = command) do
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

  def handle_message(_message_data), do: :ok

  defp load_email(%{send_command: send_command} = context) do
    Map.put(context, :email, Store.fetch(send_command.email_id))
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
        to: send_command.to,
        subject: send_command.subject,
        text_body: send_command.text,
        html_body: send_command.html
      )

    _sent_email = just_send_it.(email)

    {:ok, context}
  end

  defp send(email) do
    Mailer.deliver_now(email)
  end

  defp write_sent_event(%{send_command: send_command}) do
    stream_name = stream_name(send_command.email_id, :sendEmail)
    event = Sent.follow(send_command)
    write(event, stream_name)
  end

  # This cannot be called at the moment.
  @dialyzer {:nowarn_function, write_failed_event: 2}

  defp write_failed_event(%{send_command: send_command}, error) do
    stream_name = stream_name(send_command.email_id, :sendEmail)
    event = Failed.follow(send_command, %{reason: error.message})
    write(event, stream_name)
  end
end
