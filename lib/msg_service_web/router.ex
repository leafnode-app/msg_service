defmodule MsgServiceWeb.Router do
  use MsgServiceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MsgServiceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # This checks and sets based on having multiple types in future
  pipeline :service_type do
    plug MsgServiceWeb.ServiceType
  end

  # we make sure the application is sending a valid key
  pipeline :app_key do
    plug MsgServiceWeb.AppKeyCheck
  end

  scope "/email", MsgServiceWeb do
    pipe_through [:app_key, :api]
    post "/send", EmailController, :send
  end

  scope "/webhook", MsgServiceWeb do
    pipe_through [:service_type, :api]
    post "/", WebhookController, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:msg_service, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MsgServiceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
