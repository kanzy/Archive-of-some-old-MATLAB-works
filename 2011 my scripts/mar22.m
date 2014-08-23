

figure
for i=1:size(peptidesPool,1)
    plot(peptidesPool(i,2)-peptidesPool(i,1)+1,peptidesPool(i,9),'b*')
    hold on
end
ylabel('Matched B & Y Ions Number')
xlabel('Peptide Length')