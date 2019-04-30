defmodule Sportegic.Communication do
  require Logger

  use Phoenix.Swoosh,
    view: SportegicWeb.CommunicationView,
    layout: {SportegicWeb.LayoutView, :email}

  import Swoosh.Email

  alias Sportegic.Communication.{Mailer, Token, TwilioVerification}

  @reply_email "do_not_reply@sportegic.com"

  def email_with_token(conn, entity, email, type) do
    send_email(
      generate_url(conn, entity, type),
      email,
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

  def send_verification_code(mobile) do
    mobile
    |> TwilioVerification.send()
  end

  def check_verification_code(mobile, code) do
    mobile
    |> TwilioVerification.check(code)
  end

  defp generate_url(conn, entity, type) do
    if Mix.env() == :dev do
      "http://" <> conn.host <> ":4000/" <> type <> "?token=" <> Token.generate_token(entity)
    else
      "https://" <> conn.host <> "/" <> type <> "?token=" <> Token.generate_token(entity)
    end
  end
end
