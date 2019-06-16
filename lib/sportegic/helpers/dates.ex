defmodule Sportegic.Helpers.Dates do
  use Timex

  def readable_date_with_day(date) do
    {:ok, date} =
      date
      |> Timex.to_datetime("Australia/Melbourne")
      |> Timex.format("{WDfull}, {Mfull} {D}, {YYYY}")

    date
  end

  def readable_date!(date) do
    {:ok, date} =
      date
      |> Timex.to_datetime("Australia/Melbourne")
      |> Timex.format("{Mfull} {D}, {YYYY}")

    date
  end

  def readable_time(time) do
    {:ok, time} = Timex.format(time, "{kitchen}")
    time
  end

  # Date stored in UTC compred to now in UTC
  def days_until(date) do
    Timex.diff(date, Timex.now(), :days)
  end
end
