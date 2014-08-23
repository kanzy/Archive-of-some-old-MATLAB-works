% 
% n=0;
% for i=1:size(Whole,1)
%     if ~isnan(Whole(i,17))
%         n=n+1;
%     end
% end
% n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% figure
% for i=1:size(D1,1)
%     plot(D1(i,2), D1(i,1), '*r')
%     hold on
% end
% for i=1:size(D2,1)
%     plot(D2(i,2), D2(i,1), 'og')
%     hold on
% end
% n=0;
% for i=1:size(Whole,1)
%     if ~isnan(Whole(i,7)) && ~isnan(Whole(i,12))
%         n=n+1;
%         plot(Whole(i,2), Whole(i,1), '.b')
%         hold on
%     end
% end
% n



% figure
% for i=1:size(Whole,1)
%     if ~isnan(Whole(i,7))
%         plot(Whole(i,8), Whole(i,7), '*r')
%         hold on
%     end
%     if ~isnan(Whole(i,12))
%         plot(Whole(i,13), Whole(i,12), 'og')
%         hold on
%     end
% %     if ~isnan(Whole(i,18))
% %         plot(Whole(i,18), Whole(i,17), 'og')
% %         hold on
% %     end
% %     if ~isnan(Whole(i,23))
% %         plot(Whole(i,23), Whole(i,22), 'ob')
% %         hold on
% %     end
% end


figure

n=0;
for i=1:size(Whole,1)
    if ~isnan(Whole(i,7)) && ~isnan(Whole(i,12))
        n=n+1;
        plot(Whole(i,2), Whole(i,1), 'ob')
        hold on
    end
end
n

m=0;
for i=1:size(Whole,1)
     if ~isnan(Whole(i,17)) && ~isnan(Whole(i,22))
    %if ~isnan(Whole(i,22))
        m=m+1;
        plot(Whole(i,2), Whole(i,1), '*r')
        hold on
    end
end
m
    
    
    
    
