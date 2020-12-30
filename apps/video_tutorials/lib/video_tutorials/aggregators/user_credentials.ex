defmodule VideoTutorials.UserCredentials do
  alias VideoTutorials.{Repo, UserCredential}

  def handle_message(%{type: "Registered"} = event) do
    %{"user_id" => user_id, "email" => email, "password_hash" => password_hash} = event.data

    create_user_credential(user_id, email, password_hash)
  end

  def create_user_credential(user_id, email, password_hash) do
    Repo.insert!(
      %UserCredential{id: user_id, email: email, password_hash: password_hash},
      on_conflict: :nothing
    )
  end
end
