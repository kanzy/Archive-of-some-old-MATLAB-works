%%%aug13.m: for OpenMS found feature summary and further processing: The
%%%input is the .xls table converted from the .csv of OpenMS output (of
%%%found features).

Features=RNaseA1; %test of 2013-08-08 collecte data

figure
% Colors=flipdim(colormap(hot(101)),1);
Colors=colormap(jet(101));
maxInten=max(Features(:,3));
minInten=min(Features(:,3));
for i=1:size(Features,1)
    monoMZ=Features(i,2);
    CS=Features(i,4);
    RT=Features(i,9:10)/60;
    Inten=Features(i,3);
    currColor=Colors(1+ceil(100*log10(Inten/minInten)/log10(maxInten/minInten)),:);
    plot(RT,[monoMZ,monoMZ],'color',currColor)
    hold on
    text(RT(2),monoMZ,num2str(CS),'Color',currColor)
    hold on
end
xlabel('RT (minute)')
ylabel('M/Z')
    