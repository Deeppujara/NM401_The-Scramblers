clc;
clear all;
close all;
tic
flag = 0;
flag1 = 0;
bits = importdata('DVBS2(1).mat');
Tot_bits = length(bits);
%% DVB-S2 code starts
[New_Iscr_Qscr,C_scrambled,frame_bits,frames,flag,final]=out_DVBS2(bits);
if (flag == 1)
    clc;
    fprintf("DVB-S2 is Used \n");
    flag1 = 1;
end
%% CCSDS code starts
if (flag == 0)
    Tot_bits = length(bits);
    [flag,final,B,N,H_V]=out_CCSDS(bits,Tot_bits);
    if (flag == 1)
        fprintf("CCSDS is Used \n");
    end
end
% CCSDS ends
%% DVBS code starts
if (flag == 0) 
    [flag,final,B,N,H_V]=out_DVBS(bits,Tot_bits);
    if (flag == 1)
        fprintf("DVBS is Used \n");
    end
end
 % DVBS code ends
 %% V35 code starts
 if (flag == 0) 
    [f,H_V]=out_V35(bits,Tot_bits);
        if (f == 8650753)
            flag = 1;
            fprintf("V35 is Used \n");
        end
 end
%  % V35 code ends
%% plot
if (flag1 == 0)
    plot(-(H_V));
end