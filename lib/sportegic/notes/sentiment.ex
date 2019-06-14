defmodule Sportegic.Notes.Sentiment do
    alias Veritaserum

    def build_sentiment_score(subject, details) do
        Veritaserum.analyze([subject, details])
        |> Enum.sum()
    end

end