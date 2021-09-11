defmodule ToyRobot.Game.Players do
  alias ToyRobot.Table
  alias ToyRobot.Game.Player

  def all(registry_id) do
    player_names = Registry.select(registry_id, [{{:"$1", :_, :_}, [], [:"$1"]}])
    Enum.map(player_names, fn name -> Player.process_name(registry_id, name) end)
  end

  def except(players, name) do
    Enum.reject(players, &(&1 == name))
  end

  def available_positions(occupied_positions, table) do
    Table.valid_positions(table) -- occupied_positions
  end

  def change_position_if_occupied(occupied_positions, table, position) do
    if position_available?(occupied_positions, position) do
      position
    else
      new_position = Enum.random(available_positions(occupied_positions, table))
      Map.put(new_position, :facing, position.facing)
    end
  end

  def move(registry_id, name) do
    registry_id
    |> Player.process_name(name)
    |> Player.move()
  end

  def next_position(registry_id, name) do
    registry_id
    |> Player.process_name(name)
    |> Player.next_position()
  end

  def positions(players) do
    Enum.map(players, fn player -> coordinates(Player.report(player)) end)
  end

  def position_available?(occupied_positions, position) do
    coordinates(position) not in occupied_positions
  end

  def report(registry_id, name) do
    Player.report(find(registry_id, name))
  end

  defp coordinates(position) do
    Map.take(position, [:north, :east])
  end

  defp find(registry_id, name) do
    Player.process_name(registry_id, name)
  end
end
