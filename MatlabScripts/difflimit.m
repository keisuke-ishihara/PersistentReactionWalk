function [r_critical, v_theoretical, J] = difflimit( v1,v2,fcat,fres,r )

%% returns the front velocity for diffusion limit

J = (v1*fres-v2*fcat)/(fres+fcat);

omega = fcat+fres;
D = (v1+v2)^2/4/omega;

g = r*fres/omega;
v_theoretical = J + 2*sqrt(g*D);

T11 =  r-fcat;
T22 =   -fres;
T12 = fres;
T21 = fcat;
omega = -T11-T22;
U = (v1*T22-v2*T11)/(-omega);
D = (v1+v2)^2/4/omega;
g = (T21*T12-T11*T22)/omega;
v_theoretical = U + 2*sqrt(g*D);

if omega < 0
    v_theoretical = sqrt(-1);
end

if J < 0
    r_critical = J^2/4/D;
else
    r_critical = 0;
end

end

