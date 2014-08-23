%%%apr19.m: revised from apr18 & poolplot1.m for 1NQL disulfides plot with
%%%peptide map

pool=peptidesPool;

disp(' ')
disp(['There are ', num2str(size(pool,1)), ' peptides in this plotted pool/set.'])

uniqPool=[];
k=1;
for i=1:(size(pool,1)-1)
    if pool(i,1)~=pool(i+1,1) || pool(i,2)~=pool(i+1,2)
        uniqPool(k,:)=pool(i,1:2);
        k=k+1;
    end
end
uniqPool(k,:)=pool(size(pool,1),1:2);
disp([' and there are ', num2str(size(uniqPool,1)), ' unique peptides.'])

%%%plot pool:
h=figure;
for i=1:size(pool,1)
    p1=[pool(i,1),pool(i,2)]; % start and end aa# of each peptide
    p2=[i,i];
    plot(p1,p2,'b','LineWidth',1)
    hold on
end

%set(gca,'xtick',0:5:max(pool(:,2))+1)
xlabel('Residue Number')
ylabel('Peptide Index')
title(['EGFR-ECD Peptide Map (total ', num2str(size(pool,1)), ' peptides & ', num2str(k), ' unique peptides)']) 

%%%revised from mar26.m
%%%for MassMatrix modified database (indicate Disulfide bonds)


% AlignStruct = localalign(pdbseq, currSeq)  //here, the PDB is 3VN4; currSeq is from Wenbing's MDTCS.txt


%%%//First, copy out SS bonds section text in .pdb file into an Excel table, then save as .csv file, then import into Matlab (to generate VarName5 & VarName8)

height0=110;
for i=1:25
    s1=VarName5(i);
    s2=VarName8(i);
    
    if currSeq(s1)~='C' || currSeq(s2)~='C'
        error('Error!')
    end
    
    p1=[s1,s2]; % start and end aa# of each peptide
    p2=[height0+i*5,height0+i*5];
    plot(p1,p2,'r','LineWidth',1)
    hold on
    
    p1=[s1,s1];
    p2=[0, height0+i*5];
    plot(p1,p2,'r:','LineWidth',1)
    hold on
    
    p1=[s2,s2];
    p2=[0, height0+i*5];
    plot(p1,p2,'r:','LineWidth',1)
    hold on
end
    
% 
% modSeq=[];
% n=0;
% for i=1:size(currSeq,2)
%     n=n+1;
%     modSeq(n)=currSeq(i);
%     for j=1:12
%         k=i+(3-260 + 311-27);  %//3 & 260 are from above alignment (start AA); 311 & 27 are for correcting the AA numbering shift within the PDB 
%         if k==VarName5(j) || k==VarName8(j)
%             str=['($',num2str(j),')'];
%             modSeq=[modSeq, str];
%             n=n+size(str,2);
%         end
%     end
% end