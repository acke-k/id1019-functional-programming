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
      {:request, ref, from} ->
	send(from, {:granted, ref})
	gone(ref)
      {:status, from} ->
	send(from, :available)
	available()
    end
  end
  def gone(ref) do
    receive do
      {:return, ^ref} ->
	available()
      :quit ->
	:ok
    end
  end  
  def request({:stick, pid}, ref) do
    send(pid, {:request, ref, self()})
    receive do
      {:granted, ^ref} ->
	:ok
      {:granted, _} ->
	wait(ref)
    end
  end
  def request({:stick, pid}, ref, timeout) do
    send(pid, {:request, ref, self()})
    receive do
      {:granted, ^ref} ->
	:ok
      {:granted, _} ->
	wait(ref)
    after
      timeout ->
	:no
    end
  end
  def wait(ref, timeout) do
    receive do
      {:granted, ^ref} ->
	:ok
      {:granted, _} ->
	wait(ref, timeout)
    end
  end
  def wait(ref) do
    receive do
      {:granted, ^ref} ->
	:ok
      {:granted, _} ->
	wait(ref)
    end
  end
  
  def return({:stick, pid}, ref) do
    send(pid, {:return, ref})
      :returned -> :ok
  end
  def kill({:stick, pid}) do
    send(pid, :quit)
  end  
end
