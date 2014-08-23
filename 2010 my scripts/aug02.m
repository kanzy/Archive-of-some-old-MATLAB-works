%%%aug02.m: for false positive rate calculation and plot by Sequest big
%%%database search

titleStr='Palani ApoAI';

numMSMS=input('How many MS/MS experiments(result tables of peptide search) to use?');

numProtein=input('How many proteins (from top) are real hits? ');

target_Pscore=[];
target_Xscore=[];
target_Charge=[];
n=1;

others_Pscore=[];
others_Xscore=[];
others_Charge=[];
m=1;

for i=1:numMSMS
    disp(['Now import SEQUEST result .csv file(by OpenOffice) #', num2str(i)])
    
    SequestOutput=struct2cell(uiimport);
    SequestOutput=SequestOutput{1};
    
    M=1;
    for j=4:size(SequestOutput,1) %first 3 rows in .csv file are skipped
        SequestPepInfo=SequestOutput{j};
        
        if SequestPepInfo(1)~=','
            M=M+1;
        end
        if M>numProtein
            break
        end
        
        if SequestPepInfo(1)==',' && size(SequestPepInfo,2)>17 %to avoid last blank rows in .csv file
            commaPositions=find(SequestPepInfo==',');
            SequestPepCharge=str2double(SequestPepInfo((commaPositions(5)+1):(commaPositions(6)-1))); %get z
            
            comma_P=7; %2010-09-03 added to fix a "bug" in Sequest table("CID" column)
            while SequestPepInfo((commaPositions(comma_P)-1))~='"'
                comma_P=comma_P+1;
            end
            SequestPepPscore=str2double(SequestPepInfo((commaPositions(comma_P)+1):(commaPositions(comma_P+1)-1))); %get P score
            
            SequestPepXscore=str2double(SequestPepInfo((commaPositions(comma_P+1)+1):(commaPositions(comma_P+2)-1))); %get X score
            target_Pscore(n)=SequestPepPscore;
            target_Xscore(n)=SequestPepXscore;
            target_Charge(n)=SequestPepCharge;
            n=n+1;
        end
    end
    

    for j=(3+n-1+M-1):size(SequestOutput,1)
        SequestPepInfo=SequestOutput{j};
        
        if SequestPepInfo(1)==',' && size(SequestPepInfo,2)>17 %to avoid last blank rows in .csv file
            commaPositions=find(SequestPepInfo==',');
            SequestPepCharge=str2double(SequestPepInfo((commaPositions(5)+1):(commaPositions(6)-1))); %get z
            
            comma_P=7; %2010-09-03 added to fix a "bug" in Sequest table("CID" column)
            while SequestPepInfo((commaPositions(comma_P)-1))~='"'
                comma_P=comma_P+1;
            end
            SequestPepPscore=str2double(SequestPepInfo((commaPositions(comma_P)+1):(commaPositions(comma_P+1)-1))); %get P score
       
            SequestPepXscore=str2double(SequestPepInfo((commaPositions(comma_P+1)+1):(commaPositions(comma_P+2)-1))); %get X score
            others_Pscore(m)=SequestPepPscore;
            others_Xscore(m)=SequestPepXscore;
            others_Charge(m)=SequestPepCharge;
            m=m+1;
        end
    end
    
end

targetList=[target_Pscore' target_Xscore' target_Charge'];
decoyList=[others_Pscore' others_Xscore' others_Charge'];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=-log10(targetList(:,1));
y=[];
n=1;
for i=1:size(x,1)
    if x(i)~=Inf
        y(n)=x(i);
    else
        y(n)=30;
    end
    n=n+1;
end
n1=hist(y,0:0.1:10);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%2010-08-27 added:
decoyList_old=decoyList;
decoyList=[];
n=1;
for i=1:size(decoyList_old,1)
    if decoyList_old(i,1)<=1 && decoyList_old(i,2)>0 && decoyList_old(i,2)<10
        decoyList(n,:)=decoyList_old(i,:);
        n=n+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


x=-log10(decoyList(:,1));
y=[];
n=1;
for i=1:size(x,1)
    if x(i)~=Inf
        y(n)=x(i);
    else
        y(n)=30;
    end
    n=n+1;
end
n2=hist(y,0:0.1:10);

z=sortrows(decoyList,1);
cutoff=z(floor(0.01*size(z,1)),1);

cutoff2=z(floor(0.005*size(z,1)),1);

figure
stem(0:0.1:10,log10(n1),'b','LineWidth',2)
hold on
stem(0:0.1:10,log10(n2),'r','LineWidth',2)
hold on
v=axis;
axis([-0.5 10.5 -0.1 v(4)])

plot([-log10(cutoff),-log10(cutoff)],[-0.1,v(4)],'k:')
hold on
plot([-log10(cutoff2),-log10(cutoff2)],[-0.1,v(4)],'k:')
text(-log10(cutoff),0.9*v(4),[' 99% cutoff P=',num2str(cutoff)])
text(-log10(cutoff2),0.7*v(4),[' 99.5% cutoff P=',num2str(cutoff2)])

xlabel('-log_1_0(P Score)')
ylabel('log_1_0(Population)')
title({titleStr; '(blue=target; red=decoy)'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


x=targetList(:,2);
y=[];
n=1;
for i=1:size(x,1)
    if x(i)~=Inf
        y(n)=x(i);
    else
        y(n)=30;
    end
    n=n+1;
end
n1=hist(y,0:0.1:10);

x=decoyList(:,2);
y=[];
n=1;
for i=1:size(x,1)
    if x(i)~=Inf
        y(n)=x(i);
    else
        y(n)=30;
    end
    n=n+1;
end
n2=hist(y,0:0.1:10);

z=sortrows(decoyList,2);
cutoff=z(ceil(0.99*size(z,1)),2);

figure
for i=1:101
    if n1(i)>0
        stem(i*0.1-0.1,log10(n1(i)),'b','LineWidth',2)
        hold on
    end
    if n2(i)>0
        stem(i*0.1-0.1,log10(n2(i)),'r','LineWidth',2)
        hold on
    end
end
v=axis;
axis([-0.5 v(2) -0.1 v(4)])
plot([cutoff,cutoff],[-0.5,v(4)],'k:')
text(cutoff,0.9*v(4),[' 99% cutoff XCorr=',num2str(cutoff)])
xlabel('XCorr Score')
ylabel('log_1_0(Population)')
title({titleStr; '(blue=target; red=decoy)'})






