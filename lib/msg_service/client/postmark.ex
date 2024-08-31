defmodule MsgService.Client.PostMark do
  @moduledoc """
  HTTP client used to make requests to other services externally
  """
  use Tesla, only: [:post]

  plug Tesla.Middleware.BaseUrl, config(:postmark)
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON

  #TODO: add the add and removal of blacklist requests for domains here

  # Configuration for internal API services calls against main application
  def config do
    Application.get_env(:msg_service, :external_services)
  end
  def config(key) do
    config()[key]
  end
end
