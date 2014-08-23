%%%2012-01-03 msdfit_bxc_fit.m:

function F=oct27_msdfit_bxc_fit(bxTime, bxIniD, deltaD, kcDH, XN)

if size(bxIniD,2)~=size(kcDH,1)-XN
    error('Size not match!')
end
fitD=0;
m=0;
for i=(1+XN):size(kcDH,1)
    m=m+1;
    if kcDH(i)~=0
        fitD=fitD+bxIniD(m)*exp(-kcDH(i)*bxTime);
    end
end

F=(fitD-deltaD).^2;

