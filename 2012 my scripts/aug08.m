%%%revised from may24.m for Figure 9
%%%modified from may22.m


figure

subplot(1,2,1)

plot([-10,1],[-10,1],'b')
hold on

k=log10(3);
plot([-10+k,1],[-10,1-k],'b:')
hold on
plot([-10,1-k],[-10+k,1],'b:')
hold on

k=1;
plot([-10+k,1],[-10,1-k],'b:')
hold on
plot([-10,1-k],[-10+k,1],'b:')
hold on

plot(log10(data(:,1)), log10(data(:,2)), 'ro')
hold on

xlabel('log_1_0(NMR rate)')
ylabel('log_1_0(MSDFit rate)')



subplot(1,2,2)
hist(log10(data(:,2)./data(:,1)), 40)
hold on
xlabel('log_1_0(k_M_S_D_F_i_t/k_N_M_R)')
ylabel('Count')




