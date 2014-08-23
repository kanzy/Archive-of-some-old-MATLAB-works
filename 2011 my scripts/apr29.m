
figure

Colors=colormap(Jet(149));
for i=1:149
    if kcHD(i)~=0
    points=0.95:-0.05:0.05;
        t=-log(points)/kcHD(i);
        semilogx(t,1-points,'color',Colors(i,:))
        hold on
        text(t(1),0.04,num2str(i),'color',Colors(i,:))
        hold on
        text(t(end),0.96,num2str(i),'color',Colors(i,:))
        hold on
    end
end
grid on

     
        