function [dout,x,bits] = DVBS(Tot_bits,L,N,e,m)
    num_z = ceil((Tot_bits)*((1/2)+e));
    a = ones(1,Tot_bits);
    a(1,1:num_z) = 0;
    bits = reshape(a(randperm(Tot_bits)),1,Tot_bits);
    p = length(bits);
    scramInit = [1 0 0 1 0 1 0 1 0 0 0 0 0 0 0];
    b = length(scramInit);
    w = scramInit;
    for i = 1:L
        LFSR(i) =  xor(w(i,14),w(i,15));
        for j = 1:(b-1)
            w(i+1,1) = LFSR(i);
            w(i+1,j+1) = w(i,j);
        end
    end
    x = repmat(LFSR,1,N);
    dout = xor(bits,x);
end