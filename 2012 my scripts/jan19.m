%%%for reading dbNSFP_light_V1.3 data files

clear segarray; 
block_size = 10;
format1 = '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s'; %20 columns
% format = '%*s %*s %*s %*s %s %s %*s %*s %f %f %*s %*s %*s %*s %*s %*s %*s %s %s %d'; %20 columns
  format = '%s %s %*s %*s %s %s %*s %*s %s %s %*s %*s %*s %*s %*s %*s %*s %s %s %s'; %20 columns

file_id = fopen('dbNSFP_light1.3.chr1');

segarray1 = textscan(file_id, format1, 1, 'Delimiter','\t');   

segarray = textscan(file_id, format, block_size, 'Delimiter','\t');      
% % while ~feof(file_id)   
% %     segarray = textscan(file_id, format, block_size);      
% %     process_data(segarray); 
% % end

fclose(file_id);
