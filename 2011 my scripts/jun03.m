

    %%%establish 'mzXMLStruct_H':
    disp('Select .mzXML file of the ND(allH) sample...');
    [FileName_H,PathName_H] = uigetfile('*.mzXML','Select the mzXML file');
    mzXMLStruct_H = mzxmlread([PathName_H,FileName_H]); %function from MATLAB Bioinformatics Toolbox
    
    %%%establish a list of scan number ~ retention time of ND(allH) sample:
    Scans_RT_list_H=zeros(1,mzXMLStruct_H.mzXML.msRun.scanCount);
    for i=1:mzXMLStruct_H.mzXML.msRun.scanCount
        Scans_RT_list_H(i)=str2double(mzXMLStruct_H.scan(i).retentionTime(3:end-1));    %unit: second
    end
    
    %%%establish a list of scan number ~ MS level (1 or 2...) of ND(allH) sample: 2010-02-04 added
    Scans_msLevel_list_H=zeros(1,mzXMLStruct_H.mzXML.msRun.scanCount);
    for i=1:mzXMLStruct_H.mzXML.msRun.scanCount
        Scans_msLevel_list_H(i)=mzXMLStruct_H.scan(i).msLevel;
    end