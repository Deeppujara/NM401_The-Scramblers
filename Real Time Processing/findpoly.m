function [poly,H_V]=findpoly(bits,m)
% LFSR_seq = double(LFSR_seq);
errflag=0;
L = (2^m)-1;
Tot_bits = length(bits);
N = floor(Tot_bits/L);
bits = double(bits);
bits = 2*(bits)-1;
Y2 = reshape(bits(1:N*L)',L,N);
Y1 = Y2';
Y = mean(Y1);
R = (Y')*(Y);                                     % Correlation metrix
Eig_vec = EIGVEC(R,L);                            % Eigen vector corresponding to max. eigen value
E=Eig_vec/2;
B=ceil(E(1:L));
% final = sum(xor(B,LFSR_seq(1:L)));                % Checking the number of errors
% if(final>(round(L/2)))
%     B=~B;
% end
BB = B';
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
    if C(c)<1
        disp('an error occured')
        errflag=1
        break
    end
     V(1,C(c)) = counts(c);
end
if errflag==1
    B=~B;
    BB = B';
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
end
 H = hadamard(2^(m+1));                           % Hadamard metrix generation
 H_V = V*H;
 H_V = -1*H_V;
 [d, f] = max(abs(H_V(2:end)));
 poly = flip(de2bi(f));
%  plot(-(H_V));
end