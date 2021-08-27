defmodule ToyRobot.Game.Player do
  use GenServer

  alias ToyRobot.{Robot, Simulation}
  alias ToyRobot.Game.Players

  def start(table, position) do
    GenServer.start(__MODULE__, table: table, position: position)
  end

  def start_link(registry_id: registry_id, table: table, position: position, name: name) do
    name = process_name(registry_id, name)

    GenServer.start_link(
      __MODULE__,
      [
        registry_id: registry_id,
        table: table,
        position: position,
        name: name
      ],
      name: name
    )
  end

  def move(player) do
    GenServer.cast(player, :move)
  end

  def next_position(player) do
    GenServer.call(player, :next_position)
  end

  def report(player) do
    GenServer.call(player, :report)
  end

  def process_name(registry_id, name) do
    {:via, Registry, {registry_id, name}}
  end

  def init(table: table, position: position) do
    simulation = %Simulation{
      table: table,
      robot: struct(Robot, position)
    }

    {:ok, simulation}
  end

  def init(registry_id: registry_id, table: table, position: position, name: name) do
    position =
      registry_id
      |> Players.all()
      |> Players.except(name)
      |> Players.positions()
      |> Players.change_position_if_occupied(table, position)

    simulation = %Simulation{
      table: table,
      robot: struct(Robot, position)
    }

    {:ok, simulation}
  end

  def handle_call(:next_position, _from, simulation) do
    {:reply, Simulation.next_position(simulation), simulation}
  end

  def handle_call(:report, _from, simulation) do
    {:reply, Simulation.report(simulation), simulation}
  end

  def handle_cast(:move, simulation) do
    {:ok, new_simulation} = Simulation.move(simulation)
    {:noreply, new_simulation}
  end
end
