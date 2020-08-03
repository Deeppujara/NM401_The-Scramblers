polynomial=[1 1 0 0 0 0 0 1];
%          [0 1 2 3 4 5 6 7 8 9 0] 
e = 0.1;
m = length(polynomial)-1;
L = (2^m)-1;
N=1000;
Tot_bits=N*L;
num_z = ceil((Tot_bits)*((1/2)+e));
a = ones(1,Tot_bits);
a(1,1:num_z) = 0;
bits = reshape(a(randperm(Tot_bits)),1,Tot_bits);
[bitsequence, m]=Scrambling(polynomial,bits);
ipbits=bits;
save('check.mat','ipbits');
i=1;
bitsequence = double(bitsequence);
for j = 1:1000
    fwrite(t,bitsequence(i:i+L-1));
    if(mod(j,50)==0)
        j
        pause;
    end
    i=i+L;
end