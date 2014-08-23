%%%2011-06-17 revision
%%%2011-01-28 msdfit.m: simplified functional version of nhx_simfit.m; working on D% level.

close all
clear fitSettings fitResults

disp(' ')
disp('**********************************************************************************')
disp(' ')
disp('MSDFIT: HX-MS Single Residue Information Analysis Programs in MATLAB')
disp(' ')
disp('Kan Zhongyuan, Englander Lab')
disp('University of Pennsylvania, 2011')
disp(' ')
disp('**********************************************************************************')

X=2; %exclude N-terminal 1 or 2 residues

disp(' ')
disp('MSDFIT fitting algorithm may work on three levels: ')
disp('1: Using peptide delta mass(centroid) info only')
disp('2: Using peptide isotopic peaks amplitude distribution info')
disp('3: Using peptide isotopic peaks amplitude and detailed lineshape info')

disp(' ')
fitLevel=input('Input the number of choice: ');
if fitLevel<1 || fitLevel>3
    error('Wrong input!')
end
fitSettings.fitLevel=fitLevel;

disp(' ')
AnalyType=2%input('Use experimental or simulated HX data as input?(1=exp,2=sim): ');
switch AnalyType
    case 1
        disp(' ')
        disp('This program need an ExMS style "finalTable" as input.')
        disp('Now import the ExMS_wholeResults_afterCheck.mat file containing the "finalTable": ')
        uiimport
        void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
        proSeq=currSeq;
        if fitLevel==3
            disp(' ')
            flag=input('Also need the original mzXML file for this dataset. Is it in workspace now?(1=yes,0=no): ');
            if flag~=1
                disp('Select the .mzXML file...');
                [FileName,PathName] = uigetfile('*.mzXML','Select the mzXML file');
                mzXMLStruct = mzxmlread([PathName,FileName]); %function from MATLAB Bioinformatics Toolbox
            end
        end
        
    case 2
        flag=1%input('Use a previously saved simulated data set? (1=yes,0=no) ');
        if flag==1
            disp('Now import the MSDFIT_SimInput.mat: ')
            uiimport
            void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
            proSeq=simSettings.proSeq;
            simDarray=simSettings.simDarray;
        else
            msdfit_siminput %call msdfit_siminput.m
        end
    otherwise
        error('Wrong input!')
end

%%%show available peptides (and resolution map) for analysis:
k=1;
goodPeps=[];
for i=1:size(finalTable,1)
    if finalTable(i,12)>=1
        goodPeps(k,:)=finalTable(i,1:3);
        k=k+1;
    end
end
disp(' ')
disp('See the resolution map of the available peptide set for analysis ...')
consolid_pool(goodPeps, 1, X); %call consolid_pool.m

%%%get 'useData' and 'usePeps':
disp(' ')
AnalyStart=1%input('Input the start residue number of analysis range: ');
AnalyEnd=25%input('Input the end residue number of analysis range: ');
pepNum=1;
useData={};
usePeps=[];
for i=1:size(finalTable,1)
    if finalTable(i,2)<=AnalyEnd && finalTable(i,1)+X>=AnalyStart && finalTable(i,12)>=1
        [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(finalTable(i,1):finalTable(i,2)), X); %call pepinfo.m
        deltaD=finalTable(i,10);
        useData{pepNum,1}=[finalTable(i,1:3), deltaD, finalTable(i,20:(20+maxND+maxD))];
        usePeps(pepNum,:)=finalTable(i,1:3);
        if fitLevel==3
            switch AnalyType
                case 1
                    msdfit_msdataextract %call msdfit_msdataextract.m
                    msdfit_msdataselect %call msdfit_msdataselect.m
                    useData{pepNum,2}=selectData;
                case 2
                    useData{pepNum,2}=simDataSet{i}; %from prep of msdfit_siminput
            end
        end
        pepNum=pepNum+1;
    end
end
if pepNum==1
    error('No data for the input analysis range!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp(['There will be total ',num2str(size(usePeps,1)),' peptides to be used for fitting (and to be plotted in result Fig.2)'])
rowNum=1; colNum=1;
if size(usePeps,1)>1
    n=0;
    while rowNum*colNum<size(usePeps,1) %check
        if n>0
            disp('rowNum*colNum must > pepNum! Input again:')
        end
        rowNum=4%input('How many peptides want to be plotted in a column? '); %ask here for later auto save
        colNum=4%input('How many peptides want to be plotted in a row? ');
        n=n+1;
    end
end

%%%set fitting condition:
disp(' ')
Algo=input('Input the number of fitting algorithm to be used (1=lsqnonlin; 2=patternsearch; 3=multistart; 4=globalsearch): ');
D00=0.5%input('Input the initial D% value for fitting (e.g., 0.5): ');
Dlb=0%input('Input the lower limit real D% value (e.g., 0): ');
Dub=1%input('Input the upper limit of D% value (e.g., 1): ');
fitSettings.Algo=Algo;
fitSettings.D00=D00;
fitSettings.Dlb=Dlb;
fitSettings.Dub=Dub;

disp(' ')
AnalyName=input('Give a name for this analysis: ','s');

%%%generate 'DIndex1', 'DIndex2' and 'D0':
consolidPool=consolid_pool(usePeps, 0, X); %call consolid_pool.m
M=0;
D0=[];
DIndex1=zeros(size(consolidPool,1),max(consolidPool(:,2)-consolidPool(:,1))+1);
for i=1:size(consolidPool,1)
    if consolidPool(i,1)==consolidPool(i,2)
        if proSeq(consolidPool(i,1))~='P'
            M=M+1;
            D0(M)=D00;
            DIndex1(M,1)=consolidPool(i,1);
        end
    else
        flagAllP=1;
        for j=consolidPool(i,1):consolidPool(i,2)
            if proSeq(j)~='P'
                flagAllP=0;
            end
        end
        if flagAllP==0
            M=M+1;
            D0(M)=D00;
            k=1;
            for j=consolidPool(i,1):consolidPool(i,2)
                if proSeq(j)~='P'
                    DIndex1(M,k)=j;
                    k=k+1;
                end
            end
        end
    end
end
M=0;
D0=[];
DIndex2=[];
for i=(min(usePeps(:,1))+X):max(usePeps(:,2))
    if proSeq(i)~='P'
        M=M+1;
        D0(M)=D00;
        DIndex2(M,1)=i;
    end
end
fitResults.DIndex1=DIndex1;
fitResults.DIndex2=DIndex2;

%%%Figure 1: peptides pool & fitting spots
h=figure;
DIndex=DIndex1;
DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
for i=1:size(DIndex,1)
    if DIndex(i,2)>0
        for j=1:size(DIndex,2)
            if DIndex(i,j)>0
                p1=[DIndex(i,j),DIndex(i,j)];
                p2=[0,size(usePeps,1)+1];
                plot(p1,p2,'m','LineWidth',1)
                hold on
            end
        end
    else
        p1=[DIndex(i,1),DIndex(i,1)];
        p2=[0,size(usePeps,1)+1];
        plot(p1,p2,'r','LineWidth',1)
        hold on
    end
end
for i=1:size(usePeps,1)
    p1=[usePeps(i,1),usePeps(i,2)]; % start and end aa# of each peptide
    p2=[i,i];
    plot(p1,p2,'b','LineWidth',2)
    hold on
end
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, 0, size(usePeps,1)+1])
xlabel('Residue Number')
ylabel('Peptide Index')
title('Peptide Set(blue) & Fitted Amide Hydrogens Sites(red & magenta)')
SaveFigureName=['(',AnalyName,')_MSDFIT_Fig1.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])
disp(' ')


%%%global fitting:
switch fitLevel
    case 1
        msdfit_lev1 %call msdfit_lev1.m
    case 2
        msdfit_lev2
    case 3
        msdfit_lev3
end


%%%Figure 3: initial/fitted PF plot & recovery plot
h=figure;
subplot(2,1,1)
if AnalyType==2
    for i=min(usePeps(:,1)):max(usePeps(:,2))
        if proSeq(i)~='P'
            stem(i, simDarray(i), 'MarkerSize', 8)
            hold on
        end
    end
    DiffNorm=0;
end
DIndex=DIndex1;
DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
for i=1:size(DIndex,1)
    n=0;
    A=[];
    B=[];
    p1=[];
    p2=[];
    if DIndex(i,2)>0
        Color='m';
    else
        Color='r';
    end
    for j=1:size(DIndex,2)
        if DIndex(i,j)>0
            stem(DIndex(i,j), D00, 'MarkerSize', 7, 'Marker','square')
            hold on
            [r,c]=find(DIndex2==DIndex(i,j));
            stem(DIndex(i,j), DFit(r), 'fill', 'color', Color, 'MarkerSize', 5, 'Marker','square')
            hold on
            if AnalyType==2
                A=[A, DFit(r)];
                B=[B, simDarray(DIndex(i,j))];
            end
            p1=[p1, DIndex(i,j)];
            p2=[p2, DFit(r)];
        end
    end
    if AnalyType==2
        A=sort(A);
        B=sort(B);
        DiffNorm=DiffNorm+sum((A-B).^2);
    end
    if min(size(p1))>0
        plot(p1,p2,'m:')
        hold on
    end
end
if AnalyType==2
    DiffNorm=DiffNorm/size(DFit,2);
    fitResults.DiffNorm=DiffNorm;
end
v=axis;
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
ylabel('D%')
if AnalyType==2
    title({'Fitting Result (blue cycle=real D%; blue square=fitting initial D%; red=fitted D%)'; ...
        ['DiffNorm=',num2str(DiffNorm)]})
else
    title('Fitting Result (blue=initial D%; red=fitted D%)')
end

subplot(2,1,2)
for i=1:size(usePeps,1)
    recovD=recovd(useData{i,1}(1,5:end), usePeps(i,1), usePeps(i,2), proSeq, X); %call recovd.m
    p1=[usePeps(i,1),usePeps(i,2)]; % start and end aa# of each peptide
    p2=[recovD,recovD];
    plot(p1,p2,'b','LineWidth',2)
    hold on
end
v=axis;
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
xlabel('Residue Number')
ylabel('D%')
title('Deuterons Recovery of Peptide Set')
SaveFigureName=['(',AnalyName,')_','MSDFIT_Fig3.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])


%%%Save above result:
SaveFileName=['(',AnalyName,')_MSDFIT.mat'];
if AnalyType==2
    save(SaveFileName,'simSettings','fitSettings','AnalyName','AnalyType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults')
else
    save(SaveFileName,'fitSettings','AnalyName','AnalyType','proSeq','AnalyStart','AnalyEnd','usePeps','useData','fitResults')
end
disp(' ')
disp([SaveFileName,' has been saved in MATLAB current directory!'])

% disp(' ')
% disp(['There are ', num2str(size(DFit,2)), ' fitted residues.'])
% disp(['Average used peptide number per fitted residue is: ', num2str(size(usePeps,1)/size(DFit,2))]);
% disp(['Average used data number per fitted residue is: ', num2str(resSumNum/size(DFit,2))]);
% disp(['resNorm=',num2str(resNorm)])
% if AnalyType==2
%     disp(['DiffNorm=',num2str(DiffNorm)])
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
flag=0%input('Want to run "singlex.m" to calculate "kex" and "pf"? (1=yes,0=no) ');
if flag==0
    disp(' ')
    disp('Program over.')
    return
end

clear hxPara
hxPara.D0=input('Input intial D% (0~1) of the HX process: ');
hxPara.time=input('Input the HX time (sec): ');
hxPara.temp=input('Input the HX temperature (C): ');
hxPara.pH=input('Input pH value in the HX solution: ');
hxPara.hxDir=input('Input the HX direction (1: H->D; 2: D->H): ');

[kchPro, kex, pf] = singlex(DFit, DIndex2', proSeq, hxPara); %call singlex.m

SaveFileName=['(',AnalyName,')_MSDFIT_singlex.mat'];
save(SaveFileName,'proSeq','hxPara','DFit','kchPro','kex','pf')

h=figure;
DIndex=DIndex1;
DIndex=[DIndex, zeros(size(DIndex,1),1)]; %2010-12-02 added
for i=1:size(DIndex,1)
    n=0;
    p1=[];
    p2=[];
    if DIndex(i,2)>0
        Color='m';
    else
        Color='r';
    end
    for j=1:size(DIndex,2)
        if DIndex(i,j)>0
            stem(DIndex(i,j), log10(kchPro(DIndex(i,j))), 'k','MarkerSize', 7, 'Marker','square')
            hold on
            [r,c]=find(DIndex2==DIndex(i,j));
            stem(DIndex(i,j), log10(kex(r)), 'fill', 'color', Color, 'MarkerSize', 5, 'Marker','square')
            hold on
            text(DIndex(i,j), log10(kchPro(DIndex(i,j)))*1.05, proSeq(DIndex(i,j)))
            hold on
            p1=[p1, DIndex(i,j)];
            p2=[p2, log10(kex(r))];
        end
    end
    if min(size(p1))>0
        plot(p1,p2,'m:')
        hold on
    end
end
v=axis;
axis([min(usePeps(:,1))-0.5, max(usePeps(:,2))+0.5, v(3), v(4)])
xlabel('Residue Number')
ylabel('log_1_0(k)')
if hxPara.hxDir==1
    string1='Calculated Hyrogen Exchange Rates (H->D)';
else
    string1='Calculated Hyrogen Exchange Rates (D->H)';
end
title({string1; ...
    ['based on Temperature=',num2str(hxPara.temp),' C; pH=',num2str(hxPara.pH),'; HX Time=',num2str(hxPara.time),' (sec); D0=',num2str(hxPara.D0)]; ...
    '(black: intrinsic rate; red/magenta: exchange rate)';})

SaveFigureName=['(',AnalyName,')_','MSDFIT_singlex.fig'];
saveas(figure(h),SaveFigureName)
disp(' ')
disp([SaveFigureName,' has been saved in MATLAB current directory!'])

disp(' ')
disp('Program over.')






