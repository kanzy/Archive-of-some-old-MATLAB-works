%%%2009-08-25 aln.m: import .aln format file(generated by ClustalX2) to
%%%generate an alignment matrix for SCA analysis input(2009 Cell paper:
%%%Protein Sectors).

%%%Before run this program: import .aln file, rename the variable to
%%%'alnIn', and figure out the total number of aligned proteins.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totalProNum=input('Input the total number of aligned proteins(from alnIn): ');

size_alnIn=size(alnIn);
repeats=(size_alnIn(1)-1)/totalProNum    %how many repeats in .aln file (one same protein occupy several rows)

%%%Find out the start position(column#) of alignments in .aln file:
sizer=size(alnIn{2});
for i=2:sizer(2)
    if alnIn{i}(i-1)==' ' && alnIn{i}(i)~=' '   %there are spaces between protein info header and sequence alignment 
        START=i;  
    end
end

%%%Find out which row the main protein locate in rawAlnMatrix(same
%%%index(-1) with the first repeat of .aln file):
mainProHead=input('Input the main protein info header(e.g. "gi|119388048|sp|P00004.2"): ');
size_mainProHead=size(mainProHead);
for i=2:(1+totalProNum)
    if alnIn{i}(1:size_mainProHead(2))==mainProHead
        mainRow=i-1;  
    end
end

%%%Generate a raw alignment matrix same with that in .aln file:
rawAlnMatrix=[];
for i=1:repeats
    sizer=size(alnIn{2+totalProNum*(i-1)});    %sizer3(2) is the width of current repeat in .aln file     
    k=1;
    for j= (2+totalProNum*(i-1)) : (1+totalProNum*i)    %rows of current repeat in .aln file
        newBlock(k,:)=alnIn{j}(START:sizer(2));    %get the alignment part
        k=k+1;
    end
    rawAlnMatrix=[rawAlnMatrix newBlock];   %combine the repeats 
    clear newBlock
end

%%%Cut all gaps associated with the main protein, generate the alignment
%%%matrix for SCA analysis:
size_rawAlnMatrix=size(rawAlnMatrix);
k=1;
for j=1:size_rawAlnMatrix(2)
    if rawAlnMatrix(mainRow, j)~='-'
        AlnMatrix(:,k)=rawAlnMatrix(:,j);
        k=k+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%below code modified from 2009 Cell paper:

%% A. Measures of conservation

% load msa_serprot
% % loads 'msa', an alignment of the S1A serine protease family having the
% % form of a 1470*223 array, where each line corresponds to a different
% % sequence. Amino acids are represented by their standard one-letter
% % abbreviation and gaps by '-':

msa=AlnMatrix;  %KAN

Code_aa='ACDEFGHIKLMNPQRSTVWY-';
[N_seq,N_pos]=size(msa);
% N_seq gives the number of sequences, N_pos the number of positions.
% Background probabilities:
freq_bg=[.073 .025 .050 .061 .042 .072 .023 .053 .064 .089...
.023 .043 .052 .040 .052 .073 .056 .063 .013 .033];
% Frequencies of amino acids at given positions:
freq=zeros(21,N_pos);
for a=1:21, freq(a,:)=sum(msa==Code_aa(a))./N_seq; end
% freq(a,i) gives the frequency of amino acid a at position i.
% (gaps are treated as a 21st amino acid for latter convenience)
% Prevalent amino acid at each position:
[freq_bin,prev_aa]=max(freq(1:20,:));
% Code_aa(prev_aa(i)) gives the prevalent amino acid at position i, and
% freq_bin(i) its frequency.
% Simplified alignment in the binary approximation:
msa_bin=1.*(msa==repmat(Code_aa(prev_aa),N_seq,1));
% for each position (column of the array msa_bin), the prevalent amino acid
% is represented by '1', and all other amino acids, including gaps, by '0'.
% Background probabilities for the prevalent amino acids:
freq_bg_bin=freq_bg(prev_aa);
% Relative entropies in the binary approximation:
D_bin=freq_bin.*log(freq_bin./freq_bg_bin)...
+(1-freq_bin).*log((1-freq_bin)./(1-freq_bg_bin));
% Fig. 1A: relative entropies.
figure(1); bar(1:N_pos,D_bin);axis([0 N_pos+1 0 4]);
xlabel('positions');ylabel('D_i^{(a_i)}');
% A histogram of relative entropies.
figure(2); hist(D_bin,N_pos/5);
xlabel('D_i^{(a_i)}');ylabel('number');
% Fraction of gaps:
frac_gaps=sum(freq(21,:))/N_pos;
% Background probabilities accounting for gaps:
freq_bg_wg=[(1-frac_gaps)*freq_bg frac_gaps];
freq_bg_bin_wg=freq_bg_wg(prev_aa);
% Relative entropy in the binary approx with above background probability:
D_bin_wg=freq_bin.*log(freq_bin./freq_bg_bin_wg)...
+(1-freq_bin).*log((1-freq_bin)./(1-freq_bg_bin_wg));
% Overall conservation
D_glo=zeros(1,N_pos);
for i=1:N_pos,
for a=1:21
if(freq(a,i)>0)
D_glo(i)=D_glo(i)+freq(a,i)*log(freq(a,i)/freq_bg_wg(a));
end
end
end
% (when freq(a,i)=0, freq(a,i)*log(freq(a,i)) is to be considered =0,
% since x*log(x)->0 for x->0)
% Fig. S1: validity of the binary approximation
figure(3); plot(D_glo,D_bin_wg,'o');
xlabel('Overall conservation');
ylabel('Conservation in the binary approximation');


%% B. SCA calculations
% Correlation matrix in the binary approximation:
freq_pairs_bin=msa_bin'*msa_bin/N_seq;
C_bin=freq_pairs_bin-freq_bin'*freq_bin;
% Weights (defined as gradients of relative entropy):
W=log(freq_bin.*(1-freq_bg_bin)./(freq_bg_bin.*(1-freq_bin)));
% SCA matrix:
C_sca=(W'*W).*abs(C_bin);
% Fig. 1D: representation of the SCA matrix
figure(4); imshow(C_sca,[0 .5]);colormap(jet);


%% C. Spectral cleaning
% Spectrum of the SCA matrix
[eigvect_unsorted,lambda_unsorted]=eig(C_sca);
[lambda,lambda_order]=sort(diag(lambda_unsorted),'descend');        %KAN:PROBLEM!!!
eigvect=eigvect_unsorted(:,lambda_order);
% (the eigenvector are ordered for future convenience)
% A randomization is performed at the level of the alignment:
% the amino acids are permuted between the sequences independently
% for each position.
% The positional conservations are therefore preserved.
N_samples=100; N_ev=5;
lambda_rnd=zeros(N_samples,N_pos);
eigvect_rnd=zeros(N_samples,N_pos,N_ev);
for s=1:N_samples
msa_bin_rnd=zeros(N_seq,N_pos);
for pos=1:N_pos
perm_seq=randperm(N_seq);
msa_bin_rnd(:,pos)=msa_bin(perm_seq(:),pos);
end
freq_pairs_bin_rnd=msa_bin_rnd'*msa_bin_rnd/N_seq;
C_bin_rnd=freq_pairs_bin_rnd-freq_bin'*freq_bin;
C_sca_rnd=(W'*W).*abs(C_bin_rnd);
[eigvect_unsorted,lambda_unsorted]=eig(C_sca_rnd);
[lambda_sorted,lambda_order]=sort(diag(lambda_unsorted),'descend');
lambda_rnd(s,:)=lambda_sorted;
eigvect_rnd(s,:,:)=eigvect_unsorted(:,lambda_order(1:N_ev));
end
% Note that 'freq_bin' and 'W' are not affected by the randomization.
% Fig. S2A: comparison of spectra
figure(5);
subplot(2,1,1); [yhist,xhist]=hist(lambda,N_pos); bar(xhist,yhist,'k');axis([0 30 0 35]);
xlabel('eigenvalues (actual alignment)');ylabel('number');
[n]=hist(lambda_rnd(:),xhist);
subplot(2,1,2); bar(xhist,n/N_samples,'k'); axis([0 30 0 35]);
xlabel('eigenvalues (randomized alignments)');ylabel('number');
% (the histogram from randomized alignments is normalized for comparison)
% Fig. S2B: Interpretation of the first mode
figure(6);
plot(eigvect(:,1),sum(C_sca)/(sum(sum(C_sca).^2))^(1/2),'o');
axis([0 .25 0 .25]);
xlabel('<i |1> (first eigenvector of C\_ sca)');
ylabel('\Sigma_j C\_ sca_{ij} (normalized)');
% Fig. S2C-E: Threshold for the weights on eigenvectors 2 to 4
figure(7);
for k=2:4
subplot(2,3,k-1);
hist(eigvect(:,k),N_pos); axis([-.25 .25 0 5]);
xlabel(['<i |' num2str(k) '>']); ylabel('number');
subplot(2,3,k+2);
z=eigvect_rnd(:,:,k);[n,x]=hist(z(:),N_pos);
plot(x,n/N_samples,'r'); axis([-.25 .25 0 5]);
xlabel(['<i |' num2str(k) '> (random)']); ylabel('number');
end
% Definition of the noise threshold:
threshold=.05;
% Definition of sector positions:
sec_red=find(eigvect(:,2)>max(threshold,abs(eigvect(:,4))));
sec_blue=find(eigvect(:,2)<-max(threshold,abs(eigvect(:,4))));
sec_green=find(eigvect(:,4)>max(threshold,abs(eigvect(:,2))));
% Cleaned SCA matrix:
C_clean=zeros(N_pos,N_pos);
for k=2:4, C_clean=C_clean+lambda(k)*eigvect(:,k)*eigvect(:,k)'; end
% Ordering of sector positions:
[x,order]=sort(eigvect(sec_blue,2)); sec_blue_ord=sec_blue(order);
[x,order]=sort(-eigvect(sec_green,4)); sec_green_ord=sec_green(order);
[x,order]=sort(-eigvect(sec_red,2)); sec_red_ord=sec_red(order);
% Fig. 1E: cleaned SCA matrix
sec_all_ord=[sec_blue_ord; sec_green_ord; sec_red_ord];
figure(8); imshow(C_clean(sec_all_ord,sec_all_ord),[0 .25]);colormap(jet);
% Negative elements in the cleaned SCA matrix
figure(9); imshow(C_clean(sec_all_ord,sec_all_ord),[-.5 .5]);colormap(jet);
% Fig. S4: relation between cleaned and original correlations
figure(10);
plot(C_sca(:),C_clean(:),'o');
xlabel('elements of the original SCA matrix');
ylabel('elements of the cleaned SCA matrix (based on eigenvectors 2-4)');


%% D. Sector indentification
% Fig. S3: representation of the significant eigenvectors
modes=[2 3; 2 4; 3 4; 4 5];
figure(11);
for k=1:4
subplot(2,2,k); x=modes(k,1); y=modes(k,2);
plot(eigvect(:,x),eigvect(:,y),'ok',...
eigvect(sec_blue,x),eigvect(sec_blue,y),'ob',...
eigvect(sec_green,x),eigvect(sec_green,y),'og',...
eigvect(sec_red,x),eigvect(sec_red,y),'or');
xlabel(['<i |' num2str(x) '>']);ylabel(['<i |' num2str(y) '>']);
axis([-.4 .4 -.4 .4]);
end