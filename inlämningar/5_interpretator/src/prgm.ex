# Definiera funktioner som kan anropas 

defmodule Prgm do

  def append() do
    {[{:var, :x},{:var, :y}],
     [{:case, {:var, :x},
       [{:clause, {:atm, []}, [{:var, :y}]},
	{:clause, {:cons, {:var, :hd}, {:var, :tl}},
	 [{:cons,
	   {:var, :hd},
	   {:call, :append, [{:var, :tl}, {:var, :y}]}}]
	}]
      }]
    }
  end
  
end
