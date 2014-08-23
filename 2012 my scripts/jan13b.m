%%%2012-01-13 jan13b.m: for SNP-PIN project, working on table A, B, C

%%%PART 1: generate A_protList&Table from table A (the HPRD protein interaction database)
% A_protList=cell(size(A,1),1); %to store unique protein's RefSeq ID
% A_protTable=zeros(size(A,1),3); %col1:PPI degree, col2:number of disease SAP, col3:number of non-disease SAP
% 
% A_protList{1,1}=A{1,3};
% A_protTable(1,1)=2; %because A{1,3}==A{1,6}, count for twice.
% n=1;
% for i=2:size(A,1)
%     refSeq=A{i,3};
%     jan13b_sub1 %call jan13b_sub1.m
%     refSeq=A{i,6};
%     jan13b_sub1
% end
% A_protTable=A_protTable(1:n,:);

%%%PART 2: go through all SAP in table C (the SwissVar database)
C_ddTable=zeros(size(C,1),3); %col1:column number in table C, col2:PPI degree, col3:disease or not
n=0;
for i=2:size(C,1)
    disp(i)
    if min(size(C{i,6}))>0 %there is a SAP
        if max(size(C{i,3}))>1
            flagDisease=1;
        else
            flagDisease=0;
        end
        
        for j=2:size(B,1)
            str=B{j,3};
            if strcmp(C{i,2},str(1:end-1)) && max(size(B{j,2}))>1 %there is converted RefSeq ID(s)
                disp('there is converted RefSeq ID(s)')
                str=B{j,2};
                x=find(str==' ');
                if min(size(x))>0
                    refSeqSet=cell(size(x,2),1);
                    for k=1:size(x,2)
                        if k==1
                            refSeqSet{k,1}=str(1:(x(k)-1));
                        else
                            refSeqSet{k,1}=str((x(k-1)+1):(x(k)-1));
                        end
                    end
                else
                    clear refSeqSet
                    refSeqSet{1,1}=str;
                end
                
                for k=1:size(refSeqSet,1)
                    refSeq=refSeqSet{k,1};
                    for w=1:size(A_protTable,1)
                        if strcmp(refSeq,A_protList{w,1}) %there is match in A_protList
                            disp('there is match in A_protList')
                            if flagDisease==1
                                A_protTable(w,2)=A_protTable(w,2)+1;
                            else
                                A_protTable(w,3)=A_protTable(w,3)+1;
                            end
                            
                            n=n+1;
                            C_ddTable(n,1)=i;
                            C_ddTable(n,2)=A_protTable(w,1);
                            C_ddTable(n,3)=flagDisease;
                        end
                    end
                end
                
            end
            
        end
    end
end
%%%plot above result:
% figure
% loglog(A_protTable(:,1), A_protTable(:,2), 'ro')
% hold on
% loglog(A_protTable(:,1), A_protTable(:,3), 'bo')
    
figure
scatter3(A_protTable(:,1), A_protTable(:,2), A_protTable(:,3))

                    
m=0;n=0;
disGrp=[];
nonGrp=[];
for i=1:size(C_ddTable,1)
    if C_ddTable(i,1)>0
        if C_ddTable(i,3)==1
            m=m+1;
            disGrp(m,1)=C_ddTable(i,2);
        else
            n=n+1;
            nonGrp(n,1)=C_ddTable(i,2);
        end
    end
end       
figure
boxplot(disGrp,'notch','on')
hold on
boxplot(nonGrp,'notch','on')
                
                
        