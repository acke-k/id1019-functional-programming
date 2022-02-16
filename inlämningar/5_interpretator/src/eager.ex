# args funktionen gör inte rött
# Om man kollar seq e den tom och args är seq
# Har nog blandat ihop dem tidigare eller nåt

defmodule Eag do

  # eval_expr
  # returnerar {:ok, str} eller :error
  def eval_expr({:atm, id}, _) do {:ok, id} end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
	IO.puts("eval_expr(var): Ingen bindning till variabel #{id}\n")
	:error
	
      {_, str} ->
	{:ok, str} 
    end
  end

  def eval_expr({:cons, he, te}, env) do
    case eval_expr(he, env) do
      :error ->
	IO.puts("eval_expr(cons): Kunde inte evaluera head")
	:error
	
      {:ok, hs} ->
	case eval_expr(te, env) do
	  :error ->
	    IO.puts("eval_expr(cons): Kunde inte evaluera tail")
	    :error
	    
	  {:ok, ts} ->
	    {:ok, {hs, ts}}
	end
    end
  end

  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
	IO.puts("eval_expr(case): Kunde inte evaluera expr (case <expr> do")
	:error
	
      {:ok, str} ->
	eval_cls(cls, str, env)
    end
  end
  # ett closure garanterar att alla variabler i free ej har ett värde
  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
	IO.puts("eval_expr(lambda): Kunde inte skapa closure.")
	:error
      closure ->
	{:ok, {:closure, par, seq, closure}} # closure är ett nytt env där alla variabler i free är tilldelade
    end
  end	 

  def eval_expr({:apply, eid, args}, env) do
    case eval_expr(eid, env) do
      :error ->
	IO.puts("eval_expr(apply): Kunde inte evaluera expression id")
	:error
      {_, {:closure, par, seq, closure}} ->
	case eval_args(args, env) do
	  :error ->
	    IO.puts("eval_expr(apply): Kunde inte evaluera argument.")
	    :error
	  {:ok, strs} ->
	    env = Env.args(par, strs, closure)
	    eval_seq(seq, env)
	end
    end
  end
  
  def eval_expr({:fun, id}, env) do
    {par, seq} = apply(Prgm, id, [])
    {:ok, {:closure, par, seq, env}}
  end
  
  def eval_expr({:call, id, args}, env) do
    {par, seq} = apply(Prgm, id, [])
    case eval_args(args, env) do
      :error -> :error
      {:ok, str} ->
        new_env = Env.args(par, str, env)
        eval_seq(seq, new_env)
      end
  end
  def eval_expr(ogiltigt, env) do
    IO.puts("eval_expr(): Ogiltigt uttryck: ")
    IO.inspect(ogiltigt)
    IO.puts("env")
    IO.inspect(env)
    IO.puts("\n")
    :error
  end

  # Kopplar parametrar till argument
  # Returnerar dem i en lista
  def eval_args(args, env) do
    eval_args(args, env, [])
  end
  def eval_args([], _, ret) do {:ok, ret} end
  def eval_args([arg | at], env, ret) do
    case eval_expr(arg, env) do
      :error ->
	IO.puts("eval_args(): eval_expr() misslyckades")
	:error
      {:ok, str} ->
	eval_args(at, env, ret ++ [str])
    end
  end

  def eval_cls([], _, _) do
    IO.puts("Ingen klausul matchade\n")
    :error
  end
  
  def eval_cls([{:clause, pat, seq} | cls], str, env) do
    env = eval_scope(pat, env)
    
    case eval_match(pat, str, env) do
      # Om :fail -> prova nästa klausul
      :fail ->
	eval_cls(cls, str, env)
	# Om lyckas -> evaluera sekvensen som tillhör klausulen
      {:ok, env} ->
	eval_seq(seq, env)
    end
  end

  # eval_mathc
  # evaluerar struct mot pattern, alltså mönstermatcha
  # returnerar ett nytt environment eller :fail
  # eval_match(pat, struct, env) <==> <struct> = <pattern>
  # Förstår ej: Varför lägger man till variabeln i env?
  
  # matcha atom, ändrar ej env
  def eval_match({:atm, id}, id, {:env, env}) do
    {:ok, env}
  end
  # matcha variabel mot struktur. Lägg till i env, gör inget eller :fail
  def eval_match({:var, id}, str, {:env, env}) do
    case Env.lookup(id, {:env, env}) do
      nil ->
	{:ok,
	 Env.add(id, str, {:env, env})}
	
      {^id, ^str} ->
	{:ok, {:env, env}}
	
      {_, _} ->
	:fail
    end
  end
  # matcha ignore. Blir alltid ok, samma strukt
  def eval_match(:ignore, _, env) do {:ok, env} end
  # matcha cons(var) mot struktur. Anropa den andra match funktionerna
  def eval_match({:cons, hp, tp}, {hs, ts}, {:env, env}) do
    case eval_match(hp, hs, {:env, env}) do
      :fail ->
	:fail

      {:ok, env} ->
	eval_match(tp, ts, env)
    end
  end
  # Alla övriga blir fail
  def eval_match(_, _, _) do
    :fail
  end

  # Evaluera sekvens
  # Ta bort alla bindningar till variabler
  def eval_scope(pat, env) do Env.remove(Env.extract_vars(pat), env) end

  # Om det bara finns ett expr (inga matchningar) i sekvensen
  def eval_seq([expr], env) do
    eval_expr(expr, env)
  end

  def eval_seq([{:match, pat, expr} | seq], env) do
    case eval_expr(expr, env) do
      :error ->
	IO.puts("eval_seq(match): Kunde inte evaluera expr.")
	IO.inspect(expr)
	:error
	
      {:ok, str} ->
	envp = eval_scope(pat, env)

	case eval_match(pat, str, envp) do
	  :fail ->
	    IO.puts("eval_seq(match): Matchning misslyckades")
	    IO.inspect(pat)
	    IO.inspect(str)
	    :error

	  {:ok, envb} ->
	    eval_seq(seq, envb)
	end
    end
  end

  # Denna funktion anropas utifrån
  def eval(seq) do eval_seq(seq, Env.new()) end
  
end
