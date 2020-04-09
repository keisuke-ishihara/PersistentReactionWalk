function[rc, v_theoretical, vgap, U]=diffdeath(v1,v2,fcat,fres,r,d)

%% returns the front velocity in the diffusion limit with death rate, d

T11 =  r-fcat;
T22 = -d-fres;
T12 = fres;
T21 = fcat;
v = (v1+v2)/2;
u = (v1-v2)/2;
omega = -T11-T22;

D = (v1+v2)^2/4/(fcat+fres);

Uu = v*(T11-T22)/omega;
U = (v1*T22-v2*T11)/(-omega);
g1 = (T21*T12-T11*T22)/omega;

v_theoretical = U+2*sqrt(g1*D);

J = (v1*fres-v2*fcat)/(fres+fcat);

rc = fcat-fcat*fres/(d+fres);

r = rc;
T11 =  r-fcat;
T22 = -d-fres;
U0 = (v1*T22-v2*T11)/(T11+T22);
g0 = (T21*T12-T11*T22)/(-T11-T22);
vgap = U0+2*sqrt(g0*D);

end

