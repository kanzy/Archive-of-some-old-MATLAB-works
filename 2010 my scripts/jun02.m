SNase='ATSTKKLHKEPATLIKAIDGDTVKLMYKGQPMTFRLLLVDTPETKHPKKGVEKYGPEASAFTKKMVENAKKIEVEFDKGQRTDKYGRGLAYIYADGKMVNEALVRQGLAKVAYVYKGNNTHEQLLRKSEAQAKKEKLNIWSEDNADSGQ';
currSeq=SNase;

pH=10;

TempC=20;

deltaG=8; %estimated global stability. unit: kcal/mol

R=1.9858775; %gas constant(cal/(K*mol)); the value in spreadsheet is 1.987

maxPF=exp(1000*deltaG/(R*(TempC+273.15)));

kcDH = 3600 * fbmme_dh(currSeq, pH, TempC, 'poly'); %unit: hr^-1
N=nnz(kcDH); %non-zero ex rate residues number

maxK=max(kcDH);
minK=min(nonzeros(kcDH))/maxPF;

HXtime=0:0.01:10;

figure

Ex=exp(-maxK*HXtime);
semilogx(HXtime,Ex,'r')
hold on

Ex=exp(-minK*HXtime);
semilogx(HXtime,Ex,'b')
hold on





% PF = 1e3* ones(size(kcDH));
% START=1;
% END=4;
% 
% HXtime=0:0.01:100;
% 
% clear Ex
% figure
% 
% rColors=colormap(jet(END-START+1));
% for i=START:END
%     if currSeq(i)~='P'
%         Ex = exp(-kcDH(i)*HXtime/PF(i));
%         semilogx(HXtime,Ex,'color',rColors(i-START+1,:),'LineWidth',1)
%         hold on
%     end
% end








