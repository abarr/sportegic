import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
# application_port = System.fetch_env!("PORT")
# port = System.fetch_env!("PORT")
# host = System.fetch_env!("HOST")
# scheme = System.fetch_env!("SCHEME")

config :sportegic, Sportegic.Endpoint,
  secret_key_base: secret_key_base
 

