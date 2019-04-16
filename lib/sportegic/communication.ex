defmodule Sportegic.Communication do
  require Logger

  use Phoenix.Swoosh,
    view: SportegicWeb.CommunicationView,
    layout: {SportegicWeb.LayoutView, :email}

  import Swoosh.Email

  alias Sportegic.Communication.{Mailer, Token}

  @reply_email "do_not_reply@sportegic.com"

  def generate_verification_email(conn, user) do
    send_email(
      generate_verification_url(conn, user),
      user.email,
      "verification_email.html",
      @reply_email,
      "Sportegic Email Verification"
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

  defp generate_verification_url(conn, user) do
    if Mix.env() == :dev do
      "http://" <> conn.host <> ":4000/verification?token=" <> Token.generate_token(user)
    else
      "https://" <> conn.host <> "/verification?token=" <> Token.generate_token(user)
    end
  end
end
