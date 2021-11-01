defmodule VideoTutorialsServices.IdentityComponent.Handlers.Events.SendEmail do
  use Verity.Messaging.Handler

  alias VideoTutorialsServices.EmailerComponent.Messages.Events.Sent
  alias VideoTutorialsServices.IdentityComponent.Store
  alias VideoTutorialsServices.IdentityComponent.Messages.Events.RegistrationEmailSent

  defmodule Context do
    defstruct [:identity_id, :event]
  end

  @impl true
  def handle_message(%{type: "Sent"} = message_data) do
    message_data |> Sent.parse() |> record_registration_sent
  end

  def handle_message(_), do: nil

  def record_registration_sent(event) do
    identity_id = stream_name_to_id(event.metadata.origin_stream_name)
    context = %Context{identity_id: identity_id, event: event}

    with context <- load_identity(context),
         {:ok, context} <- ensure_registration_email_not_sent(context),
         _context <- write_registration_email_sent_event(context) do
      {:ok, :registration_email_sent}
    else
      {:error, {:already_sent_registration_email, _context}} -> {:ok, :noop}
    end
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

  defp write_registration_email_sent_event(%{event: email_sent, identity_id: identity_id}) do
    stream_name = stream_name(identity_id, :identity)

    registration_email_sent =
      RegistrationEmailSent.build(email_sent.metadata, %{
        email_id: email_sent.email_id,
        user_id: identity_id
      })

    write(registration_email_sent, stream_name)
  end
end
