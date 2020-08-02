clc;
clear all;
close all;
Tot_bits = input('Enter the value of total bits :');
e = 0.1;
fprintf('With which Modulation Technique you want to scramble it.\n1 = DVB-S2\n2 = CCSDS\n3 = DVBS\n4 = V35\n');
J = input('Enter the value of J :');
%% Scrambling Process
tic
if (J == 1)
    m = 18;
    L = (2^m)-1;
    N = floor(Tot_bits/L);
    frame_bits = 8100;
    frames = ceil(((Tot_bits)/2)/frame_bits);
    [Iscr_Qscr,complex_bits,z,C_scrambled,bits] = DVBS2(Tot_bits,frame_bits,e);
    save('DVBS2_scrambledDataset(1).mat','Iscr_Qscr')    
elseif (J == 2)
    m = 8;
    L = (2^m)-1;
    N = floor(Tot_bits/L);
    [bits,LFSR_seq,Input_seq] = CCSDS(Tot_bits,L,N,e,m);
elseif (J == 3)
    m = 15;
    L = (2^m)-1;
    N = floor(Tot_bits/L);
    [bits,LFSR_seq,Input_seq] = DVBS(Tot_bits,L,N,e,m);
elseif (J == 4)
    m = 20;
    [bits,Input_seq] = V_35(Tot_bits,e);
%     save('V35_scrabledDataset(2).mat','bits');
end
clc;
toc
%% Descrambling Process
if (m == 18)
    z = z;
    C_scrambled = C_scrambled;
    New_Iscr_Qscr = Iscr_Qscr;
    F1 = real(New_Iscr_Qscr);
    F2 = imag(New_Iscr_Qscr);
    F = F1.*F2;
    Xj = sum(F);
    out = ~(Xj>=0);
    final = xor(z(1:frame_bits),out);
    if (final <= 100)
        clc;
        fprintf("DVB-S2 is Used \n");
        Input_seq = New_Iscr_Qscr./C_scrambled;
        x1 = reshape(real(Input_seq),1,(frame_bits*frames));
        x2 = reshape(imag(Input_seq),1,(frame_bits*frames));
        Transmitted_bits = [x1,x2];
    end
end
if (m == 20)
    clc;
    fprintf("V.35 is Used \n");
   [Transmitted_bits] = deScramb(bits); 
end
if (m == 8 || m == 15)
    LFSR_seq = double(LFSR_seq);    
    bits = double(bits);
    bits = (2*(bits)-1);
    Y2 = reshape(bits(1:N*L)',L,N);
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
 if (m == 8)
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
 elseif (m == 15)
        BB = B';
        for I = 1:(m+1)
            P(1,I) = 2^(I-1);
            S(1:(L-m-1),I) = BB(I:(L-m-1+I-1));
        end
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
     if (f == 299)
         for x = 1:m
            In_Seed(x) = B(9-x);
         end
          fprintf("%d ",In_Seed);
          fprintf("\n");
     end

     if (f == 32771)
         for x = 1:m
            In_Seed(x) = B(length(B)+1-x);
         end
         fprintf("%d ",In_Seed);
         fprintf("\n");
     end
end