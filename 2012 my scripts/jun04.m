
disp(' ')
disp('This program is to compare Cytochrome C (PDB: 1HRC) like proteins hydrogen bond map.')

prot1='1HRC';
prot2=input('Input the PDB code of the protein to be compared (e.g. 1HH7): ','s');

disp(' ')
disp('Now select the SPDBV alignment result file...')
[FileName,PathName] = uigetfile('*.txt','Select the TXT file');
Align = importdata([PathName,FileName],',');

disp(' ')
disp('Now calculate "prot1Index" (1HRC) ...')
prot1Index=jun04_index(Align, prot1); 

disp(' ')
disp(['Now calculate "prot2Index" (', prot2, ') ...'])
prot2Index=jun04_index(Align, prot2); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plotStyle=2; %input('Input the plot style(1=asymmetric; 2=symmetric): ');

h=figure;

disp(' ')
disp('Now plot protein #1 (1HRC)...')
markColor='r';
markSize=8;
protIndex=prot1Index;
jun04_plot

disp(' ')
disp('Now plot protein #2 (the comparing one)...')
markColor='b';
markSize=6;
protIndex=prot2Index;
jun04_plot


foldonBorders=[1, 19, 37, 40, 57, 61, 71, 85];
foldonColors='bgymygrb';

aaMax=max(max(prot1Index(2,:)), max(prot2Index(2,:)))+3;
plot([0 aaMax],[0 aaMax],'k:')
hold on
%grid on
for i=1:8
    x=find(prot1Index(1,:)==foldonBorders(i));
    plot([prot1Index(2,x),prot1Index(2,x)],[0,aaMax], 'Color',foldonColors(i), 'LineStyle',':')
    hold on
    plot([0,aaMax],[prot1Index(2,x),prot1Index(2,x)], 'Color',foldonColors(i), 'LineStyle',':')
    hold on
end
axis([0 aaMax 0 aaMax])
xlabel('Converted Residue Number (to spdbv alignment)')
ylabel('Converted Residue Number')

SaveName=['1HRC(red) vs ', prot2, '(blue)'];
title(SaveName);

saveas(h,SaveName)
save([SaveName,' workSave.mat'], 'Align','prot1','prot2','prot1Index','prot2Index')
disp(' ')
disp([SaveName,' .fig and .mat have been saved in MATLAB current directory!'])





    