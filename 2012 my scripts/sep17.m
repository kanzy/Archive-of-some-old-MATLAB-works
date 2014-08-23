

global kch kf

proSeq='MLKQVEIFTDGSALGNPGPGGYGAILRYRGREKTFSAGYTRTTNNRMELMAAIVALEALKEHAEVILSTDSQYVRQGITQWIHNWKKRGWKTADKKPVKNVDLWQRLDAALGQHQIKWEWVKGHAGHPENERADELARAAAMNPTLEDTGYQVEV';

pH=10;
TempC=10;

hxTime=1e-2; %10msec

kcDH = fbmme_dh(proSeq, pH, TempC, 'poly');

figFlag=1;

switch figFlag
    
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure
        kfs=[1e2 3e2 1e3 3e3 1e4];
        for n=1:size(kfs,2)
            subplot(size(kfs,2),1,n)
            kf=kfs(n);
            for i=3:size(proSeq,2)
                if proSeq(i)=='P'
                    continue
                end
                
                kch=kcDH(i);
                [t,y] = ode15s(@sep17ode,[0 hxTime],[0 1 0]);
                
                occupyD=y(end,1)+y(end,2);
                
                stem(i,occupyD)
                hold on
            end
            
            %title(['Folding Rate = ', num2str(kf),' sec^-^1'])
            if n==size(kfs,2)
                xlabel('Residue Number')
            else
                %set(gca,'xtick',[])
            end
            if n==ceil(size(kfs,2)/2)
                ylabel('Fraction of D')
            end
            if n==1
                title('Folding Rates = 1e2; 3e2; 1e3; 3e3; 1e4 sec-1 (up to down)')
            end
        end
        
        
        
    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure
        kfs=100:100:5000;
        n=0;
        startAA=112;
        for i=startAA:startAA+5
            if proSeq(i)=='P'
                continue
            end
            n=n+1;
            subplot(2,3,n)
            for j=1:size(kfs,2)
                kf=kfs(j);
                kch=kcDH(i);
                [t,y] = ode15s(@sep17ode,[0 hxTime],[0 1 0]);
                
                occupyD=y(end,1)+y(end,2);
                
                semilogx(kf,occupyD,'o')
                hold on
            end
            if n==5
                xlabel('Folding Rate (sec^-^1)')
            end
            if n==1
                ylabel('Fraction of D')
            end
            title(['Residule # ',num2str(i),' (',proSeq(i),')'])
            axis([50 1e4 0 1])
        end
        
end



