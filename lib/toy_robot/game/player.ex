defmodule ToyRobot.Game.Player do
  use GenServer

  alias ToyRobot.{Simulation, Table}

  def start(robot) do
    GenServer.start(__MODULE__, robot)
  end

  def start_link(robot: robot, name: name) do
    GenServer.start_link(__MODULE__, robot, name: process_name(name))
  end

  def move(player) do
    GenServer.cast(player, :move)
  end

  def report(player) do
    GenServer.call(player, :report)
  end

  def process_name(name) do
    {:via, Registry, {ToyRobot.Game.PlayerRegistry, name}}
  end

  def init(robot) do
    simulation = %Simulation{
      table: %Table{north_boundary: 4, east_boundary: 4},
      robot: robot
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
