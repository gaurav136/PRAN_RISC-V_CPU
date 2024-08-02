module sgn_zero_extend(input [31:0] read_data_mem,
                       input [2:0] funct3,
                       input [1:0] addr_offset,
                       output reg [31:0] ext_out);


reg [7:0] byte_data;
reg [15:0] halfword_data;

always @(*) begin
    // Shift read_data_mem based on addr_offset
    case (addr_offset)
        2'b00: begin
            byte_data     = read_data_mem[7:0];
            halfword_data = read_data_mem[15:0];
        end
        2'b01: begin
            byte_data     = read_data_mem[15:8];
            halfword_data = read_data_mem[15:0];
        end
        2'b10: begin
            byte_data     = read_data_mem[23:16];
            halfword_data = read_data_mem[31:16];
        end
        2'b11: begin
            byte_data     = read_data_mem[31:24];
            halfword_data = read_data_mem[31:16];
        end
    endcase
    
    
    case(funct3)
        // lb
        3'b000: ext_out = {{24{byte_data[7]}}, byte_data[7:0]};
        // lh
        3'b001: ext_out = {{16{halfword_data[15]}}, halfword_data[15:0]};
        // lw
        3'b010: ext_out = read_data_mem;
        // lbu
        3'b100: ext_out = {24'b0, byte_data[7:0]};
        // lhu
        3'b101: ext_out = {16'b0, halfword_data[15:0]};
        
        default: ext_out = 32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx; // undefined
    endcase
end

endmodule
