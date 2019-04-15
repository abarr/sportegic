defmodule Sportegic.Repo do
  use Ecto.Repo,
    otp_app: :sportegic,
    adapter: Ecto.Adapters.Postgres
end
