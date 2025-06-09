// Módulo: control_unit
// Descripción: Genera las señales de control necesarias para ejecutar instrucciones RISC-V.
// Se compone de dos submódulos:
// - main_decoder: decodifica el opcode y genera señales de alto nivel
// - alu_decoder: decodifica detalles de la ALU a partir de funct3 y funct7
module control_unit (
	input [6:0] op,             // Opcode de la instrucción
	input [2:0] funct3,         // Campo funct3
	input funct7_5,             // Bit 5 del campo funct7 (bit 30 de la instrucción)
	input zero,                 // Resultado cero de la ALU (para ramas condicionales)
	output PCSrc,               // Señal para seleccionar si el PC debe saltar
	output [1:0] resultSrc,     // Selección de fuente de datos para escribir en registros
	output memWrite,            // Habilitación de escritura en memoria
	output regWrite,            // Habilitación de escritura en el banco de registros
	output [2:0] alu_control,   // Señal de control para la ALU
	output ALUSrc,              // Selección de segundo operando de la ALU (registro o inmediato)
	output [1:0] immSrc          // Tipo de extensión de inmediato
);

// Señales auxiliares internas
wire branch;
wire [1:0] alu_op;
wire jump; // **NUEVO:** Señal para indicar un salto incondicional (e.g., JAL)

// Instancia del decodificador principal que interpreta el opcode
main_decoder MD_INST(
	.op(op),
	.branch(branch),
	.mem_write(memWrite),
	.alu_src(ALUSrc),
	.reg_write(regWrite),
	.imm_src(immSrc),
	.result_src(resultSrc),
	.alu_op(alu_op),
	.jump(jump) // **CORRECCIÓN:** Conecta la nueva salida 'jump'
);

// Instancia del decodificador de ALU que interpreta funct3 y funct7_5
alu_decoder AD_INST(
	.alu_op(alu_op),
	.funct7_5(funct7_5),
	.funct3(funct3),
	.alu_control(alu_control)
);

// **CORRECCIÓN:** Determina si el PC debe tomar el nuevo valor (ramas condicionales o saltos incondicionales)
// PCSrc es 1 si es una instrucción de rama (branch) y la condición es verdadera (zero=1),
// O si es una instrucción de salto incondicional (jump=1, como JAL).
assign PCSrc = (branch & zero) | jump;

endmodule