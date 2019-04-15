defmodule SportegicWeb.Router do
  use SportegicWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() == :dev || :staging do
    scope "/dev" do
      pipe_through [:browser]

      forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
    end
  end

  scope "/", SportegicWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/user", UserController, only: [:new, :create, :index]
    get "/verification", UserController, :verification

    resources "/organisation", OrganisationController, only: [:new, :create, :index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SportegicWeb do
  #   pipe_through :api
  # end
end
