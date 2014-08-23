
disp(' ')
disp('This program is to test the correctness of a peptide pool geneated before,')
disp('so it need importing previously saved "exms_preload.mat" file:')
uiimport
void=input('Press "Enter" to continue...');


peptidesPool_Problem=[];
num=1;

%%%Test 1: RT prediction based on hydrophobicity
disp(' ')
disp('Test 1: RT prediction based on amino acid hydrophobicity')
aaIndex='ARNDCQEGHILKMFPSTWYV';
hpbKD=[1.8, -4.5, -3.5, -3.5, 2.5, -3.5, -3.5, -0.4, -3.2, 4.5, ...
    3.8, -3.9, 1.9, 2.8, -1.6, -0.8, -0.7, -0.9, -1.3, 4.2]; %KYTE-DOOLITTLE scale

h=figure;
hpbPool=zeros(size(peptidesPool,1),1);
for i=1:size(peptidesPool,1)
    pepSeq=currSeq(peptidesPool(i,1):peptidesPool(i,2));
    for j=1:size(pepSeq,2)
        x=find(pepSeq(j)==aaIndex);
        if hpbKD(x)>0 %only consider positive ones
            hpbPool(i)=hpbPool(i)+hpbKD(x);
        end
    end
    
    plot(peptidesPool(i,7),hpbPool(i),'*')
    hold on
    text(peptidesPool(i,7)+0.1,hpbPool(i),num2str(i))
    hold on
end
xlabel('Sequest RT (min)')
ylabel('Calculated Hydrophobicity (Kyte-Doolittle)')

disp(' ')
disp('Look at the correlation...')
wrongID=input('Input the number of any wrong RT peptide (input 0 if not any): ');
while wrongID~=0
    peptidesPool_Problem(num,:)=[peptidesPool(wrongID,:),1];
    num=num+1;
    figure(h)
    wrongID=input('Input the number of any wrong RT peptide (input 0 if no more): ');
end


%%%Test 2: RT comparison of same peptide with multiple charge states -- refer to mar08d.m
disp(' ')
disp('Test 2: RT comparison of same peptide with multiple charge states')
RTthreshold=input('Input the RT tolerance of same peptide with multiple charge states (in minute, e.g. 1)'); 
m=1;
deltaRT=[];
n=1;
pepPair=peptidesPool(1,:);
for i=2:size(peptidesPool,1)
    if peptidesPool(i,1)==peptidesPool(i-1,1) && peptidesPool(i,2)==peptidesPool(i-1,2)
        n=n+1;
        pepPair(n,:)=peptidesPool(i,:);
    else
        if n>1
            deltaRT(m)=max(pepPair(:,7))-min(pepPair(:,7));
            if deltaRT(m)>RTthreshold
                disp('Note: find inconsistent multiple charge states peptide -- there may be correct ones.')
                format shortG
                disp(pepPair)
                for j=1:size(pepPair,1)
                    peptidesPool_Problem(num,:)=[pepPair(j,:),2];
                    num=num+1;
                end
            end
            m=m+1;
        end
        n=1;
        pepPair=peptidesPool(i,:);
    end
end

%%%Test 3: Impossible protease cutting site:
disp(' ')
flag=input('Is this dataset from Pepsin digestion only? (1=yes, 0=no): ');
if flag==1
disp('Test 3: Impossible Pepsin cutting site')
for i=1:size(peptidesPool,1)
    START=peptidesPool(i,1);
    END=peptidesPool(i,2);
    if (START~=1 && ((currSeq(START-1)=='H' && currSeq(START)~='P') || (currSeq(START-1)=='K' && currSeq(START)~='I' && currSeq(START)~='G') ||currSeq(START-1)=='R' ||currSeq(START-1)=='P')) || ...
            (END~=size(currSeq,2) && ((currSeq(END)=='H' && currSeq(END+1)~='P') || (currSeq(END)=='K' && currSeq(END+1)~='I' && currSeq(END+1)~='G') ||currSeq(END)=='R' ||currSeq(END)=='P'))
        peptidesPool_Problem(num,:)=[peptidesPool(i,:),3];
        num=num+1;
    end
end
else
    disp('Test 3 is only for Pepsin, skipped here.')
end
    
%%%Test 4: Too short peptide:
disp(' ')
disp('Test 4: Too short peptide')
for i=1:size(peptidesPool,1)
    START=peptidesPool(i,1);
    END=peptidesPool(i,2);
    if END-START+1<=4
        peptidesPool_Problem(num,:)=[peptidesPool(i,:),3];
        num=num+1;
    end
end

format shortG
peptidesPool_Problem=sortrows(peptidesPool_Problem)

disp(' ')
disp('Problematic peptides have been listed as "peptidesPool_Problem" in workspace, you may review them.')
disp('The last column of "peptidesPool_Problem" display the number of test failed.')
disp('Note: Test 2 failed peptides may be correct! Please manually check.') 

format





        