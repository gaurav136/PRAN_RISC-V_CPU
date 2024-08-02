
// main_decoder.v - logic for main decoder

module main_decoder (input [6:0] op,
                     input [2:0] funct3,
                     input Zero,
                     input ALUR31,
                     output [1:0] ResultSrc,
                     output MemWrite,
                     output Branch,
                     output ALUSrc,
                     output RegWrite,
                     output Jump,
                     output Jalr,
                     output reg Take_Branch,
                     output [1:0] ImmSrc,
                     output [1:0] ALUOp,
                     output [1:0] Store,
                     output [2:0] Load);

reg [16:0] controls;

always @(*) begin
    case (op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump_Store_Load_Jalr
        
        7'b0000011:	begin
            case(funct3)
                3'b000: 	controls = 17'b1_00_1_0_01_0_00_0_xx_000_0; // lb
                3'b001: 	controls = 17'b1_00_1_0_01_0_00_0_xx_001_0; // lh
                3'b010: 	controls = 17'b1_00_1_0_01_0_00_0_xx_010_0; // lw
                3'b100: 	controls = 17'b1_00_1_0_01_0_00_0_xx_100_0; // lbu
                3'b101: 	controls = 17'b1_00_1_0_01_0_00_0_xx_101_0; // lhu
                default:    controls = 17'b1_00_1_0_01_0_00_0_xx_010_0; // lw
            endcase
        end
        
        7'b0010011: 		controls = 17'b1_00_1_0_00_0_10_0_xx_xxx_0; // I–type ALU
        7'b0010111: 		controls = 17'b1_xx_x_0_11_0_xx_0_xx_xxx_0; // auipc
        
        7'b0100011:	begin
            case(funct3)
                3'b000: 	controls = 17'b0_01_1_1_xx_0_00_0_00_xxx_0; // sb
                3'b001: 	controls = 17'b0_01_1_1_xx_0_00_0_01_xxx_0; // sh
                3'b010: 	controls = 17'b0_01_1_1_xx_0_00_0_10_xxx_0; // sw
                default:    controls = 17'b0_01_1_1_xx_0_00_0_10_xxx_0; // sw
            endcase
        end
        
        7'b0110111: 		controls = 17'b1_xx_x_0_11_0_xx_0_xx_xxx_0; // lui
        7'b0110011: 		controls = 17'b1_xx_0_0_00_0_10_0_xx_xxx_0; // R–type
        
        7'b1100011: begin
            case (funct3)
                3'b000:     controls = 17'b0_10_0_0_xx_1_01_0_xx_xxx_0; // Branch beq
                3'b001:     controls = 17'b0_10_0_0_xx_1_01_0_xx_xxx_0; // Branch bne
                3'b110:     controls = 17'b0_10_0_0_xx_1_11_0_xx_xxx_0; // Branch bltu
                3'b111:     controls = 17'b0_10_0_0_xx_1_11_0_xx_xxx_0; // Branch bgeu
                3'b100:     controls = 17'b0_10_0_0_xx_1_01_0_xx_xxx_0; // Branch blt
                3'b101:     controls = 17'b0_10_0_0_xx_1_01_0_xx_xxx_0; // Branch bge
                default:    controls = 17'b0_10_0_0_xx_1_01_0_xx_xxx_0; // Default case (could be used for invalid funct3)
            endcase
        end
        
        7'b1100111: 		controls = 17'b1_00_1_0_10_0_00_x_xx_xxx_1; // jalr
        7'b1101111:			controls = 17'b1_11_x_0_10_0_xx_1_xx_xxx_0; // jal
        
        
        default:    		controls = 17'bx_xx_x_x_xx_x_xx_x_xx_xxx_x; // ???
    endcase
    
    Take_Branch = 0;
    if (Branch) begin
        case(funct3)
            3'b000: Take_Branch = Zero;  //beq
            3'b001: Take_Branch = ~Zero;  //bne
            3'b100: Take_Branch = ALUR31; //blt
            3'b101: Take_Branch = ~ALUR31; //bge
            3'b110: Take_Branch = ~Zero ; //bltu
            3'b111: Take_Branch = Zero; //bgeu
            
            default: Take_Branch = 0;
        endcase
    end
end

assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Store, Load, Jalr} = controls;

endmodule
