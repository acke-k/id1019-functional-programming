import Prim
defmodule Bench do

  
  # Mäter exekveringstid
  def measure(function) do
    function
    |> :timer.tc
    |>elem(0)
  end
  
  
  
  def loop(0,_) do :ok end
  def loop(n, f) do 
    f.()
    loop(n-1, f)
  end
  
end

