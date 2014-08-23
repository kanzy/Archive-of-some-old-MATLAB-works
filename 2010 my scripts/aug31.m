%%%2009-10-08 poolplot2n.m: modified to compact & unique peptides plot
%%2008-07-01 poolplot2.m: given two peptide pools(col1:START#, col2:END#,
%%col3: CS), plot red for peptide only in pool1, blue for peptide only in pool2, and
%%green for peptide in common. 

clear A B C merge

A=pool_pepsin;
C=pool_fungal;
B=pool_tandem;

% 
% 
% A=input('enter name of Pool 1:');
% B=input('enter name of Pool 2:');


A=[A(:,1:3) ones(size(A,1),1)];   %1 is the label of peptide in A //red 1
B=[B(:,1:3) 2*ones(size(B,1),1)];    %2 is the label of peptide in B //green 2
C=[C(:,1:3) 3*ones(size(C,1),1)];    %3 is the label of peptide in C //blue 3

D=[A;B;C];
D=sortrows(D);


%%%generate merge pool(remove duplicate peptides):
k=1;
for i=1:size(D,1)-1
    if( D(i,1:3)==D(i+1,1:3) )
         D(i,4)=min(D(i,4), D(i+1,4));   
         D(i+1,4)=min(D(i,4), D(i+1,4));
    end
    if( D(i,1)~=D(i+1,1) ||D(i,2)~=D(i+1,2) ||D(i,3)~=D(i+1,3) )
        merge(k,:)=D(i,:);
        k=k+1;
    end
end
i=i+1; %i=size(D,1)
merge(k,:)=D(i,:);

%%%generate unique pool(remove different charges):
k=1;
E=[];
for i=1:(size(merge,1)-1)
    if merge(i,1)~=merge(i+1,1) || merge(i,2)~=merge(i+1,2)
        E(k,1:2)=merge(i,1:2);
        E(k,3)=merge(i,4);
        k=k+1;
    end
end
E(k,1:2)=merge(size(merge,1),1:2);    %Unique peptides pool
E(k,3)=merge(i,4);


%%%plot E(by compact ladder):
h=input('Input the height(floors) of peptides plot: '); %If there is an error message, means 'h' beyond lowest limit
rightEnds=zeros(h,1);

figure
k=1;
for i=1:size(E,1)
    while E(i,1)<=rightEnds(k)
        k=k+1;
    end
    p1=[E(i,1),E(i,2)]; % start and end aa# of each peptide
    p2=[k,k];
    if E(i,3)==1
        plot(p1,p2,'r','LineWidth',2);
    end
    if E(i,3)==2
        plot(p1,p2,'g','LineWidth',2);
    end
    if E(i,3)==3
        plot(p1,p2,'b','LineWidth',2);
    end
    hold on
    rightEnds(k)=E(i,2);
    k=k+1;
    if k>=h
        k=1;
    end
end


set(gca,'xtick',[0:5:150])
xlabel('Residue Number')
ylabel('Peptide Index')
title(' ')   
