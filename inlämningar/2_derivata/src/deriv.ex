defmodule Deriv do
  
@type literal() :: {:num, number()} | {:var, atom()} # Typer för nummer & variabler

 @type expr() ::
 literal() # Typer vi kan derivera
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), number()}
  | {:ln, expr()}
  | {:sin, expr()}
  | {:cos, expr()}

  # Derivera tal & variabler
  def deriv({:num, _}, _) do {:num, 0} end # Derivera tal
  def deriv({:var, v}, {:var, v}) do {:num, 1} end # Variabel med sig själv
  def deriv({:var, _}, _) do {:num, 0} end # Variabel med annan variabel

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
  # Derivera exponent (i pricip kedjereglen, [expression]^[number])
  def deriv({:exp, f, {:num, n}}, v) do
    {:mul,
     {:mul, {:num, n}, deriv(f, v)},
     {:exp, f, {:num, n - 1}}}
  end
  # Derivera naturliga logaritmen
  def deriv({:ln, f}, v) do
    {:mul,
     deriv(f, v),
     {:exp, f, {:num, -1}}}
  end
  # Derivera trigfunktioner
  def deriv({:sin, f}, v) do
    {:mul,
     deriv(f, v),
     {:cos, f}}
  end
  def deriv({:cos, f}, v) do
    {:mul,
     deriv(f, v),
     {:mul, {:num, -1}, {:sin, f}}}
  end

  # Simplify
  # Ta in ett expression och förenkla om möjligt
  # Skicka vidare till funktioner som hanterar olika specialfall
  # ADD
   # För att simplify_add ska fungera är nummer alltid till vänster
  def simplify({:add, a, {:num, n}}) do
    simplify({:add, {:num, n}, a})
  end
  # Catch all add
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  
  # MUL
   # Om vi har två nummer
  def simplify({:mul, {:num, a}, {:num, b}}) do
    simplify_mul(simplify({:num, a}), simplify({:num, b}))
  end
  
   # För att simplify_mul ska fungera är nummer alltid till vänster 
  def simplify({:mul, a, {:num, n}}) do
    simplify({:mul, {:num, n}, a})
  end
   # Catch all mul
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  # EXP
   # Catch all exp
  def simplify({:exp, f, n}) do
    simplify_exp(simplify(f), simplify(n))
  end
  
  # LN
   # Catch all ln
  def simplify({:ln, f}) do
    simplify_ln(simplify(f))
  end

  # TRIG
  def simplify({:sin, f}) do
    simplify_sin(simplify(f))
  end
  def simplify({:cos, f}) do
    simplify_cos(simplify(f))
  end
  
  def simplify(e) do e end # Catch all

  # Specialfall för add
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add({:num, e1}, {:num, e2}) do {:num, e1+e2} end
  # Fall då vi har ((x + a) + b) = ((a + b) + x) där x är var
  def simplify_add({:num, a}, {:add, {:num, b}, v}) do
    {:add, {:num, a + b}, v}
  end
  def simplify_add(e1, e2) do {:add, e1, e2} end # Catch all
    		     
  # Specialfall mul
  def simplify_mul(_, {:num, 0}) do {:num, 0} end # Om ett nummer är 0
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(e1, {:num, 1}) do e1 end # Om ett nummer är 1
  def simplify_mul({:num, 1}, e2) do e2 end
  # Fall: ((x * a) * b) där a & b är nummer
  def simplify_mul({:num, a}, {:mul, {:num, b}, v}) do
    {:mul, {:num, a + b}, v}
  end
  # Fall: Två exponenter med samma bas
  def simplify_mul({:exp, f, a}, {:exp, f, b }) do
    {:exp, f, {:num, a + b}}
  end
  def simplify_mul({:num, a}, {:num, b}) do {:num, a * b} end
  def simplify_mul(a, a) do {:exp, a, {:num, 2}} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end # Catch all

  # Specialfall exp
  def simplify_exp(_, {:num, 0}) do {:num, 1} end # f^0 = 1
  def simplify_exp(f, {:num, 1}) do f end # f^1 = f
  # Todo: Skapa funktion för att multiplicera exponent
  def simplify_exp(f, n) do {:exp, f, n} end # Catch all
  
  # Specialfall ln
  def simplify_ln({:num, 1}) do {:num, 0} end
  # Todo: Skriv clause för f = e
  def simplify_ln(f) do {:ln, f} end # Catch all

  # Specialfall trig
  # Todo: Lägg till specialfall med pi
  def simplify_cos({:num, 0}) do {:num, 1} end
  def simplify_cos(f) do {:cos, f} end # Catch all
  def simplify_sin({:num, 0}) do {:num, 0} end
  def simplify_sin(f) do {:sin, f} end # Catch all

  # Prettyprint
  # Tar in ett expression och omvandlar till string
    # Pretty print
  def pprint({:num, n}) do "#{n}" end # Nummer
  def pprint({:var, v}) do "#{v}" end # Variabel
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end # Addition
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end # Multiplikation
  def pprint({:exp, f, n}) do  "(#{pprint(f)})^(#{pprint(n)})" end # Exponent
  def pprint({:ln, f}) do  "ln(#{pprint(f)})" end # Naturliga logaritmen
  def pprint({:sin, f}) do  "sin(#{pprint(f)})" end # Naturliga logaritmen
    def pprint({:cos, f}) do  "cos(#{pprint(f)})" end # Naturliga logaritmen
end
