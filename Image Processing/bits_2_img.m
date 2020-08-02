function [image] = bits_2_img(dout,rows,columns)
    x = rows*columns;
    y = reshape(dout,8,(numel(dout)/8));
    rgb = bi2de(y');
    rgb = rgb';
    r1(1:x) = rgb(1:x); 
    r2(1:x) = rgb(x+1:(2*x)); 
    r3(1:x) = rgb(((2*x)+1):(3*x)); 
    now_rgb = [r1 r2 r3];
    image = reshape(now_rgb,rows,columns,3);
end