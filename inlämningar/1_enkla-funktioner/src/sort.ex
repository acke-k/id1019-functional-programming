defmodule Sort do

  # Insertion sort
  # Stoppar in elementet i rätt plats i en sorterad lista
  def insert(x, []) do [x] end
  def insert(x, [h | t]) do
    case x > h do
      true -> [h] ++ insert(x, t)
      false -> [x] ++ [h] ++ t
    end
  end

  def isort(l) do
    isort(l, [])
  end
  
  def isort(l, sorted) do
    case l  do
      [] -> sorted  # Listan är tom
      [h | t] -> isort(t, insert(h, sorted))
    end
  end
  
  # Merge sort
  def msort(l) do
    case l do
      [] -> []
      [x] -> [x]
      _ ->
	{a, b} = msplit(l, [], [])
	merge(msort(a), msort(b))
    end
  end
  # Mergea listorna
  # Om en av listorna är tom
  def merge(l, []) do l end
  def merge([], l) do l end
  # Annars
  def merge([h1|t1], [h2|t2]) do
    if h1 < h2 do
      [h1] ++ merge(t1, [h2] ++ t2)
    else
      [h2] ++ merge(t2, [h1] ++ t1)
    end
  end
  # Dela listan i två lika stora delar
  def msplit(l, a, b) do
    case l do
      # Om listan är tom har vi delat klart
      [] ->
	{a, b}
      [x] ->
	{a ++ [x], b}
      _ ->
	msplit(tl(l), b, a ++ [hd(l)])
    end
  end

  # Quicksort
  def qsort([]) do [] end # Om listan är tom
  
  def qsort([p | l]) do
    {lo, hi}  = qsplit(p, l, [], [])
    small = qsort(lo)
    large = qsort(hi)
    append(small, [p | large])
  end

  def qsplit(_, [], small, large) do {small, large} end # Om l är tom är alla sorterade?
  def qsplit(p, [h | t], small, large) do
    if h < p do
      qsplit(p, t, [h] ++ small, large)
    else
      qsplit(p, t, small, [h] ++ large)
    end
  end

  def append(l, d) do
    case l do
      [] -> d
      [h | t] -> [h | append(t, d)]
    end
  end	
  
end
