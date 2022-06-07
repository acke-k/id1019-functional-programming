defmodule Moves do

  @type track :: :one | :two
  @type train :: list(atom())
  @type move :: {track(), number()}
  @type state :: {list(), list(), list()}

  # Utför ett move och returnerar ett nytt state
  def single({track, num}, {main, t1, t2}) do
    case track do
      :one ->	
	{main, t1} = single(num, main, t1)
	{main, t1, t2}
      :two ->
	{main, t2} = single(num, main, t2)
	{main, t1, t2}
    end
  end
  def single(num, main, train) do
    case num < 0 do
      true ->
	num = num*-1
	main = Lists.append(main, Lists.take(train, num))
	train = Lists.drop(train, num)
	{main, train}
      false ->
	train = Lists.append(train, Lists.drop(main, length(main) - num))
	main = Lists.take(main, length(main) - num)
	{main, train}
    end
  end

  def move([], state) do [state | []] end
  def move([move | rest], state) do
    [state | move(rest, single(move, state))]
  end
end

defmodule Shunt do

  def split(train, wagon) do
    pos = Lists.position(train, wagon)
    {Lists.take(train, pos), Lists.drop(train, pos+1)}
  end

  def find(tbeg, tgoal) do find(tbeg, tgoal, []) end
  def find(_, [], moves) do moves end
  def find(tcurr, [gh | gt], moves) do
    {ch, ct} = split(tcurr, gh)
    this_moves = [
      {:one, length(ct) + 1},
      {:two, length(ch)},
      {:one, length(ct)*-1 - 1},
      {:two, length(ch)*-1}
    ]
    find(Lists.append(ch, ct), gt, Lists.append(moves, this_moves))
  end

  def few(tbeg, tgoal) do few(tbeg, tgoal, []) end
  def few(_, [], moves) do moves end
  def few([h | ct], [h | gt], moves) do few(ct, gt, moves) end
  def few(tcurr, [gh | gt], moves) do
    {ch, ct} = split(tcurr, gh)
    this_moves = [
      {:one, length(ct) + 1},
      {:two, length(ch)},
      {:one, length(ct)*-1 - 1},
      {:two, length(ch)*-1}
    ]
    few(Lists.append(ch, ct), gt, Lists.append(moves, this_moves))
  end
  
  def fewer(ms, os, ts, [y | ys]) do fewer(ms, os, ts, [y | ys], []) end
  def fewer(_, _, _, [], moves) do moves end
  def fewer(ms, os, ts, [y | ys], moves) do
    cond do
      Lists.member(ms, y) ->
	{h, t} = split(ms, y)
	this_moves = [
	  {:one, length(t) + 1},
	  {:two, length(h)},
	  {:one, -1},
	]
	ms = [y]
	os = Lists.append(os, t)
	ts = Lists.append(ts, h)
	moves = Lists.append(moves, this_moves)
	fewer(ms, os, ts, ys, moves)
	
      Lists.member(os, y) ->
	{h, t} = split(os, y)
	this_moves = [
	  {:one, length(h)*-1},
	  {:two, length(h)},
	  {:one, -1}
	]
	ms = Lists.append(ms, y)
	ts = Lists.append(h, ts)
	os = t
	moves = Lists.append(moves, this_moves)
	fewer(ms, os, ts, ys, moves)
	
      Lists.member(ts, y) ->
	{h, t} = split(ts, y)
	this_moves = [
	  {:two, length(h)*-1},
	  {:one, length(h)},
	  {:two, -1}
	]
	ms = Lists.append(ms, y)
	os = Lists.append(h, os)
	ts = t
	moves = Lists.append(moves, this_moves)
	fewer(ms, os, ts, ys, moves)
    end
  end
         
  def compress(moves) do
    comp = rules(moves)
    case comp == moves do
      true -> comp
      false -> compress(comp)
    end
  end
  
  def rules([{_, 0} | t]) do rules(t) end
  def rules([{track, n1}, {track, n2} | t]) do [{track, n1 + n2} | rules(t)] end
  def rules([h | t]) do [h | rules(t)] end
  def rules([]) do [] end
    
end
