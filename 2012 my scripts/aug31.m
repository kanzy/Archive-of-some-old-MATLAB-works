
tElapsed=zeros(10,20);
n=0;
% for i=601:620
for i=2001:2020
    n=n+1;
    disp(['Now running scan # ',num2str(i),' ...'])
    clear scansData
    scansData = exms_msdataextract([i i], [200 2000], flagND);
    for j=1:10
        programSettings.peakFindAlgo=j;
        tStart = tic;
        clear peaks
        peaks=exms_mspeakfind(scansData);
        tElapsed(j,n) = tElapsed(j) + toc(tStart);
    end
end