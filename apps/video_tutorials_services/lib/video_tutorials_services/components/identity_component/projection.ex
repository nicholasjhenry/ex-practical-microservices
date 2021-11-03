defmodule VideoTutorialsServices.IdentityComponent.Projection do
  use Verity.EntityProjection

  alias VideoTutorialsServices.IdentityComponent.Identity
  alias VideoTutorialsServices.IdentityComponent.Messages.Events.Registered
  alias VideoTutorialsServices.IdentityComponent.Messages.Events.RegistrationEmailSent

  @impl true
  def init do
    %Identity{registered?: false, registration_email_sent?: false}
  end

  @impl true
  def apply(identity, %Registered{} = event) do
    %{identity | id: event.user_id, email: event.email, registered?: true}
  end

  def apply(identity, %RegistrationEmailSent{} = _event) do
    %{identity | registration_email_sent?: true}
  end
end
