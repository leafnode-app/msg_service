defmodule MsgServiceWeb.WebhookController do
  @moduledoc """
  Webhook Controller
  """
  use MsgServiceWeb, :controller

  @doc """
  Handle webhook
  """
  def index(conn, params) do
    IO.inspect(conn)
    # Here we add the event check to decide if we need to handle it
    # Either respond to push to queue
    send_resp(conn, 200, "ok")
  end

  # handle the event type
  defp handle_event(event) when event.type == "local" do
    {:ok, :local}
  end
  defp handle_event(_event) do
    {:error, :not_found}
  end
end
