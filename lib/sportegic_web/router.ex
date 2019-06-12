defmodule SportegicWeb.Router do
  use SportegicWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker, excluded_paths: ["/login", ~r(/*new)]
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

    get "/rsvp", AccountController, :rsvp
    post "/rsvp", AccountController, :create_from_rsvp
    get "/request_verification", AccountController, :request_verification
    get "/send_verification", AccountController, :send_verification
    get "/verification", AccountController, :verification
    get "/request_reset", AccountController, :request_reset
    get "/send_reset", AccountController, :send_reset
    get "/new_password", AccountController, :new_password
    get "/update_password", AccountController, :update_password
    resources "/account", AccountController, only: [:new, :create, :index]

    get "/", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    resources "/organisation", OrganisationController, only: [:new, :create, :index]
    get "/set_organisation", OrganisationController, :set_organisation

    get "/user/:id/disable", UserController, :disable
    get "/user/:id/enable", UserController, :enable
    get "/user/invitation", UserController, :invitation
    post "/user/invitation", UserController, :create_invitation
    resources "/user", UserController

    resources "/role", RoleController

    resources "/lookup", LookupController, only: [:index] do
      resources "/type", TypeController
    end

    resources "/person", PersonController do
      resources "/document", DocumentController, except: [:show] do
        resources "/attachment", AttachmentController, only: [:index, :delete]
      end

      resources "/visa", VisaController, except: [:show] do
        resources "/attachment", AttachmentController, only: [:index, :delete]
      end

      resources "/insurance_policy", InsurancePolicyController, except: [:show] do
        resources "/attachment", AttachmentController, only: [:index, :delete]
      end

      resources "/address", AddressController, except: [:show]

      get "/notes/new", NoteController, :new
    end

    resources "/notes", NoteController do
      resources "/comments", CommentController, only: [:create, :delete]
      get "/tasks/new", TaskController, :new
      post "/tasks/new", TaskController, :create
    end

    resources "/tasks", TaskController
  end

  # Other scopes may use custom stacks.
  # scope "/api", SportegicWeb do
  #   pipe_through :api
  # end
end
