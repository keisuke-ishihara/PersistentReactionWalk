clear all;

mycolor = [0 0.4470 0.7410;
 0.8500 0.3250 0.0980;
 0.9290 0.6940 0.1250;
 0.4940 0.1840 0.5560;
 0.4660 0.6740 0.1880;
 0.3010 0.7450 0.9330;
 0.6350 0.0780 0.1840]; % this is Matlab's default color

%% plot 'ratio of switching frequencies vs. V'

vg = 10;
vs = 10;
totalf = 8; % total switching frequency is kept constant
r = 1;
my_array = 0:0.005:1; % proportion of fcat for total

xfile = 'Figure_6b_x.txt';
yfile = 'Figure_6b_y.txt';
simdir = '/Users/kishihara/Dropbox/KorolevGroup/reactiontelegraph/SimsFromRyanCornelius20191007/';

Js  = zeros(length(my_array), 1);
Vs  = zeros(length(my_array), 2);

for i = 1:length(my_array)

    fcat = my_array(i)*totalf;
    fres = (1-my_array(i))*totalf;

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
axis([0 max(my_array) min(Vs(:,1)) vg*1.2]);

box on;
ax.XTick = [0 0.5 1]; ax.XTickLabel = {'0', '0.5', '1.0'};
ax.YTick = [0 vg]; ax.YTickLabel = {'0', 'v_{+}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.03 0.025];

xlabel('switching freq ratio, f_{+}/(f_{+}+f_{-})','Fontsize',Labelfontsize);
ylabel('front velocity, V','Fontsize',Labelfontsize);

datax = importdata(strcat(simdir,xfile));
datay = importdata(strcat(simdir,yfile));
plot(datax,datay,'ko', 'MarkerSize', 7)

% saveas(myFigHandle,'plotVf_1','epsc2');

%% plot 'total switching freq f_{+}+f_{-} over birth rate vs. V'

vg = 10;
vs = 10;
r = 1;
fcat_prop = 0.8;
my_array = r*exp(-4:0.005:8); % this is the total switching frequency

xfile = 'Figure_6a_x.txt';
yfile = 'Figure_6a_y.txt';
simdir = '/Users/kishihara/Dropbox/KorolevGroup/reactiontelegraph/SimsFromRyanCornelius20191007/';

fcats = my_array*fcat_prop;
fress = my_array*(1-fcat_prop);

Js  = zeros(length(my_array), 1);
Vs  = zeros(length(my_array), 2);

for i = 1:length(my_array)

    fres = fress(i);
    fcat = fcats(i);

    J = (vg*fres-vs*fcat)/(fres+fcat);
    Js(i) = J;

    [r_critical1, v_theoretical1, J] = theoretical(vg,vs,fcat,fres,r);
    Vs(i,1) = v_theoretical1;       
    
    [r_critical2, v_theoretical2, J] = difflimit(vg,vs,fcat,fres,r);
    Vs(i,2) = v_theoretical2;       
            
end

myFigHandle = figure('Position', [30, 510, 320, 320]); hold on;

cn = 1; lw1 = 2;
plot(my_array/r, Vs(:,1), 'linewidth', lw1, 'color', 'k');
cn = 1; lw2 = 2;

% plot(my_array/r, Vs(:,2), 'linewidth', lw2, 'color', mycolor(cn,:), 'linestyle', '--');

% to remove imaginary solutions (aka. once omega diverges)
r_array = my_array/r;
newV = Vs(imag(Vs(:,2)) == 0, 2);
newr = r_array(imag(Vs(:,2)) == 0);
plot(newr, newV, 'linewidth', lw2, 'color', mycolor(cn,:), 'linestyle', '--');

line([min(my_array/r) max(my_array/r)], [vg vg],'color', 'k', 'linestyle',':', 'linewidth', 1.5);
line([0 max(my_array)], [0 0],'color', 'k', 'linewidth', .5);


Tickfontsize = 18;
Labelfontsize = 24;
ax = gca;
axis([0 11 min(Vs(:,1)) vg*1.2]);

box on;
ax.YTick = [0 vg]; ax.YTickLabel = {'0', 'v_{+}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.03 0.025];

xlabel('total switching/birth, (f_{+}+f_{-})/r','Fontsize',Labelfontsize);
ylabel('front velocity, V','Fontsize',Labelfontsize);

datax = importdata(strcat(simdir,xfile));
datay = importdata(strcat(simdir,yfile));
plot(datax,datay,'ko', 'MarkerSize', 7)

% saveas(myFigHandle,'plotVf_2','epsc2');