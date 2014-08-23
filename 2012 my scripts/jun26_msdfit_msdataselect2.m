%%%2011-06-17 msdfit_msdataselect2.m: an alternative method for msdfit.m use


deltaC=1.00335484; %the delta mass between C13(13.0033548378 u) and C12
deltaN=0.99703489; %the delta mass between N15 atom(15.0001088982 u) and N14 atom(14.0030740048 u)
%deltaO=2.00424638; %the delta mass between O18 atom(17.9991610 u) and O16 atom(15.99491461956 u)
%deltaS=1.99579590;%the delta mass between S34 atom(33.96786690 u) and S32 atom(31.97207100 u)
deltaD=1.00627675; %the delta mass between D atom(2.0141017778 u) and H atom(1.00782503207 u)

mzThreshold=20; %ppm (experience: 20 for 1e5; 35 for res 6e4; 50 for res 3e4; 200 for res 1e4)

selectPeaks=zeros((1+maxND+maxD),2); %pre-allocate
selectData=[];
for i=0:(maxND+maxD)
    %     selectPeaks(i+1,1)=monoMZ+deltamass(i)/Charge;
    
    if i<3
        mzLb=monoMZ+deltaN*i/Charge; %possible lower boundary
    end
    if i>=3 && i<maxND
        mzLb=monoMZ+i/Charge;
    end
    if i>=maxND
        mzLb=monoMZ+(maxND+deltaD*(i-maxND))/Charge; 
    end
    mzUb=monoMZ+deltaD*i/Charge; %possible upper boudary
    
    selectPeaks(i+1,1)=(mzLb+mzUb)/2;
    
    xx=find(msData(:,1)>=mzLb-monoMZ*mzThreshold*(1e-6) & msData(:,1)<=mzUb+monoMZ*mzThreshold*(1e-6));
    selectData=[selectData; msData(xx,:)];
    selectPeaks(i+1,2)=trapz(msData(xx,1),msData(xx,2)); %use trapz()
end
selectDataInt=selectPeaks(:,2)';


if pepNum==1
    disp(' ')
    disp(['For first peptide, there are total ',num2str(size(selectData,1)),' data points are selected for the ',...
        num2str(size(selectPeaks,1)),' isotopic peaks.'])
    reduceFold=0 %floor(input('Want to reduce data points number used in fitting (for all peptides)? (input 0=no, x=reduced by x fold): '));
end

if reduceFold>1
    n=0;
    selectData_origin=selectData;
    selectData=[];
    for i=1:size(selectData_origin,1)
        if rem(i,reduceFold)==0 %resampling data points
            n=n+1;
            selectData(n,:)=selectData_origin(i,:);
        end
    end
end

