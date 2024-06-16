module alu_with_seven_segment (
  input clk,rst,
  input wire [3:0] select1,
  input wire [3:0] select2,
    input [2:0] operation,
  output reg [6:0] segment,
  output reg [15:0] result,
    output reg overflow,
   output reg anode1=1'b0,
  output reg anode2=1'b0,
  output reg anode3=1'b0,
  output reg anode4=1'b0,
  output reg [4:0]cathods
);
reg t;
  reg [15:0] operand1;
  reg [15:0] operand2;
  
  reg [3:0] digit_number = 4'b0000;
  reg [19:0] clk_counter = 20'd0;

  
//multiplexing
  always @(posedge clk or negedge rst) begin
  if(rst==0)
    begin
	   clk_counter <=0;
	 end
   else
	begin
    clk_counter <= clk_counter + 1;
    if (clk_counter >= 100000) begin
        clk_counter <= 0;
      digit_number <= digit_number + 1;
      if (digit_number >= 3) begin 
        digit_number <= 0;
      end
    end
  end
end
  //anodes 
  
  always @(*) begin
    case (digit_number)
      2'b00: begin
        anode1 = 1'b0;
        anode2 = 1'b1;
        anode3 = 1'b1;
        anode4 = 1'b1;
      end
      2'b01:begin
        anode1 = 1'b1;
        anode2 = 1'b0;
        anode3 = 1'b1;
        anode4 = 1'b1;
      end
      2'b10:begin
        anode1 = 1'b1;
        anode2 = 1'b1;
        anode3 = 1'b0;
        anode4 = 1'b1;
      end
      2'b11:  begin
        anode1 = 1'b1;
        anode2 = 1'b1;
        anode3 = 1'b1;
        anode4 = 1'b0;
      end
    endcase
  end
//operand 1
  always @(*) begin
    case (select1)
        4'b0000:  operand1  = 16'b0100001100100001;
        4'b0001: operand1  = 16'b0011_0011_0011_0011; // Output 2
      4'b0010: operand1  = 16'b0100_0100_0100_0100; // Output 3
        4'b0011: operand1  = 16'b1000_1000_1000_1000; // Output 4
        4'b0100: operand1  = 16'b1001_1001_1001_1001; // Output 5
        4'b0101: operand1 = 16'b1011_1011_1011_1011; // Output 6
        4'b0110: operand1  = 16'b0111_1110_0110_0010; // Output 7
        4'b0111: operand1  = 16'b0111_1100_1100_1100; // Output 8
        4'b1000: operand1  = 16'b1111_1101_0110_1100; // Output 9
        4'b1001: operand1  = 16'b1100_0110_1000_1000; // Output 10
        4'b1010: operand1  = 16'b0001_0101_0011_0100; // Output 11
        4'b1011: operand1 = 16'b0010_1100_1000_1000; // Output 12
        4'b1100: operand1  = 16'b1001_0110_0011_1100; // Output 13
        4'b1101: operand1  = 16'b1010_1100_1010_1010; // Output 14
        4'b1110: operand1  = 16'b0101_0110_1100_0110; // Output 15
        4'b1111: operand1  = 16'b1100_1001_0011_0011; // Output 16
    endcase
end
  
 //operand 2
  always @(*) begin
    case (select2)
          4'b0000:  operand2  = 16'b0000000000000000;
        4'b0001: operand2  = 16'b0011_0011_0011_0011; // Output 2
      4'b0010: operand2  = 16'b0100_0100_0100_0100; // Output 3
        4'b0011: operand2  = 16'b1000_1000_1000_1000; // Output 4
        4'b0100: operand2  = 16'b1001_1001_1001_1001; // Output 5
        4'b0101: operand2 = 16'b1011_1011_1011_1011; // Output 6
        4'b0110: operand2  = 16'b0111_1110_0110_0010; // Output 7
        4'b0111: operand2  = 16'b0111_1100_1100_1100; // Output 8
        4'b1000: operand2  = 16'b1111_1101_0110_1100; // Output 9
        4'b1001: operand2  = 16'b1100_0110_1000_1000; // Output 10
        4'b1010: operand2  = 16'b0001_0101_0011_0100; // Output 11
        4'b1011: operand2 = 16'b0010_1100_1000_1000; // Output 12
        4'b1100: operand2  = 16'b1001_0110_0011_1100; // Output 13
        4'b1101: operand2  = 16'b1010_1100_1010_1010; // Output 14
        4'b1110: operand2  = 16'b0101_0110_1100_0110; // Output 15
        4'b1111: operand2  = 16'b1100_1001_0011_0011; // Output 16
    endcase
end
  
  //ALU OPERATIONS
always @(*)
begin
    case(operation)
        3'b000: result = operand1 + operand2; // Addition
        3'b001: result = operand1 - operand2; // Subtraction
        3'b010: result = operand1 & operand2; // Bitwise AND
        3'b011: result = operand1 | operand2; // Bitwise OR
    endcase
    
    // Overflow detection
    if(operation[2] == 1'b0) begin
        if(operation[1] == 1'b0) begin
            if(operation[0] == 1'b0) begin
                // Addition
                overflow = (operand1[15] & operand2[15] & ~result[15]) | (~operand1[15] & ~operand2[15] & result[15]);
            end else begin
                // Subtraction
                overflow = (operand1[15] & ~operand2[15] & ~result[15]) | (~operand1[15] & operand2[15] & result[15]);
            end
        end
    end
end

  //cathodes
  
  always @(*) begin
    case (digit_number)
      2'b00: cathods=result[3:0];
      2'b01: cathods= result[7:4]; 
      2'b10: cathods=result[11:8];
      2'b11: cathods= result[15:12];
    endcase
  end
      always @(*)
    begin
        case(cathods)
            4'h0: segment[6:0] = 7'b1000000;    // digit 0
            4'h1: segment[6:0] = 7'b1111001;    // digit 1
            4'h2: segment[6:0] = 7'b0100100;    // digit 2
            4'h3: segment[6:0] = 7'b0110000;    // digit 3
            4'h4: segment[6:0] = 7'b0011001;    // digit 4
            4'h5: segment[6:0] = 7'b0010010;    // digit 5
            4'h6: segment[6:0] = 7'b0000010;    // digit 6
            4'h7: segment[6:0] = 7'b1111000;    // digit 7
            4'h8: segment[6:0] = 7'b0000000;    // digit 8
            4'h9: segment[6:0] = 7'b0010000;    // digit 9
            4'ha: segment[6:0] = 7'b0001000;    // digit A
            4'hb: segment[6:0] = 7'b0000011;    // digit B
            4'hc: segment[6:0] = 7'b1000110;    // digit C
            4'hd: segment[6:0] = 7'b0100001;    // digit D
            4'he: segment[6:0] = 7'b0000110;    // digit E
        endcase
    end
endmodule
