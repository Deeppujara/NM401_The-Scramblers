function [dout] = CCSDS_img(img_bits)
    m = 8;
    L = (2^m)-1;
    N = floor(length(img_bits)/L);
    bits = img_bits;
    scramInit = [1 1 1 1 1 1 1 1];
    b = length(scramInit);
    for g = 1:b
        w((b+1)-g) = scramInit(g);
    end
    for i = 1:L
        y2(i) =  xor(w(i,1),w(i,4));
        y1(i) =  xor(y2(i),w(i,6));
        y(i) =  xor(y1(i),w(i,8));
        LFSR(i) = w(i,1);
        for j = 1:(b-1)
            w(i+1,j) = w(i,j+1);
            w(i+1,8) = y(i);
        end
    end
    x = repmat(LFSR,1,N+1);
    dout = xor(bits,x(1:length(bits)));
end