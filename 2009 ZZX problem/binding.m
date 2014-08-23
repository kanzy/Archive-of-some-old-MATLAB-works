%%%2009-07-14 for ZZX problem: A+B=AB 

a=1e-5
for i=1:10
    b=0:0.1:5;
    aa=a*ones(size(b));
    y=((aa+b+1)-((aa+b+1).^2-4.*a.*b).^0.5)/(2*a);
    plot(b,y);
    if a==1e-2 
        plot(b,y,'r');
    end
    hold on
    a=a*10
end

xlabel('Ligand Concentration (times of Kd)')
ylabel('Bound Fraction')
title('Theoretical Curves of A+B Binding') 
    