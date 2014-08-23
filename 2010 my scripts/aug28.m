
% A=[];
% B=[];
% a=1;
% b=1;
% 
% for i=1:size(finalTable_10,1)
%     if finalTable_10(i,12)==2 && finalTable_old(i,12)~=2
%         A(a,:)=finalTable_10(i,1:3);
%         a=a+1;
%     end
%     
%     if finalTable_10(i,12)~=2 && finalTable_old(i,12)==2
%         B(b,:)=finalTable_10(i,1:3);
%         b=b+1;
%     end
%     
% end
% 
% a=a-1
% b=b-1
% A
% B
%         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

total=0;
correct=0;
for i=1:size(finalTable_old,1)
    if finalTable_old(i,12)~=2 && finalTable_new(i,12)==2
        total=total+1;
        
        if finalTable_old(i,12)==1
            correct=correct+1;
        end
        
        
        
    end    
end
total
correct







