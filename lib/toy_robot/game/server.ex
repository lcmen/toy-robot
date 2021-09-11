defmodule ToyRobot.Game.Server do
  use GenServer

  alias ToyRobot.Game.{PlayerSupervisor, Players}
  alias ToyRobot.Table

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(north_boundary: north_boundary, east_boundary: east_boundary) do
    registry_id = String.to_atom("game-#{UUID.uuid4()}")
    Registry.start_link(keys: :unique, name: registry_id)

    {
      :ok,
      %{
        registry_id: registry_id,
        table: %Table{north_boundary: north_boundary, east_boundary: east_boundary}
      }
    }
  end

  def handle_call({:move, name}, _from, %{registry_id: registry_id} = state) do
    Players.move(registry_id, name)

    {:reply, :ok, state}
  end

  def handle_call({:next_position, name}, _from, %{registry_id: registry_id} = state) do
    {:reply, Players.next_position(registry_id, name), state}
  end

  def handle_call({:place, position, name}, _from, %{registry_id: registry_id, table: table} = state) do
    {:ok, _} = PlayerSupervisor.start_child(registry_id, table, position, name)
    {:reply, :ok, state}
  end

  def handle_call(:player_count, _from, %{registry_id: registry_id} = state) do
    {:reply, Registry.count(registry_id), state}
  end

  def handle_call({:position_available, position}, _from, %{registry_id: registry_id} = state) do
    available =
      registry_id
      |> Players.all()
      |> Players.positions()
      |> Players.position_available?(position)

    reply =
      if available do
        :ok
      else
        {:error, :occupied}
      end

    {:reply, reply, state}
  end

  def handle_call({:report, name}, _from, %{registry_id: registry_id} = state) do
    {:reply, Players.report(registry_id, name), state}
  end

  def handle_call({:valid_position, position}, _from, %{table: table} = state) do
    reply =
      if Table.valid_position?(table, position) do
        :ok
      else
        {:error, :out_of_bounds}
      end

    {:reply, reply, state}
  end
end
