

figure

subplot(4,1,1)
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

MS2tableMatch=[];
n=0;

subplot(4,1,2)
MS2table=MS2table1;
for i=1:size(ftable2,1)
    if ftable2(i,11)==1
        color='b';
    else
        color='m';
    end
    for j=1:size(MS2table1,1)
        if abs(ftable2(i,2)-MS2table(j,3))<=ftable2(i,2)*(1e-6)*4 && ...
                ftable2(i,7)-MS2table(j,2)<=RTwindow && MS2table(j,2)-ftable2(i,8)<=RTwindow
            stem(i,log10(ftable2(i,9)),'Color',color)
            hold on
            n=n+1;
            MS2tableMatch(n,:)=[1,MS2table(j,:),i,ftable2(i,11)];
        end
    end
end
axis([0 1100 5 9.5])

subplot(4,1,3)
MS2table=MS2table2;
for i=1:size(ftable2,1)
    if ftable2(i,11)==1
        color='b';
    else
        color='m';
    end
    for j=1:size(MS2table1,1)
        if abs(ftable2(i,2)-MS2table(j,3))<=ftable2(i,2)*(1e-6)*4 && ...
                ftable2(i,7)-MS2table(j,2)<=RTwindow && MS2table(j,2)-ftable2(i,8)<=RTwindow
            stem(i,log10(ftable2(i,9)),'Color',color)
            hold on
            n=n+1;
            MS2tableMatch(n,:)=[2,MS2table(j,:),i,ftable2(i,11)];
        end
    end
end
axis([0 1100 5 9.5])

subplot(4,1,4)
MS2table=MS2table3;
for i=1:size(ftable2,1)
    if ftable2(i,11)==1
        color='b';
    else
        color='m';
    end
    for j=1:size(MS2table1,1)
        if abs(ftable2(i,2)-MS2table(j,3))<=ftable2(i,2)*(1e-6)*4 && ...
                ftable2(i,7)-MS2table(j,2)<=RTwindow && MS2table(j,2)-ftable2(i,8)<=RTwindow
            stem(i,log10(ftable2(i,9)),'Color',color)
            hold on
            n=n+1;
            MS2tableMatch(n,:)=[3,MS2table(j,:),i,ftable2(i,11)];
        end
    end
end
axis([0 1100 5 9.5])


            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            