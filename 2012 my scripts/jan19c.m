%%%for reading dbNSFP_light_V1.3 data files

clear segarray;
block_size = 1e5;
format1 = '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s'; %20 columns
% format = '%*s %*s %*s %*s %s %s %*s %*s %f %f %*s %*s %*s %*s %*s %*s %*s %s %s %d'; %20 columns
format = '%*s %*s %*s %*s %s %s %*s %*s %s %s %*s %*s %*s %*s %*s %*s %*s %s %s %s'; %20 columns

D_index=cell(5e4,2); %col1:chromosome#, col2:uniProtAC#
D_index{1,1}=1;
D_index{1,2}='Q03013'; %get from running jan19.m on dbNSFP_liaght1.3_chr1
n=1; preN=1;
chrSet={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','Y'};
for chrNum=1:24
    disp(' ')
    disp(['Now searching chromosome # ',num2str(chrNum),' ...'])
    file_id = fopen(['dbNSFP_light1.3.chr',chrSet{chrNum}]);
    
    segarray1 = textscan(file_id, format1, 1, 'Delimiter','\t');
    
    blockNum=0;
    while ~feof(file_id)
        blockNum=blockNum+1;
        disp([' Current file extraction block number is ',num2str(blockNum)])
        
        segarray = textscan(file_id, format, block_size, 'Delimiter','\t');

        uniProtACset=segarray{1,5};
        for i=1:size(uniProtACset,1)
            uniProtAC=uniProtACset{i,1};
            
            if ~strcmp('NA', uniProtAC)
                flag=0;
                for j=preN:n
                    if strcmp(D_index{j,2}, uniProtAC)
                        flag=1;
                    end
                end
                if flag==0
                    n=n+1;
                    D_index{n,1}=chrNum;
                    D_index{n,2}=uniProtAC;
                end
            end
        end
    end
    preN=n; %finish one chromosome, no previous proteins should be compared again.
    fclose(file_id);
end
