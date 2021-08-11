defmodule ToyRobot.RunnerTest do
  use ExUnit.Case, async: true

  alias ToyRobot.{Runner, Simulation}
  import ExUnit.CaptureIO

  doctest ToyRobot.Runner

  test "it handles a valid place command" do
    %Simulation{robot: robot} = Runner.run([{:place, %{east: 1, north: 2, facing: :north}}])

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end

  test "it handles an invalid place command" do
    simulation = Runner.run([{:place, %{east: 10, north: 10, facing: :north}}])
    assert simulation == nil
  end

  test "it ignores commands until a valid placement" do
    %Simulation{robot: robot} =
      Runner.run([
        :move,
        {:place, %{east: 1, north: 2, facing: :north}}
      ])

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end

  test "it handles a place + move command" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 1, north: 2, facing: :north}},
        :move
      ])

    assert robot.east == 1
    assert robot.north == 3
    assert robot.facing == :north
  end

  test "it handles a place + invalid move command" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 1, north: 4, facing: :north}},
        :move
      ])

    assert robot.east == 1
    assert robot.north == 4
    assert robot.facing == :north
  end

  test "it handles a place + turn_left command" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 1, north: 2, facing: :north}},
        :turn_left
      ])

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :west
  end

  test "it handles a place + turn_right command" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 1, north: 2, facing: :north}},
        :turn_right
      ])

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :east
  end

  test "it handles a place + uturn command" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 1, north: 2, facing: :north}},
        :uturn
      ])

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :south
  end

  test "it handles a place + report command" do
    output =
      capture_io(fn ->
        Runner.run([
          {:place, %{east: 1, north: 2, facing: :north}},
          :report
        ])
      end)

    assert String.trim(output) == "The robot is at (1,2) and is facing NORTH"
  end

  test "it handles a place + invalid command" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 1, north: 2, facing: :north}},
        {:invalid, "EXTERMINATE"}
      ])

    assert robot.east == 1
    assert robot.north == 2
    assert robot.facing == :north
  end

  test "it prevents robot from moving outside of north boundary" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 0, north: 4, facing: :north}},
        :move
      ])

    assert robot.east == 0
    assert robot.north == 4
    assert robot.facing == :north
  end

  test "it prevents robot from moving outside of east boundary" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 4, north: 0, facing: :east}},
        :move
      ])

    assert robot.east == 4
    assert robot.north == 0
    assert robot.facing == :east
  end

  test "it prevents robot from moving outside of south boundary" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 0, north: 0, facing: :south}},
        :move
      ])

    assert robot.east == 0
    assert robot.north == 0
    assert robot.facing == :south
  end

  test "it prevents robot from moving outside of west boundary" do
    %Simulation{robot: robot} =
      Runner.run([
        {:place, %{east: 0, north: 0, facing: :west}},
        :move
      ])

    assert robot.east == 0
    assert robot.north == 0
    assert robot.facing == :west
  end
end
