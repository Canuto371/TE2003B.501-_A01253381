module main_tb();
	reg clk;
	reg reset;
	wire [31:0] debug_pc;
   wire [31:0] debug_instruction;

main DUT (
	.clk(clk),
	.debug_pc(debug_pc),
	.debug_instruction(debug_instruction)
);

always begin
	#10 clk=~clk;
end

initial begin
    clk = 0;
    #5000;
    $stop;
end
	
initial 
	begin
	  $monitor("t=%t | PC=%h | instr=%h", $time, debug_pc, debug_instruction);
	end
		
endmodule