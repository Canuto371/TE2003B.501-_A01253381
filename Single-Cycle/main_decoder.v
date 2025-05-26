module main_decoder (
	input [6:0] op,
	output reg branch, mem_write, alu_src, reg_write,
	output reg [1:0] imm_src, result_src, alu_op
);

always @(*) begin
	case (op)
		7'b0000011: begin // lw
			reg_write = 1;
			imm_src = 2'b00;
			alu_src = 1;
			mem_write = 0;
			result_src = 2'b01;
			branch = 0;
			alu_op = 2'b00;
		end
		7'b0100011: begin // sw
			reg_write = 0;
			imm_src = 2'b01;
			alu_src = 1;
			mem_write = 1;
			result_src = 2'b00;
			branch = 0;
			alu_op = 2'b00;
		end
		7'b0110011: begin // R-type
			reg_write = 1;
			imm_src = 2'b00;
			alu_src = 0;
			mem_write = 0;
			result_src = 2'b00;
			branch = 0;
			alu_op = 2'b10;
		end
		7'b1100011: begin // beq
			reg_write = 0;
			imm_src = 2'b10;
			alu_src = 0;
			mem_write = 0;
			result_src = 2'b00;
			branch = 1;
			alu_op = 2'b01;
		end
		7'b0010011: begin // I-type
			reg_write = 1;
			imm_src = 2'b00;
			alu_src = 1;
			mem_write = 0;
			result_src = 2'b00;
			branch = 0;
			alu_op = 2'b10;
		end
		7'b1101111: begin // jal
			reg_write = 1;
			imm_src = 2'b11;
			alu_src = 0;
			mem_write = 0;
			result_src = 2'b10;
			branch = 0;
			alu_op = 2'b00;
		end
		default: begin
			reg_write = 0;
			imm_src = 2'b00;
			alu_src = 0;
			mem_write = 0;
			result_src = 2'b00;
			branch = 0;
			alu_op = 2'b00;
		end
	endcase
end

endmodule
