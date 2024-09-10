defmodule MsgServiceWeb.EmailController do
  @moduledoc """
  Email Controller
  """
  use MsgServiceWeb, :controller
  require Logger

  @doc """
  Handle send email
  """
  @spec send(Plug.Conn.t(), map()) :: term() | no_return()
  def send(conn, %{"from" => from, "to" => to, "text" => text_body}) do
    # spawn a async process to send the email
    email_task = Task.async(fn ->
      MsgService.Client.PostMark.send_email(%MsgService.Schema.Email{from: from, to: to, text_body: text_body})
    end)

    {_, %Tesla.Env{body: body, status: status}} = Task.await(email_task)
    conn |> send_resp(status, Jason.encode!(%{message: body["Message"]}))
  end
end
