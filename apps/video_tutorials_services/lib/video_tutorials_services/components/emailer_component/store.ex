defmodule VideoTutorialsServices.EmailerComponent.Store do
  import Verity.Messaging.StreamName

  # use Verity.EntityStore

  # category :sendEmail
  # entity Emailer
  # projection Projection
  # reader MessageStore::Postgres::Read

  alias VideoTutorialsServices.EmailerComponent.Projection

  @category :sendEmail

  def fetch(id) do
    stream_name = stream_name(id, @category)
    MessageStore.fetch(stream_name, Projection)
  end
end
