
data=peptidesPool(:,4);

bins=250:50:1950;

figure

subplot(2,1,1)
hist(data,bins)
title('Peptide m/z Distribution')

n_elements = histc(data,bins);
c_elements = cumsum(n_elements);

subplot(2,1,2)
bar(bins,c_elements)
xlabel('m/z')
title('The Cumulative Distribution')




