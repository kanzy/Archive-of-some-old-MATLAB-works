

% finalTable: col1--VarID of Table E; col2--disease or not; col3--SIFT score;
%             col4--PolyPhen2 score;  col5--dTANGO;         col6--dWALTZ;
%             col7--dLIMBO;           col8--ddG;            col9--PIN degree;

sizer1=size(Ed_textdata,1);
sizer2=size(Ep_textdata,1);

finalTable=zeros(sizer1+sizer2-2,9);

n=0;

for i=2:sizer1
    n=n+1;
    disp(n)

    str=Ed_textdata{i,1};
    x=find(str=='_');
    finalTable(n,1)=str2double(str(x+1:end)); %Var ID (of Table E)
    finalTable(n,2)=1; %disease SAP
    finalTable(n,5)=Ed_data(i-1,1); %dTANGO
    finalTable(n,6)=Ed_data(i-1,2); %dWALTZ
    finalTable(n,7)=Ed_data(i-1,3); %dLIMBO
    finalTable(n,8)=Ed_data(i-1,4); %ddG
    
    uniProtID=Ed_textdata{i,2};
    uniProtAC=' ';
    SAP=Ed_textdata{i,3};
    aa1=SAP(1);
    aa2=SAP(end);
    aaNum=SAP(2:end-1);
    flag=0;
    for j=1:size(D,1)
        if strcmp(D{j,20},uniProtID)
                a1=D{j,6}; a2=D{j,7};
                str=D{j,1};
                x=find(str=='_');
                aNum=str(x(end)+1:end);
                if strcmp(aa1,a1) && strcmp(aa2,a2) && strcmp(aaNum,aNum)
                    flag=1;
                    finalTable(n,3)=str2double(D(j,10)); %SIFT score
                    finalTable(n,4)=str2double(D(j,11)); %PolyPhen2 score
                    uniProtAC=D{j,19};
                    break
                end
        end
    end
    if flag==0
        finalTable(n,3)=NaN;
        finalTable(n,4)=NaN;
    end
        
    flag=0;
    if max(size(uniProtAC))>1
    for j=1:size(A2,1)
        if strcmp(uniProtAC, A2{j,2})
            finalTable(n,9)=A2{j,3}; %PIN degree
            flag=1;
            break
        end
    end
    end
    if flag==0
        finalTable(n,9)=NaN; %this protein not found in HRPD database
    end 
    
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=2:sizer2
    n=n+1;
    disp(n)

    str=Ep_textdata{i,1};
    x=find(str=='_');
    finalTable(n,1)=str2double(str(x+1:end)); %Var ID (of Table E)
    finalTable(n,2)=0; %non-disease(polyphorism) SAP
    finalTable(n,5)=Ep_data(i-1,1); %dTANGO
    finalTable(n,6)=Ep_data(i-1,2); %dWALTZ
    finalTable(n,7)=Ep_data(i-1,3); %dLIMBO
    finalTable(n,8)=Ep_data(i-1,4); %ddG
    
    uniProtID=Ep_textdata{i,2};
    uniProtAC=' ';
    SAP=Ep_textdata{i,3};
    aa1=SAP(1);
    aa2=SAP(end);
    aaNum=SAP(2:end-1);
    flag=0;
    for j=1:size(D,1)
        if strcmp(D{j,20},uniProtID)
                a1=D{j,6}; a2=D{j,7};
                str=D{j,1};
                x=find(str=='_');
                aNum=str(x(end)+1:end);
                if strcmp(aa1,a1) && strcmp(aa2,a2) && strcmp(aaNum,aNum)
                    flag=1;
                    finalTable(n,3)=str2double(D(j,10)); %SIFT score
                    finalTable(n,4)=str2double(D(j,11)); %PolyPhen2 score
                    uniProtAC=D{j,19};
                    break
                end
        end
    end
    if flag==0
        finalTable(n,3)=NaN;
        finalTable(n,4)=NaN;
    end
    
    flag=0;
    if max(size(uniProtAC))>1
    for j=1:size(A2,1)
        if strcmp(uniProtAC, A2{j,2})
            finalTable(n,9)=A2{j,3}; %PIN degree
            flag=1;
            break
        end
    end
    end
    if flag==0
        finalTable(n,9)=NaN; %this protein not found in HRPD database
    end 
    
end
                
 save('Jan25_finalTable.mat', 'finalTable')           
           
            
    
    

    
    