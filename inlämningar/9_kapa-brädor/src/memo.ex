defmodule Memo do

  def new() do %{} end

  def add(mem, key, val) do
    Map.put(mem, key, val)
  end
  def lookup(mem, key) do
    Map.get(mem, key)
  end
  
  def badd(mem, key, val) do
    Map.put(mem, :binary.list_to_bin(key), val)
  end
  def blookup(mem, key) do
    Map.get(mem, :binary.list_to_bin(key))
  end
  
end
