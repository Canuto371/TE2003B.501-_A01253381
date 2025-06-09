// Módulo: main_decoder
// Descripción: Decodifica el opcode de la instrucción y genera las señales de control de alto nivel
// para los diferentes componentes del procesador.
module main_decoder (
	input [6:0] op,             // Opcode de la instrucción
	output reg branch,          // Habilita rama (para BEQ)
	output reg mem_write,       // Habilita escritura en memoria de datos (para SW)
	output reg alu_src,         // Selecciona el segundo operando de la ALU (registro o inmediato)
	output reg reg_write,       // Habilita escritura en el banco de registros
	output reg [1:0] imm_src,   // Tipo de inmediato a extender
	output reg [1:0] result_src, // Fuente del dato a escribir en registros
	output reg [1:0] alu_op,     // Operación de ALU de alto nivel
	output reg jump              // **NUEVO:** Señal para indicar un salto incondicional (e.g., JAL)
);

always @(*) begin
	// Valores por defecto (generalmente para NOP o instrucciones no reconocidas)
	reg_write = 0;
	imm_src = 2'b00;
	alu_src = 0;
	mem_write = 0;
	result_src = 2'b00;
	branch = 0;
	alu_op = 2'b00; // Por defecto, ALU realiza una suma (ADD)
	jump = 0;       // **NUEVO:** Por defecto, no hay salto incondicional

	case (op)
		7'b0000011: begin // lw (Load Word)
			reg_write = 1;      // Escribir en registro
			imm_src = 2'b00;    // Tipo I-Type inmediato
			alu_src = 1;        // Segundo operando de ALU es inmediato
			mem_write = 0;      // No escribir en memoria
			result_src = 2'b01; // El resultado proviene de la memoria de datos
			branch = 0;         // No es una rama
			alu_op = 2'b00;     // ALU realiza ADD (para calcular la dirección de memoria)
			jump = 0;           // No es un salto incondicional
		end
		7'b0100011: begin // sw (Store Word)
			reg_write = 0;      // No escribir en registro
			imm_src = 2'b01;    // Tipo S-Type inmediato
			alu_src = 1;        // Segundo operando de ALU es inmediato
			mem_write = 1;      // Escribir en memoria
			result_src = 2'b00; // No aplica (el dato no se escribe en registro, sino en memoria)
			branch = 0;         // No es una rama
			alu_op = 2'b00;     // ALU realiza ADD (para calcular la dirección de memoria)
			jump = 0;           // No es un salto incondicional
		end
		7'b0110011: begin // R-type (operaciones aritméticas/lógicas entre registros)
			reg_write = 1;      // Escribir en registro
			imm_src = 2'b00;    // No aplica inmediato, pero 00 es un valor seguro
			alu_src = 0;        // Segundo operando de ALU es de registro (RD2)
			mem_write = 0;      // No escribir en memoria
			result_src = 2'b00; // El resultado proviene de la ALU
			branch = 0;         // No es una rama
			alu_op = 2'b10;     // ALU realiza operación R-type (determinado por funct3/funct7)
			jump = 0;           // No es un salto incondicional
		end
		7'b1100011: begin // beq (Branch Equal)
			reg_write = 0;      // No escribir en registro
			imm_src = 2'b10;    // Tipo B-Type inmediato
			alu_src = 0;        // Segundo operando de ALU es de registro (para comparación)
			mem_write = 0;      // No escribir en memoria
			result_src = 2'b00; // No aplica (el resultado de la ALU es solo para la bandera zero)
			branch = 1;         // Es una rama
			alu_op = 2'b01;     // ALU realiza SUB (para comparar si SrcA == SrcB, i.e., resultado cero)
			jump = 0;           // No es un salto incondicional
		end
		7'b0010011: begin // I-type (operaciones aritméticas/lógicas con inmediato)
			reg_write = 1;      // Escribir en registro
			imm_src = 2'b00;    // Tipo I-Type inmediato
			alu_src = 1;        // Segundo operando de ALU es inmediato
			mem_write = 0;      // No escribir en memoria
			result_src = 2'b00; // El resultado proviene de la ALU
			branch = 0;         // No es una rama
			alu_op = 2'b10;     // ALU realiza operación I-type (determinado por funct3)
			jump = 0;           // No es un salto incondicional
		end
		7'b1101111: begin // jal (Jump And Link)
			reg_write = 1;      // Escribir en registro (PC+4 en rd)
			imm_src = 2'b11;    // Tipo J-Type inmediato
			alu_src = 0;        // No aplica ALU para el cálculo del valor a escribir en rd
			mem_write = 0;      // No escribir en memoria
			result_src = 2'b10; // El resultado a escribir en rd es PC+4
			branch = 0;         // No es una rama condicional, es un salto incondicional
			alu_op = 2'b00;     // No aplica ALU (o ADD si fuera necesario, pero no para el valor a escribir en rd)
			jump = 1;           // **CORRECCIÓN:** Es un salto incondicional
		end
		default: begin
			// Todas las señales permanecen en sus valores por defecto (generalmente NOP o estado idle)
			$display("MAIN_DECODER: WARNING: Unknown opcode %b", op);
		end
	endcase
end

endmodule