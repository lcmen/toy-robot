defmodule ToyRobot.Game.PlayerSupervisor do
  use DynamicSupervisor

  alias ToyRobot.Game.Player

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(registry_id, table, position, name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {
        Player,
        [registry_id: registry_id, table: table, position: position, name: name]
      }
    )
  end

  def move(registry_id, name) do
    Player.move(Player.process_name(registry_id, name))
  end

  def report(registry_id, name) do
    Player.report(Player.process_name(registry_id, name))
  end
end
