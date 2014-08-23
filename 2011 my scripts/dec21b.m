figure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,1)

Charge=1;
maxPlus=10;
monoMZ=0;
for i=0:1:maxPlus
stem(monoMZ+deltamass(i)/Charge, 1, 'ro')
hold on
end

stem(monoMZ+deltamass(-1)/Charge, 1, 'k*')
hold on

stem(monoMZ+deltamass(maxPlus+1)/Charge, 1, 'k*')
hold on

posC=zeros(1,Charge);
for i=0:(Charge-1)
    posC(i+1)=i/Charge; %assign peaks postions in [0,1) (i.e., 0, 1/Charge, 2/Charge, ... (Charge-1)/Charge)
end
interInten=0;
for d=(Charge+1):max(6,(Charge+1)) %consider potential disturbing peptide with charge state from (Charge+1) to 8
    for i=0:(Charge-1) %consider each peak postion in [0,1)
        posD=[];
        k=1;
        for j=-d:d
            pos=i/Charge+j/d; %start from position i/Charge
            ifOverlap=find(posC==pos);
            if pos>=0 && pos<1 && size(ifOverlap,2)==0 %non-overlap peak found
                posD(k)=pos;
                k=k+1;
            end
        end
        selectPositions=[];
        for m=0:ceil(maxPlus/Charge)-1 %include all [0,1) ranges
            if k>1
                for n=1:(k-1)
                    selectPositions=[selectPositions, monoMZ+deltamass(m+posD(n))];
                end
            end
        end
        if size(selectPositions,2)~=0; %make sure 'selectPositions' is not []
            stem(selectPositions, d*ones(size(selectPositions))/7, 'b*')
            hold on
        end
    end
end

axis([monoMZ+deltamass(-2)/Charge, monoMZ+deltamass(maxPlus+2)/Charge, 0, 1.2])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,2)
clear
disp('Import data for subplot 2 (-1 example 1 ...')
uiimport
void=input('Press "Enter" to continue...');

colors=cell(size(similarPeptides,1),1);
for i=1:size(similarPeptides,1)
    if i==1
        colors{i}='r';
    else
        colors{i}=[0 0.25*rem(i,5) 1-0.3*rem(i,4)];  %RGB color selection
    end
end
for i=1:1%size(similarPeptides,1)
    predictPeaks=ones((1+similarPeptides(i,5)+similarPeptides(i,6)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
    end
    stem(predictPeaks(:,1),predictPeaks(:,2)*max(YData)*(0.9-0.2*rem(i,5)),':','color',colors{i}, 'MarkerSize',5)
    text(730.63, max(YData)*(0.9-0.2*rem(i,5))*1.2, [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',10,'color',colors{i});
    hold on
end
stem(similarPeptides(1,4)+deltamass(-1)/similarPeptides(1,3),max(YData)*(0.9-0.2*rem(i,5)),':','k*', 'MarkerSize',5)
hold on

plot(XFitData, YFitData*max(YData)*0.95/max(YFitData),'m','LineWidth',1)
hold on

plot(XData,YData,'k','LineWidth',1)
hold on

ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])
axis([725.5,732,0,max(YData)*1.1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,3)
clear
disp('Import data for subplot 5 ...')
uiimport
void=input('Press "Enter" to continue...');

colors=cell(size(similarPeptides,1),1);
for i=1:size(similarPeptides,1)
    if i==1
        colors{i}='r';
    else
        colors{i}=[0 0.25*rem(i,5) 1-0.3*rem(i,4)];  %RGB color selection
    end
end
for i=1:1%size(similarPeptides,1)
    predictPeaks=ones((1+similarPeptides(i,5)+similarPeptides(i,6)),2);
    for j=1:size(predictPeaks,1)
        predictPeaks(j,1)=similarPeptides(i,4)+deltamass(j-1)/similarPeptides(i,3); %call deltamass.m 2010-09-03
    end
    stem(predictPeaks(:,1),predictPeaks(:,2)*max(YData)*(0.9-0.2*rem(i,5)),':','color',colors{i}, 'MarkerSize',5)
    text(997.5, max(YData)*(0.9-0.2*rem(i,5))*1.2, [num2str(similarPeptides(i,1)), '--', num2str(similarPeptides(i,2)),' +', num2str(similarPeptides(i,3))],'FontWeight','bold','FontSize',10,'color',colors{i});
    hold on
end
for i=1:(similarPeptides(1,5)+similarPeptides(1,6))
        stem(similarPeptides(1,4)+deltamass(i-1)/similarPeptides(1,3)+deltamass(1)/6,max(YData)*(0.9-0.2*rem(1,5))*0.7,':','b*', 'MarkerSize',5)
        hold on
        stem(similarPeptides(1,4)+deltamass(i-1)/similarPeptides(1,3)+deltamass(2)/6,max(YData)*(0.9-0.2*rem(1,5))*0.7,':','b*', 'MarkerSize',5)
        hold on
end


plot(XFitData, YFitData*max(YData)*0.9/max(YFitData),'m','LineWidth',1)
hold on

plot(XData,YData,'k','LineWidth',1)
hold on

xlabel('m/z')
% ylabel('Intensity')
v=axis;
axis([v(1),v(2),0,max(YData)*1.1])
axis([993.75,998.5,0,max(YData)*1.05])









