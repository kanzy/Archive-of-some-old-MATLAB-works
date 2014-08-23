%%%2009-08-27 secplot.m: plot sectors and foldons along primary sequence;
%%%Protein sectors identified from aln.m(2009 Cell paper); Protein foldons
%%%identified experimentally from literature.

N_pos=105;  %protein length

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%plot sectors with conservation measure(relative entropy):

D_bin=[0.25166	0.52756	0.29894	0.032719	0.0753	0.31924	0.52056	0.2551	0.34128	0.27069	1.8344	0.47766	0.13989	0.71436	3.3676	0.4944	0.74444	3.4658	3.5542	0.8546	0.67638	0.58744	0.35765	1.1829	0.40296	0.32719	0.8532	1.146	0.56694	2.5216	2.879	1.0788	2.2263	0.48847	1.8814	0.31116	0.79741	1.962	2.0845	0.50085	0.15612	1.3647	0.39509	0.34324	0.088369	0.88	0.29758	0.23936	2.9816	1.0867	0.64745	1.5313	0.80785	0.97209	0.33715	0.50085	0.84287	0.23467	0.26128	4.2616	0.31541	0.69353	0.27794	0.76841	1.491	0.16715	0.3229	1.5065	1.5137	0.383	1.1055	2.3771	1.1329	0.77712	1.1676	0.84651	1.3427	1.5842	0.69934	1.3545	3.2945	0.11974	2.0989	0.62569	1.8726	0.16844	0.72243	0.64854	0.35768	0.19607	0.63409	0.69068	0.10548	0.57393	1.2583	0.58247	0.297	0.89414	0.37786	0.44589	0.059864	0.23764	0.35351	0.026203	0.0045104
];  %Relative entropies in the binary approximation

%%identified sectors:
sec_red=[14	15	18	19	69	72	73	75	77	78	81	83	85	95];
sec_green=[11	28	39	47	49	62	68	71	80	86	87	88	89	90	92	94	96	98];
sec_blue=[7	17	27	35	37	38	42	46	53	64];

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

%%Cytochrome-c foldons:
foldon_red=[71:85 90];
foldon_yellow=[37:40 42:43 58:61 63:64];
foldon_green=[65:69 19:36];
foldon_blue=[6:15 91:103];

sizer=size(foldon_red);
for i=1:sizer(2)
    plot(foldon_red(i),5,'*r');
    hold on
end

sizer=size(foldon_yellow);
for i=1:sizer(2)
    plot(foldon_yellow(i),5,'*y');
    hold on
end

sizer=size(foldon_green);
for i=1:sizer(2)
    plot(foldon_green(i),5,'*g');
    hold on
end

sizer=size(foldon_blue);
for i=1:sizer(2)
    plot(foldon_blue(i),5,'*b');
    hold on
end

axis([0 N_pos+1 0 5.5]);
xlabel('Residue Number');
ylabel('Conservation (Relative Entropy)');
set(gca,'YTick',[1 2 3 4])
title('Comparison of Cyt-c Foldons and Sectors')
