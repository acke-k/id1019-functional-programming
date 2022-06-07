defmodule Lists do

  def take(_, 0) do [] end
  def take([h | t], n) do [h | take(t, n-1)] end
  def take([], _) do
    IO.puts("I take/2: Tog för många element")
    :error
  end

  def drop(lst, 0) do lst end
  def drop([_ | t], n) do drop(t, n-1) end
  def drop([], _) do
    IO.puts("I drop/2: Tappade för många element")
    :error
  end

  def append([], l) do l end
  def append([h1], l2) do [h1 | l2] end
  def append([h1 | t1], l2) do [h1 | append(t1, l2)] end

  def member([], _) do false end
  def member([h | t], el) do
    case h == el do
      true -> true
      false -> member(t, el)
    end
  end

  def position(lst, el) do position(lst, el, 0) end
  def position([], _, _) do
    IO.puts("I position: elem är ej i listan")
    :error
  end
  def position([h | t], el, count) do
    case h == el do
      true -> count
      false -> position(t, el, count + 1)
    end
  end
  

  
  
end
  
