defmodule Register do

  # Returna en reg datastruktur där imm är skrivet till register num
  def write(reg, num, imm) do
    case num do
      0 -> {:error, "wrote to $0"}
      _ ->
	reg = put_elem(reg, num, imm)
	reg
    end
  end
  # Returna ett element ur reg
  def read(reg, num) do
    elem(reg, num)
  end

  # Skapa en ny register struktur
  def new() do
    {0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0}
  end

end
  
