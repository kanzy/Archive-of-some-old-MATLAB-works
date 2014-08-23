
% clear
% disp('Import Jan20combine.txt of HumDiv database for input of PolyPhen2 web batch query')
% uiimport
% void=input('Press "Enter" to continue...');
% 
% for i=1:size(humdiv,1)
%     str=humdiv{i,1};
%     x=find(str=='_');
%     str2=[str(1:x(2)-1),' ',str(x(2)+1:size(str,2))];
%     humdiv{i,1}=str2;
% end
% xlswrite('Jan20_HumDiv_combine_for PolyPhen2 web input.xls',humdiv)



% for i=1:size(humvar,1)
%     str=humvar{i,1};
%     x=find(str=='_');
%     str2=[str(1:x(2)-1),' ',str(x(2)+1:size(str,2))];
%     humvar{i,1}=str2;
% end
% xlswrite('Jan20_HumVar_combine_for PolyPhen2 web input.xls',humvar)



sapList=cell(size(C,1),2); %col1:uniProtAC col2:SAP(e.g. A53T)
n=0;
for i=2:size(C,1)
    if max(size(C{i,6}))>1
        n=n+1
        sapList{n,1}=C{i,1};
        str=C{i,6};
        a1=aminolookup(str(3:5)); %three letter to one letter
        a2=aminolookup(str(size(str,2)-2:size(str,2)));
        sapList{n,2}=[a1,str(6:size(str,2)-3),a2];
    end
end

sapList2=cell(35000,1);
for i=1:35000
sapList2{i,1}=[sapList{i,1},' ',sapList{i,2}];
end
xlswrite('Jan20_SwissVar_for PolyPhen2 web input(part1).xls',sapList2)

sapList3=cell(n-35000,1);
for i=35001:n
sapList3{i-35000,1}=[sapList{i,1},' ',sapList{i,2}];
end
xlswrite('Jan20_SwissVar_for PolyPhen2 web input(part2).xls',sapList3)

        




















