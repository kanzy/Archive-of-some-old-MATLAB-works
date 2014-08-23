%%asyn928.m: 2006-09-29 For Quantitative Analysis of Proteolysis Sensitivity along a
%%peptide/protein/amyloid sequence

clear %clear all variables in WorkSpace
%clc %clear command window

global data_m
global data_f
global cleaveSites_m
global cleaveSites_f
global cleaveSites_all
global p_m
global p_f

% %1st column: charge number; 2nd column: start residue number; 3rd column: end residue number; 4rd
% %column: Normalization value;
% % data_m=[
% % 2.	95.	113.	109.
% % 2.	5.	17.	100.
% % 1.	1.	6.	117.
% % 3.	95.	124.	154.
% % 1.	125.	140.	37.
% % 2.	114.	140.	131.
% % 3.	18.	38.	44.
% % 2.	8.	17.	84.
% % 2.	125.	140.	33.
% % 1.	133.	140.	29.
% % 1.	25.	38.	61.
% % 2.	55.	62.	63.
% % ]; %Data of Sep27_mono_20min as an example;
load('-ascii', 'data_m.txt');
load('-ascii', 'data_f.txt');
disp('Monomer Data: (Charge, Start Residue Number, End Residue Number, Normalization)')
disp(data_m)
disp('Fibril Data:')
disp(data_f)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%get all cleave sites from start and end residue of proteolysis fragments
sizer=size(data_m);
k=1;
for i=1:sizer(1)
    if(data_m(i,2)~=1)
        sites(k)=data_m(i,2);
        k=k+1;
    end
end
for i=1:sizer(1)
    if(data_m(i,3)~=140) %the last residue of a-syn's number is 140
        sites(k)=data_m(i,3)+1;
        k=k+1;
    end
end
%%delete the repeat occured residues
sites=sort(sites);
sizer=size(sites);
cleaveSites_m=[];
k=1;
for i=1:(sizer(2)-1)
    if(sites(i)~=sites(i+1))
        cleaveSites_m(k)=sites(i);
        k=k+1;
    end
end
cleaveSites_m(k)=sites(sizer(2));
disp('Cleave-sites in Monomer are:')
disp(cleaveSites_m)

clear sites;
sizer=size(data_f);
k=1;
for i=1:sizer(1)
    if(data_f(i,2)~=1)
        sites(k)=data_f(i,2);
        k=k+1;
    end
end
for i=1:sizer(1)
    if(data_f(i,3)~=140) %the last residue of a-syn's number is 140
        sites(k)=data_f(i,3)+1;
        k=k+1;
    end
end
%%delete the repeat occured residues
sites=sort(sites);
sizer=size(sites);
cleaveSites_f=[];
k=1;
for i=1:(sizer(2)-1)
    if(sites(i)~=sites(i+1))
        cleaveSites_f(k)=sites(i);
        k=k+1;
    end
end
cleaveSites_f(k)=sites(sizer(2));
disp('Cleave-sites in Fibril are:')
disp(cleaveSites_f)

%%find all the sites from Mono and Fibril groups, then delete the repeat occured residues
clear sites
sites=[cleaveSites_m cleaveSites_f];
sites=sort(sites);
sizer=size(sites);
cleaveSites_all=[];
k=1;
for i=1:(sizer(2)-1)
    if(sites(i)~=sites(i+1))
        cleaveSites_all(k)=sites(i);
        k=k+1;
    end
end
cleaveSites_all(k)=sites(sizer(2));
disp('All Cleave-sites are:')
disp(cleaveSites_all)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%find the sites where p=0 in Mono and Fib groups
sizer=size(cleaveSites_all);
p_m=ones(1,sizer(2)); %initial the result Probability Vector of Mon group
p_f=ones(1,sizer(2)); %initial the result Probability Vector of Fib group
sizer_m=size(cleaveSites_m); sizer_m=sizer_m(2);
sizer_f=size(cleaveSites_f); sizer_f=sizer_f(2);
for i=1:sizer(2)
    flag=0;
    for j=1:sizer_m
        if(cleaveSites_all(i)==cleaveSites_m(j))
            flag=1;
        end
    end
    if(flag==0)
        p_m(i)=0;
    end
    
    flag=0;
    for j=1:sizer_f
        if(cleaveSites_all(i)==cleaveSites_f(j))
            flag=1;
        end
    end
    if(flag==0)
        p_f(i)=0;
    end
end
disp('Compare the Cleave Sites between Monomer and Fibril (0 means no cut):')
disp(p_m)
disp(p_f)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%just get the exact variable number in all equations: mostly copy from asyn928_fit.m
sizer=size(cleaveSites_all);
N=sizer(2);
q=asyn928_index(N,'f');


sizer=size(data_m);
M_m=sizer(1);
for i=1:M_m
    left=0;
    right=asyn928_index(N,'m')+1;
    for j=1:N
        if ( cleaveSites_all(j)==data_m(i,2))
            left=j;
        elseif ( cleaveSites_all(j)==(data_m(i,3)+1))
            right=j;
        end
    end
    recorder(i, 1:4)=[data_m(i,1) left right q];
    q=q+1;
end

q=q+1;
r=q;


sizer=size(data_f);
M_f=sizer(1);%number of equations from Fib goup
sizer=size(recorder);
for i=1:M_f
    flag=0;
    left=0;
    right=N+1;
    for j=1:N
        if ( cleaveSites_all(j)==data_f(i,2))
            left=j;
        else if ( cleaveSites_all(j)==(data_f(i,3)+1))
                right=j;
            end
        end
    end

    for j=1:sizer(1)
        if(left==recorder(j,2) && right==recorder(j,3))
            flag=1;
        end
    end
    if(flag==0)
        q=q+1;
    end
end
disp('Number of Variables:')
disp(q)
disp('Number of Equations (Identified Fragments):')
disp(M_m+M_f)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %assign Initial Values, using the similar principle with asyn918.m
counter=zeros(sizer_m,1);
for i=1:sizer_m
    for j=1:M_m
        if (data_m(j,2)==cleaveSites_m(i))|| (data_m(j,3)==cleaveSites_m(i)-1)
            counter(i)=counter(i)+data_m(j,4);
        end
    end
end
for i=1:sizer_m
    x0(i)=0.1*counter(i)/sum(counter); % select 0.1 for no exact reason
end

counter=zeros(sizer_f,1);
for i=1:sizer_f
    for j=1:M_f
        if (data_f(j,2)==cleaveSites_f(i))|| (data_f(j,3)==cleaveSites_f(i)-1)
            counter(i)=counter(i)+data_f(j,4);
        end
    end
end
k=sizer_m;
for i=(k+1):(k+sizer_f)
    x0(i)=0.1*counter(i-k)/sum(counter); %select 0.1 for no exact reason
end

for j=(i+1):(r-1)
    x0(j)=1e-3; %select 1e-3 for no exact reason
end
x0(r)=1; %assume the Mon/Fib sample amount's ratio k'=1 first
for j=(r+1):q
    x0(j)=1e-3; %select 1e-3 for no exact reason
end
format short e
disp('Initial values for all Variables (x0) are:')
disp(x0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%least-square nonlinear fitting
%%get the upper bound of x0
upper(1:i)=ones(1,i);
for j=i+1:q
    upper(j)=Inf;
end

%%use MATLAB function 'lsqnonlin' to solve equations
options=optimset('MaxIter',30);
[x,resnorm,residual,exitFlag,output]=lsqnonlin(@asyn928_fit,x0,zeros(1,q),upper,options);

disp('The solved results are:')
x
disp('The value of the squared 2-norm of the residual at x: sum(fun(x).^2):')
resnorm
disp('Value of the residual fun(x) at the solution x:')
residual
exitFlag
if exitFlag>0
    disp('The function converged to a solution x.')
elseif exitFlag==0
    disp('The maximum number of function evaluations or iterations was exceeded.')
else
    disp('The function did not converge to a solution.')
end
output

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%plotting results
j=1;
sizer=size(cleaveSites_all);
sizer=sizer(2);
for i=1:sizer
       if p_m(i)~=0
        p_m(i)=x(j);
        j=j+1;
    end
end
for i=1:sizer
       if p_f(i)~=0
        p_f(i)=x(j);
        j=j+1;
    end
end
disp('Result Probabilities of Cleave Sites in Monomer:')
disp(p_m)
disp('Result Probabilities of Cleave Sites in Fibril:')
disp(p_f)

subplot(2,1,1)
bar(cleaveSites_all, log10(p_m)+5)
xlabel('Residue Number of alpha-Synuclein')
ylabel('Probability of Proteolysis (5+log(p))')
title('2006-09-27 Monomer with 60 min proteolysis') %change title for different exp;
axis([0 140 1 4])
set(gca,'ytick',[0:4])

subplot(2,1,2)
bar(cleaveSites_all, log10(p_f)+5)
xlabel('Residue Number of alpha-Synuclein')
ylabel('Probability of Proteolysis (5+log(p))')
title('2006-09-27 Fibril with 60 min proteolysis') %change title for different exp;
axis([0 140 1 4])
set(gca,'ytick',[0:4])

format short
%%END OF asyn928.m