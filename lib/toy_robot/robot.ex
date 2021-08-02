defmodule ToyRobot.Robot do
  alias ToyRobot.Robot

  defstruct north: 0, east: 0, facing: :north

  @doc """
  Move the robot forward one space in the facing direction

  ## Examples

    iex> alias ToyRobot.Robot
    ToyRobot.Robot
    iex> robot = %Robot{north: 0, facing: :north}
    %Robot{north: 0, facing: :north}
    iex> robot |> Robot.move
    %Robot{north: 1, facing: :north}
  """
  def move(%Robot{facing: facing} = robot) do
    case facing do
      :east -> move_east(robot)
      :west -> move_west(robot)
      :north -> move_north(robot)
      :south -> move_south(robot)
    end
  end

  @doc """
  Turn the robot left

  ## Examples

    iex> alias ToyRobot.Robot
    ToyRobot.Robot
    iex> robot = %Robot{facing: :north}
    %Robot{facing: :north}
    iex> robot |> Robot.turn_left
    %Robot{facing: :west}
  """
  def turn_left(%Robot{facing: facing}) do
    case facing do
      :east -> %Robot{facing: :north}
      :west -> %Robot{facing: :south}
      :north -> %Robot{facing: :west}
      :south -> %Robot{facing: :east}
    end
  end

  @doc """
  Turn the robot right

  ## Examples

    iex> alias ToyRobot.Robot
    ToyRobot.Robot
    iex> robot = %Robot{facing: :north}
    %Robot{facing: :north}
    iex> robot |> Robot.turn_right
    %Robot{facing: :east}
  """
  def turn_right(%Robot{facing: facing}) do
    case facing do
      :east -> %Robot{facing: :south}
      :west -> %Robot{facing: :north}
      :north -> %Robot{facing: :east}
      :south -> %Robot{facing: :west}
    end
  end

  defp move_east(robot) do
    %Robot{east: robot.east + 1}
  end

  defp move_west(robot) do
    %Robot{east: robot.east - 1}
  end

  defp move_north(robot) do
    %Robot{north: robot.north + 1}
  end

  defp move_south(robot) do
    %Robot{north: robot.north - 1}
  end
end
