// Módulo: extend
// Descripción: Extiende inmediatos de 12 a 32 bits con signo según el tipo de instrucción (I, S, B, J).
module extend (
	input [31:0] entrada,     // Entrada de la instrucción completa
	input [1:0] immSrc,      // Selección del tipo de inmediato (I, S, B, J)
	output reg [31:0] immExt  // Inmediato extendido a 32 bits con signo
);

always @(*) begin
	case(immSrc)
		2'b00: begin // I-Type (Immediate de 12 bits para Load/I-type aritméticos/JALR)
			// imm[31:20]
			immExt = {{20{entrada[31]}}, entrada[31:20]}; // Extensión de signo
		end
		2'b01: begin // S-Type (Immediate de 12 bits para Store)
			// {imm[31:25], imm[11:7]}
			immExt = {{20{entrada[31]}}, entrada[31:25], entrada[11:7]}; // Extensión de signo
		end
		2'b10: begin // B-Type (Immediate de 13 bits, el bit 0 es implícito 0)
			// {imm[31], imm[7], imm[30:25], imm[11:8], 1'b0}
			immExt = {{20{entrada[31]}}, entrada[7], entrada[30:25], entrada[11:8], 1'b0};
		end
		2'b11: begin // J-Type (Immediate de 21 bits, el bit 0 es implícito 0)
			// {imm[31], imm[19:12], imm[20], imm[30:21], 1'b0}
			immExt = {{12{entrada[31]}}, entrada[19:12], entrada[20], entrada[30:21], 1'b0};
		end
		default:
			immExt = 32'b0; // Valor indefinido en caso de tipo desconocido
	endcase
end

endmodule