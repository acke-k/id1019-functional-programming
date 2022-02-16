defmodule Deriv do

  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}
  
  # Derivera tal & variabler
  def deriv({:num, _}, _) do {:num, 0} end # Derivera tal
  def deriv({:var, v}, v) do {:num, 1} end # Derivera den givna variabeln
  def deriv({:var, _}, _) do {:num, 0} end # Derivera en annan variabel
  
  # Deriveringsregler
   # Addition
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end
   # Multiplikation
  def deriv({:mul, e1, e2}, v) do
    {:add,
     {:mul, deriv(e1, v), e2},
     {:mul, e1, deriv(e2, v)}}
  end
   # Exponent
  def deriv({:exp, e1, {:num, n}}, v) do
    {:mul,
     {:mul, {:num, n}, {:exp, e1, {:num, n-1}}},
     deriv(e1, v)}
  end

  # Simplify
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify(e) do e end # Catch all

  # Simplify add
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add({:num, e1}, {:num, e2}) do {:num, e1+e2} end

  # Simplify mul
  def simplify_mul(_, {:num, 0}) do {:num, 0} end # Om ett nummer är 0
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(e1, {:num, 1}) do e1 end # Om ett nummer är 1
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul({:num, e1}, {:num, e2}) do {:num, e1 * e2} end

  # Simplify exp
  def simplify_exp(_, {:num, 0}) do {:num, 1} end # a^0 == 1
  def simplify_exp(e1, {:num, 1}) do e1 end # a^1 == a
  
  # Pretty print
  def pprint({:num, n}) do "#{n}" end # Nummer
  def pprint({:var, v}) do "#{v}" end # Variabel
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end # Addition
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end # Multiplikation
  def pprint({:exp, e1, e2}) do  "(#{pprint(e1)})^(#{pprint(e2)})" end # Exponent
  
  # test
  def test1() do
    e = {:add,
	 {:mul, {:num, 2}, {:var, :x}},
	 {:num, 4}}
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("result pprint: #{pprint(d)}\n")
    IO.write("Result simple: #{pprint(simplify(d))}\n")
    :ok
  end
  def test2() do
    e = {:add,
	 {:exp, {:var, :x}, {:num, 2}},
	 {:num, 4}}
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("result pprint: #{pprint(d)}\n")
    IO.write("Result simple: #{pprint(simplify(d))}\n")
    :ok
  end

end
  
