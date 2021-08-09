defmodule VideoPublishing.TranscodeVideo do
  require Logger

  @fake_transcoding_destination "https://www.youtube.com/watch?v=GI_P3UtZXAA"

  def transcode_video(context) do
    Logger.info("We totally have a video transcoder installed that we are")
    Logger.info("totally calling in this function. If we did not have such")
    Logger.info("an awesome one installed locally, we could call into a")
    Logger.info("3rd-party API here instead.")

    video = context.video
    context = %{context | transcoded_uri: @fake_transcoding_destination}

    Logger.info("Transacode #{video.source_uri} to #{context.transcoded_uri}")

    {:ok, context}
  end
end
