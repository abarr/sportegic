defmodule Sportegic.Communication do
  require Logger

  use Phoenix.Swoosh,
    view: SportegicWeb.CommunicationView,
    layout: {SportegicWeb.LayoutView, :email}

  import Swoosh.Email

  alias Sportegic.Communication.{Mailer, Token}

  @reply_email "do_not_reply@sportegic.com"

  def generate_email(conn, user, type) do
    send_email(
      generate_url(conn, user, type),
      user.email,
      type <> ".html",
      @reply_email,
      "Sportegic"
    )
  end

  defp send_email(url, email, email_template, from, subject) do
    new()
    |> to(email)
    |> from(from)
    |> subject(subject)
    |> render_body(email_template, %{url: url})
    |> Mailer.deliver()
  end

  defp generate_url(conn, user, type) do
    if Mix.env() == :dev do
      "http://" <> conn.host <> ":4000/" <> type <> "?token=" <> Token.generate_token(user)
    else
      "https://" <> conn.host <> "/" <> type <> "?token=" <> Token.generate_token(user)
    end
  end
end
