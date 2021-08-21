defmodule ToyRobot.Game.Player do
  use GenServer

  alias ToyRobot.{Robot, Simulation}

  def start(table, position) do
    GenServer.start(__MODULE__, table: table, position: position)
  end

  def start_link(registry_id: registry_id, table: table, position: position, name: name) do
    GenServer.start_link(
      __MODULE__,
      [
        table: table,
        position: position
      ],
      name: process_name(registry_id, name)
    )
  end

  def move(player) do
    GenServer.cast(player, :move)
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

  def handle_call(:report, _from, simulation) do
    {:reply, Simulation.report(simulation), simulation}
  end

  def handle_cast(:move, simulation) do
    {:ok, new_simulation} = Simulation.move(simulation)
    {:noreply, new_simulation}
  end
end
