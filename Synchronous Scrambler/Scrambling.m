function [outbits, m]=Scrambling(polynomial,ipfile,bits)
    m = length(polynomial)-1;
    [outbits,LFSR_seq,ipdata] = Scramb(polynomial,bits);
    save(ipfile,'ipdata');
end