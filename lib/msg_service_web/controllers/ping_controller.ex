defmodule MsgServiceWeb.PingController do
  @moduledoc """
  Ping Controller - used to check if the service is up and running
  """
  use MsgServiceWeb, :controller

  @messages %{
    ok: "ok"
  }

  @doc """
  Ping the service
  """
  def ping(conn, _params) do
    send_resp(conn, 200, Jason.encode!(%{status: @messages.ok}))
  end
end
