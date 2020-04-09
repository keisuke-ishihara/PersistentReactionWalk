%% compare V from different modes of replication

clear all;

mycolor = [0 0.4470 0.7410;
 0.8500 0.3250 0.0980;
 0.9290 0.6940 0.1250;
 0.4940 0.1840 0.5560;
 0.4660 0.6740 0.1880;
 0.3010 0.7450 0.9330;
 0.6350 0.0780 0.1840]; % this is Matlab's default color

mu = 0.3; nu = 1.2; figname = 'regime A'; regname = 'regime $A\alpha$';
% mu = 0.3; nu = 0.54; figname = 'regime B1'; regname = 'regime $B\beta$';
% mu = 0.5; nu = 0.54; figname = 'regime B2'; regname = 'regime $B\gamma$';
% mu = 0.8; nu = 0.54; figname = 'regime B3'; regname = 'regime $B\delta$';
% mu = 1.2; nu = 0.54; figname = 'regime B4'; regname = 'regime $B\epsilon$';
% mu = 0.25; nu = 0.1; figname = 'regime C1'; regname = 'regime $C\gamma$';
% mu = 0.8; nu = 0.1; figname = 'regime C2'; regname = 'regime $C\delta$';
% mu = 1.8; nu = 0.1; figname = 'regime C3'; regname = 'regime $C\epsilon$';

v2 = 1;
v1 = mu*v2;
fcat = 1;
fres = nu*fcat;

my_array = 0:0.001:1.2*(fcat);

Vs = zeros(4,length(my_array));
rcs = zeros(4,1);

for i = 1:length(my_array)
    
    mode = 'rpp';
    [r_c, v_theoretical, J] = twostateGeneralV( v1,v2,fcat,fres, my_array(i), mode);
    Vs(1,i) = v_theoretical;
    
end
rcs(1) = r_c;

for i = 1:length(my_array)
    
    mode = 'rpm';
    [r_c, v_theoretical, J] = twostateGeneralV( v1,v2,fcat,fres, my_array(i), mode);
    Vs(2,i) = v_theoretical;
    
end
rcs(2) = r_c;

for i = 1:length(my_array)
    
    mode = 'rmm';
    [r_c, v_theoretical, J] = twostateGeneralV( v1,v2,fcat,fres, my_array(i), mode);
    Vs(3,i) = v_theoretical;
    
end
rcs(3) = r_c;

for i = 1:length(my_array)
    
    mode = 'rmp';
    [r_c, v_theoretical, J] = twostateGeneralV( v1,v2,fcat,fres, my_array(i), mode);
    Vs(4,i) = v_theoretical;
    
end
rcs(4) = r_c;

myFigHandle = figure('Position', [30, 510, 400, 400]); hold on;

lw = 2;
plot(my_array, Vs(1,:), '-', 'Color', mycolor(1,:), 'linewidth', lw);
plot(my_array, Vs(2,:), '--', 'Color', mycolor(2,:), 'linewidth', lw);
plot(my_array, Vs(3,:), ':', 'Color', mycolor(3,:), 'linewidth', lw);
plot(my_array, Vs(4,:), '-.', 'Color', mycolor(4,:), 'linewidth', lw);
line([0 max(my_array)], [v1 v1],'color', 'k', 'linestyle',':', 'linewidth', 1);
line([0 max(my_array)], [0 0],'color', 'k', 'linestyle',':', 'linewidth', 1);
for i = 1:4
    plot(rcs(i), 0, 'o', 'MarkerFaceColor', mycolor(i,:),...
        'MarkerEdgeColor', mycolor(i,:), 'MarkerSize',8);
end

% check cross over for Vpp and Vpm
if nu < 1
    rho = 4*(-2+sqrt(nu)+nu)^2/(-4+nu)^2;
    [r_c, v, J] = twostateGeneralV( v1,v2,fcat,fres, rho, 'rpp');
    plot(rho,v, 'ko')
end

% check cross over for Vpp and Vmm
if nu < 1
    rho = (1-sqrt(nu))^2;
    [r_c, v, J] = twostateGeneralV( v1,v2,fcat,fres, rho, 'rpp');
    plot(rho,v, 'ko')
end

% check cross over for Vmm and Vmp
if (nu<1)&&(nu>0.25)
    rho = 4*nu*(1-3*nu+4*nu^2+2*sqrt(nu)*(1-2*nu))/(1-4*nu)^2
    [r_c, v, J] = twostateGeneralV( v1,v2,fcat,fres, rho, 'rmm');
    plot(rho,v, 'ko')
end

Tickfontsize = 16;
Labelfontsize = 20;
ax = gca;
axis([0 max(my_array) -Inf v1*1.1]);

box on;
ax.YTick = [0 v1]; ax.YTickLabel = {'0', 'v_{+}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.03 0.025];

xlabel('replication rate, \boldmath$\rho=\frac{r_{\alpha\beta}}{f_{+}}$',...
    'Fontsize',Labelfontsize, 'Interpreter', 'latex');
ylabel('front velocity, V','Fontsize',Labelfontsize);
lgd=legend({'\boldmath$V_{++}$', '\boldmath$V_{+-}$', '\boldmath$V_{--}$', '\boldmath$V_{-+}$'},...
    'Position',[0.24 0.65 0.05 0.2], 'Interpreter', 'latex');
lgd.FontSize = 14;

% rcs
% [~,p] = sort(rcs,'ascend');
% r = 1:length(rcs);
% r(p) = r;
% r % this is the order at which different velocities become greater than 0
% mytitle = [figname, ' ', mat2str(r), ': $\mu=', num2str(mu),',\,\nu=',num2str(nu),'$'];

% mu1 = (2-sqrt(nu))^(-2)
% mu2 = (2-1/sqrt(nu))^2

title(regname,'Interpreter', 'latex')
% saveas(myFigHandle, strcat('generalV_',strrep(figname, ' ','')),'epsc2');
