%%%2010-09-28 major revised
%%%2010-05-20 exms_fits.m: changed to current name
%%%2010-01-14&15 revised
%%%2010-01-11 newdxms_fits.m: big revision -- change input & disgard using DM
%%%2010-01-06 newdxms_fits.m: modify gaussbinofits.m for newdxms.m use
%%%2009-11-23 gaussbinofits.m: replace Poisson by Binomial
%%%2009-11-19 gausspoissfits.m: add poisson fit
%%%2009-11-16 gussianfits.m: can be called by dxmscheck.m & dxmscheck_pepscanview.m etc.

% function FitsResult=exms_fits(selectPeaks, ifPlot, flagND)
% 
% global peptide programSettings

selectPeaks=selectPeaks1;
ifPlot=1;



distND=peptide.distND;
maxND=peptide.main(1,5);
maxD=peptide.main(1,6);

fitAlgo=programSettings.fitAlgo; %1=Gaussians; 2=Binomials (both just for D sample fitting)

%%%size check and prepare Xdata & Ydata:
switch flagND
    case 0 %D sample
        if size(selectPeaks,1)~=1+maxND+maxD
            error('Sizes of the input "maxND", "maxD" and "selectPeaks" NOT match!')
        end
        Xdata=(0:(maxND+maxD))'; %set x-axis data scale to 0~(maxC+maxD)
    case 1 %allH sample
        if size(selectPeaks,1)~=1+maxND
            error('Sizes of the input "maxND" and "selectPeaks" NOT match!')
        end
        Xdata=(0:maxND)';
        distND=distND';
end
Ydata=selectPeaks(:,2); %keep original scale for D(by Gaussians) and ND fittings


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flagND~=1 %for D sample
    if ifPlot==1
        stem(Xdata,selectPeaks(:,2),'k')
        hold on
    end
    
    switch fitAlgo
        case 1 %by Gaussians
            distND=[distND, zeros(1,maxD)]';
            peakND=mean(find(distND==max(distND))); %2010-09-24 added
            muLb=peakND;
            muUb=(peakND+maxD);
            sigmaLb=2;   %avoid fitting one isotope peak
            sigmaUb=(maxND+maxD)/4; %about 6*sigma width
            if sigmaLb>=sigmaUb
                sigmaUb=sigmaLb+0.1;
            end
            AmpUb=max(Ydata);
            if AmpUb<=0
                AmpUb=0.1;
            end
            
            adjrsquares=[0 0]; %for comparison of diff Gaussians fittings
            rsquares=[0 0]; %2011-05-20 added
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%Fit 1: double Gaussian
            bestFitVal1=zeros(1,6);
            if size(selectPeaks,1)>=6 %need at least 6 data points to determine 6 coefficients.
                s = fitoptions('Method','NonlinearLeastSquares',...
                    'Lower',[0 muLb sigmaLb 0 muLb sigmaLb],...
                    'Upper',[AmpUb muUb sigmaUb AmpUb muUb sigmaUb],...
                    'Startpoint',[AmpUb, (muLb+muUb)/2, (sigmaLb+sigmaUb)/2, AmpUb, (muLb+muUb)/2, (sigmaLb+sigmaUb)/2],...
                    'Display', 'off');
                f = fittype('p1*exp(-((x-p2)/p3)^2)+p4*exp(-((x-p5)/p6)^2)','options',s);
                [cfun,gof] = fit(Xdata,Ydata,f);
                adjrsquares(1)=gof.adjrsquare;
                rsquares(1)=gof.rsquare;
                if ifPlot==1
                    plot(Xdata, (cfun.p1*exp(-((Xdata-cfun.p2)/cfun.p3).^2) + cfun.p4*exp(-((Xdata-cfun.p5)/cfun.p6).^2)),'m')
                    hold on
                end
                bestFitVal1=[cfun.p1, cfun.p2, cfun.p3, cfun.p4, cfun.p5, cfun.p6];  %2010-04-04 added
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%Fit 2: single Gaussian + allH spectrum
            if max(adjrsquares)<0.75 %do this only if Fit 1 is bad, 0.75 is arbitrary set (2011-02-27)
                bestFitVal2=zeros(1,6);
                if size(selectPeaks,1)>=4 %need at least 4 data points to determine 4 coefficients.
                    s = fitoptions('Method','NonlinearLeastSquares',...
                        'Lower',[0 muLb sigmaLb 0],...
                        'Upper',[AmpUb muUb sigmaUb Inf],...
                        'Startpoint',[AmpUb, (muLb+muUb)/2, (sigmaLb+sigmaUb)/2, AmpUb],...
                        'Display', 'off');
                    f = fittype('p1*exp(-((x-p2)/p3)^2)+p4*distND','options',s, 'problem',{'distND'});
                    [cfun,gof] = fit(Xdata,Ydata,f,'problem',{distND});
                    adjrsquares(2)=gof.adjrsquare;
                    rsquares(2)=gof.rsquare;
                    if ifPlot==1
                        plot(Xdata, (cfun.p1*exp(-((Xdata-cfun.p2)/cfun.p3).^2)+cfun.p4*distND),'y')
                        hold on
                    end
                    bestFitVal2=[cfun.p1, cfun.p2, cfun.p3, cfun.p4, 0, 0];  %2010-04-04 added
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            FitsResult.bestFitAdjrsquare=max(adjrsquares);
            bestFitType=find(FitsResult.bestFitAdjrsquare==adjrsquares); %may be more than 1 found.
            FitsResult.bestFitRsquare=rsquares(bestFitType);
            FitsResult.bestFitType=bestFitType(1); %2010-04-04 added
            switch bestFitType(1)
                case 1
                    FitsResult.bestFitVal=bestFitVal1;
                case 2
                    FitsResult.bestFitVal=bestFitVal2;
                otherwise
                    FitsResult.bestFitVal=zeros(1,6);
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 2 %by Binomials
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%Fit 3: double binomial
            AmpUb=max(Ydata)*maxD;
            if AmpUb<=0
                AmpUb=0.1;
            end
            
            p0=[AmpUb, 0.4, 2*AmpUb, 0.6];
            lb=[0 1e-3 0 1e-3];
            ub=[Inf 0.999 Inf 0.999];
            options=optimset('Display','off','FunValCheck','on');
            f = @(p)exms_fits_fit3(p, Ydata, distND, maxD); %use simfit1_fita.m
            [pFit,resnorm] = lsqnonlin(f,p0,lb,ub,options); %use MATLAB nonlinear least-squares curve fitting
            p1=pFit(1);
            p2=pFit(2);
            p3=pFit(3);
            p4=pFit(4);
            
            FitsResult.bestFitRsquare=rsq(Ydata, resnorm); %call my rsq.m 2011-05-20 added
            FitsResult.bestFitAdjrsquare=adjrsq(Ydata, 4, resnorm); %call my adjrsq.m
            FitsResult.bestFitType=3;
            FitsResult.bestFitVal=[p1, p2, p3, p4, 0, 0];
            
            if ifPlot==1
                plot(Xdata, p1*conv(distND, binopdf(0:maxD,maxD,p2))+p3*conv(distND, binopdf(0:maxD,maxD,p4)),'m')
                hold on
            end
            
            %             %%%////////////////////////////////////////////////////////////
            %             %%%2010-09-28 the previous "fit" version:
            %             s = fitoptions('Method','NonlinearLeastSquares',...
            %                 'Lower',[0 0 0 0],...
            %                 'Upper',[Inf 1 Inf 1],...
            %                 'Startpoint',[AmpUb, 0.4, AmpUb*2, 0.6],...
            %                 'Display', 'off');
            %             f = fittype('0*x+p1*ctranspose(conv(distND, binopdf(0:maxD,maxD,p2)))+p3*ctranspose(conv(distND, binopdf(0:maxD,maxD,p4)))',...
            %                 'options',s, 'problem',{'distND','maxD'});
            %             [cfun,gof] = fit(Xdata,Ydata,f,'problem',{distND,maxD});
            %
            %             FitsResult.bestFitAdjrsquare=gof.adjrsquare;
            %             FitsResult.bestFitType=3;
            %             FitsResult.bestFitVal=[cfun.p1, cfun.p2, cfun.p3, cfun.p4, 0, 0];
            %
            %             if ifPlot==1
            %                 plot(Xdata, cfun.p1*conv(distND, binopdf(0:maxD,maxD,cfun.p2))+cfun.p3*conv(distND, binopdf(0:maxD,maxD,cfun.p4)),'m')
            %                 hold on
            %             end
            %             %%%////////////////////////////////////////////////////////////
            %
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 3 %by Polynomial
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%Fit 5: polynomial (8th-order as default)
            if size(selectPeaks,1)>=9                
%                 s = fitoptions('Method','NonlinearLeastSquares',...
%                    'Startpoint',zeros(1,9),...
%                    'Display', 'off');
%                 f = fittype('p1*x.^8+p2*x.^7+p3*x.^6+p4*x.^5+p5*x.^4+p6*x.^3+p7*x.^2+p8*x+p9','options',s);
%                 [cfun,gof] = fit(Xdata,Ydata,f);
                [cfun,gof] = fit(Xdata,Ydata,'poly8');
                FitsResult.bestFitVal=[cfun.p1, cfun.p2, cfun.p3, cfun.p4, cfun.p5, cfun.p6];
                if ifPlot==1
                    plot(Xdata, cfun.p1*Xdata.^8+cfun.p2*Xdata.^7+cfun.p3*Xdata.^6+cfun.p4*Xdata.^5+...
                        cfun.p5*Xdata.^4+cfun.p6*Xdata.^3+cfun.p7*Xdata.^2+cfun.p8*Xdata+cfun.p9,'m');
                    hold on
                end
            else
                if size(selectPeaks,1)>=7
                    [cfun,gof] = fit(Xdata,Ydata,'poly6');
                    FitsResult.bestFitVal=[cfun.p1, cfun.p2, cfun.p3, cfun.p4, cfun.p5, cfun.p6];
                    if ifPlot==1
                        plot(Xdata, cfun.p1*Xdata.^6+cfun.p2*Xdata.^5+cfun.p3*Xdata.^4+cfun.p4*Xdata.^3+...
                            cfun.p5*Xdata.^2+cfun.p6*Xdata+cfun.p7,'m');
                        hold on
                    end
                else
                    [cfun,gof] = fit(Xdata,Ydata,'poly4');
                    FitsResult.bestFitVal=[cfun.p1, cfun.p2, cfun.p3, cfun.p4, cfun.p5, 0];
                    if ifPlot==1
                        plot(Xdata, cfun.p1*Xdata.^4+cfun.p2*Xdata.^3+cfun.p3*Xdata.^2+cfun.p4*Xdata+cfun.p5,'m');
                        hold on
                    end
                end
            end
            FitsResult.bestFitRsquare=gof.rsquare;
            FitsResult.bestFitAdjrsquare=gof.adjrsquare;
            FitsResult.bestFitType=5;
            
        otherwise
            error('Unknown type of fitting algorithm!')
    end
    
    
    if ifPlot==1
        axis([-1, (maxND+maxD+1), 0, max(1,max(Ydata)*1.1)]);
        xlabel('delta Mass(above monoisotopic)');
        ylabel('Peak Intensity');
        v=axis;
        text(v(2)*0.8, v(4)*0.8, ['Fit R^2=', num2str(FitsResult.bestFitRsquare,'%5.4f')], 'FontSize',8);
        text(v(2)*0.8, v(4)*0.7, ['Fit adjR^2=', num2str(FitsResult.bestFitAdjrsquare,'%5.4f')], 'FontSize',8);
        switch FitsResult.bestFitType
            case 1
                title('Deuterated Sample Fitting (magenta=2Gauss; yellow=Gauss+allH)');
                text(v(2)*0.8, v(4)*0.9, 'Best Fit Type="2Gauss"','FontSize',8);
            case 2
                title('Deuterated Sample Fitting (magenta=2Gauss; yellow=Gauss+allH)');
                text(v(2)*0.8, v(4)*0.9, 'Best Fit Type="Gauss+allH"','FontSize',8);
            case 3
                title('Deuterated Sample Fitting');
                text(v(2)*0.8, v(4)*0.9, 'Fit Type="2Binomials"','FontSize',8);
            case 5
                title('Deuterated Sample Fitting');
                text(v(2)*0.8, v(4)*0.9, 'Fit Type="Polynomial"','FontSize',8);
        end
    end
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else %for ND(allH) sample, only Fit4(Binomial) apply:
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Fit 4: allH spectrum
    AmpUb=max(Ydata)/max(distND);
    if AmpUb<=0
        AmpUb=0.1;
    end
    
    s = fitoptions('Method','NonlinearLeastSquares',...
        'Lower',0,...
        'Upper',Inf,...
        'Startpoint',AmpUb,...
        'Display', 'off');
    f = fittype('p1*(0*x+distND)','options',s, 'problem',{'distND'});
    [cfun,gof] = fit(Xdata,Ydata,f,'problem',{distND});
    
    FitsResult.bestFitAdjrsquare=gof.adjrsquare;
    FitsResult.bestFitRsquare=gof.rsquare; %2011-05-20 added
    FitsResult.bestFitType=4; %2010-04-26 added
    FitsResult.bestFitVal=[0 0 0 cfun.p1 0 0]; %2010-04-26 added
    
    if ifPlot==1
        stem(Xdata,Ydata,'k')
        hold on
        plot(Xdata, cfun.p1*distND,'y')
        hold on
        axis([-1, (maxND+1), 0, max(1,max(Ydata)*1.1)]);
        xlabel('delta Mass(above monoisotopic)');
        ylabel('Peak Intensity');
        title('all-H(ND) Sample Fitting');
        v=axis;
        text(v(2)*0.8, v(4)*0.9, 'Fit Type="allH"','FontSize',8);
        text(v(2)*0.8, v(4)*0.8, ['Fit R^2=', num2str(FitsResult.bestFitRsquare,'%5.4f')], 'FontSize',8);  %2011-05-20 added
        text(v(2)*0.8, v(4)*0.7, ['Fit adjR^2=', num2str(FitsResult.bestFitAdjrsquare,'%5.4f')], 'FontSize',8);
    end
    
end













