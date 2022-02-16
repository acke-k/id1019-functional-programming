defmodule Emulator do

  def run(prgm) do
    {code, data} = Program.load(prgm)
    code = Program.encode(code)
    code
    out = Out.new()
    reg = Register.new()
    run(0, code, reg, data, out)
  end

  # Läser nästa instruktion och exekverar den
  def run(pc, code, reg, mem, out) do
    next = Program.read_instruction(code, pc)
    case next do
      # Avsluta programmet
      {:halt} ->
	Out.close(out)
	
      # Lägg till ett register i out listan
      {:out, rs} ->
	pc = pc + 4
	s = Register.read(reg, rs)
	out = Out.put(out, s)
	run(pc, code, reg, mem, out)

      # Skriv rs + rt -> rd
      {:add, rd, rs, rt} ->
	pc = pc + 4
	s = Register.read(reg, rs)
	t = Register.read(reg, rt)
	reg = Register.write(reg, rd, s + t) # Varför var det en kommentar här?
	run(pc, code, reg, mem, out)
      # Skriv rs + imm -> rt
      {:addi, rt, rs, imm} ->
	pc = pc + 4
	s = Register.read(reg, rs)
	reg = Register.write(reg, rt, s + imm)
	run(pc, code, reg, mem, out)
      {:sub, rd, rs, rt} ->
	pc = pc + 4
	s = Register.read(reg, rs)
	t = Register.read(reg, rt)
	reg = Register.write(reg, rd, s - t)
	run(pc, code, reg, mem, out)
      {:lw, rd, rt, imm} ->
	pc = pc + 4
	addr = Register.read(reg, rt) + imm
	word = Memory.loadw(mem, addr)
	Register.write(reg, rd, word)
	run(pc, code, reg, mem, out)
      {:sw, rs, rt, imm} ->
	pc = pc + 4
	addr = Register.read(reg, rt) + imm
	word = Register.read(reg, rs)
	Memory.savew(mem, addr, word)
	run(pc, code, reg, mem, out)
      {:beq, rs, rt, imm} ->
	pc = pc + 4
	s = Register.read(reg, rs)
	t = Register.read(reg, rt)
	case (s - t) do
	  0 ->
	    pc = pc + imm + 4
	    run(pc, code, reg, mem, out)
	  _ -> run(pc, code, reg, mem, out)
	end
      {:bne, rs, rt, imm} ->
	pc = pc + 4
	s = Register.read(reg, rs)
	t = Register.read(reg, rt)
	case (s - t) do
	  0 -> run(pc, code, reg, mem, out)
	  _ ->
	    pc = pc + imm + 4
	    run(pc, code, reg, mem, out)
	end
      {:label, _} ->
	pc = pc + 4
	run(pc, code, reg, mem, out)
    end
  end
  
  def gen_code1() do
    {
      {:addi, 1, 0, 90},
      {:addi, 2, 1, 240},
      {:add, 3, 2, 1},
      {:sub, 4, 3, 1},
      {:out, 1},
      {:out, 2},
      {:out, 3},
      {:out, 4},
      {:halt}
    }
  end

  def gen_code2() do
    {
      {:addi, 1, 0, 10},
      {:addi, 2, 0, 20},
      {:label, :loop},
      {:addi, 3, 3, 1},
      {:bne, 3, 2, :loop},
      {:out, 3},
      {:halt}
    }
  end 

  def test1() do
    prgm = Program.new(gen_code1()) # Generera testkoden
    run(prgm)
  end
  def test2() do
    prgm = Program.new(gen_code2())
    run(prgm)
  end
end
