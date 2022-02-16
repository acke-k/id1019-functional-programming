defmodule Math do
  
  # Multiplikation
  def product(a, b) do
    case a do
      0 -> 0
      _ -> product(a - 1, b) + b
    end
  end
  
  # exponentialfunktionen (a^b)
  def exp(a, b) do
    case b do
      0 -> 1
      _ -> product(a, exp(a, b - 1))
    end
  end
end
