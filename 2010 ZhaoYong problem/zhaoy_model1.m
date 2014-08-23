%%%2010-02-23 zhaoy_model1.m:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%set model parmeters:
L1=30;
SD1=20;

L2=20;
SD2=10;

preCycles=1;
freeCycles=9;

N=10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 100% activity case:

%%%initial:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
for cycle=1:preCycles
    telomeres=telomeres+(L1+SD1.*randn(N,1));
end
[n1,xout1]=hist(telomeres,0:5:200);


%%%elongation step 2 by free telomerase:
for cycle=1:freeCycles
    telomeres=telomeres+(L2+SD2.*randn(N,1));
end
[n2,xout2]=hist(telomeres,0:5:200);

%%%plot above results:
figure
subplot(3,1,1)
plot(zy_dist1(:,1),zy_dist1(:,2)/max(zy_dist1(:,2)),'ko')
hold on
plot(xout1,n1/max(n1),'y')
hold on
plot(xout2,n2/max(n2),'r')
title(['L1=',num2str(L1),', SD1=',num2str(SD1),', L2=',num2str(L2),', SD2=',num2str(SD2),...
    ', preCycles=',num2str(preCycles),', freeCycles=',num2str(freeCycles)],'FontWeight','bold')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 40% activity case:
Activity=0.4;

%%%initial:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
for cycle=1:preCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=Activity
            telomeres(i)=telomeres(i)+(L1+SD1.*ran2(i));
        end
    end
end
[n1,xout1]=hist(telomeres,0:5:200)

%%%elongation step 2 by free telomerase:
for cycle=1:freeCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=Activity
            telomeres(i)=telomeres(i)+(L2+SD2.*ran2(i));
        end
    end
end
[n2,xout2]=hist(telomeres,0:5:200)

%%%plot above results:
subplot(3,1,2)
plot(zy_dist2(:,1),zy_dist2(:,2)/max(zy_dist2(:,2)),'ko')
hold on
plot(xout1,n1/max(n1),'y')
hold on
plot(xout2,n2/max(n2),'r')
ylabel('Relative Amount')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 10% activity case:

Activity=0.1;

%%%initial:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
for cycle=1:preCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=Activity
            telomeres(i)=telomeres(i)+(L1+SD1.*ran2(i));
        end
    end
end
[n1,xout1]=hist(telomeres,0:5:200)

%%%elongation step 2 by free telomerase:
for cycle=1:freeCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=Activity
            telomeres(i)=telomeres(i)+(L2+SD2.*ran2(i));
        end
    end
end
[n2,xout2]=hist(telomeres,0:5:200)

%%%plot above results:
subplot(3,1,3)
plot(zy_dist3(:,1),zy_dist3(:,2)/max(zy_dist3(:,2)),'ko')
hold on
plot(xout1,n1/max(n1),'y')
hold on
plot(xout2,n2/max(n2),'r')
xlabel('Elongated Telomere Length (nt)')
















