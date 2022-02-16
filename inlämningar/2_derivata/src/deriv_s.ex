defmodule Deriv do
  @type literal() ::
  {:num, number()} |
  {:var, atom()}

  @type expr() ::
  {:add, expr(), expr()} |
  {:mul, expr(), expr()} |
  literal()

  # Derivera variabler & nummer
  def deriv({:num, _}, _) do {:num, 0} end # Nummer
  def deriv({:var, v}, v) do {:num, 1} end # Variabel med sig själv
  def deriv({:var, _}, _) do {:num, 0} end # Variabel med annan variabel

  # Derivera expr()
  def deriv({:mul, e1, e2) do
	     
  end
