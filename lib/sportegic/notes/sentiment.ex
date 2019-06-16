defmodule Sportegic.Notes.Sentiment do
    alias Veritaserum

    @normalisation_param 15

    def build_sentiment_score(subject, details) do
        Veritaserum.analyze([subject, details])
        |> Enum.sum()
        |> normalise_score()
    end

    defp normalise_score(score) do
        score/:math.sqrt(:math.pow(score,2)+ @normalisation_param)
    end

end