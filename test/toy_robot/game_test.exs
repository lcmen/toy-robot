defmodule ToyRobot.GameTest do
  use ExUnit.Case

  alias ToyRobot.Game
  alias ToyRobot.Game.PlayerSupervisor

  setup do
    start_supervised(PlayerSupervisor)
    {:ok, game} = Game.start(north_boundary: 4, east_boundary: 4)
    %{game: game}
  end

  test "it can place a player", %{game: game} do
    :ok = Game.place(game, %{north: 0, east: 0, facing: :north}, "Rosie")
    assert Game.player_count(game) == 1
  end

  test "it cannot place a player out of bounds", %{game: game} do
    assert Game.place(game, %{north: 10, east: 10, facing: :north}, "Eve") == {:error, :out_of_bounds}
  end

  test "it cannot place a robot on the field occupied by another robot", %{game: game} do
    position = %{north: 0, east: 0, facing: :north}
    :ok = Game.place(game, position, "Wall-E")
    assert Game.place(game, position, "Robby") == {:error, :occupied}
  end

  test "it can move a player into a free field", %{game: game} do
    :ok = Game.place(game, %{north: 0, east: 0, facing: :east}, "Mr. Roboto")
    :ok = Game.place(game, %{north: 1, east: 0, facing: :north}, "Kit")
    assert Game.move(game, "Mr. Roboto") == :ok
  end

  test "it can't move a player into occupied field", %{game: game} do
    :ok = Game.place(game, %{north: 0, east: 0, facing: :east}, "Marvin")
    :ok = Game.place(game, %{north: 1, east: 0, facing: :south}, "Chappie")
    assert Game.move(game, "Chappie") == {:error, :occupied}
  end

  # test "it can't move a player outside of a table", %{game: game} do
  #   :ok = Game.place(game, %{north: 0, east: 1, facing: :east}, "Pinkie")
  #   :ok = Game.place(game, %{north: 0, east: 0, facing: :south}, "Brain")
  #   assert Game.move(game, "Brain") == {:error, :out_of_bounds}
  # end

  test "it does not a player on occupied field", %{game: game} do
    :ok = Game.place(game, %{north: 0, east: 1, facing: :north}, "Izzy")
    :ok = Game.place(game, %{north: 1, east: 1, facing: :west}, "Davros")
    :ok = Game.move(game, "Davros")
    :ok = Game.move(game, "Izzy")
    :ok = Game.move(game, "Davros")
    :timer.sleep(100)
    refute match?(%{north: 1, east: 1}, Game.report(game, "Davros"))
  end
end
