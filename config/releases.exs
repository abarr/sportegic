import Config

# secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
# mailgun_api_key = System.fetch_env!("MAILGUN_API_KEY")
# password = System.fetch_env!("PASSWORD")
# twilio_api_key = System.fetch_env!("TWILIO_API_KEY")
# twilio_secret_key = System.fetch_env!("TWILIO_API_KEY")

secret_key_base = "OFhwto16KFhJuK6Ic8UvJ7CQ3++5EBAGegEMC1vMoxmopEALSllv/bj1c400buK/"
password = "kiM8s5ngsJbfBEps"
mailgun_api_key = "key-ef2a9b6e6cad2b2beccf0518a6068107"
twilio_api_key = "ACac7881bb3aa9f0bf4ccf9207cb0525cd"
twilio_secret_key = "4cd12ff8f4bbc19ab529f67f55d28e9d"

config :sportegic, SportegicWeb.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "localhost", port: 4000],
  secret_key_base: secret_key_base

config :sportegic, Sportegic.Repo,
  password: password,
  hostname: "host.docker.internal"
  
config :sportegic, Sportegic.Communication.Mailer,
  api_key: mailgun_api_key,
  domain: "mail.sportegic.com"
  
config :arc,
  bucket: "sportegic-uploads"

config :sportegic, Sportegic.Communication.TwilioVerification,
  base_url: "https://verify.twilio.com/v2/Services/VA4cb85cee4a011aaf5c4d29edc2399cfd/",
  twilio_api_key: twilio_api_key,
  twilio_secret_key: twilio_secret_key

