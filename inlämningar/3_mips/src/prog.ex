defmodule Program do

  @type reg() ::
  {0, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0}
  
  @type code() :: {:code, tuple()}
  @type data() :: {:data, list()}
  @type prgm() :: {:prgm, code(), data()}

  # Skapar nytt program från en given lista av kod. Kanske skriv modul som skapar program
  def new(code) do
    encode(code)
    prgm = {:prgm, {:code, code}, {:data, []}}
    prgm
  end

  # Returna kod & data segmenten
  def load({:prgm, {:code, code}, {:data, data}}) do
    {code, data}
  end

  # Läs instruktion vid pc
  def read_instruction(code, pc) do
    elem(code, div(pc, 4)) # Instruktioner är word alligned
  end

  def encode(code) do
    encode(0, code, [], :nil)
  end

  def encode(_, code, _, {:halt}) do code end
  def encode(pc, code, labels, {:label, lbl}) do
    next = Program.read_instruction(code, pc)
    pc = pc + 4
    labels = labels ++ [{lbl, pc - 4}]
    encode(pc, code, labels, next)
  end
  def encode(pc, code, labels, {:beq, rs, rt, a}) when is_number(a) do
    next = Program.read_instruction(code, pc)
    pc = pc + 4
    encode(pc, code, labels, next)
  end
  def encode(pc, code, labels, {:beq, rs, rt, lbl}) do
    next = Program.read_instruction(code, pc)
    pc = pc + 4
    jmpaddr = Memory.loadw(labels, lbl) - pc
    code = put_elem(code, div(pc - 8, 4), {:beq, rs, rt, jmpaddr})
    encode(pc, code, labels, next)
  end
  def encode(pc, code, labels, {:bne, rs, rt, lbl}) do
    next = Program.read_instruction(code, pc)
    pc = pc + 4
    jmpaddr = Memory.loadw(labels, lbl) - pc
    code = put_elem(code, div(pc - 8, 4), {:bne, rs, rt, jmpaddr})
    encode(pc, code, labels, next)
  end
  def encode(pc, code, labels, _) do
    next = Program.read_instruction(code, pc)
    pc = pc + 4
    encode(pc, code, labels, next)
  end
  
end
  
