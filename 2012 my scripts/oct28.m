
% [FileName,PathName] = uigetfile('*.xls','Select the Excel file');
% [num,txt,SequestOutput] = xlsread([PathName,FileName]);
            

figure
subplot(2,1,1)
ColorSet=colormap(jet);
for i=1:size(num,1)
    if isnan(num(i,3))
        stem(i, log10(1), 'fill', 'color', 'w', 'MarkerSize', 4, 'Marker','square')
        hold on
    else
        switch num(i,3)
            case 1
                stem(i, log10(1), 'fill', 'color', ColorSet(end,:), 'MarkerSize', 4, 'Marker','square')
            case 0
                stem(i, log10(1e-5), 'fill', 'color', ColorSet(1,:), 'MarkerSize', 4, 'Marker','square')
            otherwise
                useColor=round(((log10(num(i,3))-log10(1e-5))/(log10(1)-log10(1e-5)))*(size(ColorSet,1)-1)+1);
                stem(i, log10(num(i,3)), 'fill', 'color', ColorSet(useColor,:), 'MarkerSize', 4)
        end
        hold on
    end
    axis([0, 271, -5.25, 0.25])
end
ylabel('log_1_0(HX rate) (sec^-^1)')


subplot(2,1,2)
ColorSet=colormap(jet);
for i=1:size(num,1)
    if isnan(num(i,4))
%         stem(i, 0, 'fill', 'color', 'w', 'MarkerSize', 4, 'Marker','square')
%         hold on
    else
        SFmin=min(num(:,4));
        SFmax=max(num(:,4));
        useColor=round(((log10(num(i,4))-log10(SFmin))/(log10(SFmax)-log10(SFmin)))*(-61)+63);
        stem(i, log10(num(i,4)), 'fill', 'color', ColorSet(useColor,:), 'MarkerSize', 4)
        hold on
    end
    v=axis;
    axis([0, 271, 0, 5])
end
xlabel('Residue Number')
ylabel('log_1_0(Relative Slowing Factor)')


