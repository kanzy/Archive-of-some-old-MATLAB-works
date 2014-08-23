figure

Charge=1;
maxPlus=10;
monoMZ=0;
for i=0:1:maxPlus
stem(monoMZ+deltamass(i)/Charge, 1, 'ro')
hold on
end

stem(monoMZ+deltamass(-1)/Charge, 1, 'k*')
hold on

stem(monoMZ+deltamass(maxPlus+1)/Charge, 1, 'k*')
hold on

xx=1;

posC=zeros(1,Charge);
for i=0:(Charge-1)
    posC(i+1)=i/Charge; %assign peaks postions in [0,1) (i.e., 0, 1/Charge, 2/Charge, ... (Charge-1)/Charge)
end
interInten=0;
for d=(Charge+1):max(8,(Charge+1)) %consider potential disturbing peptide with charge state from (Charge+1) to 8
    for i=0:(Charge-1) %consider each peak postion in [0,1)
        posD=[];
        k=1;
        for j=-d:d
            pos=i/Charge+j/d; %start from position i/Charge
            ifOverlap=find(posC==pos);
            if pos>=0 && pos<1 && size(ifOverlap,2)==0 %non-overlap peak found
                posD(k)=pos;
                k=k+1;
            end
        end
        selectPositions=[];
        for m=0:ceil(maxPlus/Charge)-1 %include all [0,1) ranges
            if k>1
                for n=1:(k-1)
                    selectPositions=[selectPositions, monoMZ+deltamass(m+posD(n))];
                end
            end
        end
        selectPositions
        if size(selectPositions,2)~=0; %make sure 'selectPositions' is not []
            stem(selectPositions, xx*ones(size(selectPositions))/9, 'b*')
            hold on
            xx=xx+1;
        end
    end
end

v=axis;
axis([monoMZ+deltamass(-2)/Charge, monoMZ+deltamass(maxPlus+2)/Charge, 0, v(4)])


