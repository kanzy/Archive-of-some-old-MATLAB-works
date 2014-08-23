global mzXMLStruct_H
disp('Select .mzXML file of the ND(allH) sample...');
[FileName_H,PathName_H] = uigetfile('*.mzXML','Select the mzXML file');
mzXMLStruct_H = mzxmlread([PathName_H,FileName_H]); %function from MATLAB Bioinformatics Toolbox