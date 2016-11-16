defmodule Fibbage.PageController do
  use Fibbage.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", id: Fibbage.generate_player_id
  end
end
