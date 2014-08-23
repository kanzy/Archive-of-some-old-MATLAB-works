
sizer1=size(textdata1,1);
sizer2=size(textdata2,1);

swissVar=zeros(sizer1+sizer2,4);

for i=1:sizer1
    disp(i)
    swissVar(i,1)=str2double(textdata1(i,10)); %SIFT score
    swissVar(i,2)=str2double(textdata1(i,11)); %PolyPhen2 score
    AC=textdata1{i,19};
    a1=textdata1{i,6}; a2=textdata1{i,7};
    str=textdata1{i,1};
    x=find(str=='_');
    aaNum=str(x(end)+1:end);
    
    flag=0;
    for j=1:size(A2,1)
        if strcmp(AC, A2{j,2})
            swissVar(i,3)=A2{j,3}; %PIN degree
            flag=1;
            break
        end
    end
    if flag==0
        swissVar(i,3)=NaN; %this protein not found in HRPD database
    end 
    
    for j=1:size(C,1)
        if max(size(C{j,6}))>1
            ACC=C{j,1};
            if strcmp(AC, ACC)
                str=C{j,6};
                a1C=aminolookup(str(3:5)); %three letter to one letter
                a2C=aminolookup(str(size(str,2)-2:size(str,2)));
                aaNumC=str(6:size(str,2)-3);
                if strcmp(a1,a1C) && strcmp(a2,a2C) && strcmp(aaNum,aaNumC)
                    if max(size(C{j,3}))>1
                        swissVar(i,4)=1; %disease
                        disp('Found disease SAP')
                    else
                        swissVar(i,4)=0; %non-disease
                    end
                    break
                end
            end
        end
    end     
end

%%%%%%%%%%%%%%%%%

for i=sizer1+1:sizer1+sizer2
    disp(i)
    swissVar(i,1)=str2double(textdata2(i-sizer1,10)); %SIFT score
    swissVar(i,2)=str2double(textdata2(i-sizer1,11)); %PolyPhen2 score
    AC=textdata2{i-sizer1,19};
    a1=textdata2{i-sizer1,6}; a2=textdata2{i-sizer1,7};
    str=textdata2{i-sizer1,1};
    x=find(str=='_');
    aaNum=str(x(end)+1:end);
    
    flag=0;
    for j=1:size(A2,1)
        if strcmp(AC, A2{j,2})
            swissVar(i,3)=A2{j,3}; %PIN degree
            flag=1;
            break
        end
    end
    if flag==0
        swissVar(i,3)=NaN; %this protein not found in HRPD database
    end 
    
    for j=1:size(C,1)
        if max(size(C{j,6}))>1
            ACC=C{j,1};
            if strcmp(AC, ACC)
                str=C{j,6};
                a1C=aminolookup(str(3:5)); %three letter to one letter
                a2C=aminolookup(str(size(str,2)-2:size(str,2)));
                aaNumC=str(6:size(str,2)-3);
                if strcmp(a1,a1C) && strcmp(a2,a2C) && strcmp(aaNum,aaNumC)
                    if max(size(C{j,3}))>1
                        swissVar(i,4)=1; %disease
                        disp('Found disease SAP')
                    else
                        swissVar(i,4)=0; %non-disease
                    end
                    break
                end
            end
        end
    end     
end

save('Jan22_SwissVar.mat', 'swissVar')
















