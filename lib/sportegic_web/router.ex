defmodule SportegicWeb.Router do
  use SportegicWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SportegicWeb.Plugs.Session
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

    get "/dashboard", DashboardController, :index

    get "/invitation", UserController, :invitation
    get "/request_verification", UserController, :request_verification
    get "/send_verification", UserController, :send_verification
    get "/verification", UserController, :verification
    get "/request_reset", UserController, :request_reset
    get "/send_reset", UserController, :send_reset
    get "/new_password", UserController, :new_password
    get "/update_password", UserController, :update_password
    resources "/user", UserController, only: [:new, :create, :index]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    resources "/organisation", OrganisationController, only: [:new, :create, :index]
    get "/set_organisation", OrganisationController, :set_organisation

    get "/org_user/invitation", OrgUserController, :invitation
    resources "/org_user", OrgUserController

    resources "/role", RoleController
  end

  # Other scopes may use custom stacks.
  # scope "/api", SportegicWeb do
  #   pipe_through :api
  # end
end
