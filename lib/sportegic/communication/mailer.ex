defmodule Sportegic.Communication.Mailer do
  use Swoosh.Mailer, otp_app: :sportegic

  def get_environment() do
    Application.get_env(:sportegic, __MODULE__)[:environment]
  end

end
