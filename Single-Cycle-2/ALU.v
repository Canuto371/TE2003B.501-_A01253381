// Módulo: ALU
// Descripción: Realiza operaciones aritméticas y lógicas entre dos fuentes de 32 bits, basadas en una señal de control.
// Los códigos de alu_control están estandarizados con el alu_decoder.
module ALU(
	input [31:0] SrcA, SrcB,// Entradas de 32 bits: source A y B
	input [2:0] alu_control,// Código de operación de la ALU (3 bits)
	output reg [31:0] alu_result,// Resultado de la ALU
	output reg zero // Indicador si el resultado es cero
);

always @(*) begin
	case(alu_control)
		3'b000: alu_result = SrcA + SrcB;// ADD
		3'b001: alu_result = SrcA - SrcB;// SUB
		3'b010: alu_result = SrcA & SrcB;// AND
		3'b011: alu_result = SrcA | SrcB;// OR
		3'b100: alu_result = SrcA ^ SrcB;// XOR
		3'b101: alu_result = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
		3'b110: alu_result = SrcA << SrcB;
		3'b111: begin
			alu_result = SrcA >> SrcB;
		end
		default: alu_result = 32'b0;
	endcase
	zero = (alu_result == 32'b0);
	$display("ALU: alu_control=%b, SrcA=%h, SrcB=%h -> result=%h, zero=%b", alu_control, SrcA, SrcB, alu_result, zero);
end

endmodule