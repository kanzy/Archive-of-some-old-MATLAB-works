
figure

subplot(2,1,1)

Charge=2;
maxPlus=19;
monoMZ=897.4951;

for i=0:1:maxPlus

stem(monoMZ+deltamass(i)/Charge, 2, 'ro')
hold on

stem(monoMZ+deltamass(i)/Charge, 1, 'bo')
hold on

end

text(monoMZ+deltamass(i)/Charge+0.1, 2, '61--75 +2','FontWeight','bold','FontSize',8,'color','r');
text(monoMZ+deltamass(i)/Charge+0.1, 1, '62--76 +2','FontWeight','bold','FontSize',8,'color','b');


set(gca,'ytick',[])
v=axis;
axis([monoMZ+deltamass(-2)/Charge, monoMZ+deltamass(maxPlus+2)/Charge, 0, v(4)*1.2])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2)

Charge=4;
maxPlus=31;
monoMZ=790.1816;
for i=0:1:maxPlus
stem(monoMZ+deltamass(i)/Charge, 3, 'ro')
hold on
end
text(monoMZ+deltamass(i)/Charge+0.1, 3, '34--61 +4','FontWeight','bold','FontSize',8,'color','r');


Charge=4;
maxPlus=33;
monoMZ=789.6712;
for i=0:1:maxPlus
stem(monoMZ+deltamass(i)/Charge, 2, 'bo')
hold on
end
text(monoMZ+deltamass(i)/Charge+0.1, 2, '62--88 +4','FontWeight','bold','FontSize',8,'color','b');
x=monoMZ+deltamass(i)/Charge+0.1;

Charge=3;
maxPlus=23;
monoMZ=790.0763;
for i=0:1:maxPlus
stem(monoMZ+deltamass(i)/Charge, 1, 'ko')
hold on
end
text(x, 1, '39--60 +3','FontWeight','bold','FontSize',8,'color','k');


xlabel('m/z')
set(gca,'ytick',[])

v=axis;
axis([monoMZ+deltamass(-3)/Charge, monoMZ+deltamass(maxPlus+4)/Charge, 0, v(4)*1.2])















