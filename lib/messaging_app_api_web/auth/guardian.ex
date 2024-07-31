defmodule MessagingAppApiWeb.Auth.Guardian do
  use Guardian, otp_app: :messaging_app_api
  alias MessagingAppApi.Context.User
   
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end
  
  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    case User.get_user_by_id(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  def authenticate(email, password) do
    case User.get_user_by_email(email) do
      nil -> {:error, :unauthorized}
      user -> 
        case validate_password(password, user.password_hash) do
          true -> create_token(user) 
          false -> {:error, :unauthorized}
        end
    end
  end


  defp validate_password(password, password_hash) do
    Bcrypt.verify_pass(password, password_hash)
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
