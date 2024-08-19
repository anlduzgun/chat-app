defmodule MessagingAppApiWeb.Auth.ErrorResponse.Unauthorized do
 defexception [message: "Unauthorized", plug_status: 401] 
end

defmodule MessagingAppApiWeb.Auth.ErrorResponse.Forbidden do
  defexception [message: "Forbidden", plug_status: 403]
end

defmodule MessagingAppApiWeb.Auth.ErrorResponse.NotFound do
  defexception [message: "Not Found", plug_status: 404]
end
