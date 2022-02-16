# Alla funktioner hittar primtal mellan 2 och n på olika sätt

defmodule Prim do

  # prim1
  # Skapa en lista av alla tal 2 ... n
  # Det första talet är 2, spara det
  # Plocka bort alla tal i resten av listan delbara med 2, spara det första elementet
  # När listan är tom är det klart

  # Initiera lista med tal
  def prim1(n) when is_integer(n) do prim1(Enum.to_list(2..n)) end
  # Iterera hela listan
  def prim1([]) do [] end
  def prim1([h | t]) do [h | prim1(rem_el(h, t))] end
  # Ta bort alla tal ur lista där rem(e, <element i listan>) == 0
  def rem_el(_, []) do [] end
  def rem_el(e, [h | t]) do
    case rem(h, e) do
      0 -> rem_el(e, t)
      _ -> [h | rem_el(e, t)]
    end
  end

  # prim2
  # En lista med alla tal mellan 2 och n, en med alla primtal som hittats
  # Kontrollera om alla tal i första listan är delbara med ett primtal som hittats
  # Om inte delbart med något spara det
  # TODO: Se till att prim ej är i omvänd ordning. Kan an brja längst bak? Antagligen inte
  
  # Initiera lista med tal. Vi vet att 2 alltid är det första primtalet
  def prim2(n) when is_integer(n) do prim2(Enum.to_list(3..n), [2]) end
  # Vi har kollat alla tal
  def prim2([], prims) do prims end
  # rekursivt steg
  def prim2([h | t], prims) do
    case rem_el2(h, prims) do
      :succ -> prim2(t, add_last(h, prims)) # Lägg till sist här
      :fucc -> prim2(t, prims)
    end
  end
  
  # Kollar om tal n är delbart med något tal i lst
  def rem_el2(_, []) do :succ end
  def rem_el2(n, [h | t]) do
    case rem(n, h) do
      0 -> :fucc
      _ -> rem_el2(n, t)
    end
  end

  def add_last(e, [h]) do [h | [e]] end
  def add_last(e, [h | t]) do
    [h | add_last(e, t)]
  end

  # Prim3: samma som prim2 fast elementet läggs till först i listan
  # På slutet vänds ordningen av listan
  # Initiera lista med tal. Vi vet att 2 alltid är det första primtalet
  def prim3(n) when is_integer(n) do prim3(Enum.to_list(3..n), [2]) end
  # Vi har kollat alla tal
  def prim3([], prims) do lst_rev(prims) end
  # rekursivt steg
  def prim3([h | t], prims) do
    case rem_el2(h, prims) do
      :succ -> prim3(t, [h | prims])
      :fucc -> prim3(t, prims)
    end
  end
  # Kollar om tal n är delbart med någota tal i lst
  def rem_el3(_, []) do :succ end
  def rem_el3(n, [h | t]) do
    case rem(n, h) do
      0 -> :fucc
      _ -> rem_el2(n, t)
    end
  end
  # Använder en ackumulator lista
  def lst_rev(lst) do lst_rev(lst, []) end
  def lst_rev([], rev) do rev end
  def lst_rev([h | t], rev) do lst_rev(t, [h | rev]) end
    

  
  
end
