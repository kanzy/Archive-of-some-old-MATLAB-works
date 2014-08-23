% close all
% clear fitSettings fitResults

% global flagBXC %2012-01-06 added

% XN=input('Input how many N-term residues (XN) to be excluded (1 or 2): ');
XN=2

% disp(' ')
% disp('**********************************************************************************')
% disp(' ')
% disp('MSDFIT: HX-MS Single Residue Resolution Information Analysis Programs in MATLAB')
% disp(' ')
% disp('Kan Zhongyuan, Englander Lab')
% disp('University of Pennsylvania, 2011')
% disp(' ')
% disp('**********************************************************************************')
% 
% disp(' ')
% disp('Batch processing (HX time points) options:')
% disp(' ')
% disp('1: To fit for getting individual D% of HX sites (will generate "MSDFIT_batTable.xls")')
% disp('2: To plot residue HX curves from MSDFIT_batTable "Data"') %copy dec08.m(2011)
% disp('3: To further plot/fit each residue HX curve (by full model)') %copy dec14.m(2011)
% disp('4: To further plot/fit each residue HX curve (by single exponential)')
% disp(' ')
% % disp('(5: To prepare "MSDFIT_batTable.xls" from older version msdfit_bat result)') %end part of msdfit_bat.m(2012-01-15 added)
% % disp(' ')
% 
% flagBat=input('Input the number of choice: ');
% if flagBat~=1
%     msdfit_bat_post %call msdfit_bat_post.m for option 2~4
%     return
% end

disp(' ')
disp('Note: Right now ONLY for SNase analysis!')
SNase='ATSTKKLHKEPATLIKAIDGDTVKLMYKGQPMTFRLLLVDTPETKHPKKGVEKYGPEASAFTKKMVENAKKIEVEFDKGQRTDKYGRGLAYIYADGKMVNEALVRQGLAKVAYVYKGNNTHEQLLRKSEAQAKKEKLNIWSEDNADSGQ';
proSeq=SNase;
%%%John's new NMR list (2011-11)
logPfList=[NaN;-1.10000000000000;NaN;NaN;0.429410000000000;NaN;0.375410000000000;0.189240000000000;0.878810000000000;3.90090000000000;NaN;4.95240000000000;4.36830000000000;1.37450000000000;5.04190000000000;4.18730000000000;1.01040000000000;NaN;4.16250000000000;1.33000000000000;4.60330000000000;4.68360000000000;4.98910000000000;6.70860000000000;7.54850000000000;6.86040000000000;4.59870000000000;0.488430000000000;1.17030000000000;5.17320000000000;NaN;6.96000000000000;1.09490000000000;7.48470000000000;7.61880000000000;6.37000000000000;7.30250000000000;NaN;5.95000000000000;4.76560000000000;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;1.91960000000000;3.08060000000000;NaN;4.44210000000000;5.73310000000000;6.69750000000000;6.73490000000000;6.56940000000000;6.96530000000000;7.20000000000000;2.34760000000000;3.94720000000000;1.70400000000000;3.79000000000000;1.57990000000000;7.54930000000000;5.77700000000000;7.64570000000000;3.88210000000000;4.61430000000000;NaN;NaN;0.0606400000000000;NaN;2.93040000000000;4.35310000000000;NaN;NaN;2.75450000000000;4.61440000000000;4.91390000000000;5.08000000000000;7.48710000000000;7.65730000000000;7.51390000000000;7.53130000000000;7.64170000000000;4.41690000000000;1.25620000000000;5.74030000000000;0.280000000000000;7.32170000000000;7.48320000000000;7.60360000000000;7.13410000000000;7.35800000000000;7.22730000000000;7.17110000000000;7.38330000000000;7.12160000000000;6.56730000000000;7.03540000000000;5.77000000000000;5.90380000000000;4.38200000000000;NaN;NaN;NaN;NaN;NaN;NaN;1.70470000000000;2.89300000000000;NaN;4.68100000000000;0.198310000000000;1.25000000000000;6.08000000000000;6.29000000000000;4.23550000000000;4.75880000000000;NaN;6.04690000000000;4.79340000000000;6.51610000000000;6.21040000000000;5.51910000000000;5.01750000000000;5.05640000000000;5.23140000000000;2.56880000000000;5.04900000000000;4.80280000000000;4.49810000000000;NaN;NaN;0.474490000000000;0.0913190000000000;0.162110000000000;-0.216740000000000;0.316960000000000;-0.352490000000000;];


% disp(' ')
% disp('The program needs "batAnalyName" and "Data"(should be (auto) prepared from MSDFIT_batTable.xls).')
% dataOption=input('Input (0=they are in workspace now, 1=to auto make, 2=to manual make): ');
% switch dataOption
%     case 0
%         %do nothing
%     case 1 %2012-05-03 added auto routine
%         disp(' ')
%         disp('Select the MSDFIT_batTable.xls file...');
%         [FileName,PathName] = uigetfile('*.xls','Select the XLS file');
%         batAnalyName=FileName(find(FileName=='(')+1:find(FileName==')')-1);
%         msdfitBatTable = xlsread([PathName FileName],1);
%         disp(' ')
% %         HXtimes=input('Input the HX time points in seconds (e.g. [60 300 1500 6000 26220 107700 259200 518400 1229400 2339400]): ');
%         HXtimes=input('Input the HX time points in seconds (e.g. [12 30 67 151 339 763 3826 14820 61980]): ');
%         while size(HXtimes,2)~=size(msdfitBatTable,2)/3-1
%             disp('Wrong input! Not match with msdfitBatTable size')
%             HXtimes=input('Input again: ');
%         end
%         %%%determine "Data" first column:
%         aaSet=msdfitBatTable(:,1);
%         for i=2:size(msdfitBatTable,2)/3
%             for j=1:size(msdfitBatTable,1)
%                 aa=msdfitBatTable(j,(i-1)*3+1);
%                 x=find(aa==aaSet);
%                 if min(size(x))==0
%                     aaSet=[aaSet;aa];
%                 end
%             end
%         end
%         aaSet=sort(aaSet);
%         if max(aaSet)>149 %check for SNase
%             error('AA number exceeds SNase size!')
%         end
%         n=1;
%         for i=1:size(aaSet,1)
%             if aaSet(i)<=0
%                 n=i;
%             else
%                 break
%             end
%         end
%         aaSet=aaSet(n+1:end);
%         Data=NaN*zeros(size(aaSet,1)+1,size(msdfitBatTable,2)/3+1);
%         Data(:,1)=[0; aaSet];
%         Data(1,:)=[0,0,HXtimes];
%         %%%Fill 'Data' with sorted number according to 'logPfList':
%         for sampleNum=1:size(msdfitBatTable,2)/3
%             rawData=msdfitBatTable(:,(sampleNum-1)*3+1:sampleNum*3);
%             %%%for single residue resolved:
%             for i=1:size(rawData,1)
%                 if rawData(i,1)>0 && rawData(i,3)==0
%                     Data(find(rawData(i,1)==Data(:,1)),sampleNum+1)=rawData(i,2);
%                 end
%             end
%             %%%for switchable residues (groups):
%             maxGrpNum=max(rawData(:,3));
%             if maxGrpNum>0
%                 for grpNum=1:maxGrpNum
%                     currGrp=rawData(find(rawData(:,3)==grpNum),:);
%                     cmpMatrix=[currGrp(:,1), logPfList(currGrp(:,1))];
%                     for i=1:size(cmpMatrix,1)
%                         if isnan(cmpMatrix(i,2))
%                             cmpMatrix(i,2)=-Inf; %convert NMR undeterimned NaN(usually very fast ex) to smallest value.
%                         end
%                     end
%                     cmpMatrix=sortrows(cmpMatrix,2);
%                     cmpMatrix=[cmpMatrix, sort(currGrp(:,2))];
%                     for i=1:size(cmpMatrix,1)
%                         Data(find(cmpMatrix(i,1)==Data(:,1)),sampleNum+1)=cmpMatrix(i,3);
%                     end
%                 end
%             end
%         end
%         
%     case 2 %the old code (before 2012-05-03):
%         disp(' ')
%         batAnalyName=input('Input the batAnalyName (e.g. "Feb27_1to61_XN1_FL2_Algo1_BXC"): ','s');
%         disp(' ')
%         disp('Make sure the variable "Data" has been prepared in the corresponding MSDFIT_batTable.xls')
%         disp('("Data" format-- col1:residue number; col2:allD result; col3+:time points results; row1:HX time(sec))')
%         Data=input('Now input "Data" in [ ]: ');
%         
%     otherwise
%         error('Wrong input!')
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 

disp(' ')
flag=input('The needed variables in workspace? (1=yes, 0=no): ');
if flag==0
disp('Now import the previously saved _exFitResults.mat...')
uiimport
void=input('Press "Enter" to continue...'); %just waiting for manual inspect
end
    

disp(' ')
        HXdir=2 %input('Input the HX direction (1=H->D; 2=D->H): ');
        %         HXratio=0.1 %input('Input the fraction of D2O (0~1) in HX buffer: ');
        %         HXallD=0.95 %input('Input the fraction of D (0~1) in FD(all-D) sample: '); %'HXratio' and 'HXallD' should be same or not necessary?
        HXtemp=20 %input('Input the HX experiment temperature("C): ');
%         if HXdir==1 %H->D
%             HXpH=input('Input the effective pH value (e.g. pDread+0.4) in HX buffer: ');
%         else %D->H
%             HXpH=input('Input the pH value in HX buffer: ');
%         end
disp(' ')
HXpH
        kchPro_HD = fbmme_hd(proSeq, HXpH, HXtemp, 'poly', 0); %call fbmme_hd.m
        kchPro_DH = fbmme_dh(proSeq, HXpH, HXtemp, 'poly'); %call fbmme_dh.m
        if HXdir==1 %H->D
            kchPro = kchPro_HD;
        else %D->H
            kchPro = kchPro_DH;
        end
        
%         exFitResults={};
%         exFitTable=[];
%         M=0;
%         for aaNum=Data(2,1):Data(end,1)
aaNum=input('Input aaNum: ');

            disp(' ')
            disp('*******************************************************')
            disp(['Now plot/analyze residue # ',num2str(aaNum),' ...'])
            aaIndex=find(aaNum==Data(:,1));
            if min(size(aaIndex))==0
                disp(' ')
                disp('Because it was not fitted, no plot for it.')
                %continue
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
                disp('Too few valid data points for ex rate fitting. Skipped')%
                %continue
            end
            
%             M=M+1;
M=find(aaNum==exFitTable(:,1));
            
            kNMR=kchPro(aaNum)/(10^(logPfList(aaNum)));
            kStart=min(kNMR, kchPro(aaNum))*1e-8;
            
            %%%2012-05-14 revised:
            s = fitoptions('Method','NonlinearLeastSquares',...
                'Lower',[0],...
                'Upper',[Inf],... %2012-04-26 revised
                'Startpoint',[kStart],...
                'Display', 'off',...
                'Robust','LAR'); %2012-05-08 added this line //use 'on' or 'LAR'
            f = fittype('(0.9-0.09)*exp(-k*x)+0.09','options',s); 
            %Xdata=Xdata(2:end); Ydata=Ydata(2:end); %2012-05-24 for pH4.2-aa#7 one time use
            [cfun,gof,output] = fit(Xdata,Ydata,f);
            a=0.9;
            b=0.09;
            kFit=cfun.k;
            if max(Ydata)<0.5 || min(Ydata)>0.5 || max(Ydata)-min(Ydata)<0.4
                disp(' ')
                disp('Warning: may be unfittable!')
            end
            disp(' ')
            kStart
            disp(' ')
            gof
            
            %close all
            h=figure;
            
            %%%plot the D% of time points:
            semilogx(Xdata, Ydata, 'ro')
            hold on
            
            %%%plot horizonal D% line of FD ctrl:
            semilogx([min(Xdata), max(Xdata)], [Data(aaIndex,2), Data(aaIndex,2)], 'y:','LineWidth',1)
            hold on
            
            %%%plot intrinsic rate curve:
            kcHD=kchPro_HD(aaNum);
            kcDH=kchPro_DH(aaNum);
            [times_ch,Y] = ode15s(@(t,y)msdfit_hx2ode(t,y,kcHD,kcDH,0.1),[0 max(Xdata)],[0.05 0.95]); %use msdfit_hx2ode.m
            %             corrY=Y(:,2)*(Data(aaIndex,2)/HXallD);  %(corrected by FD ctrl)
            %             semilogx(T,corrY,'k--')
            %             hold on
            semilogx(times_ch,(a-b)*exp(-kchPro(aaNum)*times_ch)+b,'k--','LineWidth',1)
            hold on
            
            %%%plot fitted ex curve(red) and NMR ex curve(blue):
            times=0:(min(Xdata)/3):(max(Xdata)*3);
            semilogx(times,(a-b)*exp(-kFit*times)+b,'r--','LineWidth',2)
            hold on
            semilogx(times,(a-b)*exp(-kNMR*times)+b,'b--','LineWidth',2)
            hold on
            
            axis([min(times_ch), max(Xdata)*5, -0.05, 1.05])
            
            disp(['Residue #',num2str(aaNum),' fitted HX rate = ',num2str(kFit)])
            title({['Residue #',num2str(aaNum),': NMR kex=',num2str(kNMR,'%3.2e'),' // MSDFIT kex=',num2str(kFit,'%3.2e')];...
                '(black=kch; blue=NMR; red=MSDFIT)'})
            xlabel('HX Time (sec)')
            ylabel('D Fraction')
            
            SaveFigureName=['(',batAnalyName,')_exFit_Residue#',num2str(aaNum),'(May14rev).fig'];
            saveas(figure(h),SaveFigureName)
            disp(' ')
            disp([SaveFigureName,' has been saved in MATLAB current directory!'])
            disp(' ')
%             void=input('Press "Enter" to continue...'); %just waiting for manual inspect
            
            %%%save this residue result:
            exFitResults{M,1}={cfun,gof,output};
            exFitTable(M,1)=aaNum;
            exFitTable(M,2)=kchPro(aaNum);
            exFitTable(M,3)=kNMR;
            exFitTable(M,4)=kFit;
            exFitTable(M,5)=gof.rsquare; %2012-05-08 added
            if max(Ydata)<0.5 || min(Ydata)>0.5
                exFitTable(M,6)=0; %incomplete HX transition coverage. 2012-05-14 added
            else
                exFitTable(M,6)=1;
            end

%         
        %%%save 'exFitTable' etc:
        disp(' ')
        SaveFileName=['(',batAnalyName,')_exFitResults(May14rev).mat'];
        save(SaveFileName,'flagBat', 'batAnalyName', 'proSeq', 'Data', 'kchPro',...
            'HXdir', 'HXtemp', 'HXpH', 'exFitResults', 'exFitTable')
        disp(' ')
        disp([SaveFileName,' has been saved in MATLAB current directory for later use!'])
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

