%%%2009-07-18 xuhong.m: to solve Xu Hong's problem of calculate average
%%%intensity of the cell region

clear
close all

PrefixName=input('Input the common prefix name of the image files (e.g. "1 Ctrl_Pos001_S001_" ): ');   
TimePoints=input('Input the number of time points of the image files (e.g. 11 for t000~t010): ');
Threshold=input('Input threshold value for "edge" function (default=0.4): ');

for m=1:TimePoints
    
    if m<11
        MidName=['t00' num2str(m-1)];
    else
        MidName=['t0' num2str(m-1)];
    end
    
    for n=1:2   %channel number
        ImagesName=[PrefixName MidName '_ch0' num2str(n-1) '.tif'];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%from "Image Processing Toolbox Morphology Demos: Detecting a Cell Using
        %%%Image Segmentation":
        
        %%Step 1: Read Image
        I = imread(ImagesName);
        % figure, imshow(I), title('original image');
        
        
        %%Step 2: Detect Entire Cell
        BWs = edge(I, 'sobel', (graythresh(I) * Threshold));    %default 0.4
        % figure, imshow(BWs), title('binary gradient mask');
        
        
        %%Step 3: Fill Gaps
        se90 = strel('line', 3, 90);
        se0 = strel('line', 3, 0);
        
        
        %%Step 4: Dilate the Image
        BWsdil = imdilate(BWs, [se90 se0]);
        % figure, imshow(BWsdil), title('dilated gradient mask');
        
        
        %%Step 5: Fill Interior Gaps
        BWdfill = imfill(BWsdil, 'holes');
        % figure, imshow(BWdfill), title('binary image with filled holes');
        
        
        %%Step 6: Remove Connected Objects on Border
        BWnobord = imclearborder(BWdfill, 4);
        % figure, imshow(BWnobord), title('cleared border image');
        
        
        %%Step 7: Smooth the Object
        seD = strel('diamond',1);
        BWfinal = imerode(BWnobord,seD);
        BWfinal = imerode(BWfinal,seD);
        % figure, imshow(BWfinal), title('segmented image');
        
        BWoutline = bwperim(BWfinal);
        % Segout = I; 
        % Segout(BWoutline) = 255; 
        % figure, imshow(Segout), title('outlined original image');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        L=bwlabel(BWoutline);
        stats = regionprops(L,'Area');
        idx = find([stats.Area]==max([stats.Area]));    %assuming biggest region is the destination
        BW2 = ismember(L,idx);
        BW3 = imfill(BW2, 'holes');
        Segout = I;
        Segout(BW2) = 255;
        figure, imshow(Segout), title(['TimePoint' num2str(m-1) ' Channel' num2str(n-1)]);
        
        PixNum(m,n)=0;
        PixSum(m,n)=0;
        dim=size(I);
        for i=1:dim(1)
            for j=1:dim(2)
                if BW3(i,j)==1
                    PixNum(m,n)=PixNum(m,n)+1;
                    PixSum(m,n)=PixSum(m,n)+double(I(i,j));
                end
            end
        end
        AverageIntensity(m,n)=PixSum(m,n)/PixNum(m,n);
        
    end
end

AverageIntensity







