module sgn_zero_extend (input [31:0] read_data_mem,
                        input [2:0] funct3,
                        output reg [31:0] ext_out);

always @(*) begin
    case(funct3)
        // lb
        3'b000: ext_out = {{24{read_data_mem[7]}}, read_data_mem[7:0]};
        // lh
        3'b001: ext_out = {{16{read_data_mem[15]}}, read_data_mem[15:0]};
        // lw
        3'b010: ext_out = read_data_mem;
        // lbu
        3'b100: ext_out = {24'b0, read_data_mem[7:0]};
        // lhu
        3'b101: ext_out = {16'b0, read_data_mem[15:0]};
        
        default: ext_out = 32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx; // undefined
    endcase
end

endmodule
