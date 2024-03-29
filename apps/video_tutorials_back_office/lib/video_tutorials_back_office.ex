defmodule VideoTutorialsBackOffice do
  @moduledoc """
  VideoTutorialsBackOffice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias VideoTutorialsBackOffice.Message
  alias VideoTutorialsData.Repo
  alias VideoTutorialsData.AdminStream
  alias VideoTutorialsData.AdminSubscriberPosition
  alias VideoTutorialsData.AdminUser

  import Ecto.Query, only: [from: 2]

  # Section: Messages

  def list_messages() do
    query = from(messages in Message, order_by: messages.global_position)
    Repo.all(query)
  end

  def list_messages(category: category, user_id: user_id) do
    query =
      from(messages in Message,
        where:
          fragment("message_store.category(?)", messages.stream_name) == type(^category, :string),
        where: fragment("data->>'userId'") == type(^user_id, :string),
        order_by: messages.global_position
      )

    Repo.all(query)
  end

  def list_messages(stream_name: stream_name) do
    query =
      from(messages in Message,
        where: [stream_name: ^stream_name],
        order_by: messages.global_position
      )

    Repo.all(query)
  end

  def list_messages(%{type: type}) do
    query =
      from(messages in Message, order_by: messages.global_position, where: messages.type == ^type)

    Repo.all(query)
  end

  def list_messages(%{trace_id: trace_id}) do
    query =
      from(messages in Message,
        order_by: messages.global_position,
        where: fragment("metadata->>'traceId' = ?", ^trace_id)
      )

    Repo.all(query)
  end

  def get_message!(id) do
    Repo.get!(Message, id)
  end

  # Section: Streams

  def list_streams do
    query = from(stream in AdminStream, order_by: stream.stream_name)
    Repo.all(query)
  end

  # Section: Subscriber Positions

  def list_subscriber_positions do
    query = from(subscriber in AdminSubscriberPosition, order_by: subscriber.subscriber_id)
    Repo.all(query)
  end

  # Section: Users

  def list_users() do
    query = from(user in AdminUser, order_by: user.email)
    Repo.all(query)
  end

  def get_user!(id) do
    Repo.get!(AdminUser, id)
  end
end
