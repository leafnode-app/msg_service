defmodule MsgService.Client.Leafnode do
  @moduledoc """
  HTTP client used to make requests to leafnode application
  """
  use Tesla, only: [:post]

  plug Tesla.Middleware.BaseUrl, config(:leafnode)
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON

  @doc """
  Make a POST request to the given service
  """
  @spec post(Tesla.Env.url(), Tesla.Env.body()) :: Tesla.Env.result()
  def post(path, params) do
    Tesla.post(path, params)
  end

  # Configuration for internal API services calls against main application
  def config do
    Application.get_env(:msg_service, :internal_services)
  end
  def config(key) do
    config()[key]
  end
end
