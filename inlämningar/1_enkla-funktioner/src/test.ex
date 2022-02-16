defmodule Test do
  def double(n) do
    n * 2
  end

  def far2cel(n) do
    (n-32)/1.8
  end

  def area_of_triangle(a, b) do
    (a * b) / 2
  end

  def area_of_square(a, b) do
    area_of_triangle(a, b) * 2
  end

  def area_of_circle(r) do
    2 * r * 3.14
  end
  
end
