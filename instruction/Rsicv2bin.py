def reg_to_bin(reg):
    return format(int(reg[1:]), '05b')


def imm_to_bin(imm, bits):
    imm = int(imm)
    if imm < 0:
        imm = (1 << bits) + imm
    return format(imm, f'0{bits}b')


def assemble_r_type(inst, rd, rs1, rs2, funct3, funct7):
    opcode = '0110011'
    return funct7 + reg_to_bin(rs2) + reg_to_bin(rs1) + funct3 + reg_to_bin(rd) + opcode


def assemble_i_type(inst, rd, rs1, imm, funct3, opcode):
    return imm_to_bin(imm, 12) + reg_to_bin(rs1) + funct3 + reg_to_bin(rd) + opcode


def assemble_s_type(inst, parts, funct3, opcode):
    imm = parts[2].split('(')[0]
    rs2 = parts[1]
    rs1 = parts[2].split('(')[1].rstrip(')')
    imm_bin = imm_to_bin(imm, 12)
    return imm_bin[0:7] + reg_to_bin(rs2) + reg_to_bin(rs1) + funct3 + imm_bin[7:12] + opcode


def assemble_lw(inst, parts, funct3, opcode):
    imm = parts[2].split('(')[0]
    rd = parts[1]
    rs1 = parts[2].split('(')[1].rstrip(')')
    imm_bin = imm_to_bin(imm, 12)
    return imm_bin[0:12] + reg_to_bin(rs1) + funct3 + reg_to_bin(rd) + opcode


def assemble_u_type(inst, rd, imm, opcode):
    immb = int(imm, 16)  # Convert hex string to int
    #print(immb)
    #print(imm_to_bin(immb, 20))
    return imm_to_bin(immb, 20) + reg_to_bin(rd) + opcode


def assemble_instruction(instruction):
    parts = instruction.split()
    inst = parts[0]
    #print(parts)
    if inst == 'add':
        return assemble_r_type(inst, parts[1], parts[2], parts[3], '000', '0000000')
    elif inst == 'sub':
        return assemble_r_type(inst, parts[1], parts[2], parts[3], '000', '0100000')
    elif inst == 'addi':
        return assemble_i_type(inst, parts[1], parts[2], parts[3], '000', '0010011')
    elif inst == 'lw':
        return assemble_lw(inst, parts, '010', '0000011')
    elif inst == 'sw':
        return assemble_s_type(inst, parts, '010', '0100011')
    elif inst == 'lui':
        return assemble_u_type(inst, parts[1], parts[2], '0110111')
    else:
        raise ValueError(f"Unsupported instruction: {inst}")


def main():
    instructions = [
        "lui x2 0x10000",
        "addi x3 x3 1","addi x4 x4 2","addi x5 x5 3","addi x6 x6 4","addi x7 x7 5","addi x8 x8 6","addi x9 x9 7","addi x10 x10 8",
        "addi x11 x11 9", "addi x12 x12 10", "addi x13 x13 11", "addi x14 x14 12", "addi x15 x15 13", "addi x16 x16 14", "addi x17 x17 15","addi x18 x18 16",

        "sw x3 0(x2)","sw x4 4(x2)","sw x5 8(x2)","sw x6 12(x2)",
        "sw x3 16(x2)","sw x4 20(x2)","sw x5 24(x2)","sw x6 28(x2)",
        "sw x3 32(x2)","sw x4 36(x2)","sw x5 40(x2)","sw x6 44(x2)",
        "sw x3 48(x2)","sw x4 52(x2)","sw x5 56(x2)","sw x6 60(x2)",

        "sw x3 64(x2)", "sw x6 68(x2)", "sw x9 72(x2)",
        "sw x4 76(x2)","sw x7 80(x2)", "sw x10 84(x2)",
        "sw x5 88(x2)", "sw x8 92(x2)","sw x11 96(x2)",

    ]
    hex_instructions = []
    for instr in instructions:
        bin_instr = assemble_instruction(instr)
        hex_instr = format(int(bin_instr, 2), '08x').upper()
        hex_instructions.append(hex_instr)
        print(f"{instr} -> {bin_instr} -> 0x{hex_instr}")

    with open('instruction.txt', 'w') as f:
        for hex_instr in hex_instructions:
            f.write(hex_instr + '\n')


if __name__ == "__main__":
    main()
