function [data] = deScramb(bits,poly1)
    m = length(poly1)-1;
    L = (2^m)-1;
    scramInit =  ones(1,m);
    b = length(scramInit);
     ww=scramInit;
    poly=poly1(2:b+1);
    data=zeros(1,length(bits));
    for i = 1:length(bits)
        yy(i)=mod(sum(poly.*ww),2);
        llfsr(i)=xor(yy(i),bits(i));
        ww(2:b)=ww(1:b-1);
        ww(1)=bits(i);
        data(i)=llfsr(i);
    end
end