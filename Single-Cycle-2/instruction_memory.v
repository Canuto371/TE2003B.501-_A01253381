// Módulo: instruction_memory
// Descripción: Simula una memoria de instrucciones de solo lectura (ROM) con 32 palabras de 32 bits.
// Las instrucciones se leen desde un archivo "instructions.mem".
module instruction_memory (
	input [31:0] A,             // Dirección de acceso a la memoria (PC)
	output reg [31:0] RD        // Instrucción leída desde la memoria
);

reg [31:0] mem [0:31]; // Se crea memoria de 32 registros de 32 bits (128 bytes)

initial begin
	// Se lee las instrucciones desde un archivo .mem
	// Asegúrate de que "instructions.mem" exista en el directorio de simulación/proyecto
	$readmemh("instructions.mem", mem);
	$display("INSTRUCTION_MEM: Loaded instructions from instructions.mem");
end

// Lectura combinacional de la memoria de instrucciones
always @(*) begin
	// **CORRECCIÓN:** Se usa A[6:2] para acceder a la memoria de 32 palabras (0-31).
	// A[1:0] son los bits de offset dentro de la palabra, A[31:7] no se usan si la memoria es pequeña.
	// La dirección efectiva para la memoria es A / 4 (A >> 2).
	// Para 32 palabras, necesitamos 5 bits de dirección (2^5 = 32).
	// Si A es la dirección en bytes, el índice de la palabra es A[6:2].
	if (A[6:2] < 32) begin // Asegura que el acceso esté dentro de los límites de la ROM (0-31 palabras)
		RD = mem[A[6:2]];
	end else begin
		// Se agrega este valor (NOP - No Operation: ADDI x0, x0, 0), para cuando el PC está fuera de rango
		RD = 32'h00000013;
		$display("INSTRUCTION_MEM: WARNING: PC out of instruction memory range: %h. Issuing NOP.", A);
	end
end

endmodule