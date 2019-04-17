defmodule SportegicWeb.FallbackController do
  use SportegicWeb, :controller

  def call(_conn, args) do
    IO.inspect(args, label: "ERROR IN FALLBACK")
  end
end
