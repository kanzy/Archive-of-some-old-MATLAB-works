

SNase='ATSTKKLHKEPATLIKAIDGDTVKLMYKGQPMTFRLLLVDTPETKHPKKGVEKYGPEASAFTKKMVENAKKIEVEFDKGQRTDKYGRGLAYIYADGKMVNEALVRQGLAKVAYVYKGNNTHEQLLRKSEAQAKKEKLNIWSEDNADSGQ';

pepPara.proSeq=SNase; %whole protein sequence
pepPara.START=101; %Start residue# of the peptide
pepPara.END=110; %End residue# of the peptide
pepPara.Charge=1;
pepPara.kOP=      [0.1, 0.1, 0.1, 0.1, 0.1, 0.1,  1,  1,  1,  1]; %array of openning rates of each residue of the peptide at HX condition
pepPara.kCL=      [ 10,  10,1000,1000,1000,  10, 10, 10, 10, 10]; %array of closing rates of each residue of the peptide at HX condition
% pepPara.foldIndex=[  0,   0,   1,   1,   1,   0,  2,  2,  2,  2];
pepPara.foldIndex=[  0,   0,   0,   0,   0,   0,  0,  0,  0,  0];
pepPara.iniD=ones(1,10); %array of D% of each residue of the peptide at the beginning of HX
pepPara.iniF=2*ones(1,10); %array of folding status(1=fully unfolded(open); 2=fully folded(close); 3=equilibrium by HX condition--assuming independent of other residues) of each residue of the peptide at the beginning of HX 

hxPara.Temp=30; %HX temperature (unit: 'C)
hxPara.pH=8.5; %HX pH
hxPara.hxTime=1; %HX duration time (unit: sec)
hxPara.fractionD=0.01; %fraction of D2O in HX buffer

[HDmatrix, Fmatrix, obsPeaks]=hxsim(pepPara,hxPara);






