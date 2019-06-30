defmodule Sportegic.MixProject do
  use Mix.Project

  def project do
    [
      app: :sportegic,
      version: "0.1.1",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Sportegic.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.3"},
      {:phoenix_pubsub, "~> 1.1.2"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto, "~> 3.1.2"},
      {:ecto_sql, "~> 3.1.1"},
      {:postgrex, ">= 0.0.0-rc"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:triplex, "~> 1.3.0"},
      {:argon2_elixir, "~> 2.0"},
      {:phoenix_swoosh, "~> 0.2"},
      {:timex, "~> 3.0"},
      {:tesla, "~> 1.2.0"},
      {:hackney, "~> 1.14.0"},
      {:bodyguard, "~> 2.2"},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.1"},
      {:arc_gcs, "~> 0.1.0"},
      {:poison, "~> 3.0"},
      {:ex_money, "~> 3.4"},
      {:html_sanitize_ex, "~> 1.3.0"},
      {:navigation_history, "~> 0.0"},
      {:veritaserum, "~> 0.2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
