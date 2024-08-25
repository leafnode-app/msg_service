defmodule MsgServiceWeb.WhiteList do
  @moduledoc """
  Plug to check if the request is coming from a whitelisted domain
  """
  import Plug.Conn

  @doc """
  Initialize the plug
  """
  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts), do: opts

  @doc """
  check if the domain is whitelisted and requests are allowed
  """
  # TODO: we can check user agent as the host will always be the current domain and will be false positive in the case for mail
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
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
    conn.host in config()
  end

  # Config to check the whitelist of allowed domains
  defp config do
    Application.get_env(:msg_service, :whitelist)
  end
end
