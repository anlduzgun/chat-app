defmodule MessagingAppApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :messaging_app_api,
  module: MessagingAppApiWeb.Auth.Guardian,
  error_handler: MessagingAppApiWeb.Auth.GuardianErrorHandler
  
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
