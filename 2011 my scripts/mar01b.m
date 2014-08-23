
% temp=sortrows(mascot1);
% mascot1=[];
% n=1;
% mascot1(n,:)=temp(n,:);
% for i=2:size(temp,1)
%     if temp(i,1)==temp(i-1,1) && temp(i,2)==temp(i-1,2) && temp(i,3)==temp(i-1,3)
%         mascot1(n,4)=max([mascot1(n,4), temp(i,4)]);
%     else
%         n=n+1;
%         mascot1(n,:)=temp(i,:);
%     end
% end


figure
n=0;
for i=1:size(mascot1,1)
    k=0;
    for j=1:size(peptidesPool,1)
        if mascot1(i,1)==peptidesPool(j,1) && mascot1(i,2)==peptidesPool(j,2) && mascot1(i,3)==peptidesPool(j,3)
            n=n+1;
            plot(mascot1(i,4),log10(peptidesPool(j,8)),'b*')
            hold on
            k=1;
        end
    end
    if k==0
        plot(mascot1(i,4),0.5,'go')
        hold on
    end
end

for j=1:size(peptidesPool,1)
    k=0;
    for i=1:size(mascot1,1)
        if mascot1(i,1)==peptidesPool(j,1) && mascot1(i,2)==peptidesPool(j,2) && mascot1(i,3)==peptidesPool(j,3)
            k=1;
        end
    end
    if k==0
        plot(-5,log10(peptidesPool(j,8)),'ro')
        hold on
    end
end
v=axis;
axis([-7,v(2),v(3),0.9])
plot([31,31],[v(3),0.9],'g:')
hold on
plot([-7,v(2)],[log10(0.99),log10(0.99)],'r:')
hold on
xlabel('Mascot Score')
ylabel('log_1_0 (Sequest P Score)')
title('MBP MSMS Run 1 (digested by Pepsin)')


        
        
        
        
        
        
        
        
        
        
            