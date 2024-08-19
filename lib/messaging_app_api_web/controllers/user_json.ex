defmodule MessagingAppApiWeb.UserJSON do
  alias MessagingAppApi.User

    @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end
  
  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username
    }
  end
  
  def user_token(%{user: user, token: token}) do
    %{
      id: user.id,
      email: user.email,
      token: token
    }
  end
  

end
