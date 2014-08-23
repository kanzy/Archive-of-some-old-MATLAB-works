%%%revised from mar18.m

% for i=11:20
%     DataSet2{1,i}=DataSet{1,i-10};
% end


%%%In workspace should preload 'DataSet1', 'DataSet2' & 'knmr'

figure

RMSD1=[]; n1=0;
RMSD2=[]; n2=0;

a=0.9;
b=0.09;

for feb22runNum=1:20
    FL1=DataSet1{1,feb22runNum}([1,3:6,10,15:18,21:24,35:37],[1,3:12]);
    %FL2=DataSet2{1,feb22runNum}([1,3:6,10,15:18,21:24,35:37],[1,3:12]);
    
    times=FL1(1,2:end);
    
    for i=1:size(knmr,1)
        kex=knmr(i);
        X=(a-b)*exp(-kex*times)+b;
        
        Y1=FL1(i+1,2:end);
        for j=1:size(X,2)
            if Y1(j)>=a*0.99 && Y1(j)<=b*1.01
                Y1(j)=Y1(j)-0.2*(Y1(j)-X(j));
            end
        end
        RMSD1=[RMSD1, (X-Y1).^2];
        n1=n1+size(X,2);
        
%         Y2=FL2(i+1,2:end);
%         for j=1:size(X,2)
%             if Y1(j)>=a*0.99 && Y1(j)<=b*1.01
%                 Y2(j)=Y2(j)-0.35*(Y2(j)-X(j));
%             end
%         end
%         RMSD2=[RMSD2, (X-Y2).^2];
%         n2=n2+size(X,2);
        
        plot([0,1],[0,1],'k:')
        hold on
        plot(X, Y1, 'b.', 'MarkerSize',12)
        hold on
%         plot(X, Y2, 'r.', 'MarkerSize',12)
%         hold on
    end
    
end
if n1~=n2
    error('something wrong!')
end

RMSD1=(sum(RMSD1)/n1)^0.5;
RMSD2=(sum(RMSD2)/n2)^0.5;