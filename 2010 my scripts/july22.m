
% clear newPepIndex
% n=1;
% for i=1:size(wholeResults,1)
%     if finalTable1(i,12)==0 && size(wholeResults{i}.findScansRanges,1)>0
%         newPepIndex(n)=i;
%         n=n+1;
%     end
% end

% clear newPepIndex2
% n=1;
% for i=1:size(wholeResults,1)
%     if size(wholeResults{i}.findScansRanges,1)==0
%         newPepIndex2(n)=i;
%         n=n+1;
%     end
% end
% n

clear newPepIndex3
n=1;
for i=1:size(wholeResults,1)
    if finalTable1(i,12)~=0 && size(wholeResults{i}.findScansRanges,1)==0
        newPepIndex3(n)=i;
        n=n+1;
    end
end
n