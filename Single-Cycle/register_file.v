// Módulo: register_file
// Descripción: Implementa un banco de registros con dos puertos de lectura y uno de escritura.
// Tiene 32 registros de 32 bits, como en el ISA RISC-V.

module register_file(
	input clk,                   // Señal de reloj
	input WE3,                   // Señal de habilitación de escritura 
	input [4:0] A1, A2, A3,      // Direcciones de lectura (A1, A2) y escritura (A3)
	input [31:0] WD3,            // Dato a escribir en el registro A3
	output reg [31:0] RD1, RD2   // Salidas de lectura 
);
reg [31:0] REG [31:0]; // Se crea memoria de 32 registros de 32 bits

// Lectura de registros
always @(*) begin
    RD1 = (A1 != 0) ? REG[A1] : 32'b0;
    RD2 = (A2 != 0) ? REG[A2] : 32'b0;
end


// Escritura en registro
always @(posedge clk) begin
    if (WE3 && (A3 != 0)) begin  
        REG[A3] <= WD3;
        $display("VALID WRITE: REG[%0d] = %h (A1=%0d RD1=%h, A2=%0d RD2=%h)",
                A3, WD3, A1, REG[A1], A2, REG[A2]);
    end
end
	
endmodule