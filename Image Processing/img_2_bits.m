function [img_bits] = img_2_bits(X,rows,columns)
    r = X(:,:,1);
    g = X(:,:,2);
    b = X(:,:,3);
    x = rows*columns;
    r1 = reshape(r,1,x);
    g1 = reshape(g,1,x);
    b1 = reshape(b,1,x);
    rgb = [r1 g1 b1]; 
    y = de2bi(rgb);
    img_bits = reshape(y',1,numel(y));
end