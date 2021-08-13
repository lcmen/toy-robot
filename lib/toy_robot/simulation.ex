defmodule ToyRobot.Simulation do
  alias ToyRobot.{Robot, Table, Simulation}

  defstruct [:table, :robot]

  @doc """
  Move the robot one step forward in facing direction unless,
  unless that position passes the boundaries of the table.

  ## Examples

  ### A valid movement

    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> simulation = %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    iex> Simulation.move(simulation)
    {:ok, %Simulation{table: table, robot: %Robot{north: 1, east: 0, facing: :north}}}

  ### An invalid movement

    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> simulation = %Simulation{table: table, robot: %Robot{north: 4, east: 0, facing: :north}}
    %Simulation{table: table, robot: %Robot{north: 4, east: 0, facing: :north}}
    iex> Simulation.move(simulation)
    {:error, :at_table_boundary}

  """
  def move(%{robot: robot, table: table} = simulation) do
    moved_robot = Robot.move(robot)

    if Table.valid_position?(table, moved_robot) do
      {:ok, %{simulation | robot: moved_robot}}
    else
      {:error, :at_table_boundary}
    end
  end

  @doc """
  Return the robot's current position

  ## Examples

    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> simulation = %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    iex> Simulation.report(simulation)
    %Robot{north: 0, east: 0, facing: :north}

  """
  def report(%Simulation{robot: robot}) do
    robot
  end

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

  @doc """
  Turn the robot left

  ## Examples

    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> simulation = %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    iex> Simulation.turn_left(simulation)
    {:ok, %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :west}}}

  """
  def turn_left(%Simulation{robot: robot} = simulation) do
    {:ok, %{simulation | robot: Robot.turn_left(robot)}}
  end

  @doc """
  Turn the robot right

  ## Examples

    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> simulation = %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    iex> Simulation.turn_right(simulation)
    {:ok, %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :east}}}

  """
  def turn_right(%Simulation{robot: robot} = simulation) do
    {:ok, %{simulation | robot: Robot.turn_right(robot)}}
  end

  @doc """
  Turn the robot in the opposite direction

  ## Examples

    iex> alias ToyRobot.{Robot, Table, Simulation}
    [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> simulation = %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
    iex> Simulation.uturn(simulation)
    {:ok, %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :south}}}

  """
  def uturn(%Simulation{robot: robot} = simulation) do
    {:ok, %{simulation | robot: Robot.uturn(robot)}}
  end
end
