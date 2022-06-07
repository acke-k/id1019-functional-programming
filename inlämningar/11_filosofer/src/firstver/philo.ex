defmodule Philo do

  def start(hunger, right, left, name, ctrl) do
    philo = spawn_link(fn -> dreaming(hunger, right, left, name, ctrl) end)
    {:philo, philo}
  end

  def waiting(0, _, _, name, ctrl) do
    IO.puts("#{name} is done.")
    send(ctrl, :done)
  end
  def waiting(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is waiting.")
    case Chop.request(left) do
      :ok -> IO.puts("#{name} got her left chopstick.")
      :no ->
	IO.puts("#{name} didn't get her left chopstick.")
	waiting(hunger, right, left, name, ctrl)
    end
    case Chop.request(right) do
      :ok ->
	IO.puts("#{name} got her right chopstick.")
	eating(hunger - 1, right, left, name, ctrl)
      :no ->
	IO.puts("#{name} didn't get her right chopstick.")
	Chop.return(left)
	waiting(hunger, right, left, name, ctrl)
    end
  end

  def eating(hunger, right, left, name, ctrl) do
    IO.puts("#{name} started to eat.")
    sleep(:rand.uniform(1000))
    #sleep(0)
    IO.puts("#{name} is done eating. Her hunger is #{hunger}.")
    Chop.return(left)
    IO.puts("#{name} returned her left chopstick.")
    Chop.return(right)
    IO.puts("#{name} returned her right chopstick.")
    dreaming(hunger, right, left, name, ctrl)
  end

  def dreaming(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is dreaming.")
    sleep(:rand.uniform(1000))
    #sleep(0)
    waiting(hunger, right, left, name, ctrl)
  end
  
  def sleep(0) do :ok end
  def sleep(t) do :timer.sleep(t) end
  
end
