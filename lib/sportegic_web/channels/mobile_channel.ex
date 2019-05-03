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
    if(Mix.env() == :dev) do
      push(socket, "send_verification", %{status: "ok", mobile: country <> mobile})
    else
      country = String.trim(country)
      mobile = sanitize_mobile(mobile)

      {:ok, %Tesla.Env{status: status} = response} =
        mobile
        |> String.replace_prefix("", country)
        |> Communication.send_verification_code()

      case status do
        201 ->
          %Tesla.Env{body: %{"to" => to}} = response
          push(socket, "send_verification", %{status: "ok", mobile: to})

        _ ->
          push(socket, "send_verification", %{status: "error"})
      end
    end

    {:noreply, socket}
  end

  def handle_in("check_code", %{"code" => code, "country" => country, "mobile" => mobile}, socket) do
    if(Mix.env() == :dev) do
      push(socket, "check_code", %{status: "ok"})
    else
      country = String.trim(country)
      mobile = sanitize_mobile(mobile)
      code = sanitize_mobile(code)

      {:ok, %Tesla.Env{body: %{"status" => state}, status: status}} =
        mobile
        |> String.replace_prefix("", country)
        |> Communication.check_verification_code(code)

      case [status, state] do
        [200, "approved"] ->
          push(socket, "check_code", %{status: "ok"})

        _ ->
          push(socket, "check_code", %{status: "error"})
      end
    end

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp sanitize_mobile(number) do
    number
    |> String.trim()
    |> String.replace(" ", "")
  end
end
