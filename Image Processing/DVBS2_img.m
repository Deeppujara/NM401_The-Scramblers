function [Iscr_Qscr,z,frames,frame_bits,bits] = DVBS2_img(img_bits)
    m = 18;
    Tot_bits = ((2^18)-1);
    frame_bits = 8100;
    frames = ceil(((length(img_bits))/2)/frame_bits);
    bits = img_bits;
    rest_bits = mod(length(bits),frame_bits);
    if rest_bits ~= 0
        bits((length(img_bits)+1):(frame_bits*frames*2)) = 0;
    end
    scramInit1 = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    scramInit2 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    for b = 1:m
        dout_I1(b) = scramInit1(b);
        dout_I2(b) = scramInit2(b);        
    end
    for c = 1:Tot_bits-m
        dout_I1(c+m) = xor(dout_I1(c),dout_I1(c+7));
        dout_I222(c+m) = xor(dout_I2(c),dout_I2(c+5));
        dout_I22(c+m) = xor(dout_I222(c),dout_I2(c+7));
        dout_I2(c+m) = xor(dout_I22(c),dout_I2(c+10));
    end
    z=xor(dout_I1,dout_I2);
    for j=1:frame_bits
        R(j)=2*z(mod((j+131071),Tot_bits)+1)+z(j);
    end
    C_scrambled=exp((i*pi/2).*R);
    real = bits(1:(frame_bits*frames));
    imag = bits(((frame_bits*frames)+1):(frame_bits*frames*2));
    complex_bits = complex(real,imag);
    complex_bits = reshape(complex_bits,frames,frame_bits);
    complex_bits=double(complex_bits);
    Iscr_Qscr = ((C_scrambled).*(complex_bits));
end