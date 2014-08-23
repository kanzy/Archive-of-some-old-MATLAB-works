%%%similar to msdotplot()

figure

maxInten=0;
for i=1:max(size(Peaklist))
    scanPeaks=Peaklist{i};
    for j=1:size(scanPeaks,1)
        if scanPeaks(j,2)>maxInten
            maxInten=scanPeaks(j,2);
        end
    end
end

cutoff=0.01;

for i=1:size(Peaklist,2)
    time=Peaklist_TimeIndex(i);
    scanPeaks=Peaklist{i};
    for j=1:size(scanPeaks,1)
        if scanPeaks(j,2)>=cutoff*maxInten
        plot(scanPeaks(j,1),time)
        hold on
        end
    end
end