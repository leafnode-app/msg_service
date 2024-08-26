defmodule MsgServiceWeb.ServiceType do
  @moduledoc """
  Plug to check if the request is coming from a whitelisted domain
  """

  import Plug.Conn

  @serice_types %{
    "postmark" => :email
  }

  @doc """
  Initialize the plug
  """
  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts), do: opts

  @doc """
  check if the domain is whitelisted and requests are allowed
  """
  # TODO: we can check user agent as the host will always be the current domain and will be false positive in the case for mail
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t() | term()
  def call(conn, _opts) do
    case check_service_type(get_req_header(conn, "user-agent")) do
      {:ok, service_type} ->
        conn
          |> put_private(:service_type, @serice_types[service_type])
      {:error, _reason} ->
        conn
        |> send_resp(403, "Forbidden")
        |> halt()
    end
  end

  # check the domain or host making the requets to the server
  defp check_service_type([agent] = _services) when agent === "Postmark" do
    {:ok, "postmark"}
  end
  defp check_service_type(_agent) do
    {:error, "Invalid service type"}
  end
end
