defmodule Huff do

  def sample() do
    'Let me hit it raw like fuck the outcome 
    Ayy, none of usd be here without cum
    Ayy, if it ainät all about the income
    Ayy, ayy, let me see you gon ahead and spend some'
  end

  def text() do
    'deez nuts'
  end
      
  # Skapar huffmanträd
  def test() do
    text = text()
    freq = freq(text)
    tree = huffman(freq)
    table = encode_table(tree)
    encoded = encode(text, table)
    decoded = decode(encoded, table)
    IO.inspect(decoded)
    :ok
  end
  
  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def decode([], _) do [] end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
	{char, rest}
      nil ->
	decode_char(seq, n+1, table)
    end
  end

  def encode([], _table) do [] end
  def encode([char | rest], table) do
    {_, path}  = List.keyfind!(table, char, 0)
    path ++ encode(rest, table)
  end
    
  
  def encode_table(tree) do encode_table(tree, [], []) end
  def encode_table({{el1, el2}, _n}, table, path) do
    table = encode_table(el1, table, path ++ [1])
    table = encode_table(el2, table, path ++ [0])
    table
  end
  def encode_table({el, _n}, table, path) do table ++ [{el, path}] end 
   
  # Hittar frekvens av ord, returnerar lista av tupplar
  def freq(sample) do freq(sample, []) end
  def freq([], freq) do freq end
  def freq([char | rest], freq) do    
    case List.keymember?(freq, char, 0) do
      true ->
	 {char, n} = List.keyfind!(freq, char, 0)
	freq = List.keyreplace(freq, char, 0, {char, n+1})
	freq(rest, freq)
      false ->
	freq(rest, freq ++ [{char, 1}])
    end
  end
  # Kommer vara sorterad
  def insert_sorted(el, []) do [el] end
  def insert_sorted(el = {_, n}, [h = {_, hn} | t]) do
    case n < hn do
      true ->
	[el, h | t]
      false ->
	[h | insert_sorted(el, t)]
    end
  end
  
  def huffman(freq) do
    freq = List.keysort(freq, 1)
    hufftree(freq)
  end
  def hufftree([root]) do root end
  def hufftree(tree) do
    {el1 = {_, n1}, tree} = List.pop_at(tree, 0)
    {el2 = {_, n2}, tree} = List.pop_at(tree, 0)
    comb = {{el1, el2}, n1+n2}
    tree = insert_sorted(comb, tree)
    hufftree(tree)
  end

  def read(file, n) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, n)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} ->
	list
      list ->
	list
    end
  end
  # Har kvar chars som finns i filter
  def filter(text, filter) do
    filt = fn(c) -> Enum.member?(filter, c) end
    Enum.filter(text, filt)
  end
    

  def loop(fun) do loop(100, {0, 0, 0, 0}, fun) end
  def loop(0, res, _) do
    { elem(res, 0)/100,
     elem(res, 1)/100,
     elem(res, 2)/100,
     elem(res, 3)/100,
    }
  end
  
  def loop(n, res, fun) do
    temp = fun.()
    res = {elem(res, 0) + elem(temp, 0),
	   elem(res, 1) + elem(temp, 1),
	   elem(res, 2) + elem(temp, 2),
	   elem(res, 3) + elem(temp, 3)
    }
    loop(n-1, res, fun)
  end
  # Benchmarka antal karaktärer
  # i * 4000
  def rand(0) do 0 end
  def rand(n) do :rand.uniform(n) end

  def bench(file) do
    #text = filter(read(file, :all), [])
    text = 'a'
    len = length(text)
    size = 100
    IO.puts("elem\tfreq\ttree\tencode\tdecode\t")
    for i <- 1..1000 do # Antal datapunkter
      #rand = rand(len - i*size) # size är hur stort hopp mellan punkt
      #rand = 0
      #text = Enum.drop(text, rand)
      #text = Enum.take(text, i*size) # samma
      {t_fr, t_tr, t_en, t_de} = loop(fn() -> bench_huff(text) end)
      IO.puts("#{i*size}\t#{t_fr}\t#{t_tr}\t#{t_en}\t#{t_de}")
    end
    :ok
  end

  def bench_huff(text) do
    {t_fr, freq} = :timer.tc(fn() -> freq(text) end)
    {t_tr, tree} = :timer.tc(fn() -> huffman(freq) end)
    table = encode_table(tree)
    {t_en, encoded} = :timer.tc(fn() -> encode(text, table) end)
    {t_de, _decoded} = :timer.tc(fn() -> decode(encoded, table) end)
    {t_fr, t_tr, t_en, t_de}
  end
  
end
