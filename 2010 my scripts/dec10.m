%%%2010-12-10: modified from exmstat.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag=exist('wholeResults','var'); %2010-08-19 added for backward compatibility
if flag==0
    disp('Now import the ExMS_wholeResults.mat(before check) file: ')
    uiimport;
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
else
    flag2=input('The needed "wholeResults"(before check) in workspace now?(1=yes,0=no) ');
    if flag2~=1
        disp('Now import the ExMS_wholeResults.mat(before check) file: ')
        uiimport;
        void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
    end
end

disp(' ')
disp('*************************************************************')
disp('Summary of ExMS auto-processing of this sample')
disp('*************************************************************')
m=0;
m2=0;
n=0;
skipSet=[];
foundSet=[];
N=size(wholeResults,1);
for i=1:N
    if min(size(wholeResults{i}.findScansRanges))==0
        m=m+1;
        failSet(m,:)=peptidesPool(i,:);
    else
        m2=m2+1;
        foundSet(m2,:)=peptidesPool(i,:);
    end
    if isfield(wholeResults{i},'flagSkip')==1
        if wholeResults{i}.flagSkip==1
            n=n+1;
            skipSet(n,:)=peptidesPool(i,:);
        end
    end
end
disp([num2str(N), ' peptides in the analyzed pool. (100%)'])
disp([num2str(N-m), ' peptides found by ExMS. (', num2str(100*(N-m)/N,'%4.1f'), '%)'])
disp([' (', num2str(n),  ' peptides passed the skip test(auto-determined correct). (', num2str(100*n/N,'%4.1f'), '% of the pool or ', num2str(100*n/(N-m),'%4.1f'),'% of all the found peptides))'])
disp([num2str(m), ' peptides not found or not analyzed yet. (', num2str(100*m/N,'%4.1f'), '%)'])
disp(' ')