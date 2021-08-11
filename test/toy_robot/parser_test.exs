defmodule ToyRobot.ParserTest do
  use ExUnit.Case
  doctest ToyRobot.Parser

  alias ToyRobot.Parser

  test "it can not parse invalid input" do
    input = ["SPIN", "TWIRL", "EXTERMINATE"]
    output = Parser.parse(input)

    assert output == [
             {:invalid, "SPIN"},
             {:invalid, "TWIRL"},
             {:invalid, "EXTERMINATE"}
           ]
  end
end
