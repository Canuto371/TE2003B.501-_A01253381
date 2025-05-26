// Módulo: data_memory
// Descripción: Implementa una memoria de datos que permite lecturas y escrituras sincronizadas con el flanco de subida del reloj. 
// La escritura ocurre cuando WE (write enable) está activo.
 
 module data_memory (
	input clk, WE,                     // Señal de reloj y señal de escritura (Write Enable)
	input [31:0] A, WD,                // Dirección (A) y dato de entrada a escribir (WD)
	output reg [31:0] RD               // Dato leído desde la memoria
);

// Se define una memoria de datos con 10,001 palabras de 32 bits
reg [31:0] data_mem [0:10_000];

// Escritura sincrónica
always @(posedge clk) begin
if (WE)
	data_mem[A] <= WD;
end

// Lectura combinacional
always @(*) begin
	RD = data_mem[A];
end

endmodule