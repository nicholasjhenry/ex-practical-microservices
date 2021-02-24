defmodule VideoTutorials.Password do
  def hash(clear_password) do
    {:ok, salt} = :bcrypt.gen_salt()
    {:ok, hash} = :bcrypt.hashpw(clear_password, salt)

    to_string(hash)
  end

  def equal?(clear_password, password_hash) do
    {:ok, hash_as_char} = :bcrypt.hashpw(clear_password, password_hash)
    to_string(hash_as_char) == password_hash
  end
end
