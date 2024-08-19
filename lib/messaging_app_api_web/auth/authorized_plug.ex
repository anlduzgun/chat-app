defmodule MessagingAppApiWeb.Auth.AuthorizedPlug do
  alias MessagingAppApiWeb.Auth.ErrorResponse

  def is_authorized(%{params: %{"id" => id}} = conn, _opts) do
    if conn.assigns.user.id == id do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end

  end
