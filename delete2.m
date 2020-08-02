clear all
close all
load('i.mat')
load('o.mat')
I=double(data);
a=sum(xor(I,ipdata));
