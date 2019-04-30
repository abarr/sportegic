defmodule SportegicWeb.MobileChannel do
  use SportegicWeb, :channel
  alias Sportegic.Communication

  def join("mobile:", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("send_verification", %{"country" => country, "mobile" => mobile}, socket) do
    country = String.trim(country)

    {:ok, %Tesla.Env{body: %{"status" => status, "to" => mobile}, status: response}} =
      mobile
      |> String.trim()
      |> String.replace(" ", "")
      |> String.replace_prefix("", country)
      |> Communication.send_verification_code()

    push(socket, "send_verification", %{status: status, mobile: mobile, response: response})
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (mobile:lobby).
  def handle_in("check_code", %{"code" => code, "country" => country, "mobile" => mobile}, socket) do
    {:ok, response} = Communication.check_verification_code(code, country <> mobile)
    IO.inspect(response)
    push(socket, "check_code", %{status: "ok"})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
