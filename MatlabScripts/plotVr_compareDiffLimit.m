%% compare the V-r plots analytical vs diff limit predicition
clear all;

myclass = 'vbarPos';
vg = 10;
vs = 10;
fcat = 3;
fres = 9;
whichdir = 'SimsFromRyanCornelius20190818/';
xfile = 'Figure_3a_x.txt';
yfile = 'Figure_3a_y.txt';

% myclass = 'vbar0';
% vg = 10;
% vs = 10;
% fcat = 3;
% fres = 3;
% whichdir = 'SimsFromRyanCornelius20190818/';
% xfile = 'Figure_3b_x.txt';
% yfile = 'Figure_3b_y.txt';
% 
% myclass = 'vbarNeg';
% vg = 10;
% vs = 10;
% fcat = 3;
% fres = 0.7;
% whichdir = 'SimsFromRyanCornelius20191007/';
% xfile = 'Figure_3c_x.txt';
% yfile = 'Figure_3c_y.txt';

% load data from numerical simulation
simdir = strcat('/Users/kishihara/Dropbox/KorolevGroup/reactiontelegraph/',whichdir);

r_array = linspace(0,1.4*fcat,1000);

Js  = zeros(length(r_array), 1);
Vs  = zeros(length(r_array), 2);

for i = 1:length(r_array)

    r = r_array(i);

    J = (vg*fres-vs*fcat)/(fres+fcat);
    Js(i) = J;

    [r_critical1, v_theoretical1, J] = theoretical(vg,vs,fcat,fres,r);
    Vs(i,1) = v_theoretical1;       
    
    [r_critical2, v_theoretical2, J] = difflimit(vg,vs,fcat,fres,r);
    Vs(i,2) = v_theoretical2;       
            
end

%% plot

FigHandleVr = figure('Position', [30, 510, 320, 320]); hold on;

mycolor = [0 0.4470 0.7410;
 0.8500 0.3250 0.0980;
 0.9290 0.6940 0.1250;
 0.4940 0.1840 0.5560;
 0.4660 0.6740 0.1880;
 0.3010 0.7450 0.9330;
 0.6350 0.0780 0.1840]; % this is Matlab's default color

seg1 = r_array<r_critical1;
seg2 = r_array>=r_critical1;

seg3 = r_array<r_critical2;
seg4 = r_array>=r_critical2;

% solid vs dashed
cn = 1; lw1 = 2.5;
plot(r_array, Vs(:,1), 'linewidth', lw1, 'color', 'k');

cn = 1; lw2 = 2.5;
plot(r_array, Vs(:,2), 'linewidth', lw2, 'color', mycolor(cn,:), 'linestyle', '--');

line([0 max(r_array)], [vg vg],'color', 'k', 'linestyle',':', 'linewidth', 1.5);
line([fcat fcat], [-6.22 vg],'color', 'k', 'linestyle',':', 'linewidth', 1.5);
line([0 max(r_array)], [0 0],'color', 'k', 'linewidth', 0.5);

Tickfontsize = 18;
Labelfontsize = 24;
ax = gca;
axis([0 1.2*fcat -6.2162 vg*1.6]);
ax.XTick = [0 fcat]; ax.XTickLabel = {0, 'f_{+}'};

box on;
ax.YTick = [0 vg]; ax.YTickLabel = {'0', 'v_{+}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.03 0.025];

xlabel('birth rate, r_{++}','Fontsize',Labelfontsize);
ylabel('front velocity, V','Fontsize',Labelfontsize);

datax = importdata(strcat(simdir,xfile));
datay = importdata(strcat(simdir,yfile));
plot(datax,datay,'ko', 'MarkerSize', 7)

% saveas(FigHandleVr,strcat('plotVr_compareDiffLimit_',myclass),'epsc2')