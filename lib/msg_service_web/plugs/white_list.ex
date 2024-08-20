defmodule MsgServiceWeb.WhiteList do
  @moduledoc """
  Plug to check if the request is coming from a whitelisted IP
  """
  import Plug.Conn

  @doc """
  Initialize the plug
  """
  def init(opts), do: opts

  @doc """
  check if the domain is whitelisted and requests are allowed
  """
  def call(conn, _opts) do
    if whitelisted?(conn) do
      conn
    else
      conn
      |> send_resp(403, "Forbidden")
      |> halt()
    end
  end

  # check the domain or host making the requets to the server
  defp whitelisted?(conn) do
    # TODO: check if the domain is whitelisted
    IO.inspect(conn.host, label: "WHITELIST")
    true
  end

  # Config to check the whitelist of allowed domains
  defp config do
    Application.get_env(:msg_service, :whitelist)
  end
end
