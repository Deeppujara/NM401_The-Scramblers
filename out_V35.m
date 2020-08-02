function [f,H_V] = out_V35(bits,Tot_bits)    
    m = 23;
    L = (2^m)-1;
    N = floor(Tot_bits/L);

%WHT Method to find the value of polynomial
    S = zeros(1,m+1);
    P = zeros(1,m+1);
    BB = bits';
    for I = 1:(m+1)
        P(1,I) = 2^(I-1);
        S(1:(L-m-1),I) = BB(I:(L-m-1+I-1));
    end
    
    V1=zeros(1,L-m-1);
    for q = 1:(L-m-1)
        V1(1,q) = (S(q,:)*(P'));
    end

    C = unique(V1);
    for i = 1:length(C)
        counts(i,1) = sum(V1==C(i));
    end

    V = zeros(1,(2^(m+1)));
    for c = 1:length(C)
        V(1,C(c)) = counts(c);
    end
  
    H = hadamard(2^(m+1));                           % Hadamard metrix generation
    H_V = V*H;
    H_V = -1*H_V;
    [d, f] = max(H_V);
    poly = de2bi(f);
    toc
    plot(-(H_V));
end