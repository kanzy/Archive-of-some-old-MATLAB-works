

X=input('Input the peptide #: ');

Test=wholeResults{X};

START=Test.peptide(1);
END=Test.peptide(2);
Charge=Test.peptide(3);
maxND=Test.peptide(5);
maxD=Test.peptide(6);
distND=Test.distND;

if flagND==1
    obsDistr=[Test.selectPeaks(:,2); zeros(maxD,1)];
else
    obsDistr=Test.selectPeaks(:,2);
end


DistrA=exms_deconv(obsDistr, distND, maxND, maxD, proteinName, sampleName, START, END, Charge);