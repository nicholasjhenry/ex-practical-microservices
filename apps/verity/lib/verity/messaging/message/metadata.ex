defmodule Messaging.Message.Metadata do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/messages-and-message-data/metadata.html#messaging-message-metadata-class
  """

  defstruct [:user_id, :trace_id, :origin_stream_name]

  def parse(raw) do
    %__MODULE__{
      user_id: raw["userId"],
      trace_id: raw["traceId"],
      origin_stream_name: raw["originStreamName"]
    }
  end

  def to_raw(metadata) do
    %{
      "userId" => metadata.user_id,
      "traceId" => metadata.trace_id,
      "originStreamName" => metadata.origin_stream_name
    }
  end
end
