defmodule MessagingAppApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MessagingAppApiWeb.Telemetry,
      MessagingAppApi.Repo,
      {DNSCluster, query: Application.get_env(:messaging_app_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MessagingAppApi.PubSub},
      # Start a worker by calling: MessagingAppApi.Worker.start_link(arg)
      # {MessagingAppApi.Worker, arg},
      # Start to serve requests, typically the last entry
      MessagingAppApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MessagingAppApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MessagingAppApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
