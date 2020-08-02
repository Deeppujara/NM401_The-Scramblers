clc;
clear all;
close all;
fprintf('1 = Image\n2 = Scrambled Data\n');
I = input('Enter the value of I :');
clc;
if I == 1
    fprintf('With which Modulation Technique you want to scramble it.\n1 = CCSDS\n2 = DVB-S2\n3 = DVBS\n4 = V35\n');
    J = input('Enter the value of J :');
end
clc;
fprintf('1 = Coloured Image\n2 = Black and White Image\n');
K = input('Enter the value of K :');
if I == 1
    X = image_import();
    if K == 1
        [rows,columns,n] = size(X);
        [img_bits] = img_2_bits(X,rows,columns);
    elseif K == 2
        BW = im2bw(X,0.3);
        [rows, columns] = size(BW);
        img_bits = reshape(BW,1,numel(BW));
    end
else
    bits = mat_import();
    clc;
    rows = input('Enter the value of Rows :');
    columns = input('Enter the value of Columns :');
end

if I == 1
     Tot_bits = length(img_bits);
    if J == 2
        [bits,z,frames,frame_bits,bits1] = DVBS2_img(img_bits);
    elseif J == 1
        [bits] = CCSDS_img(img_bits);
    elseif J == 3    
        [bits] = DVBS_img(img_bits);
    elseif J == 4
        [bits] = V35_img(img_bits);
    end 
end
if I == 1 || I == 2
    flag1 = 0;
    [New_Iscr_Qscr,C_scrambled,frame_bits,frames,flag,final]=out_DVBS2(bits);
    if (flag == 1)
        clc;
        fprintf("DVB-S2 is Used \n");
        flag1 = 1;
        Input_seq = New_Iscr_Qscr./C_scrambled;
        x1 = reshape(real(Input_seq),1,(frame_bits*frames));
        x2 = reshape(imag(Input_seq),1,(frame_bits*frames));
        dout = uint8([x1,x2]);
    end 
   
    if (flag == 0)
        bits = (2*bits)-1;
        Tot_bits = length(bits);
        [flag,final,B,N,H_V]=out_CCSDS(bits,Tot_bits);
        if (flag == 1)  
            fprintf("CCSDS is Used \n");
            bits = ((bits+1)/2);
            x = repmat(B,1,N+1);
            dout = xor(bits,x(1:length(bits)));
        end 
    end
    
    if (flag == 0)
    [flag,final,B,N,H_V]=out_DVBS(bits,Tot_bits);
        if (flag == 1)
            fprintf("DVBS is Used \n");
            bits = ((bits+1)/2);
            x = repmat(B,1,N+1);
            dout = xor(bits,x(1:length(bits)));
        end
    end
end
    
 if (flag == 0) 
    [f,H_V]=out_V35(bits,Tot_bits);
     if (f == 8650753)
         flag = 1;
         fprintf("V35 is Used \n");
         bits = ((bits+1)/2);
         x = repmat(B,1,N+1);
         dout = xor(bits,x(1:length(bits)));         
     end
end

if K == 1
    [image] = bits_2_img(dout,rows,columns);
    image = uint8(image);
elseif K == 2
    image = reshape(dout,rows,columns);
end

if (flag1 == 1)
    imshow(image);
    title("Image after Scrambling Process");
else
    subplot(2,1,1);
    plot(-(H_V));
    title("Output of Scrambling Process");
    subplot(2,1,2);
    imshow(image);
    title("Image after Scrambling Process");
end