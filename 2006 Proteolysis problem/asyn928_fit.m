function f = asyn928_fit(x)

global data_m
global data_f
global cleaveSites_m
global cleaveSites_f
global cleaveSites_all


sizer=size(cleaveSites_all);
N=sizer(2);
qq=asyn928_index(N,'f')+1; %the actual index number of x[] after p_m and p_f
sizer=size(data_m);
M_m=sizer(1); %number of equations from Mon goup
recorder=[];
for i=1:M_m
    left=0;
    right=N+1;
    for j=1:N
        if ( cleaveSites_all(j)==data_m(i,2))
            left=j;
        elseif ( cleaveSites_all(j)==(data_m(i,3)+1))
            right=j;
        end
    end
    recorder(i, 1:4)=[data_m(i,1) left right qq];
    
    if (data_m(i,2)==1 && data_m(i,3)~=140)%the last residue of a-syn's number is 140

        y(i)=x(asyn928_index(right,'m'));

    else
        if (data_m(i,2)~=1 && data_m(i,3)==140)%the last residue of a-syn's number is 140
            y(i)=x(asyn928_index(left,'m'));
        else
            if (data_m(i,2)==1 && data_m(i,3)==140)%the last residue of a-syn's number is 140
                y(i)=1;
            else
                y(i)=x(asyn928_index(left,'m'))*x(asyn928_index(right,'m'));
            end 
        end 
    end
    if (left+1) < right
        for k=(asyn928_index(left+1,'m')):(asyn928_index(right-1,'m'))       
            y(i)=y(i)*(1-x(k));
        end
    end
    y(i)=y(i)-x(qq)*data_m(i,4);
    
    qq=qq+1;
end

sizer=size(data_f);
M_f=sizer(1);%number of equations from Fib goup
r=qq;
for i=1:M_f
    left=0;
    right=N+1;
    for j=1:N
        if ( cleaveSites_all(j)==data_f(i,2))
            left=j;
        else if ( cleaveSites_all(j)==(data_f(i,3)+1))
                right=j;
            end
        end
    end
    
    if (data_f(i,2)==1 && data_f(i,3)~=140)%the last residue of a-syn's number is 140
        y(i+M_m)=x(asyn928_index(right,'f'));
    else if (data_f(i,2)~=1 && data_f(i,3)==140)%the last residue of a-syn's number is 140
            y(i+M_m)=x(asyn928_index(left,'f'));
        else if (data_f(i,2)==1 && data_f(i,3)==140)%the last residue of a-syn's number is 140
                y(i+M_m)=1;
            else
                y(i+M_m)=x(asyn928_index(left,'f'))*x(asyn928_index(right,'f'));
            end
        end
    end
    
    if (left+1)< right
        for k=(asyn928_index(left+1,'f')):(asyn928_index(right-1,'f'))
            y(i+M_m)=y(i+M_m)*(1-x(k));
        end
    end
    
    sizer=size(recorder);
    flag=0;
    for j=1:sizer(1)
        if data_f(i,1)==recorder(j,1) && left==recorder(j,2) && right==recorder(j,3)
            y(i+M_m)=y(i+M_m)-x(r)*x(recorder(j,4))*data_f(i,4);
            flag=1;
        end
    end
    if flag==0
        y(i+M_m)=y(i+M_m)-x(r)*x(qq+1)*data_f(i,4);
    end    
    if(flag==0)
        qq=qq+1;
    end
end


f=y;
