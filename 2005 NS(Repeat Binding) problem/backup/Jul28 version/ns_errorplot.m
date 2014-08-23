%// According to the result of 2005-07-25 by Method C:

%// ku: 1e-6 to 1e0;
%// kf: 1e-4 to 1e2; 

ku=[-7:1];
kf=[-5:4];

%// The matrix is arranged by [ku * kf] ([row * col])
%//DATA as of 2005-07-28:
errorKf=[0.4556549	-0.01828868	1.050883	0.853524	0.5290253	0.4008993	-0.2923171	-0.07735259	-0.08184659	-0.03333071
0.673955	0.096910	-0.774690	0.245510	0.735600	0.394450	0.045323	-0.100730	-0.05862592	-0.05352101
0.2882167	0.064458	-0.468520	-0.630780	0.301030	0.164350	-0.083020	-0.032920	-0.05321444	-0.07833031
0.4275596	0.071882	-0.714440	-0.482800	-0.129010	-0.159890	-0.082494	-0.079877	-0.053860	-0.03176117
3.689644	-0.085657	-0.262010	-0.145090	-0.081970	0.075547	-0.346790	0.021189	-0.03613162	-0.07694759
4.298763	2.980000	-0.159270	0.025306	-0.076238	-0.012781	0.033424	-0.086716	-0.009310826	-0.04366663
4.493628	3.439300	2.238000	0.764920	0.0086002	-0.134300	0.056905	-0.055024	-0.1412561	-0.04932972
4.383855	3.406500	2.501100	1.633500	0.632460	0.178980	0.021189	-0.124360	-0.02013314	-0.2248939
4.706089	3.925650	2.924274	1.999337	1.073769	0.2343787	-0.02231845	-0.05066318	-0.02639482	-0.06389091 ];

errorKu=[0.5362648	0.613167	0.2987948	-1.405067	-1.227110	-1.284403	-0.063952	0.5518517	0.9380688	3.194912
0.6528928	0.113940	0.056905	0.060698	-1.452200	-1.806900	-1.712200	-0.179800	0.5593042	1.629744
0.2737039	0.041393	-0.421360	0.181840	0.511880	-1.847700	-2.406700	-1.545200	-0.01170274	0.08190268
0.3725587	0.049218	-0.730490	-0.446120	0.060698	0.350250	-1.785200	-1.882700	-1.669443	0.06129267
2.419885	-0.151810	-0.275720	-0.153660	-0.006564	0.164350	0.012837	-1.490800	-2.561650	-1.357599
2.205102	1.702400	-0.210420	0.008600	-0.012334	0.017033	0.075547	0.315970	-1.812377	-1.849725
1.329267	1.318100	1.204100	0.510550	-0.004804	0.064458	0.120570	0.012837	0.2561238	-2.021748
0.4368871	0.371070	0.397940	0.342420	0.328380	0.214840	0.127100	-0.061981	0.04754534	0.2192282
-0.06825384	0.02906619	0.002307435	-0.04037419	0.05707666	0.02668265	0.137355	0.05827748	0.01223896	-0.006997338  ];

        
%// Plot 3-D error gragh:
[X,Y]=meshgrid(kf,ku);

% subplot(1,2,1);
% meshc(X,Y,errorKf)
% ylabel('log(ku)');
% xlabel('log(kf)');
% zlabel('Error of kf');
% COLORBAR('horizon');
% 
% subplot(1,2,2);
% meshc(X,Y,errorKu)
% ylabel('log(ku)');
% xlabel('log(kf)');
% zlabel('Error of ku');
% COLORBAR('horizon');

% %//Contour Graph:
subplot(1,2,1);
[C,h]=contourf(X,Y,errorKf,12);
clabel(C);
ylabel('log(ku)');
xlabel('log(kf)');
COLORBAR('horiz');
title('Relative Error of kf ( log(fitted value/true value) )');

subplot(1,2,2);
[C,h]=contourf(X,Y,errorKu,20);
clabel(C);
ylabel('log(ku)');
xlabel('log(kf)');
COLORBAR('horiz');
title('Relative Error of ku ( log(fitted value/true value) )');









