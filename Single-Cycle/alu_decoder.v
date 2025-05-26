module alu_decoder (
	input [1:0] alu_op,
	input /*clk,*/ funct7_5, op_5,
	input [2:0] funct3, 
	output reg [2:0] alu_control
);

always @(*)
	case (alu_op)
		2'b00:
			alu_control = 3'b000;
		2'b01:
			alu_control = 3'b001;
		2'b10:
			begin
				case (funct3)
					3'b000:
						begin 
							if ({op_5,funct7_5} == 2'b11)
								alu_control = 3'b001;
							else
								alu_control = 3'b000;
						end
					3'b001:
						alu_control = 3'b110;
					3'b010:
						alu_control = 3'b101;
					3'b110:
						alu_control = 3'b011;
					3'b111:
						alu_control = 3'b010;
					default:
						alu_control = 3'b000;
				endcase
			end
		default:
			alu_control = 3'b000;
	endcase
endmodule