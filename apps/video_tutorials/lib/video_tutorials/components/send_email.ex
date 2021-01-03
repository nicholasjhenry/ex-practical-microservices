defmodule VideoTutorials.SendEmail do
  alias MessageStore.NewMessage
  alias VideoTutorials.Mailer

  import Bamboo.Email

  defstruct [
    email: nil,
    send_command: nil,
    system_sender_email_address: "foo@example.com",
    just_send_it: nil
  ]

  defmodule EmailProjection do
    defstruct sent?: false

    def init() do
      %__MODULE__{}
    end

    def apply(email, %{type: "Sent"}) do
      Map.put(email, :sent?, true)
    end
  end

  def send(email) do
    Mailer.deliver_now(email)
  end

  def handle(%{type: "Send"} = command) do
    context = %__MODULE__{send_command: command, just_send_it: &send/1}

    with context <- load_email(context),
      {:ok, context} <- ensure_email_has_not_been_sent(context),
      {:ok, context} <- send_email(context),
      _context <- write_sent_event(context) do
        {:ok, :email_sent}
      else
        {:error, {:already_sent_error, _context}} -> {:ok, :noop}
        {:error, {:send_error, context, payload}} -> write_failed_event(context, payload)
    end
  end

  def load_email(context) do
    send_command = context.send_command

    email = MessageStore.fetch("sendEmail-#{send_command.data["email_id"]}", EmailProjection)
    Map.put(context, :email, email)
  end

  def ensure_email_has_not_been_sent(context) do
    if context.email.sent? do
      {:error, {:already_sent_error, context}}
    else
      {:ok, context}
    end
  end

  def send_email(context) do
    send_command = context.send_command
    just_send_it = context.just_send_it

    email = new_email(
      from: context.system_sender_email_address,
      to: Map.fetch!(send_command.data, "to"),
      subject: Map.fetch!(send_command.data, "subject"),
      text_body: Map.fetch!(send_command.data, "text"),
      html_body: Map.fetch!(send_command.data, "html")
    )

    _sent_email = just_send_it.(email)

    {:ok, context}
  end

  def write_sent_event(context) do
    send_command = context.send_command
    stream_name = "sendEmail-#{send_command.data["email_id"]}"

    event = NewMessage.new(
      stream_name: stream_name,
      type: "Sent",
      metadata: %{
        original_stream_name: Map.fetch!(send_command.metadata, "origin_stream_name"),
        trace_id: Map.fetch!(send_command.metadata, "trace_id"),
        user_id: Map.fetch!(send_command.metadata, "user_id")
      },
      data: send_command.data
    )

    MessageStore.write_message(event)
  end

  def write_failed_event(context, error) do
    send_command = context.send_command
    stream_name = "sendEmail-#{send_command.data["email_id"]}"

    event = NewMessage.new(
      stream_name: stream_name,
      type: "Failed",
      metadata: %{
        original_stream_name: Map.fetch!(send_command.metadata, "original_stream_name"),
        trace_id: Map.fetch!(send_command.metadata, "trace_id"),
        user_id: Map.fetch!(send_command.metadata, "user_id")
      },
      data: Map.put(send_command.data, :reason, error.message)
    )

    MessageStore.write_message(event)
  end
end
