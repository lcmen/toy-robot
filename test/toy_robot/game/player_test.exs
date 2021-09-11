defmodule ToyRobot.Game.PlayerTest do
  use ExUnit.Case, async: true

  alias ToyRobot.{Game.Player, Robot, Table}

  setup do
    position = %{north: 0, east: 0, facing: :north}
    table = %Table{north_boundary: 4, east_boundary: 4}
    Registry.start_link(keys: :unique, name: :player_test)
    %{position: position, registry_id: :player_test, table: table}
  end

  test "it initializes the robot on initial position", %{position: position, registry_id: registry_id, table: table} do
    {:ok, %{robot: robot}} =
      Player.init(
        registry_id: registry_id,
        table: table,
        position: position,
        name: Player.process_name(registry_id, "Joanna")
      )

    assert robot.north == 0
    assert robot.east == 0
    assert robot.facing == :north
  end

  test "it initializes the robot on a random available field if initial possition is occupied", %{
    position: position,
    registry_id: registry_id,
    table: table
  } do
    Player.start_link(
      registry_id: registry_id,
      table: table,
      position: %{north: 0, east: 0, facing: :west},
      name: "Joanna"
    )

    {:ok, %{robot: robot}} =
      Player.init(
        registry_id: registry_id,
        table: table,
        position: position,
        name: Player.process_name(registry_id, "Bobbie")
      )

    refute match?(%{north: 0, east: 0}, robot)
    assert robot.facing == :north
  end

  test "it moves the robot", %{position: position, table: table} do
    {:ok, player} = Player.start(table, position)
    :ok = Player.move(player)

    assert Player.report(player) == %Robot{north: 1, east: 0, facing: :north}
  end

  test "it shows the current position of the robot", %{position: position, table: table} do
    {:ok, player} = Player.start(table, position)
    assert Player.report(player) == %Robot{north: 0, east: 0, facing: :north}
  end
end
