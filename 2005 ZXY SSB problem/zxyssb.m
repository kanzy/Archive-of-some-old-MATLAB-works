%2005-12-19 zxyssb.m: Fitting the kinetic constants kf/ku & ka/kd of interaction between SSB
%protein and structured DNA in solution.

hold off
format short e

%//////////////////////////////////////////////////////////////////////////
global kf; 
global ku; 
global ka; 
global kd; 
global k_C;
global data;
global k_D;
global C0;
global Qt;
global Qtt;
global num;
global assTime
global stepTime
global ydata;
global sim;


C0 = input('Please input Concentration of SSB protein (M):\n');
num = input('Please input the number of different concentrations of DNA probe added:\n');
Qt = input('and the respectively added DNA concentration (M) as [Conc1 Conc2 Conc3 ...]:\n');
plot(data(:,1),data(:,2:(num+1)),'k')
hold on

assTime = input('Please input Association Time of experiment (sec):\n');
stepTime = input('Please input Steplength Time of data collection in experiment (sec):\n');

% k_C = input('Please input Fluorescence Coefficient of free SSB protein (1/M):\n');
% k_D = input('Please input Fluorescence Coefficient of bound SSB protein (1/M):\n');
k_C=1e8
k_D=4e7

inipara = input('Please input Inital fitting parameters of the rate constants as [kf ku ka kd]:\n');

%options=optimset('MaxIter',20);
[fitPara,r1,r2,exitFlag,output]=lsqnonlin(@zxyssb_fit,inipara,[0 0 0 0],[]);
output
disp('kf=')
disp(fitPara(1))
disp('ku=')
disp(fitPara(2))
disp('ka=')
disp(fitPara(3))
disp('kd=')
disp(fitPara(4))

    %//plot fitted Ass Curves:
    kf=fitPara(1);
    ku=fitPara(2);
    ka=fitPara(3);
    kd=fitPara(4);
    for i=1:num
        Qtt=Qt(i);   
        [t,y] = ode15s('zxyssb_ode',[0:stepTime:assTime],[(kf/(kf+ku))*Qtt (ku/(kf+ku))*Qtt k_C*C0]);
        fitAss(:,i)=y(:,3);
        plot(data(:,1),fitAss(:,i),'r')
        hold on
    end