defmodule Chop do

  def start do
    stick = spawn_link(fn -> available() end)
    {:stick, stick}
  end
  def available() do
    receive do
      {:request, from} ->
	send(from, :granted) # From är PID för den som anropar?
	gone()
      :quit-> :ok
      {:status, from} ->
	send(from, :available)
	available()
    end
  end
  def gone() do
    receive do
      {:return, from} ->
	send(from, :returned)
	available()
      :quit -> :ok
      {:status, from} ->
	send(from, :taken)
	gone()
    end
  end  

  def request({:stick, pid}) do
    send(pid, {:request, self()})
    receive do
      :granted -> :ok
    end
  end
  
  def return({:stick, pid}) do
    send(pid, {:return, self()})
    receive do
      :returned -> :ok
    end
  end
  def kill({:stick, pid}) do
    send(pid, :quit)
  end

  def status({:stick, pid}) do
    send(pid, {:status, self()})
    receive do
      msg -> msg
    end
  end
  
end
