function [Iscr_Qscr,complex_bits,z,C_scrambled,bits] = DVBS2(num_bits,frame_bits,e)
    m = 18;
    Tot_bits = ((2^18)-1);
    frames = ceil(((num_bits)/2)/frame_bits);
    num_z = ceil((num_bits)*((1/2)+e));
    a = ones(1,num_bits);
    a(1,1:num_z) = 0;
    bits = reshape(a(randperm(num_bits)),1,num_bits);
    rest_bits = mod(length(bits),frame_bits);
    if rest_bits ~= 0
        bits((length(bits)+1):(frame_bits*frames*2)) = 0;
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