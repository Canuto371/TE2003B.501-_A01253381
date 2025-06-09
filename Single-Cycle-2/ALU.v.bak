// Módulo: ALU
// Descripción: Realiza operaciones aritméticas y lógicas entre dos fuentes de 32 bits, basadas en una señal de control.

module ALU(
	input [31:0] SrcA, SrcB,            // Entradas de 32 bits: source A y B
	input [2:0] alu_control,            // Código de operación de la ALU (3 bits)
	output reg [31:0] alu_result,       // Resultado de la ALU
	output reg zero                     // Indicador si el resultado es cero
);

always @(*)
	begin
		case(alu_control)
			3'b000: //add
				alu_result = SrcA + SrcB;
			3'b001: //subtract
				alu_result = SrcA - SrcB;
			3'b110: //multiplicación
				alu_result = SrcA * SrcB;
			3'b101: //set less than
				alu_result = (SrcA < SrcB) ? 1 : 0; 
			3'b011: //or
				alu_result = SrcA | SrcB;
			3'b010: //and
				alu_result = SrcA & SrcB;
			default:
				alu_result = 32'b0;
		endcase
		
		zero = (alu_result == 32'b0);
		$display("ALU: alu_control=%b, SrcA=%h, SrcB=%h -> result=%h", alu_control, SrcA, SrcB, alu_result);
	end

endmodule