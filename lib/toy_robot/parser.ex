defmodule ToyRobot.Parser do
  @doc """
  Parse the input to turn it into commands list

  ## Examples

    iex> alias ToyRobot.Parser
    ToyRobot.Parser
    iex> input = ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "UTURN", "REPORT"]
    ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "UTURN", "REPORT"]
    iex> Parser.parse(input)
    [
      {:place, %{north: 2, east: 1, facing: :north}},
      :move,
      :turn_left,
      :turn_right,
      :uturn,
      :report
    ]
  """
  def parse(input) do
    Enum.map(input, &parse_item/1)
  end

  defp parse_item("PLACE " <> _rest = command) do
    format = ~r/\APLACE (\d+),(\d+),(NORTH|EAST|SOUTH|WEST)\z/

    case Regex.run(format, command) do
      [_command, east, north, facing] ->
        {
          :place,
          %{
            north: String.to_integer(north),
            east: String.to_integer(east),
            facing: String.downcase(facing) |> String.to_atom()
          }
        }

      nil ->
        {:invalid, command}
    end
  end

  defp parse_item("MOVE"), do: :move
  defp parse_item("LEFT"), do: :turn_left
  defp parse_item("RIGHT"), do: :turn_right
  defp parse_item("UTURN"), do: :uturn
  defp parse_item("REPORT"), do: :report
  defp parse_item(input), do: {:invalid, input}
end
