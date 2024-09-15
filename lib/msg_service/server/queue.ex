defmodule MsgService.Server.Queue do
  @moduledoc """
  Queue Server used to add backpressure and manage the processing of messages
  Sliding window log algorithm is used to manage the rate limit
  """
  use GenServer

  @error "Invalid type"

  @doc """
    Start the server
  """
  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
    Init the server payload
  """
  @spec init(Keyword.t()) :: {:ok, Keyword.t()}
  def init(opts) do
    {:ok, opts}
  end

  @doc """
    Trigger the message
  """
  @spec handle_cast({:trigger, map()}, Keyword.t()) :: {:noreply, Keyword.t()}
  def handle_cast({:trigger, request}, state) do
    {:ok, struct} = MsgService.Schema.Email.to_struct(request)
    # TODO: call the spam service to ask if we can
    {_, %Tesla.Env{status: status}} = MsgService.Client.Leafnode.post("/internal/trigger", request)

    # Here we check if we should do anything with what could be potential spamming
    spam_processing(status, struct)
    {:noreply, state}
  end

  # set the spam counter of the user
  defp spam_processing(status, request) when status in [403] do
    MsgService.Server.SpamHandler.trigger(%{
      from: request.from,
    })

    :error
  end
  # We dont do anything assuming the request was successful
  defp spam_processing(_status, _request), do: :ok

  @doc """
    Trigger the message - async
  """
  @spec trigger(atom(), map()) :: any()
  def trigger(type, payload) when type === :email do
    GenServer.cast(__MODULE__, {:trigger, payload})
  end
  def trigger(_type, _payload) do
    {:error, @error}
  end
end
