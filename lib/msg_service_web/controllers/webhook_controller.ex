defmodule MsgServiceWeb.WebhookController do
  @moduledoc """
  Webhook Controller
  """
  use MsgServiceWeb, :controller
  alias MsgService.Schema.Whatsapp

  @messages %{
    service_not_found: "Service not found",
    invalid_message: "Invalid message",
    ok: "ok"
  }

  @doc """
  Handle webhook
  """
  def index(conn, params) do
    IO.inspect(conn, label: "conn")
    IO.inspect(params, label: "params")

    case message_type(params) do
      {:ok, :local} ->
        # TODO: send the request to the queue
        send_resp(conn, 200, Jason.encode!(%{status: @messages.ok}))
      _ -> send_resp(conn, 404, Jason.encode!(%{status: @messages.service_not_found}))
    end
    # Here we add the event check to decide if we need to handle it
  end

  # handle the event type
  # TODO: look for a more generic way based on the webhook data
  defp message_type(event) when event.type == "local" do
    {:ok, :local}
  end
  defp message_type(_event) do
    {:error, :not_found}
  end
end
