defmodule VideoTutorialsServices.AdminStreams do
  # Aggregator

  import Ecto.Query

  alias VideoTutorialsData.{Repo, AdminStream}

  def handle_message(message) do
    %{id: message_id, global_position: message_global_position} = message
    on_conflict = from(s in AdminStream, where: s.last_message_global_position < ^message_global_position, update: [
          inc: [message_count: 1],
          set: [last_message_id: ^message_id, last_message_global_position: ^message_global_position]
        ])

    new_stream = %AdminStream{
      stream_name: message.stream_name,
      message_count: 1,
      last_message_id: message.id,
      last_message_global_position: message.global_position
    }

    try do
      Repo.insert!(new_stream, on_conflict: on_conflict, conflict_target: :stream_name)
    rescue _e -> Ecto.StaleEntryError
      :noop
    end

    :ok
  end
end
