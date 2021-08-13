defmodule ToyRobot.CLITest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  test "it provides usage instructions if no arguments are specified" do
    output =
      capture_io(fn ->
        ToyRobot.CLI.main([])
      end)

    assert String.trim(output) == "Usage: toy_robot commands.txt"
  end

  test "it provides usage instructions if too many arguments are specified" do
    output =
      capture_io(fn ->
        ToyRobot.CLI.main(["commands.txt", "commands2.txt"])
      end)

    assert String.trim(output) == "Usage: toy_robot commands.txt"
  end

  test "it shows error if the file does not exist" do
    output =
      capture_io(fn ->
        ToyRobot.CLI.main(["not_exist.txt"])
      end)

    assert String.trim(output) == "The file not_exist.txt does not exist"
  end

  test "it handles commands successfully" do
    commands = Path.expand("test/fixtures/commands.txt", File.cwd!())

    output =
      capture_io(fn ->
        ToyRobot.CLI.main([commands])
      end)

    assert String.trim(output) == "The robot is at (0,4) and is facing SOUTH"
  end
end
