
disp('Select the HB Plot generated .csv file...')
[FileName,PathName] = uigetfile('*.csv','Select the CSV file');
HBP = importdata([PathName,FileName]);

for i=1:size(HBP,1)
    str=HBP{i,1};
    commaPosition=find(str==',');
    aa1=protIndex(2, find(protIndex(1,:)==str2double(str(commaPosition(1)+1:commaPosition(2)-1))));
    aa2=protIndex(2, find(protIndex(1,:)==str2double(str(commaPosition(4)+1:commaPosition(5)-1))));
    
    hbLength=str2double(str(commaPosition(6)+1:commaPosition(7)-1));
    hbType=str(commaPosition(7)+1:end);
    switch hbType
        case 'MM'
            markType='s';
        case 'MS'
            markType='^';
        case 'SM'
            markType='v';
        case 'SS'
            markType='o';
            flag=1; %to be all plot on the lower triangle region
    end
            
    plot(aa1,aa2, 'Color',markColor, 'Marker',markType, 'MarkerSize',markSize)
    hold on
    if plotStyle==2
        plot(aa2,aa1, 'Color',markColor, 'Marker',markType, 'MarkerSize',markSize)
        hold on
    end
    
end