defmodule ToyRobot.Runner do
  alias ToyRobot.{Simulation, Table}

  def run([{:place, placement} | rest]) do
    table = %Table{north_boundary: 4, east_boundary: 4}

    case Simulation.place(table, placement) do
      {:ok, simulation} -> run(rest, simulation)
      {:error, :invalid_position} -> run(rest)
    end
  end

  def run([_command | rest]), do: run(rest)
  def run([]), do: nil

  defp run([:move | rest], simulation) do
    new_simulation =
      case Simulation.move(simulation) do
        {:ok, simulation} -> simulation
        {:error, :at_table_boundary} -> simulation
      end

    run(rest, new_simulation)
  end

  defp run([:report | rest], simulation) do
    %{
      east: east,
      north: north,
      facing: facing
    } = Simulation.report(simulation)

    facing = facing |> Atom.to_string() |> String.upcase()

    IO.puts("The robot is at (#{east},#{north}) and is facing #{facing}")

    run(rest, simulation)
  end

  defp run([:turn_left | rest], simulation) do
    {:ok, simulation} = Simulation.turn_left(simulation)
    run(rest, simulation)
  end

  defp run([:turn_right | rest], simulation) do
    {:ok, simulation} = Simulation.turn_right(simulation)
    run(rest, simulation)
  end

  defp run([:uturn | rest], simulation) do
    {:ok, simulation} = Simulation.uturn(simulation)
    run(rest, simulation)
  end

  defp run([{:invalid, _command} | rest], simulation) do
    run(rest, simulation)
  end

  defp run([], simulation), do: simulation
end
