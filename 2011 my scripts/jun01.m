
clear

pepSeq='HHHHHHIIKIIK';
Charge=2;
Darray1=[0 0 0 0.1:0.1:0.9];
Darray2=[zeros(1,6) ones(1,6)];
Darray3=[0 0 0.5*ones(1,10)];
X=2;
simMZ=770:0.001:785;
resolution=6e4;
ifPlot=1;

Darray=Darray2;
[simPeaks, simData] = pepsim(pepSeq, Charge, Darray, X, simMZ, resolution, ifPlot);

may31 %call may31.m