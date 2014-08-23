
% 
% ft=flipdim(sortrows(FeaturesTable, 9),1);
% ft(:,9)=log10(ft(:,9));
% figure
% for i=1:size(ft,1)
%     disp(i)
%     if ft(i,11)==0
%         subplot(3,1,1)
%         stem(i, ft(i,9), 'k')
%         hold on
%     end
%     
%     if ft(i,12)==0
%         subplot(3,1,2)
%         stem(i, ft(i,9), 'k')
%         hold on
%     end
%     
%     if ft(i,13)==0
%         subplot(3,1,3)
%         stem(i, ft(i,9), 'k')
%         hold on
%     end
% end
% 
% for i=1:size(ft,1)
%     disp(i)
%     if ft(i,11)==1
%         subplot(3,1,1)
%         stem(i, ft(i,9), 'b')
%         hold on
%     end
%     
%     if ft(i,12)==1
%         subplot(3,1,2)
%         stem(i, ft(i,9), 'r')
%         hold on
%     end
%     
%     if ft(i,13)==1
%         subplot(3,1,3)
%         stem(i, ft(i,9), 'm')
%         hold on
%     end
% end







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




ft=flipdim(sortrows(FeaturesTable, 9),1);
ft(:,9)=log10(ft(:,9));

figure

m1=0; m2=0; m3=0;
A1=[]; A2=[]; A3=[];
for i=1:size(ft,1)
    if ft(i,11)==0
        m1=m1+1;
        A1(m1,:)=[i,ft(i,9)];
    end
    
    if ft(i,12)==0
        m2=m2+1;
        A2(m2,:)=[i,ft(i,9)];
    end
    
    if ft(i,13)==0
        m3=m3+1;
        A3(m3,:)=[i,ft(i,9)];
    end
end

subplot(3,1,1)
stem(A1(:,1), A1(:,2), 'k')
hold on
subplot(3,1,2)
stem(A2(:,1), A2(:,2), 'k')
hold on
subplot(3,1,3)
stem(A3(:,1), A3(:,2), 'k')
hold on


m1=0; m2=0; m3=0;
A1=[]; A2=[]; A3=[];
for i=1:size(ft,1)
    if ft(i,11)==1
        m1=m1+1;
        A1(m1,:)=[i,ft(i,9)];
    end
    
    if ft(i,12)==1
        m2=m2+1;
        A2(m2,:)=[i,ft(i,9)];
    end
    
    if ft(i,13)==1
        m3=m3+1;
        A3(m3,:)=[i,ft(i,9)];
    end
end

subplot(3,1,1)
stem(A1(:,1), A1(:,2), 'b')
hold on
subplot(3,1,2)
stem(A2(:,1), A2(:,2), 'r')
hold on
subplot(3,1,3)
stem(A3(:,1), A3(:,2), 'm')
hold on
    