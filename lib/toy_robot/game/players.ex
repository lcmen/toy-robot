defmodule ToyRobot.Game.Players do
  alias ToyRobot.Game.Player

  def all(registry_id) do
    player_names = Registry.select(registry_id, [{{:"$1", :_, :_}, [], [:"$1"]}])
    Enum.map(player_names, fn name -> Player.process_name(registry_id, name) end)
  end

  def positions(players) do
    Enum.map(players, fn player -> coordinates(Player.report(player)) end)
  end

  def position_available?(positions, position) do
    coordinates(position) not in positions
  end

  defp coordinates(position) do
    Map.take(position, [:north, :east])
  end
end
