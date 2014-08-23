%// According to the result of 2005-07-25 by Method C:

%// ku: 1e-6 to 1e0;
%// kf: 1e-4 to 1e2; 

ku=[-6:0];
kf=[-4:2];

%// The matrix [logkf] or [logku] is arranged by [ku * kf] ([row * col])
fitKf=[ -3.903090	-3.774691	-1.754487	-0.2644011	0.3944517	1.045323	1.899273
-3.935542	-3.468521	-2.630784	-0.698970	0.1643529	0.9169801	1.967080
-3.928118	-3.714443	-2.482804	-1.129011	-0.1598939	0.9175056	1.920123
-4.085657	-3.262013	-2.145087	-1.081970	0.07554698	0.6532125	2.021189
-1.019997	-3.159267	-1.974694	-1.076238	-0.01278076	1.033424	1.913284
-0.5606673	-0.7619539	-1.235077	-0.9913998	-0.1343039	1.056905	1.944976
-0.5934598	-0.4989407	-0.3665316	-0.3675427	0.1789769	1.021189	1.875640]

fitKu=[ -5.886056	-5.943095	-5.939302	-7.452225	-7.806875	-7.712198	-6.179799
-4.958607	-5.421361	-4.818156	-4.488117	-6.847712	-7.406714	-6.545155
-3.950782	-4.730487	-4.446117	-3.939302	-3.649752	-5.785156	-5.882729
-3.151811	-3.275724	-3.153663	-3.006564	-2.835647	-2.987163	-4.490798
-0.2975695	-2.210419	-1.991400	-2.012334	-1.982967	-1.924453	-1.684030
0.3180633	0.204120	-0.489455	-1.004804	-0.935542	-0.8794261	-0.9871628
0.3710679	0.397940	0.3424227	0.3283796	0.2148438	0.1271048	-0.06198091]

trueKf=[kf;kf;kf;kf;kf;kf;kf]           %// a combination of size(ku) of kf.
trueKu=[ku',ku',ku',ku',ku',ku',ku']    %// a combination of size(kf) of ku'.

%// calculate the error of kf and ku relative to their true value in a LOG manner:
errorKf=fitKf-trueKf
errorKu=fitKu-trueKu
        
%// Plot 3-D error gragh:
[X,Y]=meshgrid(flipdim(ku,2),flipdim(kf,2));

subplot(1,2,1);
meshc(X,Y,errorKf)
xlabel('log(ku)');
ylabel('log(kf)');
zlabel('Error of kf');
COLORBAR('horizon');

subplot(1,2,2);
meshc(X,Y,errorKu)
xlabel('log(ku)');
ylabel('log(kf)');
zlabel('Error of ku');
COLORBAR('horizon');













