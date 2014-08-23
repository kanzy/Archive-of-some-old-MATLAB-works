global mzXMLStruct

SaveFileName='LCMS.mat';

mzThreshold=input('Input m/z window (in ppm) for peak selection (e.g. 10): '); %ppm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Manual check the identified features:

flag=input('The mzXML data ("mzXMLStruct") is in the workspace now?(1=yes,0=no)');
if flag~=1
    disp('Select .mzXML file of the LC-MS data...');
    [FileName,PathName] = uigetfile('*.mzXML','Select the mzXML file');
    mzXMLStruct = mzxmlread([PathName,FileName]); %function from MATLAB Bioinformatics Toolbox
end

disp(' ')
flagPool=input('Have a reference peptide pool file (...exms_preload.mat)? (1=yes,0=no) ');
if flagPool==1
    disp('Import it now...')
    uiimport
    void=input('Press "Enter" to continue...');
end

FeaturesCheck=cell(1,size(Features,2));
for currFeatureNum=1:size(FeaturesCheck,2)
    disp(['Now analyzing Feature #', num2str(currFeatureNum), ' ...'])
    h=figure;
    
    scanSet=Features{currFeatureNum}.scanSet;
    mzSet=Features{currFeatureNum}.mzSet;
    CS=Features{currFeatureNum}.CS;
    averagineDist=Features{currFeatureNum}.averagineDist;
    
    clear scansSubData
    scansSubData = lcms_msdataextract([Peaklist_ScanIndex(min(scanSet)),Peaklist_ScanIndex(max(scanSet))], [min(mzSet)-2,max(mzSet)+2]);
    
    averagineDist=averagineDist(:,2)*max(scansSubData(:,2))/max(averagineDist(:,2));
    mzSet=Features{currFeatureNum}.mzSet;
    for i=1:size(mzSet,2)
        stem(mzSet(i),averagineDist(i),'b:')
        hold on
    end
    text(mzSet(end), max(scansSubData(:,2)), 'Averagine', 'FontWeight','bold','color','b')
    
    matchPep=[];
    if flagPool==1
        n=0;
        for i=1:size(peptidesPool,1)
            if peptidesPool(i,3)==CS && abs(mzSet(1)-peptidesPool(i,4))<peptidesPool(i,4)*(1e-6)*mzThreshold
                n=n+1;
                distND=peptidesPool_distND{i};
                for j=1:size(distND,2)
                    stem(peptidesPool(i,4)+(j-1)*1.003355/CS, distND(j)*(1-0.1*n)*max(scansSubData(:,2))/max(distND),'r:')
                    hold on
                end
                text(peptidesPool(i,4)+(j-1)*1.003355/CS, (1-0.1*n)*max(scansSubData(:,2)), ['Match ',num2str(peptidesPool(i,1)),'--',num2str(peptidesPool(i,2)),'+',num2str(CS)], 'FontWeight','bold','color','r')
                matchPep=[matchPep; peptidesPool(i,:)];
            end
        end
    end
    
    plot(scansSubData(:,1),scansSubData(:,2),'k','LineWidth',1)
    hold on
    axis([min(mzSet)-2 max(mzSet)+2 0 max(scansSubData(:,2))*1.1]);
    xlabel('m/z');
    ylabel('Average Original Intensity');   %for scansSubData
    title({['Feature # ',num2str(currFeatureNum)];...
        ['Scan Range: ',num2str(Peaklist_ScanIndex(min(scanSet))),' -- ',num2str(Peaklist_ScanIndex(max(scanSet))),...
        ';  RT Range: ',num2str(Peaklist_TimeIndex(min(scanSet))/60, '%4.2f'),' -- ',num2str(Peaklist_TimeIndex(max(scanSet))/60),' (min)']})
    
    %%%manual judging:
    FeaturesCheck{currFeatureNum}.matchPep=matchPep;
    FeaturesCheck{currFeatureNum}.judge=input('Is this a correct peptide feature? (0=totally wrong, 1=yes, 2=no but peptide-like, 3=not sure): ');
    
    if FeaturesCheck{currFeatureNum}.judge==3
        disp('To help judge, assigned peaks now are labeled in figure.');
        for i=scanSet(1):scanSet(end)
            scanPeaks=Peaklist{i};
            for j=1:size(scanPeaks,1)
                if scanPeaks(j,3)~=0 && scanPeaks(j,1)>=min(mzSet)-2 && scanPeaks(j,1)<=max(mzSet)+2
                    if scanPeaks(j,3)==-1
                        plot(scanPeaks(j,1),0,'rx')
                    else
                        plot(scanPeaks(j,1),0,'mx')
                    end
                    hold on
                end
            end
        end
        FeaturesCheck{currFeatureNum}.judge=input('Is this a correct peptide feature? (0=totally wrong or still not sure, 1=yes, 2=no but peptide-like): ');
    end
    
    %%%save above figure:
    SaveFigureName=['LCMS_Feature#',num2str(currFeatureNum),'.fig'];
    saveas(h,SaveFigureName)
    
    close all
end

%%%plot feature box on msdotplot:
h=msdotplot(Peaklist,Peaklist_TimeIndex,'Quantile',0.9); %call msdotplot()
n1=0;
n2=0;
for currFeatureNum=1:size(Features,2)
    mzSet=Features{currFeatureNum}.mzSet;
    scanSet=Features{currFeatureNum}.scanSet;
    switch FeaturesCheck{currFeatureNum}.judge
        case 1
            color='r';
            n1=n1+1;
        case 2
            color='m';
            n2=n2+1;
        case 0
            color='y';
    end
    hold on
    plot([mzSet(1),mzSet(end)],[Peaklist_TimeIndex(scanSet(1)),Peaklist_TimeIndex(scanSet(1))],color)
    hold on
    plot([mzSet(1),mzSet(end)],[Peaklist_TimeIndex(scanSet(end)),Peaklist_TimeIndex(scanSet(end))],color)
    hold on
    plot([mzSet(1),mzSet(1)],[Peaklist_TimeIndex(scanSet(1)),Peaklist_TimeIndex(scanSet(end))],color)
    hold on
    plot([mzSet(end),mzSet(end)],[Peaklist_TimeIndex(scanSet(1)),Peaklist_TimeIndex(scanSet(end))],color)
    hold on
    text(mzSet(1), Peaklist_TimeIndex(scanSet(end))+1, num2str(currFeatureNum),'Color',color)
    
end
SaveFigureName='LCMS_Features 2D Plot.fig';
saveas(h,SaveFigureName)
disp(['There are ',num2str(n1),' (',num2str(100*n1/size(Features,2),'%4.2f'),'%) features manually checked as correct.'])
disp(['There are ',num2str(n2),' (',num2str(100*n2/size(Features,2),'%4.2f'),'%) features manually checked as incorrect but peptide-like.'])

%%%get 'foundPep' and calculate coverage over peptide pool:
if flagPool==1
    foundPep=[];
    for i=1:size(FeaturesCheck,2)
        matchPep=FeaturesCheck{i}.matchPep;
        if min(size(matchPep))~=0
            foundPep=[foundPep; matchPep];
        end
    end
    foundPep=sortrows(foundPep);
    peptidesPool=[peptidesPool zeros(size(peptidesPool,1),1)];
    n=0;
    for i=1:size(peptidesPool,1)
        for j=1:size(foundPep,1)
            if peptidesPool(i,1)==foundPep(j,1) && peptidesPool(i,2)==foundPep(j,2) && peptidesPool(i,3)==foundPep(j,3)
                peptidesPool(i,end)=peptidesPool(i,end)+1;
            end
        end
        if peptidesPool(i,end)>0
            n=n+1;
        end
    end
    foundPepCoverage=n/size(peptidesPool,1);
end


%%%final save:
SaveFileName='LCMS.mat';
if flagPool==1
    save(SaveFileName,'Peaklist','Peaklist_TimeIndex','Peaklist_ScanIndex','mzThreshold','Features','FeaturesCheck',...
        'peptidesPool','foundPep','foundPepCoverage')
else
    save(SaveFileName,'Peaklist','Peaklist_TimeIndex','Peaklist_ScanIndex','mzThreshold','Features','FeaturesCheck')
end
disp(' ')
disp([SaveFileName,' and all the figures have been saved in MATLAB current folder!'])










