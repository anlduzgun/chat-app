defmodule MessagingAppApiWeb.UserSocket do
  use Phoenix.Socket
  
  alias MessagingAppApiWeb.Auth.Guardian


  channel "event:*", MessagingAppApiWeb.EventChannel

  
  @impl true
  def connect(%{"token" => token}, socket) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        case Guardian.resource_from_claims(claims) do
          {:ok, user} ->
            {:ok, assign(socket, :user, user.id)}
          {:error, _reason} ->
            :error
        end
      {:error, _reason} -> :error
    end
  end

  def connect(_params, _socket), do: :error

  @impl true
  def id(socket) do
    if user_id = socket.assigns[:user] do
      "user_socket:#{user_id}"
    else
      nil
    end
  end

end
