// $random (seed) produces the same test inputs

module test_adder; 
reg[7:0] a,b;
wire[7:0] sum; wire cout;
integer myseed;

adder ADD(sum,cout,a,b);

initial myseed=15;

initial begin
    repeat(5)
    begin
        a=$random(myseed);
        b=$random(myseed);
        #10;
        $monitor($time , " a=%2h, b=%2h, sum=%2h " , a, b, sum);
    end
end
endmodule