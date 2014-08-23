%%%revised from mar18.m

%%%In workspace should preload 'FL1', 'FL2' & 'knmr'

figure

RMSD1=[]; n1=0;
RMSD2=[]; n2=0;

times=FL1(1,2:end);

a=0.9;
b=0.09;

for i=1:size(knmr,1)
    kex=knmr(i);
    X=(a-b)*exp(-kex*times)+b;
    
    Y1=FL1(i+1,2:end);
    for j=1:size(X,1)
        if Y1(j)~=a && Y1(j)~=b
            Y1=Y1-0.2*(Y1-X);
        end
    end
    RMSD1=[RMSD1, (X-Y1).^2];
    n1=n1+size(X,2);

    Y2=FL2(i+1,2:end);
    for j=1:size(X,1)
        if Y2(j)~=a && Y2(j)~=b
            Y2=Y2-0.35*(Y2-X);
        end
    end
    RMSD2=[RMSD2, (X-Y2).^2];
    n2=n2+size(X,2);
    
    plot([0,1],[0,1],'k:')
    hold on
    plot(X, Y1, 'b.', 'MarkerSize',12)
    hold on
    plot(X, Y2, 'r.', 'MarkerSize',12)
    hold on 
end

if n1~=n2
    error('something wrong!')
end

RMSD1=(sum(RMSD1)/n1)^0.5;
RMSD2=(sum(RMSD2)/n2)^0.5;