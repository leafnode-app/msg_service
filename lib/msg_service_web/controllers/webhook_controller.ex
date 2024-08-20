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
    case message_type(params) do
      {:ok, struct} ->
        IO.inspect(struct, label: "SENDING STRUCT TO QUEUE")
        # TODO: look for specific data to remove from the struct when sending
        # TODO: send the request to the queue
        send_resp(conn, 200, Jason.encode!(%{status: @messages.ok}))
      _ -> send_resp(conn, 404, Jason.encode!(%{status: @messages.service_not_found}))
    end
    # Here we add the event check to decide if we need to handle it
  end

  # handle the event type
  # TODO: look for a more generic way based on the webhook data - this assumes whatsapp only
  defp message_type(payload) do
    case Whatsapp.to_struct(payload) do
      {:ok, payload} ->
        {:ok, payload}
      _ ->
        {:error, @messages.invalid_message}
    end
  end
end
