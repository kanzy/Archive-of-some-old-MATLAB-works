
% 
% proSeq='ATSTKKLHKEPATLIKAIDGDTVKLMYKGQPMTFRLLLVDTPETKHPKKGVEKYGPEASAFTKKMVENAKKIEVEFDKGQRTDKYGRGLAYIYADGKMVNEALVRQGLAKVAYVYKGNNTHEQLLRKSEAQAKKEKLNIWSEDNADSGQ';
% 
% disp(' ')
% HXdir=2 %input('Input the HX direction (1=H->D; 2=D->H): ');
% HXtemp=20 %input('Input the HX experiment temperature("C): ');
% if HXdir==1 %H->D
%     HXpH=input('Input the effective pH value (e.g. pDread+0.4) in HX buffer: ');
% else %D->H
%     HXpH83=8.3 %input('Input the pH value in HX buffer: ');
%     HXpH86=8.6
%     HXpH56=5.6
%     HXpH42=4.2
% end
% kchPro_DH1 = fbmme_dh(proSeq, HXpH83, HXtemp, 'poly');
% kchPro_DH2 = fbmme_dh(proSeq, HXpH86, HXtemp, 'poly');
% kchPro_DH3 = fbmme_dh(proSeq, HXpH56, HXtemp, 'poly');
% kchPro_DH4 = fbmme_dh(proSeq, HXpH42, HXtemp, 'poly');
% 
% kchPro = [kchPro_DH1'; kchPro_DH2'; kchPro_DH3'; kchPro_DH4'];
% 
% 
% 
% [FileName, PathName] = uigetfile('*.xlsx','Select the Excel file');
% [NUM,TXT,RAW] = xlsread([PathName, FileName]);


cmpTable=zeros(size(NUM,1),4);
cmpTable(:,1)=NUM(:,1);
for i=1:size(NUM,1)
    aaNum=NUM(i,1);
    cmpTable(i,2)=kchPro(4,aaNum); %store kch at pH4.2
    logPf=[];
    n=0;
    for j=5:8
        if ~isnan(NUM(i,j))
            kch=kchPro(j-4,aaNum);
            n=n+1;
            logPf(n)=log10(kch/NUM(i,j));
        end
    end
    cmpTable(i,3)=cmpTable(i,2)/(10^mean(logPf));
    cmpTable(i,4)=mean(logPf);
end
cmpTable(:,2)=log10(cmpTable(:,2));
cmpTable(:,3)=log10(cmpTable(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure
a=-3.5;
b=0;

subplot(1,2,1)
plot([a,b],[a,b],'k')
hold on


% k=0.5;
% plot([a+k,b],[a,b-k],'k:')
% hold on
% plot([a,b-k],[a+k,b],'k:')
% hold on
% 
% k=1;
% plot([a+k,b],[a,b-k],'k:')
% hold on
% plot([a,b-k],[a+k,b],'k:')
% hold on

z=0.05;

for i=1:size(cmpTable,1)
    if strcmp(TXT{i,2},'sr')
        %plot(cmpTable(i,2), cmpTable(i,3), 'ro')
    else
        plot(cmpTable(i,2), cmpTable(i,3), 'bo')
        hold on
        text(cmpTable(i,2)+z, cmpTable(i,3)+z,[TXT{i,1},num2str(cmpTable(i,1))])
    end
end

for i=1:size(cmpTable,1)
    if strcmp(TXT{i,2},'sr')
        plot(cmpTable(i,2), cmpTable(i,3), 'ro')
        hold on
        text(cmpTable(i,2)+z, cmpTable(i,3)+z,[TXT{i,1},num2str(cmpTable(i,1))])
    else
        %plot(cmpTable(i,2), cmpTable(i,3), 'bo')
    end
end

xlabel('log_1_0(Intrinsic Rate)')
ylabel('log_1_0(HDsite Rate)')


subplot(1,2,2)
hist(cmpTable(:,4),20)
hold on
xlabel('log_1_0(PF_H_D_s_i_t_e)')
ylabel('Count')
 
 
 
 
 
 
 
 
 