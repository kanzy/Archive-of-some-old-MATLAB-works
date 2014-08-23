%%%2011-06-21 revision
%%%2011-01-28 msdfit_siminput.m: generate simulated "finalTable" for msdfit.m use; ref to dec02.m & nov30.m.
% BenIn=[0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.300000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.500000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.600000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.700000000000000,0.100000000000000;0.100000000000000,0.400000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.200000000000000,0.400000000000000,0.400000000000000,0.500000000000000,0.400000000000000,0.600000000000000,0.200000000000000;0.100000000000000,0.600000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.300000000000000,0.300000000000000,0.600000000000000,0.400000000000000,0.500000000000000,0.500000000000000,0.300000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.400000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.700000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.700000000000000,0.100000000000000,0.500000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.700000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.700000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.700000000000000,0.100000000000000,0.500000000000000,0.400000000000000,0.800000000000000,0.600000000000000,0.700000000000000,0.800000000000000,0.500000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.400000000000000;0.100000000000000,0.600000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.300000000000000,0.400000000000000,0.600000000000000,0.600000000000000,0.500000000000000,0.800000000000000,0.300000000000000;0.100000000000000,0.400000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.200000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.200000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.400000000000000,0.800000000000000,0.600000000000000,0.800000000000000,0.800000000000000,0.800000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.400000000000000,0.800000000000000,0.600000000000000,0.800000000000000,0.800000000000000,0.800000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.400000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.200000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.200000000000000;0.100000000000000,0.600000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.400000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.400000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.700000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.700000000000000,0.100000000000000,0.600000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.100000000000000,0.800000000000000,0.400000000000000,0.800000000000000,0.600000000000000,0.800000000000000,0.800000000000000,0.800000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.700000000000000,0.100000000000000,0.600000000000000,0.500000000000000,0.800000000000000,0.700000000000000,0.700000000000000,0.800000000000000,0.600000000000000;0.100000000000000,0.800000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.400000000000000,0.400000000000000,0.800000000000000,0.600000000000000,0.600000000000000,0.800000000000000,0.400000000000000;0.100000000000000,0.600000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.600000000000000,0.100000000000000,0.500000000000000,0.100000000000000,0.400000000000000;0.100000000000000,0.400000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.200000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.400000000000000,0.100000000000000,0.200000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000,0.100000000000000;0,0,0,0,0,0,0,0,0,0,0,0;];

BenIn=[0.100000000000000,0.800000000000000;0.0500000000000000,0.600000000000000;0.150000000000000,0.700000000000000;0.100000000000000,0.800000000000000;0.0500000000000000,0.750000000000000;0.0500000000000000,0.850000000000000;0.100000000000000,0.800000000000000;0.100000000000000,0.800000000000000;0.100000000000000,0.700000000000000;0.500000000000000,0.750000000000000;0.150000000000000,0.700000000000000;0.100000000000000,0.600000000000000;0.0500000000000000,0.800000000000000;0.0500000000000000,0.750000000000000;0.100000000000000,0.800000000000000;0.100000000000000,0.750000000000000;0.150000000000000,0.850000000000000;0.200000000000000,0.750000000000000;0.0100000000000000,0.800000000000000;0,0.700000000000000;0,0.600000000000000;0,0.700000000000000;0,0.800000000000000;0,0.700000000000000;0.0500000000000000,0.800000000000000;0.200000000000000,0.850000000000000;0.0500000000000000,0.600000000000000;0.100000000000000,0.800000000000000;0.150000000000000,0.750000000000000;0.200000000000000,0.750000000000000;0.500000000000000,0.700000000000000;0,0.600000000000000;0.150000000000000,0.750000000000000;0.300000000000000,0.800000000000000;0.200000000000000,0.700000000000000;0.0500000000000000,0.850000000000000;0.200000000000000,0.800000000000000;0.100000000000000,0.600000000000000;0.0500000000000000,0.700000000000000;0,0;];

XN=2

disp(' ')
disp('*************************************')
disp('Start of Simulation Subroutine...')
disp(' ')

%%%first get 'currSeq': copied from exms_preload.m
[headers, sequences] = readfasta('ExMS sequences.fasta'); %call readfast.m
disp('Proteins already in list(ExMS sequences.fasta): ')
for i=1:size(headers,2)
    disp(headers{i}(2:end))
end
disp(' ')
proteinName='MBP' %input('Input the name of your protein (may not in list): ','s');
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
SimEnd=40 %input('Input the end residue number of simulation range of the protein: ');
if SimStart>=SimEnd || SimStart<1 || SimEnd>size(proSeq,2)
    error('Wrong input!')
end
N=SimEnd-SimStart+1;
simSettings.SimStart=SimStart;
simSettings.SimEnd=SimEnd;

%%%generate D% array
disp(' ')
disp(['This simulation region of the protein has total ',num2str(N),' residues.'])


M=11 %input('How many peptides want to generate? ');
% Rand=rand(M,2);
Rand=[0.817303220653433,0.136068558708664;0.868694705363510,0.869292207640089;0.0844358455109103,0.579704587365570;0.399782649098897,0.549860201836332;0.259870402850654,0.144954798223727;0.800068480224308,0.853031117721894;0.431413827463545,0.622055131485066;0.910647594429523,0.350952380892271;0.181847028302853,0.513249539867053;0.263802916521990,0.401808033751942;0.145538980384717,0.0759666916908419;];


disp(' ')
for simPop=1:2
    if simPop==1
        disp('Now simulate the 1st sub-population (lighter) ...')
    else
        disp('Now simulate the 2nd sub-population (heavier) ...')
    end

disp(' ')
    
howMakeD=1 %input('How to simulate D% for each residue? (1=by manual input; 2=by random number; 3=use previously saved): ');
switch howMakeD
    case 1
        %inputD=input(['Input D% array of all the residues (e.g. 0.5*ones(1,',num2str(N),') or [0.1,0.2,...]): ']);
        if simPop==1
            inputD=BenIn(:,1)'
        else
            inputD=BenIn(:,2)'
        end
        
        
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
overlapType=1 %input('Input the number of choice: ');
simSettings.overlapType=overlapType;

disp(' ')
SNratio=-1 %input('Want to add random noise on data points amplitude? (input 0=no; x=S/N ratio; -1=add for Orbitrap data): ');
simSettings.SNratio=SNratio;

switch overlapType
    case 1
        disp(' ')
        L=12 %input('Input uniform peptide length (in amino acid, e.g. 10): ');
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
        
        %%%2012-10-22 adding case 5
        disp(' ')
        Lmin=7 %input('Input shortest peptide length (in amino acid, e.g. 4): ');
        Lmax=14 %input('Input longest peptide length (in amino acid, e.g. 30): ');
        if Lmax>N
            disp(['Set too long! Auto reset to ',num2str(N)])
            Lmax=N;
        end
%         M=11 %input('How many peptides want to generate? ');
%         Rand=rand(M,2);
        n=n-1;
        for i=1:M
            L=ceil(Rand(i,1)*(Lmax-Lmin)+Lmin);
            START=ceil(Rand(i,2)*(SimEnd-L-SimStart+XN)+(SimStart-XN));
            finalTable(i+n,1)=max(1, START);
            finalTable(i+n,2)=min(START+L-1, SimEnd);
            finalTable(i+n,3)=msdfit_siminput_cs(finalTable(i+n,1), finalTable(i+n,2));
            finalTable(i+n,10)=sum(simDarray((START+XN):finalTable(i+n,2))); %delta mass
            finalTable(i+n,12)=1;
        end
        finalTable=sortrows(finalTable);
        
            
%     case 2
%         disp(' ')
%         L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
%         M=input('Input the uniform overhang length (in amino acid, e.g. 3): ');
%         START=max(1, SimStart-XN);
%         END=SimEnd-L+1;
%         while START>END
%             disp('Wrong input! Do it again:')
%             L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
%         end
%         n=1;
%         finalTable=[];
%         for i=START:M:END
%             finalTable(n,1)=i;
%             finalTable(n,2)=i+L-1;
%             finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
%             finalTable(n,10)=sum(simDarray((i+XN):finalTable(n,2))); %delta mass
%             finalTable(n,12)=1;
%             n=n+1;
%         end
%         
%         n2=n-1;
%         for i=1:(n2-1)
%             finalTable(n,1)=finalTable(i,1);
%             finalTable(n,2)=finalTable(i+1,2);
%             finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
%             finalTable(n,10)=sum(simDarray((finalTable(n,1)+XN):finalTable(n,2))); %delta mass
%             finalTable(n,12)=1;
%             n=n+1;
%         end
%         
%         for i=1:(n2-2)
%             finalTable(n,1)=finalTable(i,1);
%             finalTable(n,2)=finalTable(i+2,2);
%             finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
%             finalTable(n,10)=sum(simDarray((finalTable(n,1)+XN):finalTable(n,2))); %delta mass
%             finalTable(n,12)=1;
%             n=n+1;
%         end
%         
%     case 3
%         disp(' ')
%         L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
%         M=input('Input the uniform overhang length (in amino acid, e.g. 3): ');
%         START=max(1, SimStart-XN);
%         END=SimEnd-L+1;
%         while START>END
%             disp('Wrong input! Do it again:')
%             L=input('Input uniform peptide length (in amino acid, e.g. 10): ');
%         end
%         n=1;
%         finalTable=[];
%         for i=START:M:END
%             finalTable(n,1)=i;
%             finalTable(n,2)=i+L-1;
%             finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
%             finalTable(n,10)=sum(simDarray((i+XN):finalTable(n,2))); %delta mass
%             finalTable(n,12)=1;
%             n=n+1;
%         end
%         
%     case 4
%         disp(' ')
%         L=input('Input shortest peptide length (in amino acid, e.g. 5): ');
%         M=input('Input the uniform overhang length (in amino acid, 1 or >1): ');
%         START=max(1, SimStart-XN);
%         END=SimEnd;
%         n=1;
%         finalTable=[];
%         for i=START:END
%             if START+L-1+(n-1)*M<=END
%                 finalTable(n,1)=START;
%                 finalTable(n,2)=START+L-1+(n-1)*M;
%                 finalTable(n,3)=msdfit_siminput_cs(finalTable(n,1), finalTable(n,2));
%                 finalTable(n,10)=sum(simDarray((START+XN):finalTable(n,2))); %delta mass
%                 finalTable(n,12)=1;
%                 n=n+1;
%             end
%         end
%         
%     case 5
%         disp(' ')
%         Lmin=input('Input shortest peptide length (in amino acid, e.g. 4): ');
%         Lmax=input('Input longest peptide length (in amino acid, e.g. 30): ');
%         if Lmax>N
%             disp(['Set too long! Auto reset to ',num2str(N)])
%             Lmax=N;
%         end
%         M=input('How many peptides want to generate? ');
%         Rand=rand(M,2);
%         finalTable=[];
%         for i=1:M
%             L=ceil(Rand(i,1)*(Lmax-Lmin)+Lmin);
%             START=ceil(Rand(i,2)*(SimEnd-L-SimStart+XN)+(SimStart-XN));
%             finalTable(i,1)=max(1, START);
%             finalTable(i,2)=min(START+L-1, SimEnd);
%             finalTable(i,3)=msdfit_siminput_cs(finalTable(i,1), finalTable(i,2));
%             finalTable(i,10)=sum(simDarray((START+XN):finalTable(i,2))); %delta mass
%             finalTable(i,12)=1;
%         end
%         finalTable=sortrows(finalTable);
%         
%     case 6
%         finalTable=[];
%         START=max(1, SimStart-XN);
%         finalTable(1,1)=START;
%         finalTable(1,2)=SimEnd;
%         finalTable(1,3)=msdfit_siminput_cs(finalTable(1,1), finalTable(1,2));
%         finalTable(1,10)=sum(simDarray((START+XN):SimEnd));
%         finalTable(1,12)=1;
%         
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
simResolutionBase=6e4 %input('Input simulating mass resolution at m/z 400 (e.g. 6e4): ');
sampleInterv=0.005 %input('Input m/z data point sampling interval (e.g. 0.01): ');
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
%     if SNratio>0
%         msData_origin=msData;
%         msData(:,2)=msData(:,2)+(max(msData(:,2))/SNratio)*(rand(size(msData,1),1)-0.5); %add random noise
%     end
    %%%2012-10-18 revised:
    switch SNratio
        case {0, -1}
            msData(:,2)=msData(:,2)*(400*250)/max(msData(:,2));
        otherwise
            msData(:,2)=msData(:,2)*(SNratio*250)/max(msData(:,2)); %SNratio*250 would auto adjust simulated max height, also see simnoise.m
    end
    msData = simnoise(msData, 1, SNratio); 
    
    fillType=2; %same meaning as in exms_whole_check_common.m /////////////////////////////////////////
    switch fillType
        case 2
            msdfit_msdataselect %call msdfit_msdataselect.m
        case 3
            msdfit_msdataselect2 %call msdfit_msdataselect2.m 2011-07-13 changed
    end

%     finalTable(pepNum,20:(20+maxND+maxD))=selectDataInt; %2011-06-30 added
%     selectDataInt=simnoise(selectDataInt, 2, SNratio); %2012-10-18 revised
    finalTable(pepNum,20:(20+maxND+maxD))=selectDataInt;
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

if simPop==1
    finalTable1=finalTable;
    simDataSet1=simDataSet;
    simDarray1=simDarray;
else
    finalTable2=finalTable;
    simDataSet2=simDataSet;
    simDarray2=simDarray;
end

end

if size(finalTable1,1)~=size(finalTable2,1) || size(finalTable1,2)~=size(finalTable2,2)
    error('Size not match for the two populatons!')
end
%%%merge the two populations:
finalTable(:,10)=(finalTable1(:,10)+finalTable2(:,10))/2;
finalTable(:,20:end)=(finalTable1(:,20:end)+finalTable2(:,20:end))/2;
% for i=1:size(simDataSet,1)
%     simDataSet{i,1}(:,2)=(simDataSet1{i,1}(:,2)+simDataSet2{i,1}(:,2))/2;
% end

%%%for a visual check:
figure
for i=1:size(finalTable,1)
    subplot(6,7,i)
    j=size(finalTable,2);
    while finalTable(i,j)==0
        j=j-1;
    end
    stem(0:j-20, finalTable(i,20:j), 'fill', 'b', 'MarkerSize', 3)
    hold on
    axis([-1, j-19, 0, 1.1*max(finalTable(i,20:j))])
    set(gca,'ytick',[])
    title([num2str(finalTable(i,1)),'--',num2str(finalTable(i,2))],'FontWeight','bold')
end
    
%%%Save above result:
disp(' ')
SimName=input('Give a name for this simulation: ','s');
SaveFileName=['(',SimName,')_Oct23_TwoPopSim.mat'];
save(SaveFileName,'simSettings','finalTable','simDataSet1','simDataSet2','simDarray1','simDarray2')
disp(' ')
disp([SaveFileName,' has been saved in MATLAB current directory!'])

%%%save finalTable in addition: 
SaveTxtFileName=['(',SimName,')_Oct23_TwoPopSim_finalTable.txt']; 
save(SaveTxtFileName, 'finalTable', '-ascii', '-tabs')


disp(' ')
disp('End of Simulation Subroutine.')
disp('*************************************')
disp(' ')













