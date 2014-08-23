%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%aug05.m: ref to msdfit_bat_post


disp(' ')
HXdir=input('Input the HX direction (1=H->D; 2=D->H): ');
HXtemp=input('Input the HX experiment temperature("C): ');
if HXdir==1 %H->D
    HXpH=input('Input the effective pH value (e.g. pDread+0.4) in HX buffer: ');
else %D->H
    HXpH=input('Input the pH value in HX buffer: ');
end
kchPro_HD = fbmme_hd(proSeq, HXpH, HXtemp, 'poly', 0); %call fbmme_hd.m
kchPro_DH = fbmme_dh(proSeq, HXpH, HXtemp, 'poly'); %call fbmme_dh.m
if HXdir==1 %H->D
    kchPro = kchPro_HD;
else %D->H
    kchPro = kchPro_DH;
end

disp(' ')
flagBound=input('In single exponential HX rate fitting, want to specify the plateaus (input 1) or let them float (input 2): ');
switch flagBound
    case 1
        Dlb=input('Input the lower limit of real D% value (e.g., 0): ');
        Dub=input('Input the upper limit of real D% value (e.g., 1): ');
    case 2
        Dlb=NaN;
        Dub=NaN;
    otherwise
        error('Wrong input!')
end

for aaNum=Data(2,1):Data(end,1)
    disp(' ')
    disp('*******************************************************')
    disp(['Now plot/analyze residue # ',num2str(aaNum),' ...'])
    aaIndex=find(aaNum==Data(:,1));
    if min(size(aaIndex))==0
        disp(' ')
        disp('Because it was not fitted, no plot for it.')
        continue
    end
    
    Xdata=Data(1,3:end)'; %unit:sec;
    Ydata=Data(aaIndex,3:end)';
    
    %%%2012-05-03 added to remove NaN points:
    rawData=[Xdata, Ydata];
    Xdata=[]; Ydata=[];
    n=0;
    for i=1:size(rawData,1)
        if ~isnan(rawData(i,2))
            n=n+1;
            Xdata(n,1)=rawData(i,1);
            Ydata(n,1)=rawData(i,2);
        end
    end
    
    %%%2012-05-05 added:
    if n<3
        disp(' ')
        disp('Too few valid data points for ex rate fitting. Skipped')
        continue
    end

    kStart=kchPro(aaNum)*1e-6;
    
    switch flagBound
        case 1
            a=Dub; b=Dlb;
            %%%2012-05-14 revised:
            s = fitoptions('Method','NonlinearLeastSquares',...
                'Lower',0,...
                'Upper',Inf,... %2012-04-26 revised
                'Startpoint',kStart,...
                'Display', 'off',...
                'Robust','on'); %2012-05-08 added this line //use 'on' or 'LAR'
            if HXdir==1 %H->D
                f = fittype(['(',num2str(a),'-',num2str(b),')*(1-exp(-k*x))+',num2str(b)],'options',s);
            else %D->H
                f = fittype(['(',num2str(a),'-',num2str(b),')*exp(-k*x)+',num2str(b)],'options',s);
            end
        case 2
            s = fitoptions('Method','NonlinearLeastSquares',...
                'Lower',[0.5, 0, 0],...   %0.5 and 0.2 are arbitrarily (while reasonably) assigned
                'Upper',[1, 0.1, Inf],... %2012-04-26 revised
                'Startpoint',[max(Ydata), 0, kStart],...
                'Display', 'off',...
                'Robust','on'); %2012-05-08 added this line //use 'on' or 'LAR'
            if HXdir==1 %H->D
                f = fittype('(a-b)*(1-exp(-k*x))+b','options',s);
            else %D->H
                f = fittype('(a-b)*exp(-k*x)+b','options',s);
            end
    end
    
    [cfun,gof,output] = fit(Xdata,Ydata,f);
    kFit=cfun.k;
    if flagBound==2
        a=cfun.a;
        b=cfun.b;
    end
    if max(Ydata)<0.5 || min(Ydata)>0.5 || max(Ydata)-min(Ydata)<0.4
        disp(' ')
        disp('Warning: may be unfittable!')
    end
    
    close all
    h=figure;
    
    %%%plot the D% of time points:
    semilogx(Xdata, Ydata, 'ro')
    hold on
    
    %%%plot horizonal D% line of FD ctrl:
    semilogx([min(Xdata), max(Xdata)], [Data(aaIndex,2), Data(aaIndex,2)], 'y:','LineWidth',1)
    hold on
    
    %%%plot intrinsic rate curve, fitted ex curve(red) and NMR ex curve(blue):
    kcHD=kchPro_HD(aaNum);
    kcDH=kchPro_DH(aaNum);
    if HXdir==1 %H->D
        fractionD=a;
        H0=1-b;
    else %D->H
        fractionD=b;
        H0=1-a;
    end
    [times_ch,Y] = ode15s(@(t,y)msdfit_hx2ode(t,y,kcHD,kcDH,fractionD),[0 max(Xdata)],[H0 1-H0]); %use msdfit_hx2ode.m
    times=0:(min(Xdata)/3):(max(Xdata)*3);
    if HXdir==1 %H->D
        semilogx(times_ch,(a-b)*(1-exp(-kchPro(aaNum)*times_ch))+b,'k--','LineWidth',1)
        hold on
        semilogx(times,(a-b)*(1-exp(-kFit*times))+b,'r--','LineWidth',2)
        hold on
    else %D->H
        semilogx(times_ch,(a-b)*exp(-kchPro(aaNum)*times_ch)+b,'k--','LineWidth',1)
        hold on
        semilogx(times,(a-b)*exp(-kFit*times)+b,'r--','LineWidth',2)
        hold on
    end
    hold on
    
    axis([min(times_ch), max(Xdata)*5, -0.05, 1.05])
    
    disp(['Residue #',num2str(aaNum),' fitted HX rate = ',num2str(kFit)])
    title({['Residue #',num2str(aaNum),': MSDFit kex=',num2str(kFit,'%3.2e')];...
        '(black=kch; red=MSDFit)'})
    xlabel('HX Time (sec)')
    ylabel('D Fraction')
end



