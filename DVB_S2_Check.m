clc;
clear all;
close all;
m = 18;
num_bits = 8100005;
frame_bits = 8100;
frames = ceil(((num_bits)/2)/frame_bits);
e = 0.05;
[Iscr_Qscr,complex_bits,z,C_scrambled,bits] = DVBS2(num_bits,frame_bits,e);
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
    dout = [x1,x2];
    last = sum(xor(bits,dout));
end