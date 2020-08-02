function [outbits,bits] = V_35(Tot_bits,e)
    polynomial = [1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
    num_z = ceil((Tot_bits)*((1/2)+e));
    a = ones(1,Tot_bits);
    a(1,1:num_z) = 0;
    bits = reshape(a(randperm(Tot_bits)),1,Tot_bits); 
    m = length(polynomial)-1;
    [outbits] = Scramb(polynomial,bits);
end