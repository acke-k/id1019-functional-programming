defmodule Rev do

  def append(l, d) do
    case l do
      [] -> d
      [h | t] -> [h | append(t, d)]
    end
  end	


  # Naiv
  def nreverse([]) do [] end

  def nreverse([h | t]) do
    r = nreverse(t)
    append(r, [h])
  end

  # Bra
  def reverse(l) do
    reverse(l, [])
  end

  def reverse([], r) do r end
  def reverse([h | t], r) do
    reverse(t, [h | r])
  end

  # Bench
  def bench() do
    ls = [16, 32, 64, 128, 256, 512, 1024, 2048, 5096]
    n = 100
    # bench is a closure - function with an environment
    bench = fn(l) ->
      seq = :lists.seq(1,l)
      tn = time(n, fn() -> nreverse(seq) end)
      tr = time(n, fn() -> reverse(seq) end)
      :io.format("length: ~10w  nrev: ~8w us rev: ~8w us~n", [l, tn, tr])
    end
    # We use the library function Enum.each that
    # will call bench(l) for each element l in ls
    Enum.each(ls, bench)
  end
  def time(n, fun) do
    start = System.monotonic_time(:milliseconds)
    loop(n, fun)
    stop = System.monotonic_time(:milliseconds)
    (stop - start)
  end
  def loop(n, fun) do
    if n == 0 do
      :ok else
      fun.()
      loop(n-1, fun)
    end
  end
end
