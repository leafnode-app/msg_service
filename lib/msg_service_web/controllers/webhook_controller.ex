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
  # TODO: we need to check hooks for opened, bounced and delivered (index)
  # TOOD: we need to make sure if there is an error we dont return a 200 especially if its bounced so we dont have to deal with them retrying
  # TODO: only nodes that exist we need to manage so we need to make sure we make requets to the main app to check the generated mail and it needs
  def index(conn, params) do
    IO.inspect(conn, label: "LOGGING WEBHOOK CONN DATA")
    IO.inspect(params, label: "LOGGING WEBHOOK PARAMS")
    send_resp(conn, 200, Jason.encode!(%{status: @messages.ok}))
    # case message_type(params) do
    #   {:ok, struct} ->
    #     IO.inspect(struct, label: "SENDING STRUCT TO QUEUE")
    #     # TODO: look for specific data to remove from the struct when sending
    #     # TODO: send the request to the queue
    #     send_resp(conn, 200, Jason.encode!(%{status: @messages.ok}))
    #   _ -> send_resp(conn, 404, Jason.encode!(%{status: @messages.service_not_found}))
    # end
    # Here we add the event check to decide if we need to handle it
  end

  # handle the event type
  # TODO: this would need to use the conn data to get the service caller type which is set on the plug
  defp message_type(payload) do
    case Whatsapp.to_struct(payload) do
      {:ok, payload} ->
        {:ok, payload}
      _ ->
        {:error, @messages.invalid_message}
    end
  end
end
