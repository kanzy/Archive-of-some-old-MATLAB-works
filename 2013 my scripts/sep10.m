%%%sep10.m: revised from may23.m (2013, for PNAS paper Fig.1) &
%%%pepwork_plot.m (2011, for JASMS paper)

inputPool=peptidesPool;

x=352; %P38 length ////////////////////////////////////////////////////////////////////////////////
x=169; %FLV length


%%%plot inputPool(by compact ladder):
flag=0;

while flag~=1
    
    h=input('Input the height(floors) of peptides plot: '); %If there is an error message, means 'h' beyond lowest limit
    %%%h=37 for P38
    %%%h=29 for FLV
    
    
    rightEnds=zeros(h,1);
    
    figure
    k=1;
    for i=1:size(inputPool,1)
        while inputPool(i,1)<=rightEnds(k)
            k=k+1;
        end
        p1=[inputPool(i,1),inputPool(i,2)]; % start and end aa# of each peptide
        p2=[k,k];

        plot(p1,p2,'LineWidth',1,'Color',[0.039,0.141,0.416]);
        hold on
        rightEnds(k)=inputPool(i,2);
        k=k+1;
        if k>=h
            k=1;
        end
    end
    
    sep10_resmap
    
%     set(gca,'xtick',[1, 50:50:(x-3), x]) %//may revise here////////////////////////////////////////////////
    set(gca,'xtick',[1, 20:20:(x-3), x]) %//may revise here////////////////////////////////////////////////
    set(gca,'ytick',[])
    set(gca,'XAxisLocation','top')
    set(gca,'FontWeight','bold')
    set(gca,'PlotBoxAspectRatio',[3,1,1])
    set(gca,'YDir','reverse')
    axis([0 (x+1) -3 h+2])
    
    flag=input('Is this plot OK? (1=yes, 0=no)');
end
