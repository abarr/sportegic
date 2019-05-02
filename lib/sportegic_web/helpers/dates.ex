defmodule SportegicWeb.Helpers.Dates do
    use Timex
  
    def readable_date_with_day(date) do
      {:ok, date} = Timex.format(date, "{WDfull}, {Mfull} {D}, {YYYY}")
      date
    end
  
    def readable_date(date) do
      {:ok, date} = Timex.format(date, "{Mfull} {D}, {YYYY}")
      date
    end
  
    def readable_time(time) do
      {:ok, time} = Timex.format(time, "{kitchen}")
      time
    end
  end