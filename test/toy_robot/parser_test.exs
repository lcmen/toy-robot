defmodule ToyRobot.ParserTest do
  use ExUnit.Case
  doctest ToyRobot.Parser

  alias ToyRobot.Parser

  test "it can not parse invalid input" do
    input = ["SPIN", "TWIRL", "EXTERMINATE", "PLACE 1, 2, NORTH", "move", "MoVe"]
    output = Parser.parse(input)

    assert output == [
             {:invalid, "SPIN"},
             {:invalid, "TWIRL"},
             {:invalid, "EXTERMINATE"},
             {:invalid, "PLACE 1, 2, NORTH"},
             {:invalid, "move"},
             {:invalid, "MoVe"}
           ]
  end
end
