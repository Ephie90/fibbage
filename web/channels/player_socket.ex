defmodule Fibbage.PlayerSocket do
  use Phoenix.Socket

  alias Fibbage.Player

  ## Channels
  channel "lobby", Fibbage.LobbyChannel
  channel "game:*", Fibbage.GameChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"id" => player_id}, socket) do
    {:ok, assign(socket, :player_id, player_id)}
  end

  def connect(_, _socket), do: :error

  def id(socket), do: "players_socket:#{socket.assigns.player_id}"
end