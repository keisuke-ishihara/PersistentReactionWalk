function[v_theoretical,J]=particledeath(v1,v2,fcat,fres,r,d)

%% returns the velocity of front produced by the replicating particles r_{++} and death rate

% check bounded vs. unbounded
J=(v1*fres-v2*fcat)/(fres+fcat);

v1 = v1;
v2 = -v2; % Ashish's sign convention for backward moving particles
r1=r;
r2=-d;
f1=fcat;
f2=fres;

V1=((sqrt(f1*f2*(r2*(f1-r1)+f2*r1))*(v2*(f1-r1)+f2*v1-r2*v1))*sign((f1+f2-r1-r2)*(v1-v2))+(r2*(f1-r1)+f2*r1)*(v2*(f1-r1)-f2*v1+r2*v1))/(((f1+f2-r1-r2)*sqrt(f1*f2*(r2*(f1-r1)+f2*r1)))*sign((f1+f2-r1-r2)*(v1-v2))+(f1-f2-r1+r2)*(r2*(f1-r1)+f2*r1));
V2=-(((sqrt(f1*f2*(r2*(f1-r1)+f2*r1))*(f1*v2+f2*v1-r1*v2-r2*v1))*sign((f1+f2-r1-r2)*(v1-v2))+(r2*(f1-r1)+f2*r1)*(-(f1*v2)+f2*v1+r1*v2-r2*v1))/(((-f1-f2+r1+r2)*sqrt(f1*f2*(r2*(f1-r1)+f2*r1)))*sign((f1+f2-r1-r2)*(v1-v2))+(f1-f2-r1+r2)*(r2*(f1-r1)+f2*r1)));
v_theoretical=max(V1,V2);

if r>fcat
    v_theoretical = v1;
end

end