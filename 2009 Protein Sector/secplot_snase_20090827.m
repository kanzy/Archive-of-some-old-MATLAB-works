%%%2009-08-27 secplot.m: plot sectors and foldons along primary sequence;
%%%Protein sectors identified from aln.m(2009 Cell paper); Protein foldons
%%%identified experimentally from literature.

N_pos=149;  %protein length

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%plot sectors with conservation measure(relative entropy):

D_bin=[0.1474	0.056472	0.045454	0.061942	0.19718	0.046793	0.2282	0.3088	0.050678	0.050322	0.092364	0.31404	0.14598	1.0336	0.13494	0.24639	1.0715	0.29236	2.2755	2.4017	2.2509	1.6574	0.13928	0.13949	0.27189	0.043774	0.1208	0.13659	0.082112	0.06631	0.042432	0.13171	0.14907	0.21145	0.38775	1.3841	0.12234	0.8344	1.1846	2.0484	0.64074	2.754	2.0972	0.21901	0.20891	0.28695	0.1291	0.065225	0.04872	0.063476	0.11392	0.6335	0.64484	0.76884	1.5418	0.079984	0.78102	1.6086	0.16204	0.089552	0.45529	0.60314	0.39123	0.11285	0.16493	0.12779	0.074134	0.13103	0.041891	0.078808	0.050678	0.087184	0.17118	0.54498	0.15862	0.16188	0.18924	0.054686	0.14713	0.11116	0.091043	0.16805	2.4707	0.4106	2.3319	1.3329	2.2708	0.036295	0.48844	0.30642	0.51402	0.19888	0.22101	0.082546	0.38878	0.2481	0.049695	0.15096	0.076078	0.37749	0.17277	0.12645	0.64441	1.1394	0.37068	0.22466	2.3158	0.47319	1.7501	0.61559	0.50205	0.74457	0.24763	0.1059	0.90057	0.029618	0.12612	0.14888	0.26939	0.083197	0.17103	0.14301	0.08911	0.0041592	0.10389	0.057065	0.10358	0.5669	1.2094	0.12645	0.15247	2.1253	0.55088	0.13804	0.12594	0.52922	0.17717	1.1928	0.40392	3.7109	0.31596	0.067287	0.038658	0.063325	0.027378	0.041584	0.012777	0.01036	0.0472
];  %Relative entropies in the binary approximation

%%identified sectors:
sec_red=[19    21    22    40    43    53    85    87   107   109   115   122   128];
sec_green=[14	17	18	37	39	44	47	51	55	59	76	89	90	91	100	101	110	112	117	119];
sec_blue=[27	32	41	62	63	65	75	77	82	95	96	98	102	106	113	121	139];

bar(1:N_pos,D_bin,'k');
hold on

sizer=size(sec_red);
for i=1:sizer(2)
    bar(sec_red(i),D_bin(sec_red(i)),'r');
    hold on
end

sizer=size(sec_green);
for i=1:sizer(2)
    bar(sec_green(i),D_bin(sec_green(i)),'g');
    hold on
end

sizer=size(sec_blue);
for i=1:sizer(2)
    bar(sec_blue(i),D_bin(sec_blue(i)),'b');
    hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%plot foldons:

%%SNase foldons:
foldon_red=[36 39 110 111 125 126];
foldon_yellow=[24 26 32 34 66 67 129];
foldon_green=[102 105:109];
foldon_blue=[25 35 37 73 75 90:94 99:101 103 104];


sizer=size(foldon_red);
for i=1:sizer(2)
    plot(foldon_red(i),3.5,'*r');
    hold on
end

sizer=size(foldon_yellow);
for i=1:sizer(2)
    plot(foldon_yellow(i),3.5,'*y');
    hold on
end

sizer=size(foldon_green);
for i=1:sizer(2)
    plot(foldon_green(i),3.5,'*g');
    hold on
end

sizer=size(foldon_blue);
for i=1:sizer(2)
    plot(foldon_blue(i),3.5,'*b');
    hold on
end

axis([0 N_pos+1 0 4]);
xlabel('Residue Number');
ylabel('Conservation (Relative Entropy)');
set(gca,'YTick',[1 2 3])
title('Comparison of SNase Foldons and Sectors')
