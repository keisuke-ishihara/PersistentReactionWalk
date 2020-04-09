function [r_critical, v_theoretical, J] = theoretical( v1,v2,fcat,fres,r )

%% returns the velocity of front produced by the replicating particles r_{++} only

%% check bounded vs unbounded
J = (v1*fres-v2*fcat)/(fres+fcat);

%% calculations based on analytical solutions

if J <= 0
    % bounded dynamics
    r_critical = (sqrt(fcat)-sqrt(v1/v2*fres))^2;

    if r < fcat
        fp_curr = fcat; fm = fres; r_curr = r; vp = v1; vm = v2;
        k_curr = ((fp_curr+fm-r_curr)*sqrt(r_curr*fp_curr)+r_curr*(-fp_curr+fm+r_curr))/(vp+vm)/(fp_curr-r_curr);
        s_curr = (2*r_curr*fm)/(fp_curr+fm-r_curr)-k_curr*(vm*fp_curr-vp*fm-r_curr*vm)/(fp_curr+fm-r_curr);
        v_theoretical = s_curr/k_curr;
    else
        v_theoretical = v1; % when r >= fcat
    end

else
    % unbounded dynamics
    r_critical = 0;
    if r == 0
        v_theoretical = J;
    elseif r < fcat
        fp_curr = fcat; fm = fres; r_curr = r; vp = v1; vm = v2;
        k_curr = ((fp_curr+fm-r_curr)*sqrt(r_curr*fp_curr)+r_curr*(-fp_curr+fm+r_curr))/(vp+vm)/(fp_curr-r_curr);
        s_curr = (2*r_curr*fm)/(fp_curr+fm-r_curr)-k_curr*(vm*fp_curr-vp*fm-r_curr*vm)/(fp_curr+fm-r_curr);
        v_theoretical = s_curr/k_curr;
    else
        v_theoretical = v1; % when r >= fcat
    end
    
end

% fcatc = (sqrt(r)+sqrt(v1*fres/v2))^2;
% Jc = (v1*fres-v2*fcatc)/(fres+fcatc);

end

