defmodule VideoTutorialsServices.IdentityComponent.Projection do
  use Verity.EntityProjection

  alias VideoTutorialsServices.IdentityComponent.Identity

  @impl true
  def init do
    %Identity{registered?: false, registration_email_sent?: false}
  end

  @impl true
  def apply(identity, %{type: "Registered", data: data}) do
    %{identity | id: data["user_id"], email: data["email"], registered?: true}
  end

  def apply(identity, %{type: "RegistrationEmailSent"}) do
    %{identity | registration_email_sent?: true}
  end
end
