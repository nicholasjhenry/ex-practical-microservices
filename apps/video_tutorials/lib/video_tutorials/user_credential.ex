defmodule VideoTutorials.UserCredential do
  use VideoTutorials.Schema

  schema "user_credentials" do
    field :email, :string
    field :password_hash, :string
  end
end
