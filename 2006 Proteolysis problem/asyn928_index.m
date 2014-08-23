%%Convert the number in CleaveSites_all to the number of x[] for Monomer or
%%Fibirl
function y=asyn928_index(x, flag)

global p_m
global p_f

y=0;
if(flag=='m') %
    for i=1:x
        if(p_m(i)~=0)
            y=y+1;
        end
    end
    
else if (flag=='f')
        sizer=size(p_m);
        for i=1:sizer(2)
            if(p_m(i)~=0)
                y=y+1;
            end
        end
        for i=1:x
            if(p_f(i)~=0)
                y=y+1;
            end
        end
    end
end

if y==0
    y=1;
end