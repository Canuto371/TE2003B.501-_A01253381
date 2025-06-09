// Módulo: main
// Descripción: Módulo principal del procesador RISC-V de ciclo único.
// Integra todos los bloques funcionales y gestiona el flujo de datos y control.
module main(
	input clk,
	input reset, // Se agrega la señal de reset
	output [31:0] debug_pc,
	output [31:0] debug_instruction
);

// Variables auxiliares para la ruta de datos y señales de control
wire ALUSrc;// Selección de segundo operando de la ALU (registro o inmediato)
wire zero;// Bandera de cero de la ALU (para ramas)
wire memWrite;// Habilitación de escritura en memoria de datos
wire regWrite;// Habilitación de escritura en el banco de registros
wire [1:0] resultSrc;// Selección de fuente de datos para escribir en registros (ALU, Memoria, PC+4)
wire PCSrc;// Señal para seleccionar si el PC debe saltar (rama o JAL/JALR)
wire [31:0] PCTarget;// Dirección de destino para ramas o saltos
wire [31:0] PCPlus4;// PC + 4 (siguiente instrucción secuencial)
wire [31:0] Instruction;// Instrucción actual leída de la memoria de instrucciones
wire [31:0] result;// Dato final a escribir en el banco de registros
wire [31:0] RD2;// Dato leído del segundo puerto del banco de registros (SrcB si ALUSrc=0 o dato para SW)
wire [31:0] immExt;// Inmediato extendido con signo
wire [31:0] SrcB;// Segundo operando de la ALU
wire [31:0] SrcA;// Primer operando de la ALU (siempre del banco de registros)
wire [31:0] readData;// Dato leído de la memoria de datos
wire [31:0] alu_result;// Resultado de la ALU
wire [2:0] alu_control;// Señal de control para la ALU
wire [31:0] PCNext;// Próximo valor del contador de programa (PC)
wire [1:0] immSrc;// Tipo de extensión de inmediato

// Program Counter (PC): Contador de Programa
reg [31:0] PC;

// Inicialización del PC y lógica de reset
initial begin
	PC = 32'b0;
end

always @(posedge clk or posedge reset) begin
	if (reset) begin
		PC <= 32'b0; // Resetea el PC a 0
	end else begin
		PC <= PCNext; // Actualiza el PC al siguiente valor
	end
end

// Asignaciones combinacionales
assign SrcB = ALUSrc ? immExt : RD2;// Multiplexor para el segundo operando de la ALU
assign debug_pc = PC;// Salida de depuración para el PC
assign debug_instruction = Instruction;// Salida de depuración para la instrucción
assign PCTarget = PC + immExt;// Cálculo de la dirección de salto (PC + inmediato)
assign PCPlus4 = PC + 32'd4;// Cálculo de la siguiente dirección secuencial (PC + 4 bytes)

// **CORRECCIÓN:** Asignación del próximo valor del PC
// PCNext será PCTarget si PCSrc es 1 (salto o rama), de lo contrario será PCPlus4
assign PCNext = PCSrc ? PCTarget : PCPlus4;


// Multiplexor para seleccionar el dato que se escribe en el banco de registros
// resultSrc = 00: alu_result (R-type, I-type)
// resultSrc = 01: readData (Load Word)
// resultSrc = 10: PCPlus4 (JAL)
assign result = (resultSrc == 2'b01) ? readData:(resultSrc == 2'b10) ? PCPlus4:alu_result;

// Instanciaciones de módulos del procesador de ciclo único
instruction_memory IM_INST(
	.A(PC),// Dirección del PC para leer la instrucción
	.RD(Instruction)// Salida de la instrucción leída
);

register_file RF_INST(
	.clk(clk),
	.WE3(regWrite),// Habilitación de escritura en registros
	.A1(Instruction[19:15]),// Dirección del registro fuente 1 (rs1)
	.A2(Instruction[24:20]),// Dirección del registro fuente 2 (rs2)
	.A3(Instruction[11:7]),// Dirección del registro destino (rd)
	.WD3(result),// Dato a escribir en el registro destino
	.RD1(SrcA),// Dato leído del registro rs1
	.RD2(RD2)// Dato leído del registro rs2
);

extend EX_INST(
	.entrada(Instruction),// La instrucción completa para extraer el inmediato
	.immSrc(immSrc),// Tipo de extensión del inmediato
	.immExt(immExt)// Inmediato extendido
);

ALU ALU_INST(
	.SrcA(SrcA),// Primer operando de la ALU
	.SrcB(SrcB),// Segundo operando de la ALU
	.alu_control(alu_control),// Señal de control de la ALU
	.alu_result(alu_result),// Resultado de la operación ALU
	.zero(zero)// Bandera de cero
);

data_memory DM_INST(
	.clk(clk),// Reloj para la memoria de datos
	.WE(memWrite),// Habilitación de escritura en memoria
	.A(alu_result),// Dirección de memoria (calculada por ALU)
	.WD(RD2),// Dato a escribir en memoria
	.RD(readData)// Dato leído de memoria
);

control_unit CU_INST(
	.op(Instruction[6:0]),// Opcode de la instrucción
	.funct3(Instruction[14:12]),// Campo funct3
	.funct7_5(Instruction[30]),// Bit 30 del campo funct7
	.zero(zero),// Bandera de cero para ramas condicionales
	.PCSrc(PCSrc),// Salida: Habilitación de salto del PC
	.resultSrc(resultSrc),// Salida: Selección de fuente para escribir en registros
	.memWrite(memWrite),// Salida: Habilitación de escritura en memoria
	.alu_control(alu_control),// Salida: Señal de control de la ALU
	.ALUSrc(ALUSrc),// Salida: Selección de segundo operando de la ALU
	.immSrc(immSrc),// Salida: Tipo de extensión de inmediato
	.regWrite(regWrite)// Salida: Habilitación de escritura en registros
);

endmodule