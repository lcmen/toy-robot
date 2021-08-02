defmodule ToyRobot.RobotTest do
  use ExUnit.Case
  doctest ToyRobot.Robot

  alias ToyRobot.Robot

  describe "when the robot is facing north" do
    setup do
      %{robot: %Robot{facing: :north}}
    end

    test "it moves one space north", %{robot: robot} do
      robot = robot |> Robot.move()
      assert robot.north == 1
    end
  end

  describe "when the robot is facing south" do
    setup do
      %{robot: %Robot{facing: :south}}
    end

    test "it moves one space south", %{robot: robot} do
      robot = robot |> Robot.move()
      assert robot.north == -1
    end
  end

  describe "when the robot is facing east" do
    setup do
      %{robot: %Robot{facing: :east}}
    end

    test "it moves one space east", %{robot: robot} do
      robot = robot |> Robot.move()
      assert robot.east == 1
    end
  end

  describe "when the robot is facing west" do
    setup do
      %{robot: %Robot{facing: :west}}
    end

    test "it moves one space west", %{robot: robot} do
      robot = robot |> Robot.move()
      assert robot.east == -1
    end
  end
end
