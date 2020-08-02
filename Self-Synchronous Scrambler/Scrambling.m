function [outbits, m]=Scrambling(polynomial,ipfile,bits)
     m = length(polynomial)-1;
    [outbits,ipdata] = Scramb(polynomial,bits);
    save(ipfile,'ipdata');
end