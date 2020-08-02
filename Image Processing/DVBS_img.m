function [dout] = DVBS_img(img_bits)
    m = 15;
    L = (2^m)-1;
    N = floor(length(img_bits)/L);
    bits = img_bits;
    scramInit = [1 0 0 1 0 1 0 1 0 0 0 0 0 0 0];
    b = length(scramInit);
    for g = 1:b
        w((b+1)-g) = scramInit(g);
    end
    for i = 1:L
        LFSR(i) =  xor(w(i,14),w(i,15));
        for j = 1:(b-1)
            w(i+1,1) = LFSR(i);
            w(i+1,j+1) = w(i,j);
        end
    end
    x = repmat(LFSR,1,N+1);
    dout = xor(bits,x(1:length(bits)));
end