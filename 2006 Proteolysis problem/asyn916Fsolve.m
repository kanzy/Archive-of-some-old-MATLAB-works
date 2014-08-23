%% 2006-09-16: First trial of analyze cleave sites in a-syn, equations edit
%% from Sep08 data
clear

options=optimset('fsolve');
%options=optimset('NonlEqnAlgorithm','gn');

%options=optimset('NonlEqnAlgorithm','gn','maxFunEvals',100000);
% options=optimset('maxFunEvals',100000);

n=[
90.0
59.0
67.0
38.0
28.3
23.0
23.0
36.0
24.0
19.0
73.0
] % Normalize value of each peptide, supposed to equal their molar quantity.

%x0=0.5*ones(1,11) %i.e. [0, 0, 0, ...]
x0=[0.1, 0.1, 0.1, 0.5, 0.5, 0.1, 0.1, 0.1, 0.3, 0.1, 1/500]

format long
[x,feval,exitflag]=fsolve(@asyn916FsolveEqu, x0, options, n)
format short