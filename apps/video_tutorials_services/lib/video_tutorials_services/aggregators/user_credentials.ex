defmodule VideoTutorialsServices.UserCredentials do
  # Aggregator

  alias VideoTutorialsData.{Repo, UserCredential}

  def handle_message(%{type: "Registered"} = event) do
    %{"userId" => user_id, "email" => email, "passwordHash" => password_hash} = event.data

    create_user_credential(user_id, email, password_hash)
  end

  def handle_message(_) do
  end

  def create_user_credential(user_id, email, password_hash) do
    Repo.insert!(
      %UserCredential{id: user_id, email: email, password_hash: to_string(password_hash)},
      on_conflict: :nothing
    )
  end
end
