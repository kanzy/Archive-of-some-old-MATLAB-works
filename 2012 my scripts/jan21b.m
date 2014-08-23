
% humDivDel=zeros(5282,3);
% for i=1:5282 %i.e., size(textdata,1)
%     disp(i)
%     humDivDel(i,1)=str2double(textdata(i,10)); %SIFT score
%     humDivDel(i,2)=str2double(textdata(i,11)); %PolyPhen2 score
%     AC=textdata{i,19};
%     flag=0;
%     for j=1:size(A2,1)
%         if strcmp(AC, A2{j,2})
%             humDivDel(i,3)=A2{j,3}; %PIN degree
%             flag=1;
%             break
%         end
%     end
%     if flag==0
%         humDivDel(i,3)=NaN; %this protein not found in HRPD database
%     end 
% end


% humDivNeu=zeros(6587,3);
% for i=1:6587 %i.e., size(textdata,1)
%     disp(i)
%     humDivNeu(i,1)=str2double(textdata(i,10)); %SIFT score
%     humDivNeu(i,2)=str2double(textdata(i,11)); %PolyPhen2 score
%     AC=textdata{i,19};
%     flag=0;
%     for j=1:size(A2,1)
%         if strcmp(AC, A2{j,2})
%             humDivNeu(i,3)=A2{j,3}; %PIN degree
%             flag=1;
%             break
%         end
%     end
%     if flag==0
%         humDivNeu(i,3)=NaN; %this protein not found in HRPD database
%     end 
% end



% humVarDel=zeros(20418,3);
% for i=1:20418 %i.e., size(textdata,1)
%     disp(i)
%     humVarDel(i,1)=str2double(textdata(i,10)); %SIFT score
%     humVarDel(i,2)=str2double(textdata(i,11)); %PolyPhen2 score
%     AC=textdata{i,19};
%     flag=0;
%     for j=1:size(A2,1)
%         if strcmp(AC, A2{j,2})
%             humVarDel(i,3)=A2{j,3}; %PIN degree
%             flag=1;
%             break
%         end
%     end
%     if flag==0
%         humVarDel(i,3)=NaN; %this protein not found in HRPD database
%     end 
% end


% humVarNeu=zeros(19953,3);
% for i=1:19953 %i.e., size(textdata,1)
%     disp(i)
%     humVarNeu(i,1)=str2double(textdata(i,10)); %SIFT score
%     humVarNeu(i,2)=str2double(textdata(i,11)); %PolyPhen2 score
%     AC=textdata{i,19};
%     flag=0;
%     for j=1:size(A2,1)
%         if strcmp(AC, A2{j,2})
%             humVarNeu(i,3)=A2{j,3}; %PIN degree
%             flag=1;
%             break
%         end
%     end
%     if flag==0
%         humVarNeu(i,3)=NaN; %this protein not found in HRPD database
%     end 
% end

