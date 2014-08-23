%%%2011-06-04 msmslist2.m:

% XN=2; %exclude 2 residues in N-term for HX
% 
% disp(' ')
% disp('This program is for making an inclusion list of the missing peptides for achieving full single amino acid resolution overlap.')
% disp(' ')
% disp('First, import the previously generated ExMS_preload.mat file...')
% uiimport
% void=input('Press "Enter" to continue...');
% 
% newSites=[];
% consolidPool=consolid_pool(peptidesPool, 1);
% for i=1:size(consolidPool,1)
%     if consolidPool(i,1)~=consolidPool(i,2)
%         newSites=[newSites, consolidPool(i,1)+1:consolidPool(i,2)-1];
%     end
% end
% 
% disp(' ')
% disp('For finding peptides should be included in inlcusion list...')
% peptideLengthMin=input('Input the minimum peptide length(e.g. 5): ');
% peptideLengthMax=input('Input the maximum peptide length(e.g. 20): ');
% peptideChargeMin=input('Input the minimum peptide charge(e.g. 1): ');
% peptideChargeMax=input('Input the maximum peptide charge(e.g. 4): ');
% mzDetectMin=input('Input the minimum m/z detect limit(e.g. 300): ');
% mzDetectMax=input('Input the maximum m/z detect limit(e.g. 1800): ');
%     
% n=0;
% newPool=[];
% newPool_distND={};
% for i=1:size(newSites,2)
%     for j=1:size(currSeq,2)
%         x=find(newSites==j);
%         if abs(newSites(i)-j)>=peptideLengthMin && abs(newSites(i)-j)<=peptideLengthMax && min(size(x))==0
%             aa=sort([newSites(i), j]);
%             START=aa(1); END=aa(2);
%             [peptideMass, distND, maxND, maxD]=pepinfo(currSeq(START:END), XN);
%             for k=peptideChargeMin:peptideChargeMax
%                 monoMZ=peptideMass/k+1.007276; %1.007276 is the mass of proton
%                 if monoMZ>mzDetectMin && monoMZ+(maxND+maxD)/k<mzDetectMax
%                     n=n+1;
%                     newPool(n,1)=START;
%                     newPool(n,2)=END;
%                     newPool(n,3)=k;
%                     newPool(n,4)=monoMZ;
%                     newPool_distND{n}=distND;
%                 end
%             end
%         end
%     end
% end


% disp(' ')
% RTrange=input('Input the RT range (unit: minute) of the MS/MS experiments: (e.g. [0 20]) ');
disp('Establishing inclusion list...')
msmsList=[];
n=1;
for i=1:size(rtmz,1)
    if rtmz(i,1)/60<35 && rtmz(i,1)/60>2.5
            msmsList(n,1)=rtmz(i,2); %%1.00335 is the delta mass between C13(13.00335 u) and C12(12 u)
            msmsList(n,2)=rtmz(i,1)/60-1.5;
            msmsList(n,3)=rtmz(i,1)/60+1.5;
            n=n+1;
    end
end
disp('Done!')
msmsList=sortrows(msmsList,1);

msmsList_origin=msmsList;
msmsList=[];
n=1;
msmsList(1,:)=msmsList_origin(1,:);
for i=2:size(msmsList_origin,1)
    if abs(msmsList_origin(i,1)-msmsList_origin(i-1,1))>msmsList_origin(i,1)*10*1e-6 %to remove same or very close m/z peaks (10 ppm)
        n=n+1;
        msmsList(n,:)=msmsList_origin(i,:);
    end
end
        
SaveTxtFileName=[date,'_MSMS Inclusion List.txt'];
save(SaveTxtFileName, 'msmsList', '-ascii', '-tabs')



                    
        