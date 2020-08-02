clc;
clear all;
close all;
tic
X = imread('C:\Users\Deep Pujara\Desktop\SIH\Images\SmartBin.png');
[rows,columns,n] = size(X);
[img_bits] = img_2_bits(X,rows,columns);
[bits] = CCSDS_img(img_bits);
bits = (bits*2)-1;
Tot_bits = length(bits);
[B,N,f,H_V]=out_CCSDS(bits,Tot_bits);
bits = ((bits+1)/2);
x = repmat(B,1,N+1);
dout = xor(bits,x(1:length(bits)));
[image] = bits_2_img(dout,rows,columns);
image = uint8(image);
%  imwrite(image,'image.png');
toc
subplot(2,2,1:2);
plot(-(H_V));
title("Output of Scrambling Process");
subplot(2,2,3);
imshow(X);
title("Initial Image");
subplot(2,2,4);
imshow(image);
title("Image after Scrambling Process");