function f = asyn918_fit(x)

global cleaveSites
global data

left=1;
right=1;
sizer=size(cleaveSites);
N=sizer(2);%number of variables (except variable "coefficient",i.e., x(N+1); )
sizer=size(data);
M=sizer(1);%number of equations
for i=1:M
    for j=1:N
        if ( cleaveSites(j)==data(i,1))
            left=j;
        else if ( cleaveSites(j)==(data(i,2)+1))
                right=j;
            end
        end
    end
    if (data(i,1)==1 && data(i,2)~=140)%the last residue of a-syn's number is 140
        y(i)=x(right);
    else if (data(i,1)~=1 && data(i,2)==140)%the last residue of a-syn's number is 140
            y(i)=x(left);
        else if (data(i,1)==1 && data(i,2)==140)%the last residue of a-syn's number is 140
                y(i)=1;
            else
                y(i)=x(left)*x(right);
            end
        end
    end
    for k=(left+1):(right-1)
        y(i)=y(i)*(1-x(k));
    end
    y(i)=y(i)-x(N+1)*data(i,3);
end

f=y;
