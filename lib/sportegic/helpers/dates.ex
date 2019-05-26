defmodule Sportegic.Helpers.Dates do
  use Timex
  alias Timex.Duration

  def readable_date_with_day(date) do
    {:ok, date} = Timex.format(date, "{WDfull}, {Mfull} {D}, {YYYY}")
    date
  end

  def readable_date!(date) do
    {:ok, date} = Timex.format(date, "{Mfull} {D}, {YYYY}")
    date
  end

  def readable_time(time) do
    {:ok, time} = Timex.format(time, "{kitchen}")
    time
  end

  def time_until_date(date) do
    case Timex.diff(date, Timex.now(), :days) do
      n when is_integer(n) and n == 0 ->
        "<h6 class='red-text'>This task is due today.</h6>"

      n when is_integer(n) and n < 0 ->
        abs_days = Timex.diff(date, Timex.today(), :days) |> abs() |> Integer.to_string()

        "<h6 class='red-text'>This task is overdue by " <>
          abs_days <> " days. Due date is " <> readable_date!(date) <> "</h6>"

      _ ->
        "<h6>This task is due in " <>
          Integer.to_string(Timex.diff(date, Timex.now(), :days)) <>
          " days. Due Date is " <> readable_date!(date) <> "</h6>"
    end
  end
end
