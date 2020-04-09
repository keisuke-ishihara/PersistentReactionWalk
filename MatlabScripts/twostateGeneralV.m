function [r_critical, v_theoretical, J] = twostateGeneralV(vp,vm,fp,fm,r, mode)

%% returns the right moving front velocity for different modes of replication

J = (vp*fm-vm*fp)/(fp+fm);

if mode == 'rpp'
   
    rpp = r;
    top = 2*sqrt(fp*rpp)*vm -(fp + rpp)*vm + fm*vp;
    bottom = (fm + fp + rpp - 2*sqrt(fp*rpp));
    
    v_theoretical = top/bottom;
    if r>fp
        v_theoretical = vp;
    end
    r_critical = (sqrt(fp)-sqrt(vp*fm/vm))^2;

elseif mode == 'rpm'
    
    rpm = r;
    top = 2*fp*sqrt(rpm*(fm+rpm))*(vm+vp) -fp*(fm+fp+2*rpm)*vm + fm*(fm+fp)*vp+2*fp*rpm*vp;
    bottom =(fm+fp)^2+4*fp*rpm;
    
    v_theoretical = top/bottom;
    r_critical = (fp*vm-fm*vp)^2/(4*fp*vp*vm);
    
elseif mode == 'rmm'
    
    rmm = r;
    top = -fp*vm + (fm+rmm+2*sqrt(fm*rmm))*vp;
    bottom = fm + fp + rmm + 2*sqrt(fm*rmm);
    
    v_theoretical = top/bottom;
    r_critical = (sqrt(vm*fp/vp)-sqrt(fm))^2;
    
elseif mode == 'rmp'
    
    rmp = r;
    top = 2*fm*sqrt(rmp*(fp+rmp))*(vm+vp) - (fp*(fm+fp)+2*fm*rmp)*vm + fm*(fm+fp+2*rmp)*vp;
    bottom = (fm+fp)^2 + 4*fm*rmp;
    
    v_theoretical = top/bottom;
    r_critical = (fp*vm-fm*vp)^2/(4*fm*vp*vm);

else
    disp('error: mode for twostateGeneralV');
end


end

