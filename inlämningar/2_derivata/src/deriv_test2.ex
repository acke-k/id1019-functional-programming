defmodule Deriv do

  @type literal() :: {:num, number()} | {:var, atom()} # Typer för nummer & variabler

  @type expr() :: literal() # Typer för aritmetiska operationer
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()} # :exp har alltid ett {:num, number()} som exponent
  | {:ln, expr()}

  # Derivera tal & variabler
  def deriv({:num, _}, _) do {:num, 0} end # Derivera tal
  def deriv({:var, v}, {:var, v}) do {:num, 1} end # Derivera den givna variabeln
  def deriv({:var, _}, _) do {:num, 0} end # Derivera en annan variabel

  # Derivera addition
 
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end
   # Derivera multiplikation
  def deriv({:mul, e1, e2}, v) do
    {:add,
     {:mul, deriv(e1, v), e2},
     {:mul, e1, deriv(e2, v)}}
  end
  # Derivera exponent
  def deriv({:exp, f, {:num, n}}, v) do
    {:mul,
     {:mul, {:num, n}, {:exp, f, {:num, n - 1}}},
     deriv(f, v)}
  end
  # TODO
  # x^n
  # ln(x)
  # sqrt(x)
  # sin(x)

  # Simplify
  def simplify({:add, e1, {:num, a}}) do # Flytta alltid nummer till vänster för simplify_add
    simplify_add(simplify({:num, a}), simplify(e1))
  end
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, {:num, a}}) do # Flytta alltid nummer till vänster för simplify_mul
    simplify_mul(simplify({:num, a}), simplify(e1))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, f, n}) do
    simplify_exp(simplify(f), simplify(n))
    end
  def simplify(e) do e end

  # Simplify addition
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add({:num, e1}, {:num, e2}) do {:num, e1+e2} end
  def simplify_add({:add, v, {:num, a}}, {:num, b}) do # ((a + v) + b) = (a + b) + v
    {:add, {:num, a + b}, v}
  end
  def simplify_add({:add, {:num, a}, v}, {:num, b}) do # ((v + a) + b) = (a + b) + v
    {:add, {:num, a + b}, v}
  end
  def simplify_add(e1, e2) do {:add, e1, e2} end # catch all
  # Simplify multiplikation
  def simplify_mul(_, {:num, 0}) do {:num, 0} end # Om ett nummer är 0
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(e1, {:num, 1}) do e1 end # Om ett nummer är 1
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul({:num, e1}, {:num, e2}) do {:num, e1 * e2} end
  def simplify_mul({:mul, {:num, a}, v}, {:num, b}) do # ((v * a) * b) = (a * b) + v
    {:mul, {:num, a * b}, v}
  end
  def simplify_mul({:mul, v, {:num, a}}, {:num, b}) do # ((a * v) * b) = (a * b) + v
    {:mul, {:num, a * b}, v}
  end
  def simplify_mul(a, b) do {:mul, a, b} end # catch all
  

  # Simplify exponent
  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(f, {:num, 1}) do f end
  def simplify_exp({:num, 0}, _) do {:num, 0} end
  def simplify_exp({:num, 1}, _) do {:num, 1} end
  def simplify_exp(e, r) do {e, r} end

  # Pretty print
  def pprint({:num, n}) do "#{n}" end # Nummer
  def pprint({:var, v}) do "#{v}" end # Variabel
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end # Addition
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end # Multiplikation
  def pprint({:exp, e1, e2}) do  "(#{pprint(e1)})^(#{pprint(e2)})" end # Exponent

  # test addition & multiplikation
  def test_add_mult() do
    e = {:add,
	 {:mul, {:num, 2}, {:var, :x}},
	 {:num, 4}}
    d = deriv(e, {:var, :x})
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("result pprint: #{pprint(d)}\n")
    IO.write("Result pprint & simple: #{pprint(simplify(d))}\n")
    :ok
  end
end
 
