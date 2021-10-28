defmodule VideoTutorialsServices.AdminUsers do
  # Aggregator

  import Ecto.Query

  alias VideoTutorialsData.{Repo, AdminUser}

  def handle_message(%{type: "Registered"} = event) do
    ensure_user(event.data["userId"])
    set_email(event.data["userId"], event.data["email"], event.global_position)
  end

  def handle_message(%{type: "RegistrationEmailSent"} = event) do
    ensure_user(event.data["userId"])
    mark_registation_email_sent(event.data["userId"], event.global_position)
  end

  defp ensure_user(id) do
    Repo.insert!(%AdminUser{id: id}, on_conflict: :nothing)
  end

  defp set_email(id, email, global_position) do
    from(u in AdminUser,
      where: [id: ^id],
      where: u.last_identity_event_global_position < ^global_position
    )
    |> Repo.update_all(set: [email: email, last_identity_event_global_position: global_position])
  end

  defp mark_registation_email_sent(id, global_position) do
    from(u in AdminUser,
      where: [id: ^id],
      where: u.last_identity_event_global_position < ^global_position
    )
    |> Repo.update_all(
      set: [registration_email_sent: true, last_identity_event_global_position: global_position]
    )
  end
end
