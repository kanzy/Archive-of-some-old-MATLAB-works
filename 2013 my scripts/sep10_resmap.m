%%%2012-05-11 changed name and revised to resmap.m
%%%2011-06-20 revision of plotting
%%%2010-07-05 consolid_pool.m: generate consolidation peptide pool. Refer to consolid_by20090414.m


X=2; %exclude N-terminal 1 or 2 residues

resPlotSytle=1; %2013-03-04 added options

%%%generate initial consolidPool:
sites=[inputPool(:,1)+X; inputPool(:,2)+1];
sites=sort(sites);
k=1;
consolidPool=[];
for i=1:size(sites,1)-1
    if sites(i)~=sites(i+1)
        consolidPool(k,1)=sites(i);
        consolidPool(k,2)=sites(i+1)-1;
        k=k+1;
    end
end

%%%generate the coefficients matrix for linear equations:
coeff=zeros(size(inputPool,1), size(consolidPool,1));
for i=1:size(inputPool,1)
    first=inputPool(i,1)+X;
    last=inputPool(i,2);
    for j=1:size(consolidPool,1)
        if first<=consolidPool(j,1) && last>=consolidPool(j,2)
            coeff(i,j)=1;
        end
    end
end

%%to remove fake peptides:
% consolidPool_new=consolidPool;
% k=0;
% for j=1:size(consolidPool,1)
%     if sum(coeff(:,j))==0
%         consolidPool_new=[consolidPool_new(1:(j-1-k),:); consolidPool((j+1-k):size(consolidPool,1),:)];
%         k=k+1;
%     end
% end
%%%below is 2010-12-05 change
consolidPool_new=[];
for j=1:size(consolidPool,1)
    if sum(coeff(:,j))~=0
        consolidPool_new=[consolidPool_new; consolidPool(j,:)];
    end
end
consolidPool=consolidPool_new;

disp(' ')
disp('Generating the resolution map from the input overlapping peptides...')
disp('(Note: Proline is NOT excluded!)')

% h=figure;
% k=5;
% for i=1:size(inputPool,1)
%     p1=[inputPool(i,1),inputPool(i,2)]; % start and end aa# of each peptide
%     p2=[k,k];
%     plot(p1,p2,'Color',[0.039,0.141,0.416],'LineWidth',1)  %2013-03-04 changed to "dark blue"
%     hold on
%     k=k+1;
% end
% ylabel('Peptide Index')
% title('The Overlapping Peptide Set')
% grid on
% v=axis;
% axis([0, max(consolidPool(:,2))+1, -10, v(4)]) %may revise here ////////////////////////////////////////////////////////////////

N_single=0;
N_switch=0;
switch resPlotSytle
    case 1
        for i=1:size(consolidPool,1)
            if consolidPool(i,1)==consolidPool(i,2)
                N_single=N_single+1;
                Color='r';
                p1=[consolidPool(i,1),consolidPool(i,2)]; % start and end aa# of each peptide
                p2=[-0.2, -0.2]; %may revise this ////////////////////////////////////////////////////////////////////////////////////
                plot(p1,p2,'.-', 'LineWidth',1, 'Color',Color, 'MarkerSize', 10) %2013-03-05  %may revise this ////////////////////////////////////////////////////////////////////////////////
                hold on
            else
                N_switch=N_switch+1;
                Color='b';
%                 width=2;
%                 p1=[consolidPool(i,1),consolidPool(i,2)]; % start and end aa# of each peptide
%                 p2=[-10+width,-10+width];
%                 plot(p1,p2,'LineWidth',1, 'Color',Color) %2013-03-05
%                 hold on
%                 p2=[-10-width,-10-width];
%                 plot(p1,p2,'LineWidth',1, 'Color',Color) %2013-03-05
%                 hold on
%                 p1=[consolidPool(i,1),consolidPool(i,1)]; % start and end aa# of each peptide
%                 p2=[-10-width,-10+width];
%                 plot(p1,p2,'LineWidth',1, 'Color',Color) %2013-03-05
%                 hold on
%                 p1=[consolidPool(i,2),consolidPool(i,2)]; % start and end aa# of each peptide
%                 p2=[-10-width,-10+width];
%                 plot(p1,p2,'LineWidth',1, 'Color',Color) %2013-03-05
%                 hold on
                
                area([consolidPool(i,1)-0.25,consolidPool(i,2)+0.25],[-0.4,-0.4],'FaceColor',Color,'LineStyle','none'); %may revise///////////////////////////
                hold on
                
            end   
            
        end
%         xlabel('Residue Number')
%         ylabel('Resolved Site Index')
%         title('The Residue Resolution Map')
%         grid on
        
    case 2 %2013-03-04 added
        x1=0;x2=0;
        for i=1:size(consolidPool,1)
            if consolidPool(i,1)==consolidPool(i,2)
                Color='r';
                x1=x1+1;
            else
                Color='b';
                x2=x2+1;
            end         
            area([consolidPool(i,1)-0.35,consolidPool(i,2)+0.35],[1,1],'FaceColor',Color,'LineStyle','none');
            hold on
        end
        xlabel('Residue Number')
        title('The Residue Resolution Map')
        axis([0.5, max(consolidPool(:,2))+0.5, 0 1])
        disp(x1)
        disp(x2)
        
end

% flag=input('Want to save this figure? (1=yes,0=no): ');
% if flag==1
%     SaveFigureName=input('Input the saved name for this figure: ','s');
%     saveas(figure(h),[SaveFigureName,'.fig'])
%     disp([SaveFigureName,'.fig has been saved in MATLAB current directory!'])
% end

N_single
N_switch


