// Módulo: instruction_memory
// Descripción: Simula una memoria de instrucciones de solo lectura (ROM) con 32 palabras de 32 bits.

module instruction_memory (
	input [31:0] A,           // Dirección de acceso a la memoria 
	output reg [31:0] RD      // Instrucción leída desde la memoria
);

reg [31:0] mem [0:31]; // Se crea memoria de 32 registros de 32 bits

initial begin
	$readmemh("instructions.mem", mem); // Se lee las instrucciones desde un archivo .mem
end

always @(*) begin
	if (A[9:2] < 32) // Se usa A[9:2] porque las instrucciones siguen una secuencia a 4 bytes
		RD = mem[A[9:2]];
	else
		RD = 32'h00000013; // Se agrega este valor (NOP), para cuando está fuera de rango
end

endmodule