
proSeq='ATSTKKLHKEPATLIKAIDGDTVKLMYKGQPMTFRLLLVDTPETKHPKKGVEKYGPEASAFTKKMVENAKKIEVEFDKGQRTDKYGRGLAYIYADGKMVNEALVRQGLAKVAYVYKGNNTHEQLLRKSEAQAKKEKLNIWSEDNADSGQ';

disp(' ')
HXdir=2 %input('Input the HX direction (1=H->D; 2=D->H): ');
HXtemp=20 %input('Input the HX experiment temperature("C): ');
if HXdir==1 %H->D
    HXpH=input('Input the effective pH value (e.g. pDread+0.4) in HX buffer: ');
else %D->H
    HXpH83=8.3 %input('Input the pH value in HX buffer: ');
    HXpH86=8.6
    HXpH56=5.6
    HXpH42=4.2
end
kchPro_DH1 = fbmme_dh(proSeq, HXpH83, HXtemp, 'poly');
kchPro_DH2 = fbmme_dh(proSeq, HXpH86, HXtemp, 'poly');
kchPro_DH3 = fbmme_dh(proSeq, HXpH56, HXtemp, 'poly');
kchPro_DH4 = fbmme_dh(proSeq, HXpH42, HXtemp, 'poly');

kchPro = [kchPro_DH1'; kchPro_DH2'; kchPro_DH3'; kchPro_DH4'];



[FileName, PathName] = uigetfile('*.xlsx','Select the Excel file');
[NUM,TXT,RAW] = xlsread([PathName, FileName]);


cmpTable=zeros(size(NUM,1),3);
cmpTable(:,1)=NUM(:,1);
cmpTable(:,2)=NUM(:,4);
for i=1:size(NUM,1)
    aaNum=NUM(i,1);
    logPf=[];
    n=0;
    for j=5:8
        if ~isnan(NUM(i,j))
            kch=kchPro(j-4,aaNum);
            n=n+1;
            logPf(n)=log10(kch/NUM(i,j));
        end
    end
    cmpTable(i,3)=mean(logPf);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%below refered to aug08.m

figure
a=-2;
b=10;

subplot(1,2,1)
plot([a,b],[a,b],'k')
hold on

k=0.5;
plot([a+k,b],[a,b-k],'k:')
hold on
plot([a,b-k],[a+k,b],'k:')
hold on

k=1;
plot([a+k,b],[a,b-k],'k:')
hold on
plot([a,b-k],[a+k,b],'k:')
hold on

for i=1:size(cmpTable,1)
    if strcmp(TXT{i,2},'sr')
        %plot(cmpTable(i,2), cmpTable(i,3), 'ro')
    else
        plot(cmpTable(i,2), cmpTable(i,3), 'bo')
    end
    hold on
%     text(cmpTable(i,2), cmpTable(i,3),[TXT{i,1},num2str(cmpTable(i,1))])
%     hold on
end

for i=1:size(cmpTable,1)
    if strcmp(TXT{i,2},'sr')
        plot(cmpTable(i,2), cmpTable(i,3), 'ro')
    else
        %plot(cmpTable(i,2), cmpTable(i,3), 'bo')
    end
    hold on
%     text(cmpTable(i,2), cmpTable(i,3),[TXT{i,1},num2str(cmpTable(i,1))])
%     hold on
end

xlabel('log_1_0(PF by NMR)')
ylabel('log_1_0(PF by HDsite)')
axis([-1.4 9 -1.4 9])


subplot(1,2,2)
hist(cmpTable(:,3)-cmpTable(:,2),25)
hold on
xlabel('log_1_0(PF_H_D_s_i_t_e/PF_N_M_R)')
ylabel('Count')
 

%%%2013-04-02 added:
m=0;n=0;
for i=1:size(cmpTable,1)
    x=abs(cmpTable(i,3)-cmpTable(i,2));
    if x<=0.5
        m=m+1;
    else
        if x<=1
            n=n+1;
        end
    end
end
size(cmpTable,1)
m
n
    
 
 
 
 
 
 
 