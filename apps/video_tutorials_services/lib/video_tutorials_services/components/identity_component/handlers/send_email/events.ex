defmodule VideoTutorialsServices.IdentityComponent.Handlers.SendEmail.Events do
  alias MessageStore.NewMessage
  alias VideoTutorialsServices.IdentityComponent.Store

  def handle_message(%{type: "Sent"} = event) do
    record_registration_email(event)
  end

  def handle_message(_) do
    nil
  end

  defp load_identity(context) do
    maybe_identity = Store.fetch(context.identity_id)

    Map.put(context, :identity, maybe_identity)
  end

  defp ensure_registration_email_not_sent(context) do
    if context.identity.registration_email_sent? do
      {:error, {:already_sent_registration_email, context}}
    else
      {:ok, context}
    end
  end

  defp record_registration_email(event) do
    identity_id = stream_name_to_id(event.metadata["origin_stream_name"])
    context = %{identity_id: identity_id, event: event}

    with context <- load_identity(context),
         {:ok, context} <- ensure_registration_email_not_sent(context),
         _context <- write_registration_email_sent_event(context) do
      {:ok, :registration_email_sent}
    else
      {:error, {:already_sent_registration_email, _context}} -> {:ok, :noop}
    end
  end

  defp write_registration_email_sent_event(context) do
    event = context.event

    registered_event =
      NewMessage.new(
        stream_name: "identity-#{context.identity_id}",
        type: "RegistrationEmailSent",
        metadata: %{
          trace_id: Map.fetch!(event.metadata, "trace_id"),
          user_id: context.identity_id
        },
        data: %{
          user_id: context.identity_id,
          email_id: Map.fetch!(event.data, "email_id")
        },
        # TODO
        expected_version: nil
      )

    MessageStore.write_message(registered_event)
  end

  defp stream_name_to_id(stream_name) do
    [_category | rest] = String.split(stream_name, "-")
    Enum.join(rest, "-")
  end
end
