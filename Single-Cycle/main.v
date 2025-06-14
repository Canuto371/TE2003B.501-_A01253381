module main(
	input clk,
	output [31:0] debug_pc,
	output [31:0] debug_instruction
);

// Variables auxiliares
wire ALUSrc;
wire zero;
wire memWrite;
wire regWrite;
wire resultSrc;
wire PCSrc;
wire [31:0] A;
wire [31:0] PCTarget;
wire [31:0] PCPlus4;
wire [31:0] Instruction;
wire [31:0] result;
wire [31:0] RD2;
wire [31:0] immExt;
assign SrcB = ALUSrc ? immExt : RD2;
wire [31:0] SrcA;
wire [31:0] readData;
wire [31:0] alu_result;
wire [2:0] alu_control;
wire [31:0] PCNext;
wire [1:0] immSrc;

// Program Counter : En vez de utilizar una función externa, se realiza el cambio de PC a PCNext en el modulo main.
reg [31:0] PC;

//Se inicializa PC en 0
initial begin
	PC = 32'b0;
end

// Asignaciones
assign result = resultSrc ? readData : alu_result;
assign debug_pc = PC;
assign debug_instruction = Instruction;
assign PCNext = PCSrc ? PCTarget : PCPlus4;
assign PCTarget = PC + immExt;
assign PCPlus4 = PC + 4;

always @(posedge clk) begin
    PC <= PCNext;
end

// Instanciaciones de modulos Single Cycle
instruction_memory IM_INST(
	.A(PC),
	.RD(Instruction)
);

register_file RF_INST(
	.clk(clk),
	.WE3(regWrite),
	.A1(Instruction[19:15]),
	.A2(Instruction[24:20]),
	.A3(Instruction[11:7]),
	.WD3(result),
	.RD1(SrcA),
	.RD2(RD2)
);

extend EX_INST(
	.entrada(Instruction),
	.immSrc(immSrc),
	.immExt(immExt)
);

ALU ALU_INST(
	.SrcA(SrcA), 
	.SrcB(SrcB),
	.alu_control(alu_control),
	.alu_result(alu_result),
	.zero(zero)
);

data_memory DM_INST(
	.clk(clk),
	.WE(memWrite),
	.A(alu_result), 
	.WD(RD2),
	.RD(readData) //Instruction
);

control_unit CU_INST(
	.op(Instruction[6:0]),
	.funct3(Instruction[14:12]),
	.funct7_5(Instruction[30]),
	.zero(zero),
	.PCSrc(PCSrc),
	.resultSrc(resultSrc),
	.memWrite(memWrite),
	.alu_control(alu_control),
	.ALUSrc(ALUSrc),
	.immSrc(immSrc),
	.regWrite(regWrite)
);

endmodule