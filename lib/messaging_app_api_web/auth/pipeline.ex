defmodule MessagingAppApiWeb.Auth.Pipeline.Access do
  use Guardian.Plug.Pipeline, otp_app: :messaging_app_api,
  module: MessagingAppApiWeb.Auth.Guardian,
  error_handler: MessagingAppApiWeb.Auth.GuardianErrorHandler
  
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource
end

defmodule MessagingAppApiWeb.Auth.Pipeline.Admin do
  use Guardian.Plug.Pipeline, otp_app: :messaging_app_api,
  module: MessagingAppApiWeb.Auth.Guardian,
  error_handler: MessagingAppApiWeb.Auth.GuardianErrorHandler
  
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "admin"}
  plug Guardian.Plug.LoadResource
end
