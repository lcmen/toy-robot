defmodule ToyRobot.Game.Server do
  use GenServer

  alias ToyRobot.{Game.PlayerSupervisor, Table}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def place(game, position, name) do
    case valid_position(game, position) do
      :ok -> GenServer.call(game, {:place, position, name})
      error -> error
    end
  end

  def player_count(game) do
    GenServer.call(game, :player_count)
  end

  def init(north_boundary: north_boundary, east_boundary: east_boundary) do
    registry_id = String.to_atom("game-#{UUID.uuid4()}")
    Registry.start_link(keys: :unique, name: registry_id)

    {
      :ok,
      %{
        players: %{},
        registry_id: registry_id,
        table: %Table{north_boundary: north_boundary, east_boundary: east_boundary}
      }
    }
  end

  defp valid_position(game, position) do
    GenServer.call(game, {:valid_position, position})
  end

  def handle_call(
        {:place, position, name},
        _from,
        %{registry_id: registry_id, table: table} = state
      ) do
    {:ok, _} = PlayerSupervisor.start_child(registry_id, table, position, name)
    {:reply, :ok, state}
  end

  def handle_call(:player_count, _from, %{registry_id: registry_id} = state) do
    {:reply, Registry.count(registry_id), state}
  end

  def handle_call({:valid_position, position}, _from, %{table: table} = state) do
    if Table.valid_position?(table, position) do
      {:reply, :ok, state}
    else
      {:reply, {:error, :out_of_bounds}, state}
    end
  end
end
