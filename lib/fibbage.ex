defmodule Fibbage do
  use Application

  @id_length Application.get_env(:fibbage, :id_length)

  def generate_player_id do
    @id_length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64()
    |> binary_part(0, @id_length)
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(Fibbage.Endpoint, []),
      # Start your own worker by calling: Fibbage.Worker.start_link(arg1, arg2, arg3)
      # worker(Fibbage.Worker, [arg1, arg2, arg3]),
      supervisor(Fibbage.Game.Supervisor, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fibbage.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Fibbage.Endpoint.config_change(changed, removed)
    :ok
  end
end
