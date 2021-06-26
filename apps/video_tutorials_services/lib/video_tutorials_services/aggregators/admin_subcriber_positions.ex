defmodule VideoTutorialsServices.AdminSubscriberPositions do
  # Aggregator

  import Ecto.Query

  alias VideoTutorialsData.{Repo, AdminSubscriberPosition}

  def handle_message(%{stream_name: "components:" <> _, type: "Read"} = message) do
    %{stream_name: stream_name, global_position: message_global_position, position: position} = message
    subscriber_id = stream_to_entity_id(stream_name)

    on_conflict = from(s in AdminSubscriberPosition, where: s.last_message_global_position < ^message_global_position, update: [
          set: [position: ^position, last_message_global_position: ^message_global_position]
        ])

    new_position = %AdminSubscriberPosition{
      subscriber_id: subscriber_id,
      last_message_global_position: message.global_position
    }

    try do
      Repo.insert!(new_position, on_conflict: on_conflict, conflict_target: :subscriber_id)
    rescue _e -> Ecto.StaleEntryError
      :noop
    end

    :ok
  end

  def handle_message(_message), do: :ok

  defp stream_to_entity_id(stream_name) do
    stream_name
    |> String.split("-", parts: 2)
    |> List.last
  end
end
