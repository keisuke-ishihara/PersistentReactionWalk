%% compare the V-r plots for polymer, particle and diffusion limit
clear all;

v1 = 10;
v2 = 15;
fcat = 1;
fres = 1;
d = 0; % no death

r_array = linspace(0,1.05*fcat,1000);

Js  = zeros(length(r_array), 1);
Ps  = zeros(length(r_array), 1);
Ds  = zeros(length(r_array), 1);
Vs  = zeros(length(r_array), 1);

for i = 1:length(r_array)

    r = r_array(i);
   
    % particles with death
    [v_theoretical1, J] = particledeath(v1,v2,fcat,fres,r,d);
    
    % diffusion limit with death
    [rcDiff, v_theoretical2, vgapDiff, U] = diffdeath(v1,v2,fcat,fres,r,d);

    % polymer
    [rcPoly, v_theoretical3, J, vgapPoly] = theoreticalnewpole(v1,v2,fcat,fres,r);
    Vs(i) = v_theoretical3;       

    Ps(i) = v_theoretical1;  
    Ds(i) = v_theoretical2;  
end

mycolor = [0 0.4470 0.7410;
 0.8500 0.3250 0.0980;
 0.9290 0.6940 0.1250;
 0.4940 0.1840 0.5560;
 0.4660 0.6740 0.1880;
 0.3010 0.7450 0.9330;
 0.6350 0.0780 0.1840]; % this is Matlab's default color

newV1 = Ps(imag(Ps(:,1)) == 0, 1);
newr1 = r_array(imag(Ps(:,1)) == 0);

newV2 = Ds(imag(Ds(:,1)) == 0, 1);
newr2 = r_array(imag(Ds(:,1)) == 0);

newV3 = Vs(Vs ~= 0);
newr3 = r_array(Vs ~= 0);

FigHandleVr = figure('Position', [30, 510, 370, 330]); hold on;

line([0 max(r_array)], [v1 v1],'color', 'k', 'linestyle',':', 'linewidth', 1.5);
line([0 max(r_array)], [0 0],'color', 'k', 'linestyle',':', 'linewidth', 1.5);
line([fcat fcat], [Ds(1) 1.2*v1],'color', 'k', 'linestyle',':', 'linewidth', 1.5);

plot(newr2, newV2, '--', 'linewidth', 2)  % difflimit
plot(newr1, newV1, 'k.')  % particles
plot(newr3, newV3, '-.', 'color', mycolor(2,:),'linewidth', 2)  % polymer

plot(rcPoly,vgapPoly, 'o', 'color', mycolor(2,:))

xlim([0 max(r_array)])
ylim([Ds(1) 1.2*v1])

box on;
Tickfontsize = 18;
Labelfontsize = 19.5;
ax = gca;
ax.XTick = [0 rcPoly fcat]; ax.XTickLabel = {0, 'r_{gap}', 'f_{+}'};
ax.YTick = [0 vgapPoly v1]; ax.YTickLabel = {'0', 'V_{gap}', 'v_{+}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.03 0.025];
xlabel('replication rate','Fontsize',Labelfontsize);
ylabel('front velocity, V','Fontsize',Labelfontsize);
% legend('difflimit', 'particles', 'polymer')
mytitle = '$d_{+}=d_{-}=0$';
title(mytitle,'Interpreter', 'latex')

% saveas(FigHandleVr,'plotVr_comparePolymerParticleDiffusionNoDeath.eps','epsc2')
