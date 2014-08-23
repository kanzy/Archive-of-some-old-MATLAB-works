





h=jun28_dsms_smap(peptidesPoolRefRT, [], ssPepTable_matchMerge(:,2:8), finalTable(:,12), ssTable, currSeq); %call (old lcms_check_smap.m)
% SaveFigureName=['(', date, ')_', FileName, '_DSMS-ExMS_Peptide & Disulfide map.fig'];
% saveas(h,SaveFigureName)
% saveas(h,[SaveFigureName(1:end-4),'.png'])