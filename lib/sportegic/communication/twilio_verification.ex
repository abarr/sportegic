defmodule Sportegic.Communication.TwilioVerification do
    use Tesla

    plug Tesla.Middleware.BaseUrl, 
        Application.get_env(:sportegic, __MODULE__)[ :base_url]
    plug Tesla.Middleware.FormUrlencoded
    plug Tesla.Middleware.BasicAuth, 
        username: Application.get_env(:sportegic, __MODULE__)[:twilio_api_key], 
        password: Application.get_env(:sportegic, __MODULE__)[:twilio_secret_key]
    plug Tesla.Middleware.JSON

    def send(number) do
        __MODULE__.post("Verifications", %{Channel: "sms", To: number})
    end

    def check(number, code) do
        __MODULE__.post("VerificationCheck", %{To: number, Code: code} )
    end
end
