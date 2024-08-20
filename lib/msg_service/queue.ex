defmodule MsgService.Queue do
  @moduledoc """
  Queue Server used to add backpressure and manage the processing of messages
  """
  use GenServer

  # rate limit of messages per specific item
  @rate_limit 5_000
  @stale_time 10_000
  @doc """
    Start the server
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
    Init the server payload
  """
  def init(opts) do
    IO.inspect(opts, label: "INIT QUEUE")
    {:ok, opts}
  end

  # TODO: helper functions that will do the GenServer calls
  # TODO add helper methods for process event, get quueue by type, helper function to check rate limit per key
  # TOOD: process or try again for the user if rate limited
  # TODO: function to check cleanup of all keys that are longer older than 10s
end
