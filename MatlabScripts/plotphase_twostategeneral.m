%% draw phase diagram for V arising from different modes of replication

clear all;
myFigHandle3 = figure('Position', [30, 510, 400, 400]); hold on;

lightyellow = [.96 .96 .67];
lightred  = [1 .8 .8];
lightblue = [.7 .85 1];
lightgray = [.80 0.79 0.79]+0.06;

maxxy = 1.24;
N = 100;

%% fill regions

c = jet(9);
c(1,:) = [.9,.9,.9]; 
c = c(randperm(size(c, 1)), :);
c = 0.8*c+0.2*white(9);

% region A
handle = fill([0 maxxy maxxy 0],[1 1 maxxy maxxy],c(2,:));
set(handle,'EdgeColor','None');

% fill region B1
mynu = linspace(1/4,1,N); % only valid for 1/4 < nu < 1
mymu = (2-1./sqrt(mynu)).^2;
X = [mymu,fliplr(mymu)];
curve1 = ones(size(mynu));
curve2 = mynu;
inBetween = [curve1, fliplr(curve2)];
handle = fill(X,inBetween, c(3,:)); set(handle,'EdgeColor','None');

% fill region B2
mynu = linspace(1/4,1,N);
Y = [mynu,fliplr(mynu)];
curve1 = 1./(2-sqrt(mynu)).^2;
curve2 = (2-1./sqrt(mynu)).^2;
inBetween = [curve1, fliplr(curve2)];
handle = fill(inBetween, Y, c(4,:)); set(handle,'EdgeColor','None');

% fill region B3
mynu = linspace(0.25,1,N); % only valid for nu < 1
mymu = 1./(2-sqrt(mynu)).^2;
X = [mymu,fliplr(mymu)];
curve1 = 0.25*ones(size(mynu));
curve2 = mynu;
inBetween = [curve1, fliplr(curve2)];
handle = fill(X,inBetween, c(5,:)); set(handle,'EdgeColor','None');

% region B4
handle = fill([1 maxxy maxxy 1],[0.25 0.25 1 1],c(6,:));
set(handle,'EdgeColor','None');

% fill region C1
mynu = linspace(0, 1/4,N);
Y = [mynu,fliplr(mynu)];
curve1 = 1./(2-sqrt(mynu)).^2;
curve2 = zeros(size(mynu));
inBetween = [curve1, fliplr(curve2)];
handle = fill(inBetween, Y, c(7,:)); set(handle,'EdgeColor','None');

% fill region C2
mynu = linspace(0, 1/4,N);
Y = [mynu,fliplr(mynu)];
curve1 = 1./(2-sqrt(mynu)).^2;
curve2 = ones(size(mynu));
inBetween = [curve1, fliplr(curve2)];
handle = fill(inBetween, Y, c(8,:)); set(handle,'EdgeColor','None');

% region C3
handle = fill([1 maxxy maxxy 1],[0 0 .25 .25],c(9,:));
set(handle,'EdgeColor','None');
%% draw lines

% draw line for crossing vel > 0 for Vrpp and Vrpm
mynu = linspace(0,1,N); % only valid for nu < 1
mymu = 1./(2-sqrt(mynu)).^2;
plot(mymu, mynu, 'color', 'k', 'linewidth', 0.8, 'linestyle', '-')

% draw line for crossing vel > 0 for Vrmm and Vrmp
mynu = linspace(1/4,1,N); % only valid for 1/4 < nu < 1
mymu = (2-1./sqrt(mynu)).^2;
plot(mymu, mynu, 'color', 'k', 'linewidth', 0.8, 'linestyle', '-')

% draw line for crossing vel > 0 for Vrpp and Vrmm, which is mu = 1
line([1 1], [0 1],'color', 'k', 'linewidth', 0.8, 'linestyle', '-');
% line([1 1], [0 1],'color', 'k', 'linestyle', ':', 'linewidth', 2);
% line([1 maxxy], [1 1],'color', 'k', 'linestyle', ':', 'linewidth', 2);

%% rest of the plot

Tickfontsize = 16;
Labelfontsize = 24;
ax = gca;
axis([0 maxxy 0 maxxy]);

box on;
ax.XTick = [0 0.25 1]; ax.XTickLabel = {'', '0.25', '1.0'};
ax.YTick = [0 0.25 1]; ax.YTickLabel = {'0', '0.25', '1.0'};

ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.02 0.02];
ax.LineWidth  = 1.2;

textsize = 12;
xpos = 1.5;

text(0.55, 1.1, '$A\alpha$','Interpreter', 'latex',  'Fontsize', 24)
text(0.04, .45, '$B\beta$','Interpreter', 'latex',  'Fontsize', 24)
text(0.37, .45, '$B\gamma$','Interpreter', 'latex',  'Fontsize', 24)
text(0.7, .45, '$B\delta$','Interpreter', 'latex',  'Fontsize', 24)
text(1.05, .45, '$B\epsilon$','Interpreter', 'latex',  'Fontsize', 24)
text(0.1, .12, '$C\gamma$','Interpreter', 'latex',  'Fontsize', 24)
text(0.62, .12, '$C\delta$','Interpreter', 'latex',  'Fontsize', 24)
text(1.05, .12, '$C\epsilon$','Interpreter', 'latex',  'Fontsize', 24)

text(0.30, 0.80, '\boldmath$\mu=\left(2-\frac{1}{\sqrt{\nu}}\right)^{2}$','Interpreter', 'latex',  'Fontsize', textsize, 'Fontweight','Bold', 'Color', 'k');
text(0.51, 0.31, '\boldmath$\mu=(2-\sqrt{\nu})^{-2}$','Interpreter', 'latex',  'Fontsize', textsize, 'Fontweight','Bold', 'Color', 'k');

xlabel('\boldmath$\mu=\frac{v_+}{v_-}$', 'Fontsize', Labelfontsize,'Interpreter','latex');
ylabel('\boldmath$\nu=\frac{f_-}{f_+}$','Fontsize',Labelfontsize,'Interpreter','latex');

% saveas(myFigHandle3,'phase_twostate3.eps','epsc2');