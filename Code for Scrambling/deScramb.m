function [out] = deScramb(bits)
    poly1 = [1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
    m = length(poly1)-1;
    scramInit =  zeros(1,m);
    b = length(scramInit);
    ww=scramInit;
    count = 0;
    counter_out=0;
    out=zeros(1,length(bits));
    poly=poly1(2:b+1);
    for i = 1:length(bits)
        enable = ~(xor(ww(1),ww(9)));
       
        if enable == 1
            count = count+1;
        else 
            count = 0;  
        end
        if count == 31
            count=0;
            counter_out = 1 ;
        end
        yy(i) = ~(xor(ww(3),ww(20)));
        yy(i) = ~(xor(yy(i),counter_out));
        out(i) = ~(xor(yy(i),bits(i)));
        ww(2:b) = ww(1:b-1);
        ww(1) = bits(i);
        counter_out = 0;
    end
end