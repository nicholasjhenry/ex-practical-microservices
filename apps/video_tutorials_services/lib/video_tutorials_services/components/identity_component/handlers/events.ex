defmodule VideoTutorialsServices.IdentityComponent.Handlers.Events do
  use Verity.Messaging.Handler

  alias VideoTutorialsServices.IdentityComponent.Store
  alias VideoTutorialsServices.EmailerComponent.Messages.Commands.Send

  defmodule Context do
    defstruct [:identity_id, :event, :email]
  end

  @impl true
  def handle_message(%{type: "Registered"} = event), do: send_email(event)
  def handle_message(_), do: nil

  defp send_email(event) do
    context = %Context{
      identity_id: Map.fetch!(event.data, "user_id"),
      event: event,
      email: email()
    }

    with context <- load_identity(context),
         {:ok, context} <- ensure_registration_email_not_sent(context),
         context <- render_registered_email(context),
         _context <- write_send_command(context) do
      {:ok, :registration_email_requested}
    else
      {:error, {:already_sent_registration_email, _context}} -> {:ok, :noop}
    end
  end

  defp email do
    %{
      subject: "You're Registered!",
      text: "Foo",
      html: "<p>Foo</p>"
    }
  end

  defp load_identity(context) do
    Map.put(context, :identity, Store.fetch(context.identity_id))
  end

  defp ensure_registration_email_not_sent(context) do
    if context.identity.registration_email_sent? do
      {:error, {:already_sent_registration_email, context}}
    else
      {:ok, context}
    end
  end

  defp render_registered_email(context), do: context

  defp write_send_command(context) do
    event = context.event
    identity = context.identity
    email = context.email
    uuid_v5_namespace = "0c46e0b7-dfaf-443a-b150-053b67905cc2"

    email_id = UUID.uuid5(uuid_v5_namespace, identity.email)

    stream_name = command_stream_name(email_id, :sendEmail)

    send_email_command =
      Send.new(
        %{
          origin_stream_name: stream_name(identity.id, :identity),
          trace_id: Map.fetch!(event.metadata, "trace_id"),
          user_id: Map.fetch!(event.metadata, "user_id")
        },
        %{
          email_id: email_id,
          to: identity.email,
          subject: email.subject,
          text: email.text,
          html: email.html
        }
      )

    write(send_email_command, stream_name)
  end
end
