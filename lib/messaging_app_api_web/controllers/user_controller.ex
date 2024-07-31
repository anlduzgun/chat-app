defmodule MessagingAppApiWeb.UserController do
  use MessagingAppApiWeb, :controller

  alias MessagingAppApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias MessagingAppApi.User
  alias MessagingAppApi.Context.User, as: User_context
  action_fallback MessagingAppApiWeb.FallbackController


  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- User_context.create_user(user_params),
          {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:user_token, %{user: user, token: token})
    end
  end
  
  def sign_in(conn, %{"email" => email, "password_hash" => password_hash}) do
    case Guardian.authenticate(email, password_hash) do
      {:ok, user, token} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_status(:ok)
        |> render(:user_token, %{user: user, token: token})
      {:error, :unauthorized} -> raise ErrorResponse.Unauthorized, message: "Email or Password incorrect." 
    end
    
  end

  def show(conn, %{"id" => id}) do
    #user = User_context.get_user_by_id(id)
    render(conn, :show, user: conn.assigns.user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = User_context.get_user_by_id(id)

    with {:ok, %User{} = user} <- User_context.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = User_context.get_user_by_id(id)

    with {:ok, %User{}} <- User_context.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
  

end
