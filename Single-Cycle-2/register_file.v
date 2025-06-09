// Módulo: register_file
// Descripción: Implementa un banco de registros con dos puertos de lectura y uno de escritura.
// Tiene 32 registros de 32 bits, como en el ISA RISC-V.
// El registro x0 (dirección 0) siempre lee 0 y no puede ser escrito.
module register_file(
	input clk,                    // Señal de reloj
	input WE3,                    // Señal de habilitación de escritura
	input [4:0] A1, A2, A3,       // Direcciones de lectura (A1, A2) y escritura (A3)
	input [31:0] WD3,             // Dato a escribir en el registro A3
	output reg [31:0] RD1, RD2     // Salidas de lectura
);

reg [31:0] REG [31:0]; // Se crea una memoria de 32 registros de 32 bits

// Inicializar el registro x0 a 0 (aunque la lógica de lectura ya lo fuerza)
initial begin
    REG[0] = 32'b0;
end

// Lectura combinacional de registros
always @(*) begin
	// Si la dirección es 0 (x0), se lee 0, de lo contrario, el valor del registro
	RD1 = (A1 == 5'b0) ? 32'b0 : REG[A1];
	RD2 = (A2 == 5'b0) ? 32'b0 : REG[A2];
end

// Escritura síncrona en registro
always @(posedge clk) begin
	// Escribir solo si WE3 está activo y la dirección de escritura no es x0 (A3 != 0)
	if (WE3 && (A3 != 5'b0)) begin
		REG[A3] <= WD3;
		$display("REG_FILE: VALID WRITE: REG[%0d] = %h (A1=%0d RD1=%h, A2=%0d RD2=%h) at time=%t",
				 A3, WD3, A1, REG[A1], A2, REG[A2], $time);
	end
end

endmodule