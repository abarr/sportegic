import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
mailgun_api_key = System.fetch_env!("MAILGUN_API_KEY")
password = System.fetch_env!("PASSWORD")
twilio_api_key = System.fetch_env!("TWILIO_API_KEY")
twilio_secret_key = System.fetch_env!("TWILIO_SECRET_KEY")
google_credentials = System.fetch_env!("GOOGLE_STORAGE_CREDENTIALS")

config :sportegic, SportegicWeb.Endpoint,
  secret_key_base: secret_key_base

config :sportegic, Sportegic.Repo,
  password: password
  
config :sportegic, Sportegic.Communication.Mailer,
  api_key: mailgun_api_key,
  domain: "mail.sportegic.com"
  
config :arc,
  bucket: "sportegic-uploads"
  

config :goth,
  json: google_credentials |> File.read!

config :sportegic, Sportegic.Communication.TwilioVerification,
  base_url: "https://verify.twilio.com/v2/Services/VA4cb85cee4a011aaf5c4d29edc2399cfd/",
  twilio_api_key: twilio_api_key,
  twilio_secret_key: twilio_secret_key

