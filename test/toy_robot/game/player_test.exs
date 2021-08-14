defmodule ToyRobot.Game.PlayerTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Game.Player
  alias ToyRobot.Robot

  setup do
    {:ok, player} = Player.start(%Robot{north: 0, east: 0, facing: :north})
    %{player: player}
  end

  test "it moves the robot", %{player: player} do
    :ok = Player.move(player)

    assert Player.report(player) == %Robot{
             north: 1,
             east: 0,
             facing: :north
           }
  end

  test "it shows the current position of the robot", %{player: player} do
    assert Player.report(player) == %Robot{
             north: 0,
             east: 0,
             facing: :north
           }
  end
end
