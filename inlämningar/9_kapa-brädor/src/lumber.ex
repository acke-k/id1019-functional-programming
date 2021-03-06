defmodule Plank do
  
  # Första anropet
  def split(seq) do split(seq, 0, [], []) end
  # Hela stocker är uppdelad
  def split([], l, left, right) do [{left, right, l}] end
  # Dela den
  def split([s|rest], l, left, right) do
    split(rest, l + s, left ++ [s], right) ++
      split(rest, l + s, left, [right, [s]])
  end

  # Dynamic cost with all in left
  def gcost([]) do {0, :na} end # Hantera tom sekvens
  # Det första anropen
  def gcost(seq) do
    {cost, tree, _} = gcost(seq, Memo.new())
    {cost, tree}
  end
  # Basfall #1
  def gcost([el], mem) do {0, el, mem} end
  def gcost([s|rest]=seq, mem) do
    {c, t, mem} = gcost(rest, s, [s], [], mem)
    {c, t, Memo.add(mem, seq, {c, t})}
  end
  # Fler basfall
  def gcost([], l, left, right, mem)  do
    {lc, lt, mem} = gcheck(left, mem)
    {rc, rt, mem} = gcheck(right, mem)
    {rc + lc + l, {lt, rt}, mem}
  end 
  def gcost([s], l, [], right, mem)  do
    {c, t, mem} = gcheck(right, mem) # OBS minnet uppdateras
    {c + l + s, {t, s}, mem}
  end
  def gcost([s], l, left, [], mem)  do
    {c, t, mem} = gcheck(left, mem)
    {c + l + s, {s, t}, mem}
  end
  def gcost([s|rest], l, left, right, mem) do
    {lc, lt, mem} = gcost(rest, l+s, [s|left], right, mem)
    {rc, rt, mem} = gcost(rest, l+s, left, [s|right], mem)
    if lc < rc do
      {lc, lt, mem}
    else
      {rc, rt, mem}
    end
  end
  def gcheck(seq, mem) do
    case Memo.lookup(mem, seq) do
      nil ->
	gcost(seq, mem) # Lägg till i minnet
      {c, t} ->
	{c, t, mem} # Returnera det som hittades
    end
  end



  # Dynamic cost no mirror
  def mcost([]) do {0, :na} end # Hantera tom sekvens
  # Det första anropen
  def mcost(seq) do
    {cost, tree, _} = mcost(seq, Memo.new())
    {cost, tree}
  end
  # Basfall #1
  def mcost([el], mem) do {0, el, mem} end
  def mcost([s|rest]=seq, mem) do
    {c, t, mem} = mcost(rest, s, [s], [], mem)
    {c, t, Memo.badd(mem, seq, {c, t})}
  end
  # Fler basfall
  def mcost([], l, left, right, mem)  do
    {lc, lt, mem} = mcheck(left, mem)
    {rc, rt, mem} = mcheck(right, mem)
    {rc + lc + l, {lt, rt}, mem}
  end 
  def mcost([s], l, [], right, mem)  do
    {c, t, mem} = mcheck(right, mem) # OBS minnet uppdateras
    {c + l + s, {t, s}, mem}
  end
  def mcost([s], l, left, [], mem)  do
    {c, t, mem} = mcheck(left, mem)
    {c + l + s, {s, t}, mem}
  end
  def mcost([s|rest], l, left, right, mem) do
    {lc, lt, mem} = mcost(rest, l+s, [s|left], right, mem)
    {rc, rt, mem} = mcost(rest, l+s, left, [s|right], mem)
    if lc < rc do
      {lc, lt, mem}
    else
      {rc, rt, mem}
    end
  end

  def mcheck(seq, mem) do
    case Memo.blookup(mem, seq) do
      nil ->
	mcost(seq, mem) # Lägg till i minnet
      {c, t} ->
	{c, t, mem} # Returnera det som hittades
    end
  end

  
  # Dynamic cost
  def dcost([]) do {0, :na} end # Hantera tom sekvens
  # Det första anropen
  def dcost(seq) do
    {cost, tree, _} = dcost(seq, Memo.new())
    {cost, tree}
  end
  # Basfall #1
  def dcost([el], mem) do {0, el, mem} end
  def dcost(seq, mem) do
    {c, t, mem} = dcost(seq, 0, [], [], mem)
    {c, t, Memo.add(mem, seq, {c, t})}
  end
  # Fler basfall
  def dcost([], l, left, right, mem)  do
    {l_cost, l_tree, l_mem} = dcheck(left, mem)
    {r_cost, r_tree, r_mem} = dcheck(right, l_mem)
    {r_cost + l_cost + l, {l_tree, r_tree}, r_mem}
  end 
  def dcost([s], l, [], right, mem)  do
    {cost, tree, mem} = dcheck(right, mem) # OBS minnet uppdateras
    {cost + l + s, {tree, s}, mem}
  end
  def dcost([s], l, left, [], mem)  do
    {cost, tree, mem2} = dcheck(left, mem)
    {cost + l + s, {s, tree}, mem2}
  end
  def dcost([s|rest], l, left, right, mem) do
    {l_cost, l_tree, l_mem} = dcost(rest, l+s, [s|left], right, mem)
    {r_cost, r_tree, r_mem} = dcost(rest, l+s, left, [s|right], l_mem)
    if l_cost < r_cost do
      {l_cost, l_tree, l_mem}
    else
      {r_cost, r_tree, r_mem}
    end
  end
  
  # Kolla om en sekvens finns i mem
  def dcheck(seq, mem) do
    case Memo.lookup(mem, seq) do
      nil ->
	dcost(seq, mem) # Lägg till i minnet
      {c, t} ->
	{c, t, mem} # Returnera det som hittades
    end
  end
    
  # Cost med print
  def pcost([]) do 0 end
  def pcost([el]) do {0, el} end
  def pcost(seq) do pcost(seq, 0, [], []) end  

  def pcost([], l, left, right)  do
    {l_cost, l_tree} = pcost(left)
    {r_cost, r_tree} = pcost(right)
    {r_cost + l_cost + l, {l_tree, r_tree}}
  end
  def pcost([s], l, [], right)  do
    {cost, tree} = pcost(right)
    {cost + l + s, {tree, s}}
  end
  def pcost([s], l, left, [])  do
    {cost, tree} = pcost(left)
    {cost + l + s, {s, tree}}
  end
  def pcost([s|rest], l, left, right) do
    {l_cost, l_tree} = pcost(rest, l+s, [s|left], right)
    {r_cost, r_tree} = pcost(rest, l+s, left, [s|right])
    if l_cost < r_cost do
      {l_cost, l_tree}
    else
      {r_cost, r_tree}
    end
  end
end


defmodule Bench do
  # Benchmarks
  def bench(n) do
    IO.puts("naive")
    pbench(n)
    IO.puts("With map")
    dbench(n)
    IO.puts("With map and improved memo")
    mbench(n)
  end
  
  # Generera en lista med n element mellan 0 & k
  def bench_list(n, k) do
    lst = []
    for i <- 1..n do
      lst ++ rem(i, k) + 1
    end
  end
  
  def mbench(n, k) do
    for i <- 1..n do
      {t, _} = :timer.tc(fn() -> Plank.mcost(bench_list(i, k)) end)
      IO.puts("#{i}\t#{t} us")
    end
  end
  
  def mbench(n) do
    for i <- 1..n do
      {t, _} = :timer.tc(fn() -> Plank.mcost(Enum.to_list(1..i)) end)
      IO.puts("#{i}\t#{t} us")
    end
  end
  
  def pbench(n) do
    for i <- 1..n do
      {t, _} = :timer.tc(fn() -> Plank.pcost(Enum.to_list(1..i)) end)
      IO.puts("#{i}\t#{t} us")
    end
  end
  
  def dbench(n) do
    for i <- 1..n do
      {t, _} = :timer.tc(fn() -> Plank.dcost(Enum.to_list(1..i)) end)
      IO.puts("#{i}\t#{t} us")
    end
  end

  def gbench(n) do
    for i <- 1..n do
      {t, _} = :timer.tc(fn() -> Plank.gcost(Enum.to_list(1..i)) end)
      IO.puts("#{i}\t#{t} us")
    end
  end
end
