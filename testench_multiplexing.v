module alu_with_seven_segment_tb;

  // Inputs
  reg clk;
  reg rst;
  reg [3:0] select1, select2;
  reg [2:0] operation;
  
  // Outputs
  wire [15:0] result;
  
  wire overflow;
  wire anode1, anode2, anode3, anode4;
  wire [6:0] segment;
  wire [4:0] cathods;
  
  // Instantiate the Unit Under Test (UUT)
  alu_with_seven_segment UUT (
    .clk(clk),
    .rst(rst),
    .select1(select1),
    .select2(select2),
    .operation(operation),
    .result(result),
    .overflow(overflow),
    .anode1(anode1),
    .anode2(anode2),
    .anode3(anode3),
    .anode4(anode4),
    .segment(segment),
    .cathods(cathods)
  );

  // Clock generation
  initial begin
    rst=1;
    clk = 0;
    forever #10 clk = ~clk; 
  end
 
  initial begin
    #10
    select1 = 4'b0000;
    select2 = 4'b0000;
    operation = 3'b000; // Addition
    #20;
    #20;
    #20;
    #20;
    
    
    select1 = 4'b1000;
    select2 = 4'b0001;
    operation = 3'b001; //subtraction
     #20;
    #20;
    #20;
    #20;
    
    
           select1 = 4'b0100;
    select2 = 4'b0011;
    operation = 3'b010; //bitwise AND
    #20;
    #20;
    #20;
    #20;
    
            select1 = 4'b0000;
    select2 = 4'b0001;
    operation = 3'b011; //bitwise OR
    #20;
    #20;
    #20;
    #20;
    
   
    $finish;
  end
    initial 
    begin
              $dumpfile("alu_with_seven_segment_tb.vcd"); 
  $dumpvars(0,alu_with_seven_segment_tb);
    end
  

endmodule
