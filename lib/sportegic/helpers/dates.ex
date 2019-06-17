defmodule Sportegic.Helpers.Dates do
  use Timex

  def readable_date_with_day(date, timezone) do
    {:ok, date} =
      date
      |> Timex.to_datetime(timezone)
      |> Timex.format("{WDfull}, {Mfull} {D}, {YYYY}")

    date
  end

  def readable_date!(date, timezone) do
    {:ok, date} =
      date
      |> Timex.to_datetime(timezone)
      |> Timex.format("{Mfull} {D}, {YYYY}")

    date
  end

  def readable_date!(date) do
    {:ok, date} =
      date
      |> Timex.format("{Mfull} {D}, {YYYY}")

    date
  end
  
  # Date stored in UTC compared to now in UTC
  def days_until(date) do
    Timex.diff(date, Timex.now(), :days)
  end
end
