defmodule Test do

  def gen_seq1() do
    [
      {:match, {:var, :x}, {:atm, :a}}, # x = :a
      {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}}, # y = {x, :b}
      {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}}, # {_, z} = y
      {:var, :z} # z
    ]
  end

  def gen_seq2() do
    [
      {:match, {:var, :x}, {:atm, :a}}, # x = :a
      {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}}, # y = {x, :b}
      {:match, {:cons, {:atm, :c}, {:var, :z}}, {:var, :y}}, # {:c, z} = y
      {:var, :z} # z
    ]
  end

  def gen_seq_cls() do
    [
      {:match, {:var, :x}, {:atm, :a}}, # x = :a
      {:case, {:var, :x}, # case x do
       [{:clause, {:atm, :b}, [{:atm, :ops}]}, # :b -> ops
	{:clause, {:atm, :a}, [{:atm, :yes}]}, # :a -> yes
       ]}
    ]
  end

  def gen_seq_lambda() do
    [
      {:match, {:var, :x}, {:atm, :a}}, # x = :a
      {:match, {:var, :f}, # :f = lambda(x).{x, y}.y
       {:lambda, [{:var, :y}], [{:var, :x}], [{:cons, {:var, :x}, {:var, :y}}]}},
      {:apply, {:var, :f}, [{:atm, :b}]} # apply(f, b)
    ]
  end

  def gen_seq_fun() do
    [
      {:match, {:var, :x},
       {:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}}, # x = {:b, []}
      {:match, {:var, :y},
       {:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}},
      {:apply, {:fun, :append}, [{:var, :x}, {:var, :y}]}
    ]
  end
  
  def test1() do
    Eag.eval(gen_seq1())
  end

  def test2() do
    Eag.eval(gen_seq2())
  end

  def test_cls() do
    Eag.eval(gen_seq_cls())
  end

  def test_lam() do
    Eag.eval(gen_seq_lambda())
  end

  def test_fun() do
    Eag.eval_seq(gen_seq_fun(), Env.new())
  end
  
end
