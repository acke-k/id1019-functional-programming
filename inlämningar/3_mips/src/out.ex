defmodule Out do
  # Skapa en ny out-lista
  def new() do
    []
  end

  # När :halt "anropas", skriv ut hela out-listan
  def close([]) do :empty_list end
  def close([h|t]) do
    case t do
      [] -> [h]
      _ -> [h] ++ close(t)
    end
  end
  # Lägg till element i out-listan
  def put(out, imm) do
    out ++ [imm]
  end
  
end
