defmodule MsgService.Server.SpamHandler do
  @moduledoc """
  Handle the requests to track and managed if users are spamming to block for a period of time.
  Implements logic that will count if the user makes requets to non existing nodes more than 10 times in 15min period
  """
  use GenServer

  # Unix timestamp of 15min we need to remove this from the current time to check
  @blacklist_timeout 900_000
  @interval 900
  @rate_limit 5

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
    # TODO: Need to init by checking all blacklisted items and grant access on server restart
    {:ok, opts}
  end

  @doc """
    process the spammer
  """
  @spec handle_cast({:process, %{from: String.t()}}, Keyword.t()) :: {:noreply, Keyword.t()}
  def handle_cast({:process, payload}, state) do
    %{from: spammer} = payload

    # Check if the last request was more than 15min ago
    {_, user_state} = check_request(state, spammer)

    # We need to update that piece of state
    state =
      state
      |> Map.put(spammer, user_state)

    # state = if user do
    # end

    {:noreply, state}
  end

  @doc """
  Get the current spammer state
  """
  @spec handle_call(:get_state, term(), Keyword.t()) :: {:reply, map(), map()}
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @doc """
    Get the current spammer
  """
  @spec get_state() :: map()
  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  @doc """
    Trigger the message - async
  """
  @spec trigger(%{from: String.t()}) :: any()
  def trigger(payload) do
    GenServer.cast(__MODULE__, {:process, payload})
  end

  defp check_request(state, user) do
    case Map.get(state, user) do
      nil ->
        IO.inspect("INIT REQUEST")
        {:safe, user_state(:init)}

      user_state ->
        last_ts = Map.get(user_state, :last_ts)
        future = last_ts + @interval

        cond do
          # If the user has hit the rate limit and 15 minutes have not passed
          user_state.count <= @rate_limit and DateTime.utc_now() |> DateTime.to_unix(:second) > future ->
            IO.inspect("SAFE FOR NOW")
            {:safe, user_state(:init)}

          user_state.count >= @rate_limit ->
            IO.inspect("TOO many REQUEST - BLOCKING")
            # TODO: We need to blacklist the user here - reqeust to service
            {_, %Tesla.Env{status: status, body: body} = resp} = MsgService.Client.PostMark.add_trigger_rule(user)
            IO.inspect(resp, label: "POSTMARK")
            # We reset the blocked user
            case block_status(status) do
              :blocked ->
                # Task that will remove the blacklist rule after a set time
                remove_rule(body["ID"])
                {:blocked, user_state(:init)}
              _ ->
                # Incase there was some error, we try again when a new request comes in
                {:blocked, user_state}
            end

          # Increment the request count
          true ->
            IO.inspect("INCREMENTING REQUEST")
            {:safe, user_state(:increment, user_state)}
        end
    end
  end

  # Modify the user_state function to handle resetting the count
  defp user_state(:init) do
    %{
      count: 1,
      last_ts: DateTime.utc_now() |> DateTime.to_unix(:second)
    }
  end
  defp user_state(:increment, user) do
    %{
      count: Map.get(user, :count) + 1,
      last_ts: DateTime.utc_now() |> DateTime.to_unix(:second)
    }
  end

  # check the statys of the response to know if the blacklist was successful
  defp block_status(status) when status in [200] do
    :blocked
  end
  defp block_status(_status), do: :error

  # task that will grant the user access after a set time
  defp remove_rule(id) do
    IO.inspect("BLOCKED")
    # TODO: create a Job service, Genserver, to remove the rule
    # This is for now, not ideal, new process timed
    Task.start(fn ->
      Process.sleep(@blacklist_timeout)
      MsgService.Client.PostMark.remove_trigger_rule(id)
    end)
  end
end
