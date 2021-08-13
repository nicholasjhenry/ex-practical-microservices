defmodule VideoTutorialsServices.IdentityComponent.Projection do
  alias VideoTutorialsServices.IdentityComponent.Identity

  def init do
    %Identity{registered?: false, registration_email_sent?: false}
  end

  def apply(identity, %{type: "Registered", data: data}) do
    %{identity | id: data["user_id"], email: data["email"], registered?: true}
  end

  def apply(identity, %{type: "RegistrationEmailSent"}) do
    %{identity | registration_email_sent?: true}
  end
end
