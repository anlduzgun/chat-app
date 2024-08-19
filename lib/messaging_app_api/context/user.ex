defmodule MessagingAppApi.Context.User do
  
  import Ecto.Query
  alias MessagingAppApi.Repo
  alias MessagingAppApi.User
  
  def list_users do
    Repo.all(User)
  end

  def create_user(params \\%{}) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
 
  def get_user_by_id(id) do
    Repo.get(User,id)
  end

  def get_user_by_email(email) do
    User
    |> where(email: ^email)
    |> Repo.one()
  end

  def update_user(%User{} = user, attrs) do
   user 
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = account) do
    Repo.delete(account)
  end

end
