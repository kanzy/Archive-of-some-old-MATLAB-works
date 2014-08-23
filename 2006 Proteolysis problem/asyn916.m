
options=optimset('MaxIter',30);

x0=[0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.001]      
format short e
[fitPara,r1,r2,exitFlag,output]=lsqnonlin(@asyn916_fit,x0,zeros(1,11),ones(1,11),options)
format short