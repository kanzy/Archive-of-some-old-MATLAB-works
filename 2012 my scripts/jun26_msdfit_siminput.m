%%%2011-06-21 revision
%%%2011-01-28 msdfit_siminput.m: generate simulated "finalTable" for msdfit.m use; ref to dec02.m & nov30.m.

clear simSettings

disp(' ')
disp('*************************************')
disp('Start of Simulation Subroutine...')
disp(' ')

%%%first get 'currSeq': copied from exms_preload.m
[headers, sequences] = readfasta('ExMS sequences(Jun26mod).fasta'); %call readfast.m
disp('Proteins already in list(ExMS sequences.fasta): ')
for i=1:size(headers,2)
    disp(headers{i}(2:end))
end
disp(' ')
proteinName='SNase' %input('Input the name of your protein (may not in list): ','s');
flag=0;
for i=1:size(headers,2)
    if strcmp(proteinName, headers{i}(2:end))==1
        proSeq=sequences{i}
        flag=1;
    end
end
if flag==0
    disp('Unknown protein!');
    proSeq=input('Input the sequence of your protein (one row & in capital): ','s')
end
clear headers sequences
simSettings.proteinName=proteinName;
simSettings.proSeq=proSeq;

disp(' ')
SimStart=1 %input('Input the start residue number of simulation range of the protein: ');
SimEnd %=input('Input the end residue number of simulation range of the protein: ');
if SimStart>=SimEnd || SimStart<1 || SimEnd>size(proSeq,2)
    error('Wrong input!')
end
N=SimEnd-SimStart+1;
simSettings.SimStart=SimStart;
simSettings.SimEnd=SimEnd;

%%%generate D% array
disp(' ')
disp(['This simulation region of the protein has total ',num2str(N),' residues.'])
howMakeD=2 %input('How to simulate D% for each residue? (1=by manual input; 2=by random number; 3=use previously saved): ');
switch howMakeD
    case 1
        inputD=input(['Input D% array of all the residues (e.g. 0.5*ones(1,',num2str(N),') or [0.1,0.2,...]): ']);
        while size(inputD,2)~=N
            disp('Wrong input! Do it again:')
            inputD=input(['Input D% array of all the residues (e.g. 0.5*ones(1,',num2str(N),') or [0.1,0.2,...]): ']);
        end
        simDarray=NaN*ones(1,size(proSeq,2)); %initialize
        simDarray(SimStart:SimEnd)=inputD;
    case 2
        simDarray=NaN*ones(1,size(proSeq,2)); %initialize
        simDarray(SimStart:SimEnd)=rand(1,N); %artificial D% array for each residue
    case 3
        disp('Now import the previous MSDFIT_simDarray.mat: ')
        uiimport
        void=input('Press "Enter" to continue...'); %just waiting for uiimport complete
        if size(simDarray,2)~=size(proSeq,2)
            error('Size not match!')
        end
    otherwise
        error('Wrong input!')
end
disp(' ')
disp('Checking D% at Proline residues...')
for i=SimStart:SimEnd
    if proSeq(i)=='P'
        disp(['Residue #',num2str(i),' is Proline, D% at this position is reset to 0!'])
        simDarray(i)=0;
    end
end
disp('Done! "simDarray" has been generated.')
simSettings.simDarray=simDarray;

disp(' ')
disp('Next, to simulate peptide set data for analysis...')
disp('The available ways are:')
disp(' ')
disp('1: Ideal set (full overlapping with single residue overhang)')
disp('2: Less ideal set (multiple residue overhang, multiple set)')
disp('3: Even Less ideal set (multiple residue overhang, single set)')
disp('4: Common (N-terminal) end set')
disp('5: Random set')
disp('6: Single peptide (will span the whole simulation range)')
disp(' ')
overlapType=6 %input('Input the number of choice: ');
simSettings.overlapType=overlapType;

disp(' ')
SNratio=300 %input('Want to add random noise on data points amplitude? (input 0=no; x=S/N ratio): ');
simSettings.SNratio=SNratio;

switch overlapType
    case 1
        disp(' ')
        L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
        START=max(1, SimStart-XN);
        END=SimEnd-L+1;
        while START>END
            disp('Wrong input! Do it again:')
            L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
        end
        n=1;
        finalTable=[];
        for i=START:END
            finalTable(n,1)=i;
            finalTable(n,2)=i+L-1;
            finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
            finalTable(n,10)=sum(simDarray((i+XN):finalTable(n,2))); %delta mass
            finalTable(n,12)=1;
            n=n+1;
        end
        
    case 2
        disp(' ')
        L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
        M=input('Input the uniform overhang length (in amino acid, e.g. 3): ');
        START=max(1, SimStart-XN);
        END=SimEnd-L+1;
        while START>END
            disp('Wrong input! Do it again:')
            L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
        end
        n=1;
        finalTable=[];
        for i=START:M:END
            finalTable(n,1)=i;
            finalTable(n,2)=i+L-1;
            finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
            finalTable(n,10)=sum(simDarray((i+XN):finalTable(n,2))); %delta mass
            finalTable(n,12)=1;
            n=n+1;
        end
        
        n2=n-1;
        for i=1:(n2-1)
            finalTable(n,1)=finalTable(i,1);
            finalTable(n,2)=finalTable(i+1,2);
            finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
            finalTable(n,10)=sum(simDarray((finalTable(n,1)+XN):finalTable(n,2))); %delta mass
            finalTable(n,12)=1;
            n=n+1;
        end
        
        for i=1:(n2-2)
            finalTable(n,1)=finalTable(i,1);
            finalTable(n,2)=finalTable(i+2,2);
            finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
            finalTable(n,10)=sum(simDarray((finalTable(n,1)+XN):finalTable(n,2))); %delta mass
            finalTable(n,12)=1;
            n=n+1;
        end
        
    case 3
        disp(' ')
        L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
        M=input('Input the uniform overhang length (in amino acid, e.g. 3): ');
        START=max(1, SimStart-XN);
        END=SimEnd-L+1;
        while START>END
            disp('Wrong input! Do it again:')
            L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
        end
        n=1;
        finalTable=[];
        for i=START:M:END
            finalTable(n,1)=i;
            finalTable(n,2)=i+L-1;
            finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
            finalTable(n,10)=sum(simDarray((i+XN):finalTable(n,2))); %delta mass
            finalTable(n,12)=1;
            n=n+1;
        end
        
    case 4
        disp(' ')
        L=input('Input shortest peptide length (in amino acid, e.g. 5): ');
        M=input('Input the uniform overhang length (in amino acid, 1 or >1): ');
        START=max(1, SimStart-XN);
        END=SimEnd;
        n=1;
        finalTable=[];
        for i=START:END
            if START+L-1+(n-1)*M<=END
                finalTable(n,1)=START;
                finalTable(n,2)=START+L-1+(n-1)*M;
                finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
                finalTable(n,10)=sum(simDarray((START+XN):finalTable(n,2))); %delta mass
                finalTable(n,12)=1;
                n=n+1;
            end
        end
        
    case 5
        disp(' ')
        Lmin=input('Input shortest peptide length (in amino acid, e.g. 4): ');
        Lmax=input('Input longest peptide length (in amino acid, e.g. 30): ');
        if Lmax>N
            disp(['Set too long! Auto reset to ',num2str(N)])
            Lmax=N;
        end
        M=input('How many peptides want to generate? ');
        Rand=rand(M,2);
        finalTable=[];
        for i=1:M
            L=ceil(Rand(i,1)*(Lmax-Lmin)+Lmin);
            START=ceil(Rand(i,2)*(SimEnd-L-SimStart+XN)+(SimStart-XN));
            finalTable(i,1)=max(1, START);
            finalTable(i,2)=min(START+L-1, SimEnd);
            finalTable(i,3)=msdfit_siminput_cs(finalTable(i,1), finalTable(i,2));
            finalTable(i,10)=sum(simDarray((START+XN):finalTable(i,2))); %delta mass
            finalTable(i,12)=1;
        end
        finalTable=sortrows(finalTable);
        
    case 6
        finalTable=[];
        START=max(1, SimStart-XN);
        finalTable(1,1)=START;
        finalTable(1,2)=SimEnd;
        finalTable(1,3)=msdfit_siminput_cs(finalTable(1,1), finalTable(1,2));
        finalTable(1,10)=sum(simDarray((START+XN):SimEnd));
        finalTable(1,12)=1;
        
    otherwise
        error('Wrong input of "overlapType"!')
end

%%%simulate peptides' envelope (fill "finalTable_ideal" column 20+): 2011-06-29 revised
finalTable_ideal=finalTable;
for pepNum=1:size(finalTable,1)
    START=finalTable(pepNum,1); %Start residue# of the peptide
    END=finalTable(pepNum,2); %End residue# of the peptide
    [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), XN); %call pepinfo.m
    finalTable(pepNum,4)=peptideMass/finalTable(pepNum,3)+1.007276; %m/z of mono; 1.007276 is the mass of proton;
    finalTable_ideal(pepNum,4)=finalTable(pepNum,4);
    Distr=1;
    for i=(START+XN):END
        if proSeq(i)~='P'
            Distr=conv(Distr, [1-simDarray(i), simDarray(i)]);
        end
    end
    obsDistr=conv(distND, Distr);
    finalTable_ideal(pepNum,20:19+max(size(obsDistr)))=obsDistr/sum(obsDistr); %normalization
end

%%%also prepare 'simDataSet':
disp(' ')
simResolutionBase=1e5 %input('Input simulating mass resolution at m/z 400 (e.g. 6e4): ');
sampleInterv=3e-3 %input('Input m/z data point sampling interval (e.g. 0.001): ');
simDataSet=cell(size(finalTable,1),1);
for pepNum=1:size(finalTable,1)
    START=finalTable(pepNum,1);
    END=finalTable(pepNum,2);
    Charge=finalTable(pepNum,3);
    monoMZ=finalTable(pepNum,4);
    pepSeq=proSeq(START:END);
    [peptideMass, distND, maxND, maxD]=pepinfo(proSeq(START:END), XN); %call pepinfo.m
    pepDarray=simDarray(START+XN:END);
    simMZ=floor(monoMZ-1):sampleInterv:ceil(monoMZ+(maxND+maxD)/Charge+1);
%     for i=2:size(simMZ,2)
%         simMZ(i)=simMZ(i-1)+sampleInterv*(1+0.2*(rand-0.5)); %make unevenly m/z spacing
%     end
    simResolution=simResolutionBase*(400/monoMZ).^0.5; %just for Orbitrap data: the resolution decreases with square root of mass (FT-ICR MS resolution decreases linearly with mass; TOF diff ...)
    clear msData
    [simPeaks, msData] = pepsim(pepSeq, Charge, [zeros(1,XN) pepDarray], XN, simMZ, simResolution, 0); %call pepsim.m
    if SNratio>0
        msData_origin=msData;
        msData(:,2)=msData(:,2)+(max(msData(:,2))/SNratio)*(rand(size(msData,1),1)-0.5); %add random noise
    end
    
    fillType=3; %same meaning as in exms_whole_check_common.m
    switch fillType
        case 2
            msdfit_msdataselect %call msdfit_msdataselect.m
        case 3
            jun26_msdfit_msdataselect2 %call msdfit_msdataselect2.m 2011-07-13 changed
    end

    finalTable(pepNum,20:(20+maxND+maxD))=selectDataInt; %2011-06-30 added
    simDataSet{pepNum}=selectData;
    
    finalTable(pepNum,10)=centroid([(0:maxND+maxD)',selectDataInt'])-centroid([(0:maxND)',distND']); %2011-07-14 added
    
    if pepNum==2 && size(finalTable,1)>10
        disp(' ')
        disp('Generating simulated MS data... Please Wait!')
    end
end
disp(' ')
disp('All done!')
simSettings.simResolutionBase=simResolutionBase;
simSettings.sampleInterv=sampleInterv;

% %%%Save above result:
% disp(' ')
% SimName=input('Give a name for this simulation: ','s');
% SaveFileName=['(',SimName,')_MSDFIT_SimInput.mat'];
% save(SaveFileName,'simSettings','finalTable','finalTable_ideal','simDataSet')
% disp(' ')
% disp([SaveFileName,' has been saved in MATLAB current directory!'])
% if howMakeD~=3
%     SaveFileName=['(',SimName,')_MSDFIT_simDarray.mat'];
%     save(SaveFileName,'simDarray')
%     disp(' ')
%     disp([SaveFileName,' has also been saved in MATLAB current directory!'])
% end

disp(' ')
disp('End of Simulation Subroutine.')
disp('*************************************')
disp(' ')













