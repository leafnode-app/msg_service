defmodule MsgService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MsgServiceWeb.Telemetry,
      MsgService.Repo,
      {DNSCluster, query: Application.get_env(:msg_service, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MsgService.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MsgService.Finch},
      # Start a worker by calling: MsgService.Worker.start_link(arg)
      # {MsgService.Worker, arg},
      # Start to serve requests, typically the last entry
      MsgServiceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MsgService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MsgServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
