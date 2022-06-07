defmodule Morse do

  # Specs: O(lg(k)) eller O(1)
  # Lösning: Gör en map

  # Gör om trädet till en tuppel, lookup blir O(1)
  def encode_table_tup() do
    encode_table_tup(morse(), [], List.to_tuple(List.duplicate(0, 128)))
  end
  def encode_table_tup(:nil, _, table) do table end
  def encode_table_tup({:node, :na, long, short}, code, table) do
    table = encode_table_tup(long, code ++ '-', table)
    table = encode_table_tup(short, code ++ '.', table)
    table
  end   
  def encode_table_tup({:node, char, long, short}, code, table) do
    table = insert_tup(table, char, Enum.reverse(code))
    table = encode_table_tup(long, code ++ '-', table)
    table = encode_table_tup(short, code ++ '.', table)    
    table
  end
  # Stoppa in element i en tuppel
  def insert_tup(tuple, index, elem) do put_elem(tuple, index, elem) end
  # Elem är ett ascii värde
  def encode_lookup_tup(table, elem) do elem(table, elem) end

  # Specs: O(n*m), svansrekursiv
  # Är O(n) för att lookup är O(1)
  # Är svansrekursiv
  # Koda en sträng (endast små bokstäver)
  # Är o(
  def encode_tup(text) do encode_tup(text, encode_table_tup(), []) end
  
  def encode_tup([], _, encoded) do Enum.reverse(encoded) end
  def encode_tup([first | text], table, encoded) do
    encoded = [32] ++ encode_lookup_tup(table, first) ++ encoded # Svansrekursiv
    encode_tup(text, table, encoded)
  end

  def decode(text) do decode(text, morse(), []) end
  def decode([], _, acc) do Enum.reverse(acc) end
  def decode([head | text], {:node, val, long, short}, acc) do
    case head do
      32 ->
	#IO.inspect(val)
	acc = [val | acc]
	decode(text, morse(), acc)
      ?- ->
	decode(text, long, acc)
      ?. ->
	decode(text, short, acc)
    end
  end
    
  
  def morse() do
    {:node, :na,
     {:node, 116,
      {:node, 109,
       {:node, 111,
	{:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
	{:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
       {:node, 103,
	{:node, 113, nil, nil},
	{:node, 122,
	 {:node, :na, {:node, 44, nil, nil}, nil},
	 {:node, 55, nil, nil}}}},
      {:node, 110,
       {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
       {:node, 100,
	{:node, 120, nil, nil},
	{:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
     {:node, 101,
      {:node, 97,
       {:node, 119,
	{:node, 106,
	 {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
	 nil},
	{:node, 112,
	 {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
	 nil}},
       {:node, 114,
	{:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
	{:node, 108, nil, nil}}},
      {:node, 105,
       {:node, 117,
	{:node, 32,
	 {:node, 50, nil, nil},
	 {:node, :na, nil, {:node, 63, nil, nil}}},
	{:node, 102, nil, nil}},
       {:node, 115,
	{:node, 118, {:node, 51, nil, nil}, nil},
	{:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end
end
