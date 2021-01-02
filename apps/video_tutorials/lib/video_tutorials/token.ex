defmodule VideoTutorials.Token do
  @salt "1Z73WxH/cDS96wsHXXI8QVAFOy5tg/APqIufGTO8nO2cTn/Mtp7zCnrx+0fSVY1/"
  @expiry 86400 # one day


  def sign(conn, data) do
    Phoenix.Token.sign(conn, @salt, data)
  end


  def verify(conn, token, opts \\ []) do
    Phoenix.Token.verify(conn, @salt, token, max_age: Keyword.get(opts, :max_age, @expiry))
  end
end
