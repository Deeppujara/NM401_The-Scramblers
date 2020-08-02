function[flag,final,B,N,H_V] = out_CCSDS(bits,Tot_bits)
H_V = 0;
flag = 0;
m = 8;                                            % Heighest degree of polynomial
L = (2^m)-1;                                      % Size of LFSR sequence
N = floor(Tot_bits/L);                            % Number of windows
LFSR_seq = importdata('CCSDS_LFSR.mat');          % Importing LFSR sequence
LFSR_seq = double(LFSR_seq);                      
bits = double(bits);                              
Y2 = reshape(bits(1:N*L)',L,N);                   % Reshape column wise in N*L windows
Y1 = Y2';
Y = mean(Y1);
R = (Y')*(Y);                                     % Correlation metrix
Eig_vec = EIGVEC(R,L);                            % Eigen vector corresponding to max. eigen value
E=Eig_vec/2;
B=ceil(E(1:L));
final = sum(xor(B,LFSR_seq(1:L)));                % Checking the number of errors
if(final>(round(L/2)))
   B=~B;
end

%WHT Method to find the value of polynomial
if (final <= 50 || final >= 200)
    flag = 1;
    clc;
    S = zeros(1,m+1);
    P = zeros(1,m+1);
    for l = 1:(m+1)
        S(1,l) = B(1,l);
        P(1,l) = 2^(l-1);
    end
    for n = 1:(L-m-2)
        S((n+1),:) = circshift(S(n,:),1);
        S((n+1),1) = B(1,(m+n+1)); 
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
    H = hadamard(2^(m+1));                           % Hadamard metrix generation
    H_V = V*H;
    H_V = -1*H_V;
    [d, f] = max(H_V);
    poly = de2bi(f);
    end
end