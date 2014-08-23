

%%establish 'mzXMLStruct_H':
disp('Select .mzXML file of the ND(allH) sample...');
[FileName_H,PathName_H] = uigetfile('*.mzXML','Select the mzXML file');
mzXMLStruct_H = mzxmlread([PathName_H,FileName_H]); %function from MATLAB Bioinformatics Toolbox


Scans_msLevel_list=zeros(1,mzXMLStruct_H.mzXML.msRun.scanCount);

MSMS=zeros(mzXMLStruct_H.mzXML.msRun.scanCount,3);
MSMSdata=cell(mzXMLStruct_H.mzXML.msRun.scanCount,1);
n=1;

for i=1:mzXMLStruct_H.mzXML.msRun.scanCount
    Scans_msLevel_list(i)=mzXMLStruct_H.scan(i).msLevel;
    if Scans_msLevel_list(i)==2
        MSMS(n,1)=i; %scan#
        MSMS(n,2)=str2double(mzXMLStruct_H.scan(i).retentionTime(3:end-1))/60; %RT; unit: min
        MSMS(n,3)=mzXMLStruct_H.scan(i).precursorMz.value; %precursor m/z
        MSMSdata{n} =[mzXMLStruct_H.scan(i).peaks.mz(1:2:end), mzXMLStruct_H.scan(i).peaks.mz(2:2:end)]; %m/z~Int
        n=n+1;
    end
end

MSMS=MSMS(1:n-1,:);
