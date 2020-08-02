function [flag,final,B,N,H_V] = out_DVBS(bits,Tot_bits)
    flag = 0;
    m = 15;
    L = (2^m)-1;
    N = floor(Tot_bits/L);
    LFSR_seq = importdata('DVBS_LFSR.mat');
    LFSR_seq = double(LFSR_seq);
    bits = double(bits);
    Y2 = reshape(bits(1:N*L)',L,N);
    Y1 = Y2';
    Y = mean(Y1);
    R = (Y')*(Y);
    Eig_vec = EIGVEC(R,L);
    E=Eig_vec/2;
    B=ceil(E(1:L));
    final = sum(xor(B,LFSR_seq(1:L)));
    if(final>(round(L/2)))
       B=~B;
    end

%WHT Method to find the value of polynomial
if (final <= 500 || final >= 32000)
    flag = 1;
    clc;
    S = zeros(1,m+1);
    P = zeros(1,m+1);
    for l = 1:(m+1)
        S(1,l) = B(1,l);
        P(1,l) = 2^(l-1);
    end
    for n = 1:(L-m-2)
        S((n+1),:) = circshift(S(n,:),(-1));
        S((n+1),(m+1)) = B(1,(m+n+1));  
    end
    V1=zeros(1,L-m-1);
    for q = 1:(L-m-1)
        V1(1,q) = (S(q,:)*(P'));
    end
    V2 = zeros((L-m-1),(2^(m+1)));
    for c = 1:(L-m-1)
        V2(c,(V1(1,c))) = 1;
    end
    V = sum(V2,1);
    H = hadamard(2^(m+1));
    H_V = V*H;
    H_V = -1*H_V;
    [d, f] = max(H_V);
    poly = de2bi(f);
end