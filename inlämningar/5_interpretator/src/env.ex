defmodule Env do

  # Grundläggande typer
  @type atm :: {:atm, atom}
  @type vari :: {:var, atom}
  @type ignore :: :ignore
  @type cons(h, t) :: {:cons, h, t}
  @type env :: {:env, map}
  @type clause :: {:clause, pat, seq}
  @type cas :: {:case, expr, clause} | {:case, expr, list}
  @type params :: [vari] # Lista med vari, t.ex. [{:var, :x}, {:var, :y}]
  @type free :: [vari]  # Lista med vari, t.ex. [{:var, :x}, {:var, :y}]
  @type args :: list # Det som kommer sätts i de bundna variablerna
  @type fun :: {:fun, atm} # {:fun, id}
  
  # Typ för mönster
  @type pat :: atm | vari | ignore | cons(pat, pat)

  # Uttryck
  @type expr :: atm | vari | cons(expr, expr)

  # match
  @type match :: {pat, expr}
  
  # Sekvens
  @type seq :: expr || {match, seq} # Lista av matches med expr på slutet

  # Lambda
  @type lambda :: {:lambda, params, free, seq}
  @type closure :: {:closure, params, seq, env}
  @type apply :: {:apply, expr, args}

  # Funktioner för att hantera listor
  def list_add(key, val, list) do
    [{key, val}] ++ list
  end

  def list_lookup(key, list) do
    List.keyfind(list, key, 0)
  end

  def list_remove(key, list) do
    List.keydelete(list, key, 0)
  end
  
  # Funktioner för att hantera omgivningar
  def new() do
    {:env, []}
  end
  def add(id, str, {:env, env}) do
    {:env, list_add(id, str, env)}
  end

  def lookup(id, {:env, env}) do
    list_lookup(id, env)
  end
  # Tar bort alla bindningar till element i listan ur env
  def remove([], {:env, env}) do
    {:env, env}
  end

  def remove([h | t], {:env, env}) do
    remove(t, {:env, list_remove(h, env)})
  end
  # Skapa en closure: Se till att alla fria variabler har ett värde
  def closure([], {:env, env}) do {:env, env} end
  
  def closure([{:var, h} | t], {:env, env}) do
    case lookup(h, {:env, env}) do
      {_, _} ->
	closure(t, {:env, env})
	
      nil ->
	IO.puts("closure failed: fri variabel har ej tilldelats värde: ")
	IO.inspect(h)
	IO.puts("\n")
	:error
    end
  end
  # tilldela alla args värden från params args(parameters, args, env)
  def args([], _, {:env, env}) do {:env, env} end
    
  def args([{_, par_id} | pt], [arg_id | at], {:env, env}) do
    args(pt, at, add(par_id, arg_id, {:env, env}))
  end
  def args(_, _, _) do
    IO.puts("args(): Nådde catch-all")
    :error
  end
  
  # Returnera en lista med alla variabler i mönstret
  def extract_vars({:var, id}) do [id] end
  def extract_vars({:cons, ph, pt}) do extract_vars(ph) ++ extract_vars(pt) end # Gör append här
  def extract_vars(_) do [] end

end
