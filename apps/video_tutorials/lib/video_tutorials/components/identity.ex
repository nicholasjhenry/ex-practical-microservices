defmodule VideoTutorials.Identity do
  defstruct [:id, :email, :registered?, :registration_email_sent?]

  alias MessageStore.NewMessage

  defmodule AlreadyRegisteredError do
    defexception [:message]
  end

  def init do
    %__MODULE__{registered?: false, registration_email_sent?: false}
  end

  def apply(identity, %{type: "Registered", data: data}) do
    %{identity | id: data["user_id"], email: data["email"], registered?: true}
  end

  def apply(identity, %{type: "RegistrationEmailSent"}) do
    %{identity | registration_email_sent?: true}
  end

  # Command Handler
  def handle_message(%{type: "Register"} = command) do
    register_user(command)
  end

  # Event Handler
  def handle_message(%{type: "Registered"} = event) do
    send_email(event)
  end

  def register_user(command) do
    context = %{command: command, identity_id: command.data["user_id"], identity: nil}

    context
    |> load_identity
    |> ensure_not_registered
    |> write_registered_event
  end

  defp load_identity(context) do
    identity_stream_name = "identity-#{context.identity_id}"

    maybe_identity = MessageStore.fetch(identity_stream_name, __MODULE__)

    Map.put(context, :identity, maybe_identity)
  end

  defp ensure_not_registered(context) do
    if context.identity.registered? do
      raise AlreadyRegisteredError
    end

    context
  end

  defp write_registered_event(context) do
    command = context.command

    registered_event = NewMessage.new(
      stream_name: "identity-#{command.data["user_id"]}",
      type: "Registered",
      metadata: %{
        trace_id: Map.fetch!(command.metadata, "trace_id"),
        user_id: Map.fetch!(command.metadata, "user_id")
      },
      data: %{
        user_id: Map.fetch!(command.data, "user_id"),
        email: Map.fetch!(command.data, "email"),
        password_hash: Map.fetch!(command.data, "password_hash")
      }
    )

    MessageStore.write_message(registered_event)
  end

  def send_email(event) do
    email =
      %{
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

  def render_registered_email(context) do
    context
  end

  def write_send_command(context) do
    event = context.event
    identity = context.identity
    email = context.email
    uuid_v5_namespace = "0c46e0b7-dfaf-443a-b150-053b67905cc2"

    email_id = UUID.uuid5(uuid_v5_namespace, identity.email)

    send_email_command = NewMessage.new(
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
end
