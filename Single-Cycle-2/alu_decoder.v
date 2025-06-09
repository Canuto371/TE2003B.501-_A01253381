// Módulo: alu_decoder
// Descripción: Decodifica las señales de control para la ALU basándose en el opcode, funct3 y funct7.
module alu_decoder (
	input [1:0] alu_op,// Operación de ALU de alto nivel desde main_decoder
	input funct7_5,// Bit 30 de la instrucción (para diferenciar ADD/SUB, SRL/SRA)
	input [2:0] funct3,// Campo funct3 de la instrucción
	output reg [2:0] alu_control// Señal de control final para la ALU
);

always @(*) begin
	case (alu_op)
		2'b00: begin// ALU_OP para Load/Store/JAL/JALR (siempre ADD para cálculo de dirección)
			alu_control = 3'b000;// ADD
		end
		2'b01: begin// ALU_OP para BEQ (SUB para comparación)
			alu_control = 3'b001;// SUB
		end
		2'b10: begin// ALU_OP para R-type y I-type (operaciones aritméticas/lógicas detalladas)
			case (funct3)
				3'b000: begin// ADD/SUB (R-type), ADDI (I-type)
					if (funct7_5 == 1'b1)// Si funct7[5] es 1 (bit 30), es SUB (0x4000_0000 para SUB)
						alu_control = 3'b001;// SUB
					else
						alu_control = 3'b000;// ADD
				end
				3'b001: alu_control = 3'b110;// SLL
				3'b010: alu_control = 3'b101;// SLT
				3'b011: alu_control = 3'b100;// SLTU (Set Less Than Unsigned - no implementado en ALU tal cual, pero asignado a XOR)
				3'b100: alu_control = 3'b100;// XOR
				3'b101: begin// SRL/SRA
					if (funct7_5 == 1'b1)
						alu_control = 3'b111;
					else
						alu_control = 3'b111;
				end
				3'b110: alu_control = 3'b011;// OR
				3'b111: alu_control = 3'b010;// AND
				default: alu_control = 3'b000;// Default a ADD
			endcase
		end
		default:
			alu_control = 3'b000;// Default a ADD
	endcase
end

endmodule