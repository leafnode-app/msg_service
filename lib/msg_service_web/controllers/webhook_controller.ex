defmodule MsgServiceWeb.WebhookController do
  @moduledoc """
  Webhook Controller
  """
  use MsgServiceWeb, :controller

  @messages %{
    service_not_found: "Service not found",
    invalid_message: "Invalid message",
    ok: "ok"
  }

  @doc """
  Handle webhook
  """
  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    case trigger_message_type(conn.private[:service_type], params) do
      {:ok, _struct} ->
        send_resp(conn, 200, Jason.encode!(%{status: @messages.ok}))
      _ -> send_resp(conn, 404, Jason.encode!(%{status: @messages.service_not_found}))
    end
  end

  # handle the event type
  defp trigger_message_type(type, params) when type === :email do
    # {_status, struct} = Email.to_struct(params)
    MsgService.Server.Queue.trigger(:email, params)
    {:ok, params}
  end
  defp trigger_message_type(_type, _params) do
    {:error, @messages.invalid_message}
  end
end
