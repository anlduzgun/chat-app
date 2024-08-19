defmodule MessagingAppApiWeb.Router do
  use MessagingAppApiWeb, :router
  
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :user_auth do
    plug MessagingAppApiWeb.Auth.Pipeline.Access
    plug MessagingAppApiWeb.Auth.SetUser
  end

  pipeline :admin_auth do
    plug MessagingAppApiWeb.Auth.Pipeline.Admin
  end

  scope "/api/users", MessagingAppApiWeb do
    pipe_through :api 
    post "/create", UserController, :create
    post "/sign_in", UserController, :sign_in
  end
  
  scope "/api/users", MessagingAppApiWeb do
    pipe_through [:api, :user_auth] 
    get "/:id", UserController, :show
    post "/update", UserController, :update
    delete "/delete", UserController, :delete
  end

  scope "/api/events", MessagingAppApiWeb do
    pipe_through [:api, :admin_auth ]
    post "/create_event", EventController, :create
    get "/get_chat_room_by_id/:event_id", EventController, :get_chat_room
    put "/update", EventController, :update
  end

  scope "/api/events", MessagingAppApiWeb do
    pipe_through :api
  end


  scope "/api/tickets", MessagingAppApiWeb do
    pipe_through [:api, :admin_auth]
    post "/create", TicketController, :create_ticket
  end

  scope "/api/tickets", MessagingAppApiWeb do
    pipe_through [:api, :user_auth]
    patch "/:ticket_id/assign/:user_id", TicketController, :assign_ticket_to_user
  end

  
end
