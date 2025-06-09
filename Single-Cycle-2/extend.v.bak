// Módulo: extend
// Descripción: Extiende inmediatos de 12 a 32 bits con signo según el tipo de instrucción (I, S, B, J).

module extend (
	input [31:0] entrada,        // Entrada de la instrucción 
	input [1:0] immSrc,          // Selección del tipo de inmediato (I, S, B, J)
	output reg [31:0] immExt     // Inmediato extendido a 32 bits con signo
);

// Registro auxiliar de 12 bits para formar el inmediato antes de extenderlo
reg [11:0] aux_extend;

always @(*)
	begin
		case(immSrc)
			2'b00: //I-Type
				aux_extend = entrada[31:20];
			2'b01: //S-Type
				aux_extend = {entrada[31:25],entrada[11:7]};
			2'b10: //B-Type
				aux_extend = {entrada[31],entrada[7],entrada[30:25],entrada[11:8]};
			2'b11: //J-Type
				aux_extend = {entrada[31],entrada[19:12],entrada[20],entrada[30:21]};
			default:
				aux_extend = 12'b0; // Valor indefinido en caso de tipo desconocido
		endcase
		
		// Extensión de signo a 32 bits
		immExt = $signed(aux_extend); // Agrega a la izquierda 20 bits del bit más significativo de aux_extend
	end

endmodule