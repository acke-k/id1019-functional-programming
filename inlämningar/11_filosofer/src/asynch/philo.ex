defmodule Philo do

  def start(hunger, right, left, name, ctrl, timeout) do
    philo = spawn_link(fn -> dreaming(hunger, right, left, name, ctrl, timeout) end)
    {:philo, philo}
  end
  
  def waiting(hunger, right, left, name, ctrl, timeout) do
    IO.puts("#{name} is waiting.")
    case Chop.request(left, right, timeout) do
      :ok ->
	IO.puts("#{name} got both of her chopsticks.")
	eating(hunger - 1, right, left, name, ctrl, timeout)	
      :no ->
	Chop.return(left)
	IO.puts("#{name} returned her left chopstick.")
	Chop.return(right)
	IO.puts("#{name} returned her right chopstick.")
	waiting(hunger, right, left, name, ctrl, timeout)
    end
  end
    
  def eating(hunger, right, left, name, ctrl, timeout) do
    IO.puts("#{name} started to eat.")
    sleep(:rand.uniform(1000))
    #sleep(0)
    IO.puts("#{name} is done eating. Her hunger is #{hunger}.")
    Chop.return(left)
    IO.puts("#{name} returned her left chopstick.")
    Chop.return(right)
    IO.puts("#{name} returned her right chopstick.")
    dreaming(hunger, right, left, name, ctrl, timeout)
  end
  def dreaming(0, _, _, name, ctrl, _) do
    IO.puts("#{name} is done.")
    send(ctrl, :done)
  end
  def dreaming(hunger, right, left, name, ctrl, timeout) do
    IO.puts("#{name} is dreaming.")
    sleep(:rand.uniform(1000))
    #sleep(0)
    waiting(hunger, right, left, name, ctrl, timeout)
  end
  
  def sleep(0) do :ok end
  def sleep(t) do :timer.sleep(t) end
  
end
