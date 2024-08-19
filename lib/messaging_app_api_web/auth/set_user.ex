defmodule MessagingAppApiWeb.Auth.SetUser do
  import Plug.Conn
  alias MessagingAppApiWeb.Auth.ErrorResponse
  alias MessagingAppApi.Context.User


  def init(_opts) do
    
  end

  def call(conn, _options) do
    if conn.assigns[:user] do
      conn
    else
      user_id = get_session(conn, :user_id)

      if user_id == nil, do: raise ErrorResponse.Unauthorized

      user = User.get_user_by_id(user_id)
      cond do
        user_id && user -> assign(conn, :user, user)
        true -> assign(conn, :user, nil)
      end
    end
  end
end
