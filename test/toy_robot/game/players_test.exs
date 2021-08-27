defmodule ToyRobot.Game.PlayersTest do
  use ExUnit.Case, async: true

  alias ToyRobot.Table
  alias ToyRobot.Game.Players

  setup do
    %{table: %Table{north_boundary: 1, east_boundary: 1}}
  end

  test "it returns available positions", %{table: table} do
    occupied = [%{north: 0, east: 0}]
    assert occupied not in Players.available_positions(occupied, table)
  end

  test "it changes position if it's occupied", %{table: table} do
    occupied_positions = [%{north: 0, east: 0}]
    initial_position = %{north: 0, east: 0, facing: :north}
    new_position = Players.change_position_if_occupied(occupied_positions, table, initial_position)

    assert new_position != initial_position
    assert new_position.facing == initial_position.facing
  end

  test "it does not change position if it's not occupied", %{table: table} do
    initial_position = %{north: 0, east: 0, facing: :north}
    assert Players.change_position_if_occupied([], table, initial_position) == initial_position
  end
end
