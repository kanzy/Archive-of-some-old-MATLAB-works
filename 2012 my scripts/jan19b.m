%%%2012-01-19 jan19b.m: revised from jan13b; should run after jan19c ============================unfinished!
%%%2012-01-13 jan13b.m: for SNP-PIN project, working on table A, B, C

%%%PART 1: generate A_protList&Table from table A (the HPRD protein interaction database)

%%%PART 2: go through all SAP in table C (the SwissVar database)
C_ddTable=zeros(size(C,1),3); %col1:column number in table C, col2:PPI degree, col3:disease or not, col4:SIFT score, col5:PolyPhen2 score
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

                
                
        