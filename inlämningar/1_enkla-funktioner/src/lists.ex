defmodule Lists do
  # Returnera n:te elementet i listan l
  #
  # Ta bort element med -- och head
  # Ta sedan ut rätt element m.h.a. head
  # Anta att det första elementet i listan har index 0
  def nth(n, l) do
    case n do
      # Returnera huvudet i listan
      0 -> hd(l)
      # Ta bort ett element ur listan
      _ -> nth(n - 1, l -- [hd(l)])
    end
  end

  # Returnera antal element i en lista
  def len(l) do
    case l do
      # Om listan är tom
      [] -> 0
      # Om ej tom, kalla den rekursiva varianten
      _ -> len(1, l -- [hd(l)])
    end
  end

  # Rekursiv variant
  #
  # n sparar längden mellan varje anrop
  def len(n, l) do
    case l do
      # Skriv ut längden
      [] -> n
      # Annars anropa igen & inkrementera n, ta bort ett element ur l
      _ -> len(n + 1, l -- [hd(l)])
    end
  end

  # Returnerar summan av alla element i listan
  #
  # Först kolla om listan är tom, om inte anropas den rekursiva varianten
  def sum(l) do
    case l do
      [] -> 0
      _ -> sum(hd(l), l -- [hd(l)])
    end
  end

  # Rekursiv variant
  #
  # n sparar summan mellan varje anrop
  def sum(n, l) do
    case l do
      [] -> n
      _ -> sum(n + hd(l), l -- [hd(l)])
    end
  end

  # Duplicera alla element är duplicerade (finns två av varje)
  #
  # Basfall: Är listan tom?
  def duplicate(l) do
    case l do
      [] -> l
      _ -> duplicate(l, l)
    end
  end
  # Rekursiv variant
  #
  # Varje iteration tas ett element ur d och det läggs till i l
  def duplicate(l, d) do
    case d do
      [] -> l
      _ -> duplicate(l ++ [hd(d)], d -- [hd(d)])
    end
  end

  # Lägg till element x i listan om det inte finns i den
  #
  # Basfall: Är hd(l) == x?
  def add(x, l) do
    case hd(l) do
      ^x -> l
      _ -> add(x, l, l)
    end
  end
  # Rekursiv del
  #
  # Är listan tom eller är hd(d) == x?
  def add(x, l, d) do
    d = d -- [hd(d)]
    if d == [] do
      l = l ++ [x]
      l
    else
      case hd(d) do
	^x -> l
	_ -> add(x, l, d)
      end
    end
  end

  # Remove
  #
  # Basfall: Är hd(l) == x?
  def remove(x, l) do
    if l == [] do
      []
    else
      case hd(l) do
	^x -> remove(x, l -- [x], l -- [x])
	_ -> remove(x, l, l)
      end
    end
  end
  # Rekursivt steg: Är n:te elementet == x?
  def remove(x, l, d) do
    if d == [] do
      l
    else
      case hd(d) do
	^x -> remove(x, l -- [x], d -- [hd(d)])
	_ -> remove(x, l, d -- [hd(d)])
      end
    end
  end

  # Unique
  #
  # Basfall: Är head == något element i l?
  # Hjälpfunktion för att hitta element i lista
  def find(x, l) do
    if len(l) == 1 do
      hd(l) == x
    else
      case hd(l) do
	^x -> true
	_ -> find(x, l -- [hd(l)])
      end
    end
  end

  # Unique
  #
  # Basfall: Kolla huvud mot alla element efter huvud
  # Rekursivt steg: Kolla element n mot alla element utom n
  def unique(l) do
    if len(l) == 1 do
      l
    else
      case find(hd(l), l -- [hd(l)]) do
	true -> unique(l -- [hd(l)], l -- [hd(l)])
	false -> unique(l, l -- [hd(l)])
      end
    end
  end

  def unique(l, d) do
    if len(d) == 1 do
      case find(hd(d), l -- [hd(d)]) do
	true -> l -- [hd(d)]
	false -> l
      end
    else
      case find(hd(d), l -- [hd(d)]) do
	true -> unique(l -- [hd(d)], d -- [hd(d)])
	false -> unique(l, d -- [hd(d)])
      end
    end
  end

  # Tar bort alla element förutom n i en lista
  def remove_inverse(x, l) do
    if len(l) == 1 do
      case hd(l) do
	^x -> l
	_ -> []
      end
      
    else
      case hd(l) do
	^x -> remove_inverse(x, l, l -- [hd(l)])
	_ -> remove_inverse(x, l -- [hd(l)], l -- [hd(l)])
      end
    end
  end
  
  def remove_inverse(x, l, d) do
    if len(d) == 1 do
      case hd(d) do
	^x -> l
	_ -> l -- [hd(d)]
	end
    else
      case hd(d) do
      ^x -> remove_inverse(x, l, d -- [hd(d)])
	_ -> remove_inverse(x, l -- [hd(d)], d -- [hd(d)])
      end
    end
  end

  
  # Pack
  #
  # Basfall: Hur många gånger finns hd(l) i l? Ta bort dem och lägg till i ny lista
  # Rekursion: Hur många gånger finns n:te elementet i l? Ta bort dem och lägg till i ny lista
  def pack(l) do
    if remove(hd(l), l) == [] do
      [l]
    else
      pack(remove(hd(l), l), [remove_inverse(hd(l), l)])
    end
  end

  def pack(l, d) do
    if remove(hd(l), l) == [] do
      d ++ [remove_inverse(hd(l), l)]
    else
      pack(remove(hd(l), l), d ++ [remove_inverse(hd(l), l)])
    end
  end

  # Reverse
  def reverse([]) do [] end
    
  def reverse([h|t]) do
    reverse(t) ++ [h]
  end
    

end
