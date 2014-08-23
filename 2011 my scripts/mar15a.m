
%%%Figure 1:
% ftable1=[];
% figure
% n1=0;
% n2=0;
% n3=0;
% for i=1:2000
%     
%     switch FeaturesTable(i,10)
%         case 1
%             n1=n1+1;
%             color='b';
%         case 2
%             n2=n2+1;
%             color='y';
%         case 0
%             n3=n3+1;
%             color='r';
%     end
%     stem(i,n1/i,'Color',color)
%     hold on
%           
%     if FeaturesTable(i,10)==1
%     ftable1(n1,:)=FeaturesTable(i,:);
%     end
% end
% n1
% n2
% n3


%%%get features distribution of correct(blue) ID%
% Dist1=zeros(2000,2);
% n1=0;
% for i=1:2000
%     if FeaturesTable(i,10)==1
%             n1=n1+1;
%     end
%     Dist1(i,1)=i;
%     Dist1(i,2)=n1/i;  
% end
% n1
% 
% 

%%%fit above distribution
% X=Dist1(:,1);
% Y=Dist1(:,2);
% cftool




% %%%merge features of same peptide:
% ftable1_sort=sortrows(ftable1,2);
% ftable2=[];
% ftable2(1,:)=ftable1_sort(1,:);
% n=1;
% for i=2:size(ftable1_sort,1)
%     if ftable1_sort(i,4)==ftable2(n,4) && ... %same Charge state
%              abs(ftable1_sort(i,2)-ftable2(n,2))<ftable2(n,2)*(1e-6)*5 && ... %very close m/z by 5 ppm
%              ftable2(n,7)-ftable1_sort(i,8)<=0.5 && ftable1_sort(i,7)-ftable2(n,8)<=0.5 %RT colseness requirement             
%         ftable2(n,9)=ftable2(n,9)+ftable1_sort(i,9); %merge intensity
%         ftable2(n,5)=min(ftable2(n,5), ftable1_sort(i,5)); %merge RT
%         ftable2(n,6)=max(ftable2(n,6), ftable1_sort(i,6));
%         ftable2(n,7)=min(ftable2(n,7), ftable1_sort(i,7));
%         ftable2(n,8)=max(ftable2(n,8), ftable1_sort(i,8));
%     else
%         n=n+1;
%         ftable2(n,:)=ftable1_sort(i,:);
%     end
% end
% 
% 
% %%%Figure 2:
% ftable2=[ftable2, zeros(size(ftable2,1),1)];
% ftable2=sortrows(ftable2,9);
% figure
% for i=1:size(ftable2,1)
%     color='m';
%     for j=1:size(theoryPool,1)
%         if ftable2(i,4)==theoryPool(j,3) && abs(ftable2(i,2)-theoryPool(j,4))<=ftable2(i,2)*(1e-6)*10 %match m/z by 10 ppm
%             ftable2(i,11)=1;
%             color='b';
%         end
%     end
%     stem(size(ftable2,1)-i+1,log10(ftable2(i,9)),'Color',color)
%     hold on
% end
% sum(ftable2(:,11))
% sum(ftable2(:,11))/size(ftable2,1)


% %%%get matching peptide distribution:
% Dist2=zeros(size(ftable2,1),2);
% n=0;
% for i=1:size(ftable2,1)
%     if ftable2(size(ftable2,1)-i+1,11)==1
%         n=n+1;
%     end
%     Dist2(i,:)=[i,n/i];
% end
% 
% %%%fit above distribution
% X=Dist2(:,1);
% Y=Dist2(:,2);
% cftool




% %%%Figure 2: (Wrong!!!)
% ftable2_rev=[ftable2(:,1:10), zeros(size(ftable2,1),1)];
% ftable2_rev=sortrows(ftable2_rev,9);
% figure
% for i=1:size(ftable2_rev,1)
%     color='m';
%     for j=1:size(theoryPool_rev,1)
%         if ftable2_rev(i,4)==theoryPool_rev(j,3) && abs(ftable2_rev(i,2)-theoryPool_rev(j,4))<=ftable2_rev(i,2)*(1e-6)*10 %match m/z by 10 ppm
%             ftable2_rev(i,11)=1;
%             color='b';
%         end
%     end
%     stem(size(ftable2_rev,1)-i+1,log10(ftable2_rev(i,9)),'Color',color)
%     hold on
% end
% sum(ftable2_rev(:,11))
% sum(ftable2_rev(:,11))/size(ftable2_rev,1)


% %%%Figure 2: estimate FPR
% ftable2_SN=[ftable2(:,1:10), zeros(size(ftable2,1),1)];
% ftable2_SN=sortrows(ftable2_SN,9);
% figure
% for i=1:size(ftable2_SN,1)
%     color='m';
%     for j=1:size(theoryPool_SN,1)
%         if ftable2_SN(i,4)==theoryPool_SN(j,3) && abs(ftable2_SN(i,2)-theoryPool_SN(j,4))<=ftable2_SN(i,2)*(1e-6)*10 %match m/z by 10 ppm
%             ftable2_SN(i,11)=1;
%             color='b';
%         end
%     end
%     stem(size(ftable2_SN,1)-i+1,log10(ftable2_SN(i,9)),'Color',color)
%     hold on
% end
% sum(ftable2_SN(:,11))
% sum(ftable2_SN(:,11))/size(ftable2_SN,1)


n=1;
ftable3=[];
for i=1:size(ftable2,1)
    if ftable2(i,11)==1
        ftable3(n,:)=ftable2(i,1:10);
        n=n+1;
    end
end

% % %%%estimate FPR: might be wrong!!
% % ftable3=[ftable3, zeros(size(ftable3,1),1)];
% % ftable3=sortrows(ftable3,9);
% % for i=1:size(ftable3,1)
% %     color='m';
% %     for j=1:size(theoryPool_SN,1)
% %         if ftable3(i,4)==theoryPool_SN(j,3) && abs(ftable3(i,2)-theoryPool_SN(j,4))<=ftable3(i,2)*(1e-6)*10 %match m/z by 10 ppm
% %             ftable3(i,11)=1;
% %             color='b';
% %         end
% %     end
% %     stem(size(ftable3,1)-i+1,log10(ftable3(i,9)),'Color',color)
% %     hold on
% % end
% % sum(ftable3(:,11))
% % sum(ftable3(:,11))/size(ftable3,1)


peptidesPool_ftable3match=[peptidesPool, zeros(size(peptidesPool,1),2)];
n=zeros(size(peptidesPool,1),1);
for i=1:size(peptidesPool,1)
    for j=1:size(ftable3,1)
        if peptidesPool(i,3)==ftable3(j,4) && abs(peptidesPool(i,4)-ftable3(j,2))<peptidesPool(i,4)*(1e-6)*10
            peptidesPool_ftable3match(i,9)=ftable3(j,1);
            peptidesPool_ftable3match(i,10)=ftable3(j,9);
            n(i)=1;
        end
    end
end
sum(n)/size(peptidesPool,1)











