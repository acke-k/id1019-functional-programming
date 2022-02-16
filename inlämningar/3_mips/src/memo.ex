defmodule Memory do

  @type mem() ::
  {number(), number()} # {addr, data}}

  # Spara ord i minnet
  def loadw([], _) do 0 end
  def loadw([{addr, data} | _ ], addr) do data end
  def loadw([_ | t], addr) do loadw(t, addr) end

  # Skriv datan i imm till data[addr]
  # Sök igenom listan efter post som matchar addr, skriv över eller skapa ny post
  def savew([], addr, data) do [{addr, data}] end
  def savew([{addr, _} | t], addr, data) do [{addr, data} | t] end
  def savew([h | t], addr, data) do [h | savew(t, addr, data)] end
    
end
