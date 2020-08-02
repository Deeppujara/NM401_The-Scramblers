function[New_Iscr_Qscr,C_scrambled,frame_bits,frames,flag,final] = out_DVBS2(bits)
    flag = 0;
    frame_bits = 8100;
    [rows,column] = size(bits);
    frames = rows;
    z = importdata('DVBS2_Gold_Sequence.mat');
    C_scrambled = importdata('DVBS2_C-scrambled.mat');
    New_Iscr_Qscr = bits;
    F1 = real(New_Iscr_Qscr);
    F2 = imag(New_Iscr_Qscr);
    F = F1.*F2;
    Xj = sum(F);
    out = ~(Xj>=0);
    final = sum(xor(z(1:frame_bits),out));
    if (final <= 1500)
        flag = 1;
    end
end