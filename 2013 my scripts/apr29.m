

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%adapted from lcmd_check.m:

disp(' ')
flag=input('The new(Apr29) mzXML data ("mzXMLStruct") is in the workspace now?(1=yes,0=no): ');
if flag~=1
    disp('Select .mzXML file of the LC-MS data...');
    [FileName,PathName] = uigetfile('*.mzXML','Select the mzXML file');
    mzXMLStruct = mzxmlread([PathName,FileName]); %function from MATLAB Bioinformatics Toolbox
end

%%%2013-04-08 added:
disp(' ')
flagPrecursor=input('Does this mzXMLStruct contain MS2 data and want to make the precursor (parent ion) list?(1=yes,0=no): ');
precursorListNew=[];
if flagPrecursor==1
    precursorRTwindow=30; %unit: seconds
    m=0;
    for i=1:mzXMLStruct.mzXML.msRun.scanCount
        if mzXMLStruct.scan(i).msLevel==2
            m=m+1;
            precursorListNew(m,1)=i;
            precursorListNew(m,2)=mzXMLStruct.scan(i).precursorMz.value;
            precursorListNew(m,3)=mzXMLStruct.scan(i).precursorMz.precursorIntensity;
            precursorListNew(m,4)=str2double(mzXMLStruct.scan(i).retentionTime(3:end-1));    %unit: second
        end
    end
end

clear mzXMLStruct

disp(' ')
flag=exist('Features','var');
if flag~=1
    disp('Now import saved LCMS_Result_afterCheck.mat of the dataset to be checked:')
    uiimport
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
else
    disp('The "Features" of the dataset to be checked is determined in workspace...')
    disp('(If not, terminate the program(Ctrl+Break) and clear workspace before restart LCMS.)')
end


disp(' ')
flag=exist('peptidesPool','var');
if flag~=1
    disp('Now import saved ExMS_preload.mat:')
    uiimport
    void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
end

disp(' ')
mzThreshold=input('Input m/z window (in ppm) used in the checking (e.g. 10): '); %ppm



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%adapted from lcmd_check_sparent.m:

disp(' ')
disp('For finding S-S peptides should be included in inlcusion list...')
peptideChargeMin=input('Input the minimum peptide charge(e.g. 1): ');
peptideChargeMax=input('Input the maximum peptide charge(e.g. 4): ');
mzDetectMin=input('Input the valid minimum m/z detect limit(e.g. 250): ');
mzDetectMax=input('Input the valid maximum m/z detect limit(e.g. 1900): ');
disp(' ')
RTrange=input('Also input the RT range (unit: minute) of the MS/MS experiments: (e.g. [0 30]) ');
featureRTwindow=input(' and input the RT window (unit: minute) for each feature/peptide: (e.g. 1) ');  

n=0;
msmsList=[];
for i=1:size(FeaturesTable,1)
    if FeaturesTable(i,14)==1
        MatchSSpep=Features{1,i}.MatchSSpep;
        scanSet=Features{1,i}.scanSet;
        for j=1:size(MatchSSpep,1)
            ssPep=MatchSSpep(j,:); %format: [pep1start, pep1end, pep2start, pep2end, pepFlag] for the first 5 columns
            [peptideMass, distND, maxND, maxD]=sspepinfo(currSeq, ssPep, 2); %call sspepinfo.m
            for pepCS=peptideChargeMin:peptideChargeMax
                monoMZ=peptideMass/pepCS+1.007276; %1.007276 is the mass of proton
                if monoMZ>mzDetectMin && monoMZ<mzDetectMax
                    for k=1:size(distND,2) %//this part as suggested by Palani 2010-08-05
                        if distND(k)>=0.67*max(distND) %0.67 is the height cutoff used
                            n=n+1;
                            msmsList(n,1)=monoMZ+(k-1)*1.00335/pepCS; %%1.00335 is the delta mass between C13(13.00335 u) and C12(12 u)
                            msmsList(n,2)=max(RTrange(1), Peaklist_TimeIndex(min(scanSet))/60-featureRTwindow);
                            msmsList(n,3)=min(RTrange(2), Peaklist_TimeIndex(max(scanSet))/60+featureRTwindow);
                        end
                    end
                end
            end
        end
    end
end
msmsList=sortrows(msmsList,1);

msmsList_old=msmsList;
msmsList=msmsList(1,:);
n=1;
for i=2:size(msmsList_old,1)
    if abs(msmsList_old(i,1)-msmsList_old(i-1,1))<=5e-4 %to merge very close m/z values (about 2.5 ppm window at m/z=200 and 0.25 ppm at 2000)
        msmsList(n,1)=mean([msmsList_old(i,1), msmsList_old(i-1,1)]);
        msmsList(n,2)=min(msmsList_old(i,2), msmsList_old(i-1,2));
        msmsList(n,3)=max(msmsList_old(i,3), msmsList_old(i-1,3));
    else
        n=n+1;
        msmsList(n,:)=msmsList_old(i,:);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msmsListMatchPrecursorListNew=cell(size(msmsList,1),1);
for i=1:size(msmsList,1)
    n=0;
    for j=1:size(precursorListNew,1)
        if abs(msmsList(i,1)-precursorListNew(j,2))<msmsList(i,1)*(1e-6)*mzThreshold && ...
                precursorListNew(j,4)>=msmsList(i,2)*60 && precursorListNew(j,4)<=msmsList(i,3)*60
            n=n+1;
            msmsList(i,4)=1;
            msmsListMatchPrecursorListNew{i,n}=precursorListNew(j,:);
        end
    end
end










