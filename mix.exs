defmodule ToyRobot.MixProject do
  use Mix.Project

  def project do
    [
      app: :toy_robot,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      escript: escript()
    ]
  end

  def application do
    [
      extra_applications: [:crypto, :logger],
      mod: {ToyRobot.Application, []}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end

  defp deps do
    [
      {:uuid, "~> 1.1"}
    ]
  end

  defp escript do
    [main_module: ToyRobot.CLI]
  end
end
