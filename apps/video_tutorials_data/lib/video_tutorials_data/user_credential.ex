defmodule VideoTutorialsData.UserCredential do
  use VideoTutorialsData.Schema

  schema "user_credentials" do
    field :email, :string
    field :password_hash, :string
  end
end
