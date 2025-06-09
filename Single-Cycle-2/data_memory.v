// Módulo: data_memory
// Descripción: Implementa una memoria de datos que permite lecturas y escrituras sincronizadas con el flanco de subida del reloj.
// La escritura ocurre cuando WE (write enable) está activo.
// La dirección de lectura se registra para una mejor inferencia de RAM.
module data_memory (
	input clk, WE,                  // Señal de reloj y señal de escritura (Write Enable)
	input [31:0] A, WD,             // Dirección (A) y dato de entrada a escribir (WD)
	output reg [31:0] RD             // Dato leído desde la memoria
);

// Se define una memoria de datos con 10,001 palabras de 32 bits
// Este tamaño puede ser grande para algunos FPGAs pequeños, pudiendo forzar la inferencia a registros lógicos.
reg [31:0] data_mem [0:10_000];
reg [31:0] A_reg; // Registro para la dirección de lectura

// Escritura sincrónica y registro de dirección de lectura
always @(posedge clk) begin
	A_reg <= A; // Registrar la dirección de lectura para ayudar a la inferencia de RAM
	if (WE) begin
		// Asegurarse de que la dirección esté dentro de los límites de la memoria
		if (A <= 10_000) begin
			data_mem[A] <= WD;
			$display("DATA_MEM: Write Addr=%h, Data=%h at time=%t", A, WD, $time);
		end else begin
			$display("DATA_MEM: WARNING: Write access out of bounds at Addr=%h at time=%t", A, $time);
		end
	end
end

// Lectura combinacional de la memoria de datos usando la dirección registrada
always @(*) begin
	if (A_reg <= 10_000) begin
		RD = data_mem[A_reg];
	end else begin
		RD = 32'b0; // Retorna cero si la dirección de lectura está fuera de límites
		$display("DATA_MEM: WARNING: Read access out of bounds at Addr=%h at time=%t", A_reg, $time);
	end
end

endmodule