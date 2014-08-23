
figure
n=0;
rmse6=0;
rmse8=0;
rmse10=0;
for i=1:size(R6,1)
    if R6(i,12)==2 && R8(i,12)==2 && R10(i,12)==2
        n=n+1;
        ave=(R6(i,10)+R8(i,10)+R10(i,10))/3;
        x6=R6(i,10)-ave;
        x8=R8(i,10)-ave;
        x10=R10(i,10)-ave;

        stem(n,x6,'r')
        hold on
        stem(n,x8,'g')
        hold on
        stem(n,x10,'b')
        hold on
        
        rmse6=rmse6+x6^2;
        rmse8=rmse8+x8^2;
        rmse10=rmse10+x10^2;
    end
end
rmse6=(rmse6/n).^0.5
rmse8=(rmse8/n).^0.5
rmse10=(rmse10/n).^0.5