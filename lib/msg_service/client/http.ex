defmodule MsgService.Client.Http do
  @moduledoc """
  HTTP client used to make requests to other services externally
  """
  use Tesla, only: [:post]

  @default_endpoint "http://localhost:5000"

  plug Tesla.Middleware.BaseUrl, config(:leafnode)
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON

  @doc """
  Make a POST request to the given service
  """
  @spec post(Tesla.Env.url(), Tesla.Env.body()) :: Tesla.Env.result()
  def post(path, params) do
    resp = Tesla.post(path, params)
    IO.inspect(resp, label: "HTTP POST response")
  end

  # Configuration for internal API services calls against main application
  def config do
    Application.get_env(:msg_service, :internal_services, @default_endpoint)
  end
  def config(key) do
    config()[key]
  end
end
