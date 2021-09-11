defmodule ToyRobot.Game.PlayerSupervisorTest do
  use ExUnit.Case, async: true

  alias ToyRobot.{Game.PlayerSupervisor, Table}

  setup do
    start_supervised(PlayerSupervisor)

    position = %{north: 0, east: 0, facing: :north}
    registry_id = String.to_atom("player-supervisor-test-#{UUID.uuid4()}")
    table = %Table{north_boundary: 4, east_boundary: 4}

    Registry.start_link(keys: :unique, name: registry_id)
    {:ok, _} = PlayerSupervisor.start_child(registry_id, table, position, "Izzy")
    [{_, _}] = Registry.lookup(registry_id, "Izzy")

    %{registry_id: registry_id, player_name: "Izzy"}
  end

  test "it moves a robot forward", %{registry_id: registry_id, player_name: player_name} do
    %{north: north} = PlayerSupervisor.report(registry_id, player_name)

    assert north == 0

    :ok = PlayerSupervisor.move(registry_id, player_name)
    %{north: north} = PlayerSupervisor.report(registry_id, player_name)

    assert north == 1
  end
end
