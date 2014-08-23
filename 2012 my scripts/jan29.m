%%%generate protein interaction network (graph) matrix A3:

A3=sparse(size(A2,1), size(A2,1));
for i=1:size(A,1)
    disp(i)
    prot1=A{i,3};
    prot2=A{i,6};
    flag1=0; flag2=0;
    for j=1:size(A2,1)
        if strcmp(prot1,A2{j,1})
            p1=j;
            flag1=1;
        end
        if strcmp(prot2,A2{j,1})
            p2=j;
            flag2=1;
        end
        if flag1==1 && flag2==1
            break
        end
    end
    A3(p1,p2)=1;
end
A3=max(A3,A3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
xy=zeros(size(A3,1),2);
for i=1:size(A3,1)
    xy(i,1)=cos(2*pi*i/size(A3,1));
    xy(i,2)=sin(2*pi*i/size(A3,1));
end
gplot(A3,xy,'-*')
axis square

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[bc,E] = betweenness_centrality(A3,struct('istrans',1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cc=clustering_coefficients(A3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cn rt] = core_numbers(A3,struct('istrans',1));









