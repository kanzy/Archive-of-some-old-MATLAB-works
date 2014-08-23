%%%2012-07-02 scancmp.m

%%%establish 'mzXMLStruct':
disp('Select the .mzXML data file ...');
[FileName,PathName] = uigetfile('*.mzXML','Select the mzXML file');
mzXMLStruct = mzxmlread([PathName,FileName]); %function from MATLAB Bioinformatics Toolbox

disp(' ')
disp('To extract/inspect certain mass spec data ...')
extractMzRange(1)=input('Input the m/z lower boundary: ');
extractMzRange(2)=input('Input the m/z upper boundary: ');
extractScansRange(1)=input('Input the start scan number: ');
extractScansRange(2)=input('Input the end scan number: ');

if extractMzRange(1)>=extractMzRange(2) || extractScansRange(1)>extractScansRange(2)
    error('Wrong input!')
end

n=0;
for scanNum=extractScansRange(1):extractScansRange(2)
    n=n+1;
    scanData =[mzXMLStruct.scan(scanNum).peaks.mz(1:2:end), mzXMLStruct.scan(scanNum).peaks.mz(2:2:end)];   %m/z~Int
    m=1;
    clear subData
    subData=[];
    for i=1:size(scanData,1)
        if scanData(i,1)>=extractMzRange(1) && scanData(i,1)<=extractMzRange(2)
            subData(m,:)=scanData(i,:);
            m=m+1;
        end
    end
    clear scanData
    
    SaveXlsFileName=['Extracted Data(Scan#',num2str(extractScansRange(1)),'-#',num2str(extractScansRange(2)),').xls'];
    xlswrite(SaveXlsFileName, {'m/z','Intensity',' ',['Scan Number ',num2str(scanNum)]},n);
    xlswrite(SaveXlsFileName, subData, n, 'A2');
    
    figure
    plot(subData(:,1),subData(:,2))
    xlabel('m/z')
    ylabel('Intensity')
    title(['Scan Number ',num2str(scanNum)])
end

disp(' ')
disp([SaveXlsFileName, ' has been saved in MATLAB current directory!'])














