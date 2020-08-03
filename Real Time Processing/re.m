clear a data;
m=7;
L = (2^m)-1;
b=[];
while(length(b)<(L*100))
    a=fread(t,L);
    a=a';
    b=[b a];
end
[polyOut,H_V] = findpoly(b,m);
[data] = deScramb(b,polyOut);
% plot(H_V);
polyOut
while(1)
    a=fread(t,L);
    a=a';
    [d] = deScramb(a,polyOut);
    data = [data d];
end
% load('check.mat')
% sum(xor(ipbits,data))
