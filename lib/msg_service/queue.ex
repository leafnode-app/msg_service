defmodule MsgService.Queue do
  @moduledoc """
  Queue Server used to add backpressure and manage the processing of messages
  Sliding window log algorithm is used to manage the rate limit
  """
  use GenServer

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

  # TODO: helper functions that will do the GenServer calls
  # TODO add helper methods for process event, get quueue by type, helper function to check rate limit per key
end
