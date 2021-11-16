defmodule VideoTutorialsServices.VideoPublishingComponent.Commands.NameVideoHandlerTest do
  use VideoTutorialsServices.DataCase

  alias VideoTutorialsServices.VideoPublishingComponent.Projection
  alias VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands.NameVideoHandler
  alias VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands.PublishVideoHandler
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.NameVideo
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.PublishVideo

  test "name a video with valid data" do
    publish_video()

    command =
      NameVideo.build(
        %{
          trace_id: UUID.uuid4(),
          user_id: UUID.uuid4(),
          position: 1,
          global_position: 12
        },
        %{
          name: "Prod Bugs Hate This Guy: 42 Things You Didn't Know About JS",
          video_id: "1"
        }
      )

    NameVideoHandler.handle_message(command)

    video_publishing = MessageStore.fetch("videoPublishing-1", Projection)
    assert video_publishing.id == "1"
    assert video_publishing.name == "Prod Bugs Hate This Guy: 42 Things You Didn't Know About JS"
  end

  test "name a video with invalid data" do
    publish_video()

    command =
      NameVideo.build(
        %{
          trace_id: UUID.uuid4(),
          user_id: UUID.uuid4(),
          position: 1,
          global_position: 12
        },
        %{
          name: "",
          video_id: "1"
        }
      )

    NameVideoHandler.handle_message(command)

    video_publishing = MessageStore.fetch("videoPublishing-1", Projection)
    assert video_publishing.id == "1"
    assert video_publishing.name == ""
  end

  def publish_video do
    command = %PublishVideo{
      owner_id: "bb6a04b0-cb74-4981-b73d-24b844ca334f",
      source_uri: "https://sourceurl.com/",
      video_id: "1",
      metadata: %{
        trace_id: UUID.uuid4(),
        user_id: UUID.uuid4()
      }
    }

    context = %{command: command, transcoded_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA"}
    PublishVideoHandler.write_video_published_event(context)
  end
end
