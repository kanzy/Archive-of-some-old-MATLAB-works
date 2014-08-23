
%%refer to mar15a.m, use Mar15_more.mat

theoryPool=[theoryPool_forward; theoryPool_E83K];


%%%merge features of same peptide:
ftable2=[];
ftable2(1,:)=ftable1_sort(1,:);
n=1;
for i=2:size(ftable1_sort,1)
    if ftable1_sort(i,4)==ftable2(n,4) && ... %same Charge state
             abs(ftable1_sort(i,2)-ftable2(n,2))<ftable2(n,2)*(1e-6)*5 && ... %very close m/z by 5 ppm
             ftable2(n,7)-ftable1_sort(i,8)<=0.5 && ftable1_sort(i,7)-ftable2(n,8)<=0.5 %RT colseness requirement             
        ftable2(n,9)=ftable2(n,9)+ftable1_sort(i,9); %merge intensity
        ftable2(n,5)=min(ftable2(n,5), ftable1_sort(i,5)); %merge RT
        ftable2(n,6)=max(ftable2(n,6), ftable1_sort(i,6));
        ftable2(n,7)=min(ftable2(n,7), ftable1_sort(i,7));
        ftable2(n,8)=max(ftable2(n,8), ftable1_sort(i,8));
    else
        n=n+1;
        ftable2(n,:)=ftable1_sort(i,:);
    end
end


%%%Figure 2:
ftable2=[ftable2, zeros(size(ftable2,1),1)];
ftable2=sortrows(ftable2,9);

figure
subplot(2,1,1)
n=0;
for i=1:size(ftable2,1)
    color='m';
    for j=1:size(theoryPool,1)
        if ftable2(i,4)==theoryPool(j,3) && abs(ftable2(i,2)-theoryPool(j,4))<=ftable2(i,2)*(1e-6)*4 %match m/z by 10 ppm
            ftable2(i,11)=1;
            n=n+1;
            color='b';
        end
    end
    stem(size(ftable2,1)-i+1,log10(ftable2(i,9)),'Color',color)
    hold on
end
sum(ftable2(:,11))
sum(ftable2(:,11))/size(ftable2,1)
axis([0 1100 5 9.5])

subplot(2,1,2)
RTwindow=0.5;
n=0;
ftable3a=[];
for i=1:size(ftable2,1)
    color='b';
    flag=0;
    for j=1:size(peptidesPool,1)
        if ftable2(i,4)==peptidesPool(j,3) && abs(ftable2(i,2)-peptidesPool(j,4))<=ftable2(i,2)*(1e-6)*4 && ... %match m/z by 10 ppm
                peptidesPool(j,7)>=ftable2(i,7)-RTwindow && peptidesPool(j,7)<=ftable2(i,8)+RTwindow
            flag=1;
        end
    end
    if flag==1
        n=n+1;
        ftable3a(n,:)=ftable2(i,:);
        stem(size(ftable2,1)-i+1,log10(ftable2(i,9)),'Color',color)
        hold on
    end
end
axis([0 1100 5 9.5])
n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% n=0;
% for i=1:size(peptidesPool,1)
%     flag=0;
%     for j=1:size(ftable2,1)
%         if ftable2(j,4)==peptidesPool(i,3) && abs(ftable2(j,2)-peptidesPool(i,4))<=ftable2(j,2)*(1e-6)*4 && ... %match m/z by 10 ppm
%                 peptidesPool(i,7)>=ftable2(j,7)-RTwindow && peptidesPool(i,7)<=ftable2(j,8)+RTwindow
%             flag=1;
%         end
%     end
%     if flag==1
%         n=n+1;
%     end
% end
% n


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=0;
m=0;
ftable3b=[];
ftable3c=[];
for i=1:1091
    if ftable2(size(ftable2,1)-i+1,11)==0
        n=n+1;
        ftable3b(n,:)=ftable2(size(ftable2,1)-i+1,:);
    else
        m=m+1;
        ftable3c(m,:)=ftable2(size(ftable2,1)-i+1,:);
    end
end
n
m
        
ftable3bx=[];
n=0;
for i=1:size(ftable3b,1)
    x=ftable3b(i,2)-18.0106/ftable3b(i,4);
%     x=ftable3b(i,2)-21.981943/ftable3b(i,4);
    for j=1:size(ftable3c,1)
        if ftable3b(i,4)==ftable3c(j,4) && abs(ftable3c(j,2)-x)<=x*(1e-6)*4
            n=n+1;
            ftable3bx(n,:)=[ftable3b(i,:),j];
        end
    end
end
n
    
    
    
    
    
    
    
    
    
    
    
    
    
    


