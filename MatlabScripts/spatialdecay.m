%% plot spatial decay of front vs. replication rate

v1 = 20; v2 = 10; fcat = 3; fres = 1;

[r_critical, v_theoretical, J, K] = theoretical_returnsK( v1,v2,fcat,fres,fcat/2);

N = 100;
r_array = linspace(0.02,0.999*fcat,N);

Ks = zeros(1,N);
Vs = zeros(1,N);

for i = 1:N
    
    [r_critical, v_theoretical, J, K] = theoretical_returnsK( v1,v2,fcat,fres,r_array(i) );

    Ks(i) = K;
    Vs(i) = v_theoretical;
    
end

myfontsize = 14;
Tickfontsize = 16;
Labelfontsize = 18;

figure('Position', [500, 100, 320, 300]);
semilogy(r_array,Ks,'LineWidth',2.2); hold on
plot([r_critical r_critical],[1/100 100], 'k:')
plot([fcat fcat],[1/100 100], 'k:')
xlabel('replication rate r_{++}', 'FontSize', myfontsize)
ylabel('spatial decay rate \kappa_{f}', 'FontSize', myfontsize)

xlim([0 fcat*1.05])

set(gca,'linewidth',1.6)
ax = gca;
ax.XTick = [r_critical fcat];
ax.XTickLabel = {'r_{c}', 'f_{+}'};
ax.FontSize = Tickfontsize;
ax.FontWeight = 'Bold';
ax.TickLength = [0.025 0.035];

% filename = 'fig_spatialdecay';
% print(filename,'-dpng')
% print(filename,'-depsc','-tiff')
