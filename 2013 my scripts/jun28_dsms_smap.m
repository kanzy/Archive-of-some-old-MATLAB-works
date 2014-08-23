%%%2013-06-24 major revison
%%%2013-05-20 renamed to dsms_smap: be called by dsms.m
%%%lcms_check_smap.m: should be called by lcms_check.m
%%%2013-04-24 added: Peptide & Disulfide Plot (adapted from apr19.m)
%%%apr19.m: revised from apr18 & poolplot1.m for 3VN4 disulfides plot with peptide map

function h=dsms_smap(peptidesPool1, peptidesPool2, ssPepTable, ssPepGoodFlags, ssTable, proSeq)  

%%%inputs size check:
if size(ssPepTable, 2)~=7
    error('The input "ssPepTable" must be in 7-column format! (start# and end# of up to 3 fragments and the last column indicating the total fragment number)')
end
if min(size(ssPepGoodFlags))~=1 || max(size(ssPepGoodFlags))~=size(ssPepTable,1)
    error('The input "ssPepGoodFlags" is in wrong format!')
end
if size(ssTable,2)~=2
    error('The input "ssTable" is in wrong format!')
end

h=figure;

%%%this could be the original peptide pool (without (full) TCEP reduction)
if min(size(peptidesPool1))>0
    for i=1:size(peptidesPool1,1)
        p1=[peptidesPool1(i,1),peptidesPool1(i,2)]; % start and end aa# of each peptide
        p2=[i,i];
        plot(p1,p2,'k','LineWidth',1)
        hold on
    end
    baseHeight=size(peptidesPool1,1)/2; %roughly set
else
    baseHeight=0;
end

%%%this could be the (TCEP reducted) refernce pool
if min(size(peptidesPool2))>0
    for i=1:size(peptidesPool2,1)
        p1=[peptidesPool2(i,1),peptidesPool2(i,2)]; % start and end aa# of each peptide
        p2=[i+baseHeight,i+baseHeight];
        plot(p1,p2,'b','LineWidth',1)
        hold on
    end
    baseHeight=baseHeight+size(peptidesPool2,1);
end

baseHeight=baseHeight+20;

%%%plot "ssPepTable" with optional "ssPepGoodFlags":
n=0;
for i=1:size(ssPepTable,1)
    if ssPepGoodFlags(i)>=1 %passed ExMS autocheck //or with other meaning
        pepColor='g';
    
    n=n+2;
    for j=1:ssPepTable(i,7) %number of fragments
        ssPepPos=ssPepTable(i, (j*2-1):(j*2)); %2013-05-31 changed from 1:4
        p1=[ssPepPos(1),ssPepPos(2)]; % start and end aa# of current fragment
        p2=[baseHeight+n, baseHeight+n];
        plot(p1,p2,pepColor,'LineWidth',1)
        hold on
    end
    end
end

baseHeight=baseHeight+n+(20);
for i=1:size(ssTable,1)
    s1=ssTable(i,1);
    s2=ssTable(i,2);
    p1=[s1,s2]; % start and end aa# of the S-S bonds
    p2=[baseHeight+i*3,baseHeight+i*3];
    plot(p1,p2,'m','LineWidth',1)
    hold on
    p1=[s1,s1];
    p2=[0, baseHeight+i*3];
    plot(p1,p2,'m:','LineWidth',1)
    hold on
    p1=[s2,s2];
    p2=[0, baseHeight+i*3];
    plot(p1,p2,'m:','LineWidth',1)
    hold on
end
finalHeight=baseHeight+i*3;

xlabel('Residue Number')
ylabel('Peptide Index')
title('Map of Peptide (red[green]=S-S linked[ExMS confirmed]) & Disulfide bonds(magenta)')
axis([0, size(proSeq,2)+1, 0, finalHeight+10])



% SaveFigureName=['(', date, ')_', FileName, '_DSMS_Peptide & Disulfide map.fig'];
% saveas(h,SaveFigureName)
% saveas(h,[SaveFigureName(1:end-4),'.png'])

