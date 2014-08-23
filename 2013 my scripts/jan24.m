

global mzXMLStruct_D
flagND=0;

disp('Select .mzXML file of the D sample...');
[FileName_D,PathName_D] = uigetfile('*.mzXML','Select the mzXML file');
mzXMLStruct_D = mzxmlread([PathName_D,FileName_D]); %function from MATLAB Bioinformatics Toolbox


scansSumData = exms_msdataextract([950, 950], [200, 1800], flagND);



figure
plot(Raw(:,1),Raw(:,2),'-or')
hold on
plot(scansSumData(:,1),scansSumData(:,2),'-ob')


x=(scansSumData(:,1)-Raw(:,1))./Raw(:,1);
figure
hist(x)


% y=scansSumData(:,2)-Raw(1:size(scansSumData,1),2);
% figure
% hist(y,100)