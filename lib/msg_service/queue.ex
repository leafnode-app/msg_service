defmodule MsgService.Queue do
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
    IO.inspect(opts, label: "INIT QUEUE")
    {:ok, opts}
  end

  @doc """
    Trigger the message
  """
  @spec handle_cast({:trigger, map()}, Keyword.t()) :: {:noreply, Keyword.t()}
  def handle_cast({:trigger, payload}, state) do
    MsgService.Client.Http.post("/internal/trigger/" <> payload["To"], payload)
    {:noreply, state}
  end

  @doc """
    Trigger the message - async
  """
  @spec trigger(atom(), map()) :: any()
  def trigger(type, payload) when type === :email do
    {:ok, GenServer.cast(__MODULE__, {:trigger, payload})}
  end
  def trigger(_type, _payload) do
    {:error, @error}
  end
end
