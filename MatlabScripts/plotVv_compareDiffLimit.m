clear all;
mycolor = [0 0.4470 0.7410;
 0.8500 0.3250 0.0980;
 0.9290 0.6940 0.1250;
 0.4940 0.1840 0.5560;
 0.4660 0.6740 0.1880;
 0.3010 0.7450 0.9330;
 0.6350 0.0780 0.1840]; % this is Matlab's default color

%% plot 'velocity ratio v_{+}/(v_{+}+v_{-}) vs. V'

fcat = 3;
fres = 3;
totalv = 10; % keep the total velocity constant
r = 1;
my_array = 0:0.01:1; % vary proportion of vg

xfile = 'Figure_5b_x.txt';
yfile = 'Figure_5b_y.txt';
simdir = '/Users/kishihara/Dropbox/KorolevGroup/reactiontelegraph/SimsFromRyanCornelius20191007/';

Js  = zeros(length(my_array), 1);
Vs  = zeros(length(my_array), 2);

for i = 1:length(my_array)

    vg = totalv*my_array(i);
    vs = totalv*(1-my_array(i));

    J = (vg*fres-vs*fcat)/(fres+fcat);
    Js(i) = J;

    [r_critical1, v_theoretical1, J] = theoretical(vg,vs,fcat,fres,r);
    Vs(i,1) = v_theoretical1;       
    
    [r_critical2, v_theoretical2, J] = difflimit(vg,vs,fcat,fres,r);
    Vs(i,2) = v_theoretical2;       
            
end

myFigHandle = figure('Position', [30, 510, 320, 320]); hold on;

cn = 1; lw1 = 2;
plot(my_array, Vs(:,1), 'linewidth', lw1, 'color', 'k');
cn = 1; lw2 = 2;
plot(my_array, Vs(:,2), 'linewidth', lw2, 'color', mycolor(cn,:), 'linestyle', '--');

line([0 max(my_array)], [vg vg],'color', 'k', 'linestyle',':', 'linewidth', 1.5);
line([0 max(my_array)], [0 0],'color', 'k', 'linewidth', .5);

Tickfontsize = 18;
Labelfontsize = 24;
ax = gca;
axis([0 max(my_array) min(Vs(:,1)) vg*1.1]);

box on;
ax.YTick = [0 vg]; ax.YTickLabel = {'0', 'v_{+}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.03 0.025];

xlabel('velocity ratio, v_{+}/(v_{+}+v_{-})','Fontsize',Labelfontsize);
ylabel('front velocity, V','Fontsize',Labelfontsize);

datax = importdata(strcat(simdir,xfile));
datay = importdata(strcat(simdir,yfile));
plot(datax,datay,'ko', 'MarkerSize', 7)

% saveas(myFigHandle,'plotVv_1.eps','epsc2')

%% plot 'total velocity v_{+}+v_{-} vs. V'

fcat = 3;
fres = 3;
r = 1;
vg_prop = 0.3;
my_array = 0:0.1:10; % vary total velocity

xfile = 'Figure_5a_x.txt';
yfile = 'Figure_5a_y.txt';
simdir = '/Users/kishihara/Dropbox/KorolevGroup/reactiontelegraph/SimsFromRyanCornelius20191007/';

Js  = zeros(length(my_array), 1);
Vs  = zeros(length(my_array), 2);

for i = 1:length(my_array)

    vg = vg_prop*my_array(i);
    vs = (1-vg_prop)*my_array(i);

    J = (vg*fres-vs*fcat)/(fres+fcat);
    Js(i) = J;

    [r_critical1, v_theoretical1, J] = theoretical(vg,vs,fcat,fres,r);
    Vs(i,1) = v_theoretical1;       
    
    [r_critical2, v_theoretical2, J] = difflimit(vg,vs,fcat,fres,r);
    Vs(i,2) = v_theoretical2;       
            
end

myFigHandle = figure('Position', [30, 510, 320, 320]); hold on;
cn = 1; lw1 = 2;
plot(my_array, Vs(:,1), 'linewidth', lw1, 'color', 'k');
cn = 1; lw2 = 2;
plot(my_array, Vs(:,2), 'linewidth', lw2, 'color', mycolor(cn,:), 'linestyle', '--');

line([0 max(my_array)], [vg vg],'color', 'k', 'linestyle',':', 'linewidth', 1.5);
line([0 max(my_array)], [0 0],'color', 'k', 'linewidth', .5);

Tickfontsize = 18;
Labelfontsize = 24;
ax = gca;
axis([0 max(my_array) 0 vg*1.1]);

box on;
ax.YTick = [0 vg]; ax.YTickLabel = {'0', 'v_{+}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.03 0.025];

xlabel('total velocity v_{+}+v_{-}','Fontsize',Labelfontsize);
ylabel('front velocity, V','Fontsize',Labelfontsize);

datax = importdata(strcat(simdir,xfile));
datay = importdata(strcat(simdir,yfile));
plot(datax,datay,'ko', 'MarkerSize', 7)

% saveas(myFigHandle,'plotVv_2.eps','epsc2')
