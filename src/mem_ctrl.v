module mem_ctrl (
    input wire clk,
    input wire rst,
    input wire[`RegAddrBus] ram_addr_i,
    input wire[`RegBus] ram_data_i,
    input wire ram_r_enable_i,
    input wire ram_w_enable_i,
    input wire[1:0] ram_mask_i,
    input wire[`InstAddrBus] pc,
    //input wire[7:0] cpu_data_i,
    input wire[7:0] din,
    input wire[`StallBus] stall,
    input wire rdy_in,

    output reg cpu_wr,
    output reg ram_busy,
    output reg ram_done,
    output reg pc_done,
    output reg[`RegBus] ram_addr_o,
    output reg[`RegBus] ram_r_data_o,
    output reg[7:0] cpu_data_o,
//    output reg pc_enable;
    output reg[`InstBus] inst_o
);

reg[3:0] read_sta;
reg read_enable;
reg mpc;
reg[`RegAddrBus] addr_i;

always @ ( * ) begin
    if(rst == `RstEnable) begin
        read_enable = 1'b0;
        mpc = 1'b0;
        cpu_wr = 1'b0;
    end else if(!read_sta)begin
        if(ram_r_enable_i == `WriteEnable) begin
            mpc = 1'b1;
            read_enable = 1'b1;
            cpu_wr = 1'b1;
            addr_i = ram_addr_i;
        end else if(!stall[0]) begin
            addr_i = pc;
            mpc = 1'b0;
            read_enable = 1'b1;
            cpu_wr = 1'b0;
        end else begin
            read_enable = 1'b0;
            cpu_wr = 1'b0;
        end
    end
end

always @ ( posedge clk ) begin
    ram_done <= 1'b0;
    if(rst == `RstEnable) begin
        read_sta <= 5'b00000;
    end
    if (!rdy_in) begin
        ram_busy = 1'b1;
        cpu_wr = 1'b0;
    //end

    end else if (ram_w_enable_i == `WriteEnable) begin
        case(ram_mask_i)
            2'b01: begin
                ram_done <= 1'b1;
                ram_busy <= 1'b0;
                ram_addr_o <= addr_i;
                cpu_data_o <= ram_data_i[7:0];
            end
            2'b10: begin
                case (read_sta)
                    4'h0: begin
                        ram_busy = 1'b1;
                        ram_addr_o <= addr_i;
                        cpu_data_o <= ram_data_i[7:0];
                        read_sta = read_sta + 1;
                    end
                    4'h1: begin
                        ram_busy = 1'b1;
                        ram_addr_o <= addr_i + 1;
                        cpu_data_o <= ram_data_i[15:8];
                        read_sta = read_sta + 1;
                    end
                    4'h2: begin
                        ram_busy = 1'b0;
                        ram_done = 1'b1;
                        read_sta = 4'h0;
                    end
                endcase
            end
            2'b11: begin
                case (read_sta)
                    4'h0: begin
                        ram_busy = 1'b1;
                        ram_addr_o <= addr_i;
                        cpu_data_o <= ram_data_i[7:0];
                        read_sta = read_sta + 1;
                    end
                    4'h1: begin
                        ram_busy = 1'b1;
                        ram_addr_o <= addr_i + 1;
                        cpu_data_o <= ram_data_i[15:8];
                        read_sta = read_sta + 1;
                    end
                    4'h2: begin
                        ram_busy = 1'b1;
                        ram_addr_o <= addr_i + 2;
                        cpu_data_o <= ram_data_i[23:16];
                        read_sta = read_sta + 1;
                    end
                    4'h3: begin
                        ram_busy = 1'b1;
                        ram_addr_o <= addr_i + 3;
                        cpu_data_o <= ram_data_i[31:24];
                        read_sta = read_sta + 1;
                    end
                    4'h4: begin
                        ram_busy = 1'b0;
                        ram_done = 1'b1;
                        read_sta = 4'h0;
                    end
                endcase
            end
            default: begin
            end
        endcase
    //end else if(ram_r_enable_i == `WriteEnable) begin
    end else if(read_enable == `WriteEnable)begin
        case(read_sta)
            4'h0: begin
                ram_busy <= 1'b1;
                ram_addr_o <= addr_i;
                read_sta <= read_sta + 1;
            end
            4'h1: begin
                //ram_busy <= 1'b1;
                ram_r_data_o[7:0] <= din;
                ram_addr_o <= addr_i + 1;
                read_sta <= read_sta + 1;
            end
            4'h2: begin
                //ram_busy = 1'b1;
                ram_r_data_o[15:8] <= din;
                ram_addr_o <= addr_i + 2;
                read_sta <= read_sta + 1;
            end
            4'h3: begin
                //ram_busy = 1'b1;
                ram_r_data_o[23:16] <= din;
                ram_addr_o <= addr_i + 3;
                read_sta <= read_sta + 1;
            end
            4'h4: begin
                ram_busy <= 1'b0;
                ram_done <= 1'b1;
                ram_r_data_o[31:24] <= din;
                read_sta = 4'h0;
            end
            default: begin
            end
        endcase
    end
end

always @ ( * ) begin
    if(!mpc && ram_done) begin
        ram_done = 1'b0;
        pc_done = 1'b1;
        inst_o = ram_r_data_o;
    end else begin
        inst_o = `ZeroWord;
        pc_done = 1'b0;
    end
end

endmodule // mem_ctrl
