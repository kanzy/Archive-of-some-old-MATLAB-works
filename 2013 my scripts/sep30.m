

n=0;
pepSet1=[];
for i=1:size(finalTable1,1)
    if finalTable1(i,12)>=0.5
        n=n+1;
        pepSet1(n,1:4)=[finalTable1(i,1:3), log10(sum(finalTable1(i,20:end)))];
    end
end


n=0;
pepSet2=[];
for i=1:size(finalTable2,1)
    if finalTable2(i,12)>=0.5
        n=n+1;
        pepSet2(n,1:4)=[finalTable2(i,1:3), log10(sum(finalTable2(i,20:end)))];
    end
end

%%%plot pepSet1:
figure

N=23;

Colors=colormap(hot(N));
%Colors=colormap(gray(N));

maxInten=max(max(pepSet1(:,4), max(pepSet2(:,4))));
minInten=4;

subplot(2,1,1)
for i=1:size(pepSet1,1)
    p1=[pepSet1(i,1),pepSet1(i,2)]; % start and end aa# of each peptide
    p2=[i,i];
    if pepSet1(i,4)~=-Inf
        currColor=Colors(round((3-N)*(pepSet1(i,4)-minInten)/(maxInten-minInten)+N-2), :);
    else
        currColor=Colors(N-1,:);
    end
    plot(p1,p2,'color',currColor,'LineWidth',1)
    hold on
end

subplot(2,1,2)
for i=1:size(pepSet2,1)
    p1=[pepSet2(i,1),pepSet2(i,2)]; % start and end aa# of each peptide
    p2=[i,i];
    currColor=Colors(round((3-N)*(pepSet2(i,4)-minInten)/(maxInten-minInten)+N-2), :);
    plot(p1,p2,'color',currColor,'LineWidth',1)
    hold on
end








