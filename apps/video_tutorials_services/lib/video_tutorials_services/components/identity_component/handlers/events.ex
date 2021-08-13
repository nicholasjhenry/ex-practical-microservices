defmodule VideoTutorialsServices.IdentityComponent.Handlers.Events do
  alias MessageStore.NewMessage
  alias VideoTutorialsServices.IdentityComponent.Projection

  def handle_message(%{type: "Registered"} = event) do
    send_email(event)
  end

  def handle_message(%{type: "Sent"} = event) do
    record_registration_email(event)
  end

  def handle_message(_) do
    nil
  end

  defp load_identity(context) do
    identity_stream_name = "identity-#{context.identity_id}"

    maybe_identity = MessageStore.fetch(identity_stream_name, Projection)

    Map.put(context, :identity, maybe_identity)
  end

  defp send_email(event) do
    email = %{
      subject: "You're Registered!",
      text: "Foo",
      html: "<p>Foo</p>"
    }

    context = %{identity_id: Map.fetch!(event.data, "user_id"), event: event, email: email}

    with context <- load_identity(context),
         {:ok, context} <- ensure_registration_email_not_sent(context),
         context <- render_registered_email(context),
         _context <- write_send_command(context) do
      {:ok, :registration_email_requested}
    else
      {:error, {:already_sent_registration_email, _context}} -> {:ok, :noop}
    end
  end

  defp ensure_registration_email_not_sent(context) do
    if context.identity.registration_email_sent? do
      {:error, {:already_sent_registration_email, context}}
    else
      {:ok, context}
    end
  end

  defp render_registered_email(context) do
    context
  end

  defp write_send_command(context) do
    event = context.event
    identity = context.identity
    email = context.email
    uuid_v5_namespace = "0c46e0b7-dfaf-443a-b150-053b67905cc2"

    email_id = UUID.uuid5(uuid_v5_namespace, identity.email)

    send_email_command =
      NewMessage.new(
        stream_name: "sendEmail:command-#{email_id}",
        type: "Send",
        metadata: %{
          origin_stream_name: "identity-#{identity.id}",
          trace_id: Map.fetch!(event.metadata, "trace_id"),
          user_id: Map.fetch!(event.metadata, "user_id")
        },
        data: %{
          email_id: email_id,
          to: identity.email,
          subject: email.subject,
          text: email.text,
          html: email.html
        },
        # TODO: review expected version
        expected_version: nil
      )

    MessageStore.write_message(send_email_command)
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
