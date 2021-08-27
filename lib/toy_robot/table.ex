defmodule ToyRobot.Table do
  alias ToyRobot.Table

  defstruct [:north_boundary, :east_boundary]

  @doc """
  Check if given position is within table boundaries.

  ## Examples

    iex> alias ToyRobot.Table
    ToyRobot.Table
    iex> table = %Table{north_boundary: 4, east_boundary: 4}
    %Table{north_boundary: 4, east_boundary: 4}
    iex> table |> Table.valid_position?(%{north: 4, east: 4})
    true
    iex> table |> Table.valid_position?(%{north: 0, east: 0})
    true
    iex> table |> Table.valid_position?(%{north: 6, east: 0})
    false

  """
  def valid_position?(
        %Table{north_boundary: north_boundary, east_boundary: east_boundary},
        %{north: north, east: east}
      ) do
    north >= 0 && north <= north_boundary && east >= 0 && east <= east_boundary
  end

  @doc """
  Returns all valid position for a given table's boundaries.

  ## Examples

    iex> alias ToyRobot.Table
    ToyRobot.Table
    iex> table = %Table{north_boundary: 1, east_boundary: 1}
    %Table{north_boundary: 1, east_boundary: 1}
    iex> Table.valid_positions(table)
    [
      %{north: 0, east: 0},
      %{north: 0, east: 1},
      %{north: 1, east: 0},
      %{north: 1, east: 1},
    ]

  """
  def valid_positions(%Table{north_boundary: north_boundary, east_boundary: east_boundary}) do
    for north <- 0..north_boundary, east <- 0..east_boundary do
      %{north: north, east: east}
    end
  end
end
