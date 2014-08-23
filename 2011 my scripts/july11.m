
close all

%%%For each same condition (HX time point) and same "fitLevel" ---
%%%should manually import MSDFIT.mat of Pepsin dataset, change "usePeps"
%%%and "useData" name of it; then import (only the two variables) of FP
%%%dataset, change name; then ready for use

usePeps=[usePeps_pepsin; usePeps_fp];

useData=cell(size(useData_pepsin,1)+size(useData_fp,1),size(useData_pepsin,2));
for i=1:size(useData_pepsin,1)
    for j=1:size(useData_pepsin,2)
        useData{i,j}=useData_pepsin{i,j};
    end
end

for i=1:size(useData_fp,1)
    for j=1:size(useData_fp,2)
        useData{size(useData_pepsin,1)+i,j}=useData_fp{i,j};
    end
end

XN=2;
fitLevel=fitSettings.fitLevel;

july11_msdfit