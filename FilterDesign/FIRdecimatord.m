function N = FIRdecimatord(ap,as,fd,fs)
% ap: passband ripple
% as: stopband ripple
% fd: trasition band width
% fs: sampling frequency

a1=0.005309; a2=0.07114; a3=-0.4761;
a4=-0.00266; a5=-0.5941; a6=-0.4278;
D = log10(as)*(a1*(log10(ap))^2+a2*log10(ap)+a3)+...
    (a4*(log10(ap))^2+a5*log10(ap)+a6);
N=D/(fd/fs);

end 