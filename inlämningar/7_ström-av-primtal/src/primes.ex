defmodule Primes do

  defstruct [:next]

  # Implementerar enumerable
  def primes() do
    %Primes{next: fn() -> {2, fn() -> sieve(z(3), 2) end} end}
  end

  # Gör ej det
  #def primes() do
  #  fn() -> {2, fn() -> sieve(z(3), 2) end} end
  #end

  def next(%Primes{next: fun}) do
    {p, next_fun} = fun.()
    {p, %Primes{next: next_fun}}
  end
  
  defimpl Enumerable do

    def count(_) do {:error, __MODULE__} end
    def member?(_, _) do {:error, __MODULE__} end
    def slice(_) do {:error, __MODULE__} end

    def reduce(_, {:halt, acc}, _fun) do
      {:halted, acc}
    end

    def reduce(primes, {:suspend, acc}, fun) do
      {:suspended, acc, fn(cmd) -> reduce(primes, cmd, fun) end}
    end
    def reduce(primes, {:cont, acc}, fun) do
      {p, next} = Primes.next(primes)
      reduce(next, fun.(p, acc), fun)
    end
    
  end

  # Returnera fun
  # När fun anropas returneras {n + 1, fun}
  def z(n) do
    fun = fn() -> {n, z(n + 1)} end
    fun
  end

  # Tar in en genererare fun och ett nummer filt_num
  # Returnera continuation av fun med alla tal ej delbara med filt_num
  # {<första nummer ej delbart med filt_num>, continuation}
  def filter(fun, filt_num) do
    {next_num, next_fun} = fun.()
    case rem(next_num, filt_num) do
      0 ->
	filter(next_fun, filt_num)
      _ ->
	{next_num, fn() ->
	  filter(next_fun, filt_num) end}
    end
  end
  
  # Returnerar continuation av primtal
  # Returnerar ett primtal och en continuation av alla nummer där det primtalet är filtrerat
  # arg ges i f.(:<arg>)

  # "Default", d.v.s. utan flagga är att fortsätta leta
  def sieve(fun, prime) do
    {next_prime, next_fun} = filter(fun, prime)
    {next_prime, fn() -> sieve(next_fun, next_prime) end}
  end
  
  # Fortsätt leta
  def sieve(:cont, fun, prime) do
    {next_prime, next_fun} = filter(fun, prime)
    {next_prime, fn(arg) -> sieve(arg, next_fun, next_prime) end}
  end

  # Sluter söka efter nya primtal
  # Inte säker på vad som ska vara här
  def sieve(:halt, fun, prime) do
    {next_prime, next_fun} = filter(fun, prime)
    {next_prime, fn(arg) -> sieve(arg, next_fun, next_prime) end}
  end

end
  
