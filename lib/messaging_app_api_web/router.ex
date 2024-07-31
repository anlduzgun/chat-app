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

  pipeline :auth do
    plug MessagingAppApiWeb.Auth.Pipeline
    plug MessagingAppApiWeb.Auth.SetUser
  end

  scope "/api", MessagingAppApiWeb do
    pipe_through :api
    get "/", DefaultController,  :index
    post "/events/create_event", EventController, :create
    post "/users/create", UserController, :create
    post "/users/sign_in", UserController, :sign_in
  end

  scope "/api", MessagingAppApiWeb do
    pipe_through [:api, :auth]
    get "/events/get_chat_room_by_id/:event_id", EventController, :get_chat_room
    get "/users/get_user_by_id/:id", UserController, :show 
  end
  
end
