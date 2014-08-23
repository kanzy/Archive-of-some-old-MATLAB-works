
%%%morning work:

% fid = fopen('test1.html','w');
% % fprintf(fid, ['<H2>Inputs</H2>']);
% fprintf(fid, ['', 'test sting']);
% fprintf(fid, ['<BR>', 'test sting2']);
% % fprintf(fid, [’\n<BR><U>Input Boolean:</U> ’, num2str(some boolean)]);
% % fprintf(fid, [’\n<BR><U>Input Number:</U> ’, num2str(some value)]);
% fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



A=finalTable15;
B=finalTable20;

for i=1:size(A,1)
    if (A(i,12)>=1 && B(i,12)<1) || (B(i,12)>=1 && A(i,12)<1)
        i
        A(i,1:3)
        A(i,12)
        B(i,12)
        disp('------------')
    end
end