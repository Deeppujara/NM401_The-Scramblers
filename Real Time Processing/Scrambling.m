function [outbits, m]=Scrambling(polynomial,bits)

 m = length(polynomial)-1;
% e = 0.1;
% L = (2^m)-1;
% N=100;
% Tot_bits = L*N;
% num_z = ceil((Tot_bits)*((1/2)+e));
% a = ones(1,Tot_bits);
% a(1,1:num_z) = 0;
% bits = reshape(a(randperm(Tot_bits)),1,Tot_bits);
[outbits] = Scramb(polynomial,bits);
% save(ipfile,'ipdata');
end