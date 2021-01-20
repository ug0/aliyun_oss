defmodule Aliyun.Oss do
  @moduledoc """
  Documentation for Aliyun.Oss.

  - `Aliyun.Oss.Bucket`: Bucket related operations.
  - `Aliyun.Oss.Object`: Object related operations.
  - `Aliyun.Oss.LiveChannel`: LiveChannel related operations.
  """

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Test.Worker.start_link(arg)
      # {Test.Worker, arg}
      {Task.Supervisor, name: Aliyun.Oss.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aliyun.Oss.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
