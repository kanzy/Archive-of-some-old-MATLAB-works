

% ftable2=flipud(ftable2);

figure

subplot(2,1,1)
for i=1:size(ftable2,1)
    if ftable2(i,11)==1
        color='b';
    else
        color='m';
    end
    stem(i,log10(ftable2(i,9)),'Color',color)
    hold on
end
axis([0 1100 5 9.5])
sum(ftable2(:,11))
sum(ftable2(:,11))/size(ftable2,1)


RTwindow=1;

subplot(2,1,2)
n=0;
for i=1:size(ftable2,1)
    if ftable2(i,11)==0
        flag=0;
%         x=ftable2(i,2)-21.981943*2/ftable2(i,4);
%         x=ftable2(i,2)-0.984016/ftable2(i,4);
%         x=ftable2(i,2)+17.026549/ftable2(i,4);
% x=ftable2(i,2)-15.994915*2/ftable2(i,4);
% x=ftable2(i,2)-37.955882/ftable2(i,4);
% x=ftable2(i,2)-18.0106*3/ftable2(i,4);
% x=ftable2(i,2)+18.0106*3/ftable2(i,4);
% x=ftable2(i,2)-17.026549*2/ftable2(i,4);
% x=ftable2(i,2)+0.984016/ftable2(i,4);
% x=ftable2(i,2)-13.979265/ftable2(i,4);
% x=ftable2(i,2)-26.015650/ftable2(i,4);
% x=ftable2(i,2)+1.031634 /ftable2(i,4);
% x=ftable2(i,2)+15.994915*2/ftable2(i,4);
x=ftable2(i,2)+94.041865/ftable2(i,4);
        
        for j=1:size(ftable2,1)
            if ftable2(j,11)==1 && ftable2(i,4)==ftable2(j,4) && abs(ftable2(j,2)-x)<=x*(1e-6)*4 && ...
                    ftable2(i,7)-ftable2(j,8)<RTwindow && ftable2(j,7)-ftable2(i,8)<RTwindow
                    
                stem(i,log10(ftable2(i,9)),'m')
                hold on
                stem(j,log10(ftable2(j,9)),':b')
                hold on
%                 plot([i,j],[log10(ftable2(i,9)),log10(ftable2(j,9))],':k')
%                 hold on
                flag=1;
            end
        end
        if flag==1
            n=n+1;
        end
    end
end
axis([0 1100 5 9.5])
n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
for i=1:size(ftable2,1)
    if ftable2(i,11)==0
%         x=ftable2(i,2)-21.981943*2/ftable2(i,4);
%         x=ftable2(i,2)-0.984016/ftable2(i,4);
% x=ftable2(i,2)+17.026549/ftable2(i,4);
% x=ftable2(i,2)-15.994915*2/ftable2(i,4);
% x=ftable2(i,2)-37.955882/ftable2(i,4);
% x=ftable2(i,2)-18.0106*3/ftable2(i,4);
% x=ftable2(i,2)+18.0106*3/ftable2(i,4);
% x=ftable2(i,2)-17.026549*2/ftable2(i,4);
% x=ftable2(i,2)+0.984016/ftable2(i,4);
% x=ftable2(i,2)-13.979265/ftable2(i,4);
% x=ftable2(i,2)-26.015650/ftable2(i,4);
% x=ftable2(i,2)+1.031634 /ftable2(i,4);
% x=ftable2(i,2)+15.994915*2/ftable2(i,4);
x=ftable2(i,2)+94.041865/ftable2(i,4);
        
        
        for j=1:size(ftable2,1)
            if ftable2(j,11)==1 && ftable2(i,4)==ftable2(j,4) && abs(ftable2(j,2)-x)<=x*(1e-6)*4 && ...
                    ftable2(i,7)-ftable2(j,8)<RTwindow && ftable2(j,7)-ftable2(i,8)<RTwindow
                subplot(2,1,1)
                plot(log10(ftable2(i,9)),log10(ftable2(j,9)),'k*')
                hold on
                
                subplot(2,1,2)
                plot([ftable2(i,7),ftable2(i,8)],[(ftable2(j,7)+ftable2(j,8))/2,(ftable2(j,7)+ftable2(j,8))/2],'m')
                hold on
                plot([(ftable2(i,7)+ftable2(i,8))/2,(ftable2(i,7)+ftable2(i,8))/2],[ftable2(j,7),ftable2(j,8)],'b')
                hold on
            end
        end
    end
end
subplot(2,1,1)
axis([5 9.5 5 9.5])
subplot(2,1,2)
axis([2 12 2 12])
        
        
        
        
n=0;
mtable=[];
for i=1:200
    if ftable2(i,11)==0
        n=n+1;
        mtable(n,:)=ftable2(i,:);
    end
end
        
        
        
        
        
        
        
        
        
        
