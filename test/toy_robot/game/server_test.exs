defmodule ToyRobot.Game.ServerTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Game.Server

  setup do
    {:ok, game} = Server.start_link(north_boundary: 4, east_boundary: 4)
    %{game: game}
  end

  test "it can place a player", %{game: game} do
    :ok = Server.place(game, %{north: 0, east: 0, facing: :north}, "Rosie")
    assert Server.player_count(game) == 1
  end

  test "it cannot place a player out of bounds", %{game: game} do
    res = Server.place(game, %{north: 10, east: 10, facing: :north}, "Eve")
    assert res == {:error, :out_of_bounds}
  end

  test "it cannot place a robot on the field occupied by another robot", %{game: game} do
    position = %{north: 0, east: 0, facing: :north}
    :ok = Server.place(game, position, "Wall-E")
    res = Server.place(game, position, "Robby")
    assert res == {:error, :occupied}
  end
end
