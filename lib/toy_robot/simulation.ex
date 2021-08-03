defmodule ToyRobot.Simulation do
  alias ToyRobot.{Robot, Table, Simulation}

  defstruct [:table, :robot]

  @doc """
  Simulate robot placement.

  ## Examples

  With valid position:

    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> Simulation.place(table, %{north: 0, east: 0, facing: :north})
    {:ok, %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}}

  With invalid position:

    iex> alias ToyRobot.{Table, Simulation}
    [ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> Simulation.place(table, %{north: 6, east: 0, facing: :north})
    {:error, :invalid_position}
  """
  def place(table, placement) do
    if Table.valid_position?(table, placement) do
      {:ok, %Simulation{table: table, robot: struct(Robot, placement)}}
    else
      {:error, :invalid_position}
    end
  end
end
