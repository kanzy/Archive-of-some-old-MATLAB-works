%%asyn918.m: 2006-09-18 For Quantitative Analysis of Proteolysis Sensitivity along a
%%peptide/protein/amyloid sequence

clear
global data
global cleaveSites

% %1st column: start residue number; 2nd column: end residue number; 3rd
% %column: Normalization value;
% data=[
% 125	140	90
% 18	38	59
% 5	17	67
% 114	140	38
% 95	113	28.3
% 8	17	23
% 39	54	23
% 18	38	36
% 9	38	24
% 90	113	19
% 39	89	73
% ]; %Data of Sep08_2min as an example;
load('-ascii', 'data.txt');
data

%get all cleave sites from start and end residue of proteolysis fragments
sizer=size(data);
k=1;
for i=1:sizer(1)
    if(data(i,1)~=1)
        sites(k)=data(i,1);
        k=k+1;
    end
end
for i=1:sizer(1)
    if(data(i,2)~=140) %the last residue of a-syn's number is 140
        sites(k)=data(i,2)+1;
        k=k+1;
    end
end

%delete the repeat occured residues
sites=sort(sites);
sizer=size(sites);
cleaveSites=[];
k=1;
for i=1:(sizer(2)-1)
    if(sites(i)~=sites(i+1))
        cleaveSites(k)=sites(i);
        k=k+1;
    end
end
cleaveSites(k)=sites(sizer(2));
cleaveSites

%assign Initial Values
sizer=size(cleaveSites);
n=sizer(2);
% for i=1:n
%     x0(i)=0.01;
% end
% x0(n+1)=0.001;
x0(n+1)=0.1/sum(data(:,3)); % assume a total 10% proteolysis
sizer=size(data);
counter=zeros(n,1);
for i=1:n
    for j=1:sizer(1)
        if (data(j,1)==cleaveSites(i))
            counter(i)=counter(i)+data(j,3);
        end
        if(data(j,2)==cleaveSites(i)-1)
            counter(i)=counter(i)+data(j,3);
        end
    end
end
for i=1:n
    x0(i)=0.1*counter(i)/sum(counter); % select 0.1 for no exact reason
end
x0 

%least-square nonlinear fitting
format short e
options=optimset('MaxIter',30);
[fitPara,r1,r2,exitFlag,output]=lsqnonlin(@asyn918_fit,x0,zeros(1,(n+1)),ones(1,(n+1)),options)

format short
fitPara=fitPara(1:n);
bar(cleaveSites, log10(fitPara)+5)
xlabel('Cleavage Site Number along alpha-Synuclein')
ylabel('Possibility of Proteolysis (5+log(p))')
title('2006-09-08 Monomer with 20min proteolysis --Ctrl 1') %change title for different exp;