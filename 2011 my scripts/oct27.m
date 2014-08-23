
pDread=4;
Temp=4;

% pDread=9;
% Temp=37;

Times=[10,30,100,300,1000,3000,1e4,3e4,1e5,3e5];

kcHD = fbmme_hd(currSeq, pDread, Temp, 'poly', 1);


%%%get peptide list:
peptidesPool=[peptidesPool_pep; peptidesPool_FP; peptidesPool_pepFP];
peptidesPool_old=sortrows(peptidesPool);
peptidesPool=peptidesPool_old(1,:);
n=1;
for i=2:size(peptidesPool_old,1)
    if (peptidesPool_old(i,1)==peptidesPool_old(i-1,1) && peptidesPool_old(i,2)==peptidesPool_old(i-1,2) && peptidesPool_old(i,3)==peptidesPool_old(i-1,3))==0
        n=n+1;
        peptidesPool(n,:)=peptidesPool_old(i,:);
    end
end
       
%%%calculate and plot HX curve: NMR vs COREX
record=zeros(size(rawPfArray,1),2);
n=0;
Ds_nmr={};
Ds_corex={};
for i=1:size(peptidesPool,1)
    START=peptidesPool(i,1);
    END=peptidesPool(i,2);
    Charge=peptidesPool(i,3);
    flag=1;
    for j=START+2:END
        x=find(j==rawPfArray(:,1));
        if min(size(x))==0
            flag=0;
        else
            if rawPfArray(x,2)==0 || rawPfArray(x,3)==0
                flag=0;
            end
        end
    end
    if flag==1
        n=n+1;
        D_nmr=zeros(1,size(Times,2));
        D_corex=zeros(1,size(Times,2));
        y=find(rawPfArray(:,1)>=START+2 & rawPfArray(:,1)<=END);
        if max(size(y))~=END-START-1
            error('Size Wrong')
        end
        for j=1:max(size(y))
            record(y(j),1)=record(y(j),1)+1;
            record(y(j),2)=record(y(j),2)+(rawPfArray(y(j),2)-rawPfArray(y(j),3));
            k=kcHD(rawPfArray(y(j),1));
            if rawPfArray(y(j),2)==0 || rawPfArray(y(j),3)==0
                error('Wrong')
            end
            pf_nmr=10^rawPfArray(y(j),2);
            pf_corex=10^rawPfArray(y(j),3);
            D_nmr=D_nmr+(1-exp(-Times*k/pf_nmr));
            D_corex=D_corex+(1-exp(-Times*k/pf_corex));
        end
        Ds_nmr{n}=D_nmr;
        Ds_corex{n}=D_corex;
        
        close all
        h=figure;
        semilogx(Times, D_nmr, 'b.-')
        hold on
        semilogx(Times, D_corex, 'r.-')
        hold on
        xlabel('Time (sec)')
        ylabel('D')
        title([num2str(START),'-',num2str(END),' +',num2str(Charge)'])
        SaveFigureName=[num2str(START),'-',num2str(END),'cs',num2str(Charge),'_HXcurve.fig'];
        saveas(h,SaveFigureName)
    end
end

%%%%show correlations
figure
subplot(1,2,1)
for i=1:size(rawPfArray,1)
plot(rawPfArray(i,2),rawPfArray(i,3),'o')
hold on
text(rawPfArray(i,2),rawPfArray(i,3),num2str(record(i,1)))
hold on
end
plot([-1,9],[-1,9],'k:')
hold on
xlabel('NMR determined Log Pf')
ylabel('COREX predicted Log Pf')
title('Residue level correlation')

subplot(1,2,2)
for i=1:n
    D_nmr=Ds_nmr{i};
    D_corex=Ds_corex{i};
    plot(D_nmr, D_corex,'.:')
    hold on
end
plot([-1,12],[-1,12],'k:')
hold on
xlabel('NMR determined Ds on peptides')
ylabel('COREX predicted Ds on peptides')
title('Peptide level correlation')
% 
% cftool
        
sum(record(:,2))
        
        
            
            
        








