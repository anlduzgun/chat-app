defmodule MessagingAppApiWeb.UserController do

  @moduledoc """
  The `UserController` is responsible for managing user-related actions within the MessagingAppApi application.

  ## Responsibilities

  - Creating a new user and generating an authentication token.
  - Signing in an existing user and generating a new authentication token.
  - Displaying user details.
  - Updating user information.
  - Deleting a user.

  This controller leverages the `Guardian` library for authentication and authorization, and interacts with the `User_context` for database operations.

  ## Plug Usage

  - `is_authorized`: This plug is used to ensure that only authorized users can access certain actions (`update`, `delete`, `show`).

  """

  use MessagingAppApiWeb, :controller

   alias MessagingAppApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias MessagingAppApi.User
  alias MessagingAppApi.Context.User, as: User_context
  action_fallback MessagingAppApiWeb.FallbackController

  import MessagingAppApiWeb.Auth.AuthorizedPlug


  plug :is_authorized when action in [:update, :delete, :show]

  @doc """
  Creates a new user and returns a token upon successful creation.

  `POST api/users/create`

  **Parameters**: 

  - `user_params` (map):

  **Example Usage**:

  ```json
  {
    "user_params": {
    "username": "sample_user", 
    "email": "sample@email.com" , 
    "password_hash": "hashed+password"
    }
  }
  ```
 
  `Response`:
  - `201 Created`: Returns the created user and an authentication token.
  """
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- User_context.create_user(user_params),
          {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:user_token, %{user: user, token: token})
    end
  end

  @doc """
  Authenticates a user and returns a token upon successful sign-in.

  `POST api/users/sign_in`

  **Parameters**:
  email (string): The user's email.
  password_hash (string): The user's password hash.

  **Example Usage**:

  ```json
  {
    "email": "sample@email.com", 
    "password_hash": "hashed+password"
  }
  ```
  `Response`: 
  - `200 OK`: Returns the authenticated user and a token.
  - `401 Unauthorized`: Raises an error if the email or password is incorrect.
  """  
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

  @doc """
  Retrieves and displays user details by ID.  

  `GET api/users/:id`

  **Parameters**:
  - `id`: The user's ID.

  **Example Usage**:
  `GET /api/users/44d2557e-ehb0-a45e-a0cc-f8b5cb83bc6f`

  `Responses`:
  - `200 OK`:Returns the user details.  
  - `401 Unauthorized`: Raises an error if token invalid.
  - `403 Forbidden`: Raises an an error if session id and id paramater don't match 
  """  

  def show(conn, %{"id" => id}) do
    user = User_context.get_user_by_id(id)
    render(conn, :show, user: user)
  end

  @doc """
  Updates an existing user's information.

  `POST api/users/update`

  **Parameters**:
  - `id` (string): The user's ID.
  - `user_params` (map): A map containing the updated user parameters.
 
  **Example Usage**:

  ```json
  { 
    "id": "44d2557e-ehb0-a45e-a0cc-f8b5cb83bc6f",
    "user_params":
      {
      "email": "updated@email.com", 
      "password_hash": "updated+hashed+password"
      }
  }
  ```
  `Response`:
  - `200 OK`: Returns the updated user details.
  - `401 Unauthorized`: Raises an error if token invalid.
  - `403 Forbidden`: Raises an an error if session id and id paramater don't match 

  """  

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = User_context.get_user_by_id(id)

    with {:ok, %User{} = user} <- User_context.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  @doc """
  Deletes a user by ID.

  `DELETE api/users/delete_user/:id`

  **Parameters**:
  - `id`: The user's ID.

  **Example Usage**:
  `DELETE /api/users/delete/44d2557e-ehb0-a45e-a0cc-f8b5cb83bc6f`
  
  `Response`:
  - `204 No Content`: Confirms the user has been deleted.
  - `401 Unauthorized`: Raises an error if token invalid.
  - `403 Forbidden`: Raises an an error if session id and id paramater don't match 

  """  

  def delete(conn, %{"id" => id}) do
    user = User_context.get_user_by_id(id)

    with {:ok, %User{}} <- User_context.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
  

end

