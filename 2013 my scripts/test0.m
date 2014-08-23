
tic
x = zeros(1000,100);          % Initialize the main variable
for i = 1:1000            % Parallel loop
     y = zeros(1,100);       % Initialize the secondary variable
     for j = 1:100           % Inner loop
         y(j) = sin(exp(exp(sin(factorial(i)))));
     end
     y                      % Display the inner variable (note the random execution about "i" in the command window)
     x(i,:) = y;            % Get values from loop into the main variable
end
size(x) % Display main variable

toc
