clear
fid=fopen('E:\USER\kanzy\wfseq.txt');
origin=fscanf(fid,'%c');
fclose(fid);

N=size(origin); N=N(2);

m=1;
for i=1:(N-5)
    hexmer=origin(i:i+5);
    k=0;
    for j=(i+1):(N-5)
        testmer=origin(j:j+5);
        if(strcmpi(hexmer,testmer)==1)
            k=k+1;
        end
    end
    if(k>0)
        resultsA{m}=hexmer;
        m=m+1;
    end
end

resultsB=sort(resultsA);
resultsC(1)=resultsB(1);
s=resultsC(:,1);
resultsD{1}=findstr(origin,s{1});
k=2;
for i=2:(m-1)
    if(strcmp(resultsB(i),resultsB(i-1))==0)
        resultsC(k)=resultsB(i);
        s=resultsC(:,k);
        resultsD{k}=findstr(origin,s{1});
        k=k+1;
    end
end

N=size(resultsC); N=N(2);
for i=1:N
    final(i,1)=resultsC(:,i);
    O=size(resultsD{i});
    final{i,2}=num2str(O(2));
end
disp('The repeatly hexmer and occurent times are:'\n)
disp(final)
pattern=input('Input the inquiry hexmer pattern in UPCASE:\n');
disp('The found starting sites of this pattern are:\n')
disp(findstr(origin,pattern))


