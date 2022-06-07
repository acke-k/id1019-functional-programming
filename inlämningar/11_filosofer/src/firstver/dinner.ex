defmodule Dinner do

  def start(), do: spawn(fn -> init() end)

  def init() do
    c1 = Chop.start()
    c2 = Chop.start()
    c3 = Chop.start()
    c4 = Chop.start()
    c5 = Chop.start()
    ctrl = self()
    Philo.start(5, c1, c2, "Arendt", ctrl)
    Philo.start(5, c2, c3, "Hypathia", ctrl)
    Philo.start(5, c3, c4, "Simone", ctrl)
    Philo.start(5, c4, c5, "Elisabeth", ctrl)
    Philo.start(5, c5, c1, "Ayn", ctrl)
    wait(5, [c1, c2, c3, c4, c5])
  end

  def wait(0, _) do
    IO.puts("All philosophers are full.")
    :ok
  end
  def wait(n, chopsticks) do
    receive do
      :done ->
	wait(n-1, chopsticks)
      :abort ->
	Process.exit(self(), :kill)
    end
  end
end
