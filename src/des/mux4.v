module mux4 (
    d0,
    d1,
    d2,
    d3,
    s,
    y
);
    parameter WIDTH = 8;
    
    input wire [WIDTH - 1:0] d0;
    input wire [WIDTH - 1:0] d1;
    input wire [WIDTH - 1:0] d2;
    input wire [WIDTH - 1:0] d3;
    input wire [2:0] s;        // One-hot encoded selection (e.g., 4'b0001, 4'b0010, 4'b0100, 4'b1000)
    output wire [WIDTH - 1:0] y;
    
    // Using one-hot encoding:
    // s[0] selects d0
    // s[1] selects d1
    // s[2] selects d2
    // s[3] selects d3
    assign y = s == 3'b000 ? d0 :
               s == 3'b001 ? d1 :
               s == 3'b010 ? d2 :
               d3; 
    

endmodule