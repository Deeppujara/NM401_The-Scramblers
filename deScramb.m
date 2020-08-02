function [data] = deScramb(bits,poly1)
    m = length(poly1)-1;
    L = (2^m)-1;
    scramInit =  ones(1,m);
    b = length(scramInit);
     ww=scramInit;
    poly=poly1(2:b+1);
    for i = 1:L
        yy(i)=mod(sum(poly.*ww),2);
        llfsr(i)=yy(i);
        ww(2:b)=ww(1:b-1);
        ww(1)=yy(i);
    end
    x = repmat(llfsr,1,ceil(length(bits)/L));
    data = xor(bits,x(1:length(bits)));
end