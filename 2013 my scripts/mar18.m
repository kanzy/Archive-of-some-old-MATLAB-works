
disp('The one in MATLAB folder!')
figure

RMSD1=[]; n1=0;
RMSD2=[]; n2=0;
for i=1:5
    disp(['Now import Run # ',num2str(i),' (FL1 Centroid fitting): '])
    uiimport
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
    
    X=simSettings.simDarray(1, [3:10, 12:29]); %ABC use 12:30; D use 12:29
    Y1=fitResults.DFit;
    
    RMSD1=[RMSD1, (X-Y1).^2];
    n1=n1+size(X,2);
    
    
    disp(['Now import Run # ',num2str(i),' (FL2 Envelope fitting): '])
    uiimport
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
    Y2=fitResults.DFit;
    
    RMSD2=[RMSD2, (X-Y2).^2];
    n2=n2+size(X,2);
    
    plot([0,1],[0,1],'k:')
    hold on
    plot(X, Y1, 'bo')
    hold on
    plot(X, Y2, 'ro')
    hold on
    
end

if n1~=n2
    error('something wrong!')
end

RMSD1=(sum(RMSD1)/n1)^0.5;
RMSD2=(sum(RMSD2)/n2)^0.5;

% plot([0,1],[0,1],'k:')
% hold on
% for i=1:5
%     disp(['Now import Run # ',num2str(i),' (FL1 Centroid fitting): '])
%     uiimport
%     void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
%     
%     X=simSettings.simDarray(1, [3:10, 12:29]);
%     Y1=msdfitTable(:,2);
%     
%     disp(['Now import Run # ',num2str(i),' (FL2 Envelope fitting): '])
%     uiimport
%     void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
%     Y2=msdfitTable(:,2);
%     
%     a=4;b=5;
%     X(a:b)=sort(X(a:b)); Y2(a:b)=sort(Y2(a:b)); 
%     a=6;b=7;
%     X(a:b)=sort(X(a:b)); Y2(a:b)=sort(Y2(a:b)); 
%     a=17;b=19;
%     X(a:b)=sort(X(a:b)); Y2(a:b)=sort(Y2(a:b)); 
%     a=21;b=22;
%     X(a:b)=sort(X(a:b)); Y2(a:b)=sort(Y2(a:b)); 
%     
%     for j=1:26
%         if (j>3 && j<8) || (j>16 && j<20) || (j>20 && j<23)
%             plot(X(j), Y1(j), 'bo')
%             hold on
%             plot(X(j), Y2(j), 'ro')
%             hold on
%         else
%             plot(X(j), Y1(j), 'b.')
%             hold on
%             plot(X(j), Y2(j), 'r.')
%             hold on
%         end
%     end
%     
% end






