function dy=mbp(t,y)
dy = zeros(3,1);    % a column vector

global Cmbp
global mkf
global mku
global mka
global mkd

% y1:Q y2:R y3:D 
dy(1) = -mku*y(1) + mkf*y(2);
dy(2) = mku*y(1) - (mkf + mka*Cmbp)*y(2) + mkd*y(3); 
dy(3) = mka*Cmbp*y(2) - mkd*y(3);