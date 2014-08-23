%%%oct14.m: for merging two conditions ExMS result as HDsite input

clear
disp(' ')
disp('First import the _afterCheck.mat file of Pepsin condition.')
uiimport
void=input('Press ENTER to continue ...');

finalTable1=finalTable;
peptidesPool1=peptidesPool;
wholeResults1=wholeResults;
sampleName1=sampleName;
programSettings1=programSettings;


disp(' ')
disp('Now import the _afterCheck.mat file of Fungal condition.')
uiimport
void=input('Press ENTER to continue ...');

% if ~strcmp(sampleName1, sampleName)
%     error('Sample names not match!')
% end

peptidesPool=[peptidesPool1; peptidesPool];
if size(finalTable,2)>size(finalTable1,2)
    finalTable1=[finalTable1, zeros(size(finalTable1,1), size(finalTable,2)-size(finalTable1,2))];
else
    finalTable=[finalTable, zeros(size(finalTable,1), size(finalTable1,2)-size(finalTable,2))];
end
finalTable=[finalTable1; finalTable];

sizer1=size(wholeResults1,1);
for i=1:size(wholeResults,1)
    wholeResults1{sizer1+i,1}=wholeResults{i,1};
end
wholeResults=wholeResults1;

clear wholeResults1 identicalPeptidesTable i void






