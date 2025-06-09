// Módulo: main_tb
// Descripción: Testbench para simular el procesador RISC-V de ciclo único.
module main_tb();
	reg clk;
	reg reset; // Se agrega la señal de reset

	wire [31:0] debug_pc;
	wire [31:0] debug_instruction;

// Instancia del procesador (Device Under Test)
main DUT (
	.clk(clk),
	.reset(reset), // Conecta la señal de reset
	.debug_pc(debug_pc),
	.debug_instruction(debug_instruction)
);

// Generación de reloj
always begin
	#10 clk = ~clk; // Periodo de reloj de 20 unidades de tiempo
end

// Secuencia de inicialización y simulación
initial begin
	clk = 0;
	reset = 1; // Afirmar reset al inicio
	#20;       // Mantener reset por un ciclo de reloj completo
	reset = 0; // Desafirmar reset
	#5000;     // Ejecutar simulación por 5000 unidades de tiempo
	$stop;     // Detener la simulación
end

// Monitorización de señales clave
initial begin
	$monitor("t=%t | PC=%h | Instr=%h", $time, debug_pc, debug_instruction);
end

endmodule