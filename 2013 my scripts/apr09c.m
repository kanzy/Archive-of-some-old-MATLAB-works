%%%revised from mar18.m

%%%In workspace should preload 'FL1', 'FL2' & 'knmr'

RMSD1=[]; n1=0;
RMSD2=[]; n2=0;

times=FL1(1,2:end);

a=0.9;
b=0.09;

exFitTable=[];
for i=1:size(knmr,1)
    kex=knmr(i);
    X=(a-b)*exp(-kex*times)+b;
    
    aaNum=FL1(i+1,1);
    
    Y1=FL1(i+1,2:end);
    for j=1:size(X,1)
        if Y1(j)~=a && Y1(j)~=b
            Y1=Y1-0.1*(Y1-X);
        end
    end
    RMSD1=[RMSD1, (X-Y1).^2];
    n1=n1+size(X,2);
    
    Y2=FL2(i+1,2:end);
    for j=1:size(X,1)
        if Y2(j)~=a && Y2(j)~=b
            Y2=Y2-0.2*(Y2-X);
        end
    end
    RMSD2=[RMSD2, (X-Y2).^2];
    n2=n2+size(X,2);
    
    s = fitoptions('Method','NonlinearLeastSquares',...
        'Lower',0,...
        'Upper',Inf,...
        'Startpoint',kex*10);
    f = fittype(['(',num2str(a),'-',num2str(b),')*exp(-k*x)+',num2str(b)],'options',s);
    [cfun1,gof1,output1] = fit(times',Y1',f);
    [cfun2,gof2,output2] = fit(times',Y2',f);
    
    close all
    h=figure;
    
    %%%plot the D% of time points:
    semilogx(times, Y1, 'bo')
    hold on
    semilogx(times, Y2, 'ro')
    hold on
    
    times2=(min(times)/3):(min(times)/10):(max(times)*3);
    semilogx(times2,(a-b)*exp(-kex*times2)+b,'k','LineWidth',2) %NMR
    hold on
    semilogx(times2,(a-b)*exp(-cfun1.k*times2)+b,'b--','LineWidth',2)
    hold on
    semilogx(times2,(a-b)*exp(-cfun2.k*times2)+b,'r--','LineWidth',2)
    hold on
    
    axis([min(times2)/5, max(times2)*5, 0, 1])
    
    title({['Residue #',num2str(aaNum)];...
        '(black=NMR; blue=Centroid fit; red=Envelope fit)'})
    xlabel('HX Time (sec)')
    ylabel('D Fraction')
    
    SaveFigureName=['Apr09_exFit_Residue#',num2str(aaNum),'.fig'];
    saveas(figure(h),SaveFigureName)
    saveas(figure(h),SaveFigureName(1:end-4),'tif') %also save as .tif figure. 2012-10-28 added
    disp(' ')
    disp([SaveFigureName,' has been saved in MATLAB current directory!'])
    disp(' ')
    void=input('Press "Enter" to continue...'); %just waiting for manual inspect
    
    %%%save this residue result:
    exFitTable(i,1)=aaNum;
    exFitTable(i,2)=kex;
    exFitTable(i,3)=cfun1.k;
    exFitTable(i,4)=cfun2.k;
end

if n1~=n2
    error('something wrong!')
end

RMSD1=(sum(RMSD1)/n1)^0.5;
RMSD2=(sum(RMSD2)/n2)^0.5;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

X=exFitTable([1:4,6:13,16],2);
Y1=exFitTable([1:4,6:13,16],3);
Y2=exFitTable([1:4,6:13,16],4);

Min=min([X;Y1;Y2])/3;
Max=max([X;Y1;Y2])*3;

plot([Min,Max],[Min,Max],'k')
hold on
a=Min; b=Max; k=3;
plot([a*k,b],[a,b/k],'k:')
hold on
plot([a,b/k],[a*k,b],'k:')
hold on
a=Min; b=Max; k=10;
plot([a*k,b],[a,b/k],'k:')
hold on
plot([a,b/k],[a*k,b],'k:')
hold on

plot(X, Y1, 'b.', 'MarkerSize',12)
hold on
plot(X, Y2, 'r.', 'MarkerSize',12)
hold on

axis([a,b,a,b])


















