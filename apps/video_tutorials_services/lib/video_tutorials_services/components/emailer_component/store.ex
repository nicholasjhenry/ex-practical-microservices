defmodule VideoTutorialsServices.EmailerComponent.Store do
  # alias VideoTutorialsServices.EmailerComponent.Emailer
  alias VideoTutorialsServices.EmailerComponent.Projection

  use Verity.EntityStore,
    category: :sendEmail,
    entity: Emailer,
    projection: Projection
end
