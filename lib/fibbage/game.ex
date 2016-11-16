defmodule Fibbage.Game do
  use GenServer
  alias Fibbage.Game.Board

  defstruct [
    id: nil,
    player1: nil,
    player2: nil,
    player3: nil,
    turns: [],
    over: false,
    winner: nil
  ]

  # CLIENT

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: ref(id))
  end

  def join(id, player_id, pid), do: try_call(id, {:join, player_id, pid})

  # ...

  # SERVER

  def init(id) do
    {:ok, %__MODULE__{id: id}}
  end

  # ...

  def handle_call(:get_data, _from, game), do: {:reply, game, game}

  def handle_call({:join, player_id, pid}, _from, game) do
    cond do
      game.player1 != nil and game.player2 != nil and game.player3 != nil->
        {:reply, {:error, "No more players allowed"}, game}
      Enum.member?([game.player1, game.player2, game.player3], player_id) ->
        {:reply, {:ok, self}, game}
      true ->
        Process.flag(:trap_exit, true)
        Process.monitor(pid)

        {:ok, board_pid} = create_board(player_id)
        Process.monitor(board_pid)

        game = add_player(game, player_id)

        {:reply, {:ok, self}, game}
    end
  end

  defp create_board(player_id), do: Board.create(player_id)

  defp add_player(%__MODULE__{player1: nil} = game, player_id), do: %{game | player1: player_id}
  defp add_player(%__MODULE__{player2: nil} = game, player_id), do: %{game | player2: player_id}
  defp add_player(%__MODULE__{player3: nil} = game, player_id), do: %{game | player3: player_id}

  defp ref(id), do: {:global, {:game, id}}

  defp try_call(id, message) do
    case GenServer.whereis(ref(id)) do
      nil ->
        {:error, "Game does not exist"}
      pid ->
        GenServer.call(pid, message)
    end
  end
end