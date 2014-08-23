%%%2010-02-25 zhaoy.m: simulate to fit experimental results of ZhaoYong's
%%%telomere elongation study.
disp('pre-requisite: import "yongs data.mat"')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%set model parmeters:
L1=60; %fixed
SD1=20; %fixed

L2=8;
SD2=3;

preCycles=1; %fixed
freeCycles=9;

Limit=200; %greater than 170~180 will be fine.

N=100000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 100% activity case:

%%%initial:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
ran=randn(N,1);
for cycle=1:preCycles
    for i=1:N
        if telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L1+SD1.*ran(i));
        end
    end
end
[n1,xout1]=hist(telomeres,0:5:200);


%%%elongation step 2 by free telomerase:
ran=randn(N,1);
for cycle=1:freeCycles
    for i=1:N
        if telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L2+SD2.*ran(i));
        end
    end
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
axis([-40,240,0,1.1])
title(['L1=',num2str(L1),', SD1=',num2str(SD1),', L2=',num2str(L2),', SD2=',num2str(SD2),...
    ', preCycles=',num2str(preCycles),', freeCycles=',num2str(freeCycles),...
    ', Limit=',num2str(Limit)],'FontWeight','bold')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 40%(apparent) activity case:
Activity1=0.8;
Activity2=0.9;

%%%initial:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
for cycle=1:preCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=Activity1 && telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L1+SD1.*ran2(i));
        end
    end
end
[n1,xout1]=hist(telomeres,0:5:200);

%%%elongation step 2 by free telomerase:
for cycle=1:freeCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=Activity2 && telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L2+SD2.*ran2(i));
        end
    end
end
[n2,xout2]=hist(telomeres,0:5:200);

%%%plot above results:
subplot(3,1,2)
plot(zy_dist2(:,1),zy_dist2(:,2)/max(zy_dist2(:,2)),'ko')
hold on
plot(xout1,n1/max(n1),'y')
hold on
plot(xout2,n2/max(n2),'r')
axis([-40,240,0,1.1])
ylabel('Relative Amount')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%for 10%(apparent) activity case:

Activity1=0.8;
Activity2=0.3;

%%%initial:
telomeres=zeros(N,1);

%%%elongation step 1 by pre-positioning telomerase:
for cycle=1:preCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=Activity1 && telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L1+SD1.*ran2(i));
        end
    end
end
[n1,xout1]=hist(telomeres,0:5:200);

%%%elongation step 2 by free telomerase:
for cycle=1:freeCycles
    ran1=rand(N,1);
    ran2=randn(N,1);
    for i=1:N
        if ran1(i)<=Activity2 && telomeres(i)<Limit
            telomeres(i)=telomeres(i)+(L2+SD2.*ran2(i));
        end
    end
end
[n2,xout2]=hist(telomeres,0:5:200);

%%%plot above results:
subplot(3,1,3)
plot(zy_dist3(:,1),zy_dist3(:,2)/max(zy_dist3(:,2)),'ko')
hold on
plot(xout1,n1/max(n1),'y')
hold on
plot(xout2,n2/max(n2),'r')
axis([-40,240,0,1.1])
xlabel('Elongated Telomere Length (nt)')
















