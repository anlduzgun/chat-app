defmodule MessagingAppApi.Repo do
  use Ecto.Repo,
    otp_app: :messaging_app_api,
    adapter: Ecto.Adapters.Postgres
end
