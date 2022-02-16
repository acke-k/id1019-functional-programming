defmodule Bench do
  
  def bench() do bench(100) end

  def bench(l) do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    time = fn (i, f) ->
      seq = Enum.map(1..i, fn(_) -> :rand.uniform(100000) end)
      elem(:timer.tc(fn () -> loop(l, fn -> f.(seq) end) end),0)
    end

    bench = fn (i) ->

      list = fn (seq) ->
        List.foldr(seq, list_new(), fn (e, acc) -> list_insert(e, acc) end)
      end

      tree = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert(e, acc) end)
      end

      dummy = fn (seq) ->
        List.foldr(seq, dummy_new(), fn (e, acc) -> dummy_insert(e, acc) end)
      end      

      tl = time.(i, list) / 100
      tt = time.(i, tree) / 100
      td = time.(i, dummy) /100

      IO.write("#{i}\t\t\t#{tl}\t\t\t#{tt}\t\t\t#{td}\n")
    end

    IO.write("# benchmark of lists and tree (loop: #{l}) \n")
    Enum.map(ls, bench)

    :ok
  end
  
  def loop(0,_) do :ok end
  def loop(n, f) do 
    f.()
    loop(n-1, f)
  end
  def dummy_new () do end
  def dummy_insert(_, _) do end

  
  def list_new() do [] end
  
  def list_insert(e, []) do [e] end
  def list_insert(e, [h|t]) do
    case e < h do
      true -> [e | [h | t]]
      false -> [h | list_insert(e, t)]
    end
  end
  
  def tree_new() do :nil end

  def tree_insert(e, :nil) do {e, :nil, :nil} end
  def tree_insert(e, {a, l ,r}) do
    case e < a do
      true -> {a, tree_insert(e, l), r}
      false -> {a, l, tree_insert(e, r)}
    end
  end
end

Bench.bench()
