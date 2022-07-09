clear;

%% Load Albedo Box and MODIS Data

dataDir = '/Users/Julian/Documents/_Projects/MDV-Lakes-Thesis/albedo-model/data/albedo-box/';

% Import corrected as table
M = readtable([dataDir 'corrected_wMODIS/allfile.csv']);

% Drop convert column types
M.type = categorical(M.type);
M.flight = categorical(M.flight);
M.elev(M.elev==-9999) = NaN;
albedo = M;

clear M

gls = [0 1 2 3];
lks = [1 2 3];
sls = [2 1];

mrkGls={'o','o','s','d'};
mrkLks={'x','*','+'};
mrkSls={'^','v'};

flights = { 'run1gl15c', 'run1gl16c', 'run1gl17c',...
            'run2gl15c', 'run2gl16c', 'run2gl17c',...
            'run3gl15c', 'run3gl16c', 'run3gl17c',...
            'run4gl15c', 'run4gl16c', 'run4gl17c',...
            'run5gl15c', 'run5gl16c'};
        
cmap = colormap(    [[0.6500    0.6500    0.6500]
                    [0.3020    0.7451    0.9333]
                    [0.3569    0.2471    0.0667]]);

%% Plot all points 1:1 by Type - UNCORRECTED

xData   = (albedo.Albedo_BSA_shortwave + albedo.Albedo_WSA_shortwave)/2000;
yData   = albedo.radprop;
sz      = 25;
c       = albedo.type;

figure(1); clf; hold all;
set(gcf,'units','normalized','outerposition',[0.2 0.2 0.7 1]);

for i = 1: length (gls)
    temp = albedo.locid == gls(i) & albedo.type == 'gl';
    scatter(xData(temp), yData(temp), sz, c(temp), mrkGls{i});
end
% for i = 1: length (lks)
%     temp = albedo.locid == lks(i) & albedo.type =='lk';
%     scatter(xData(temp), yData(temp), sz, c(temp), mrkLks{i});
% end
% for i = 1: length (sls)
%     temp = albedo.locid == sls(i) & albedo.type == 'sl';
%     scatter(xData(temp), yData(temp), sz, c(temp), mrkSls{i});
% end

%scatter(xData, yData, sz, c, 'filled');
line([0 1], [0 1],'Color','k','LineStyle','--','LineWidth', 1.5)

% Plot line of best fit
obs = yData;
mod = xData;
idy = ~isnan(mod);
fit = polyfit(obs(idy), mod(idy), 1);
[R,P] = corrcoef(obs(idy),mod(idy));
xFit = linspace(0, 1, 1000);
yFit = polyval(fit, xFit);
plot(xFit, yFit, 'r','LineStyle','--','LineWidth', 1)

% Calculate RMSE
err = (obs - mod);
SE = err.^2;
MSE = nansum(SE)/length(~isnan(SE));
RMSE = sqrt(MSE);

% Display
str = { ['RMS Error: ', num2str(RMSE, '%4.3f')],...
            ['r^{2}: ', num2str((R(1,2)*R(1,2)), '%4.3f')],...
            ['r: ', num2str(R(1,2), '%4.3f')],...
            ['p: ', num2str(P(1,2), '%4.3f')]};
ntitle(str, 'FontWeight', 'bold', 'FontSize', 14, 'location', 'center');

cbh = colorbar;
cbh.Ticks = [1.333 2 2.633];
cbh.TickLabels = {'Glacier','Lake','Soil'};

set(gca,'XColor','k', 'YColor', 'k', 'FontWeight', 'bold', 'FontSize',14,'LineWidth', 1.5, 'GridColor', 'k', 'box', 'on');
set(gca,'XLim',[0 1])
set(gca,'YLim',[0 1])

xlabel('\alpha_{MODIS}', 'FontSize', 18)
ylabel('\alpha_{BOX}', 'FontSize', 18)

%% Facet Plot 1:1 of by Flight and Type by color - UNCORRECTED

figure (4); clf; clear ha;  ha = tight_subplot(5,3, [0.05 0.05], [.07 .03], [.1 .03]);
set(gcf,'units','normalized','outerposition',[0 0 0.5 1]);

% Start plotting loop through flights
for f = 1:14
    
    axes(ha(f)); hold all;
    
    byFlight = albedo(albedo.flight == flights(f),:);
    
    xData   = (byFlight.Albedo_BSA_shortwave + byFlight.Albedo_WSA_shortwave)/2000;
    yData   = byFlight.radprop;
    sz      = 10;
    c       = byFlight.type;
    
    for i = 1: length (gls)
        temp = byFlight.locid == gls(i) & byFlight.type == 'gl';
        scatter(xData(temp), yData(temp), sz, c(temp), mrkGls{i});
    end
    for i = 1: length (lks)
        temp = byFlight.locid == lks(i) & byFlight.type =='lk';
        scatter(xData(temp), yData(temp), sz, c(temp), mrkLks{i});
    end
    for i = 1: length (sls)
        temp = byFlight.locid == sls(i) & byFlight.type == 'sl';
        scatter(xData(temp), yData(temp), sz, c(temp), mrkSls{i});
    end
    
    %scatter(xData, yData, sz, c, 'filled');
    line([0 1], [0 1],'Color','k','LineStyle','--','LineWidth', 1.5)
    
    %ntitle(char(flights(f)), 'location', 'north')
    
    % Plot line of best fit
    obs = yData;
    mod = xData;
    idy = ~isnan(mod);
    fit = polyfit(obs(idy), mod(idy), 1);
    [R,P] = corrcoef(obs(idy),mod(idy));
    xFit = linspace(0, 1, 1000);
    yFit = polyval(fit, xFit);
    plot(xFit, yFit, 'r','LineStyle','--','LineWidth', 1)
    
    % Calculate RMSE
    err = (obs - mod);
    SE = err.^2;
    MSE = nansum(SE)/length(~isnan(SE));
    RMSE(f) = sqrt(MSE);
    
    % Display
    str = { ['RMS Error: ', num2str(RMSE(f), '%4.3f')],...
            ['r^{2}: ', num2str((R(1,2)*R(1,2)), '%4.3f')],...
            ['r: ', num2str(R(1,2), '%4.3f')],...
            ['p: ', num2str(P(1,2), '%4.3f')]};
    ntitle(str, 'FontWeight', 'bold', 'FontSize', 14, 'location', 'center');
    
    set(gca,'FontWeight', 'bold', 'FontSize',14,'LineWidth', 1.5, 'GridColor', 'k', 'box', 'on');
    set(gca,'XLim',[0 1], 'XTickLabel', [0 0.5 1])
    set(gca,'YLim',[0 1], 'YTickLabel', [0 0.5 1])
end

delete(ha(15))

axes(ha(7))
ylabel('\alpha_{BOX}')

axes(ha(14))

xlabel('\alpha_{MODIS}')
                
cbh = colorbar;
cbh.Ticks = [1.333 2 2.633];
cbh.TickLabels = {'Glacier','Lake','Soil'};

%% Facet Plot 1:1 of by Flight by Type - UNCORRECTED

type = {'gl', 'sl', 'lk'};

for t = 1:3

    figure (4+t); clf; clear ha;  ha = tight_subplot(5,3, [0.05 0.05], [.07 .03], [.1 .03]);
    set(gcf,'units','normalized','outerposition',[0 0 0.5 1]);
    
    % Start plotting loop through flights
    for f = 1:14
        
        axes(ha(f)); hold all;
        
        byFlight = albedo(albedo.flight == flights(f),:);
        byFlight = byFlight(byFlight.type == type(t),:);
        
        xData   = (byFlight.Albedo_BSA_shortwave + byFlight.Albedo_WSA_shortwave)/2000;
        yData   = byFlight.radprop;
        sz      = 10;
        c = cmap(t,:);
        
        for i = 1: length (gls)
            temp = byFlight.locid == gls(i) & byFlight.type == 'gl';
            scatter(xData(temp), yData(temp), sz, c, mrkGls{i});
        end
        for i = 1: length (lks)
            temp = byFlight.locid == lks(i) & byFlight.type =='lk';
            scatter(xData(temp), yData(temp), sz, c, mrkLks{i});
        end
        for i = 1: length (sls)
            temp = byFlight.locid == sls(i) & byFlight.type == 'sl';
            scatter(xData(temp), yData(temp), sz, c, mrkSls{i});
        end
        
%         scatter(xData, yData, sz, c, 'filled');
        line([0 1], [0 1],'Color','k','LineStyle','--','LineWidth', 1.5)
        
        %ntitle(char(flights(f)), 'location', 'north')
        
        % Plot line of best fit
        obs = yData;
        mod = xData;
        idy = ~isnan(mod);
        fit = polyfit(obs(idy), mod(idy), 1);
        [R,P] = corrcoef(obs(idy),mod(idy));
        xFit = linspace(0, 1, 1000);
        yFit = polyval(fit, xFit);
        plot(xFit, yFit, 'r','LineStyle','--','LineWidth', 1)
        
        % Calculate RMSE
        err = (obs - mod);
        SE = err.^2;
        MSE = nansum(SE)/length(~isnan(SE));
        RMSE(f) = sqrt(MSE);
        
        % Display
        str = { ['RMS Error: ', num2str(RMSE(f), '%4.3f')],...
                ['r^{2}: ', num2str((R(1,2)*R(1,2)), '%4.3f')],...
                ['r: ', num2str(R(1,2), '%4.3f')],... 
                ['p: ', num2str(P(1,2), '%4.3f')]};
        ntitle(str, 'FontWeight', 'bold', 'FontSize', 14, 'location', 'center');
        
        set(gca,'FontWeight', 'bold', 'FontSize',14,'LineWidth', 1.5, 'GridColor', 'k', 'box', 'on');
        set(gca,'XLim',[0 1], 'XTickLabel', [0 0.5 1])
        set(gca,'YLim',[0 1], 'YTickLabel', [0 0.5 1])
    end
    
    delete(ha(15))
    
    axes(ha(7))
    ylabel('\alpha_{BOX}')
    
    axes(ha(14))
    
    xlabel('\alpha_{MODIS}')
    
end

%% Plot all points 1:1 by Type - CORRECTED

xData   = (albedo.Albedo_BSA_shortwave + albedo.Albedo_WSA_shortwave)/2000;
yData   = albedo.cor_alb;
sz      = 25;
c       = albedo.type;

figure(6); clf; hold all;
set(gcf,'units','normalized','outerposition',[0.2 0.2 0.7 1]);

for i = 1: length (gls)
    temp = albedo.locid == gls(i) & albedo.type == 'gl';
    scatter(xData(temp), yData(temp), sz, c(temp), mrkGls{i});
end
for i = 1: length (lks)
    temp = albedo.locid == lks(i) & albedo.type =='lk';
    scatter(xData(temp), yData(temp), sz, c(temp), mrkLks{i});
end
for i = 1: length (sls)
    temp = albedo.locid == sls(i) & albedo.type == 'sl';
    scatter(xData(temp), yData(temp), sz, c(temp), mrkSls{i});
end

% scatter(xData, yData, sz, c, 'filled');
line([0 1], [0 1],'Color','k','LineStyle','--','LineWidth', 1.5)

% Plot line of best fit
obs = yData;
mod = xData;
idy = ~isnan(mod);
fit = polyfit(obs(idy), mod(idy), 1);
[R,P] = corrcoef(obs(idy),mod(idy));
xFit = linspace(0, 1, 1000);
yFit = polyval(fit, xFit);
plot(xFit, yFit, 'r','LineStyle','--','LineWidth', 1)

% Calculate RMSE
err = (obs - mod);
SE = err.^2;
MSE = nansum(SE)/length(~isnan(SE));
RMSE = sqrt(MSE);

% Display
str = { ['RMS Error: ', num2str(RMSE, '%4.3f')],...
            ['r^{2}: ', num2str((R(1,2)*R(1,2)), '%4.3f')],...
            ['r: ', num2str(R(1,2), '%4.3f')],...
            ['p: ', num2str(P(1,2), '%4.3f')]};
ntitle(str, 'FontWeight', 'bold', 'FontSize', 14, 'location', 'center');
                
cbh = colorbar;
cbh.Ticks = [1.333 2 2.633];
cbh.TickLabels = {'Glacier','Lake','Soil'};

set(gca,'XColor','k', 'YColor', 'k', 'FontWeight', 'bold', 'FontSize',14,'LineWidth', 1.5, 'GridColor', 'k', 'box', 'on');
set(gca,'XLim',[0 1])
set(gca,'YLim',[0 1])

xlabel('\alpha_{MODIS}', 'FontSize', 18)
ylabel('\alpha_{BOX}', 'FontSize', 18)

%% Facet Plot 1:1 of by Flight and Type by color - CORRECTED

figure (7); clf; clear ha;  ha = tight_subplot(5,3, [0.05 0.05], [.07 .03], [.1 .03]);
set(gcf,'units','normalized','outerposition',[0 0 0.5 1]);

% Start plotting loop through flights
for f = 1:14
    
    axes(ha(f)); hold all;
    
    byFlight = albedo(albedo.flight == flights(f),:);
    
    xData   = (byFlight.Albedo_BSA_shortwave + byFlight.Albedo_WSA_shortwave)/2000;
    yData   = byFlight.cor_alb;
    sz      = 10;
    c       = byFlight.type;
    
    for i = 1: length (gls)
        temp = byFlight.locid == gls(i) & byFlight.type == 'gl';
        scatter(xData(temp), yData(temp), sz, c(temp), mrkGls{i});
    end
    for i = 1: length (lks)
        temp = byFlight.locid == lks(i) & byFlight.type =='lk';
        scatter(xData(temp), yData(temp), sz, c(temp), mrkLks{i});
    end
    for i = 1: length (sls)
        temp = byFlight.locid == sls(i) & byFlight.type == 'sl';
        scatter(xData(temp), yData(temp), sz, c(temp), mrkSls{i});
    end
    
%     scatter(xData, yData, sz, c, 'filled');
    line([0 1], [0 1],'Color','k','LineStyle','--','LineWidth', 1.5)
    
    %ntitle(char(flights(f)), 'location', 'north')
    
    % Plot line of best fit
    obs = yData;
    mod = xData;
    idy = ~isnan(mod);
    fit = polyfit(obs(idy), mod(idy), 1);
    [R,P] = corrcoef(obs(idy),mod(idy));
    xFit = linspace(0, 1, 1000);
    yFit = polyval(fit, xFit);
    plot(xFit, yFit, 'r','LineStyle','--','LineWidth', 1)
    
    % Calculate RMSE
    err = (obs - mod);
    SE = err.^2;
    MSE = nansum(SE)/length(~isnan(SE));
    RMSE(f) = sqrt(MSE);
    
    % Display
    str = { ['RMS Error: ', num2str(RMSE(f), '%4.3f')],...
            ['r^{2}: ', num2str((R(1,2)*R(1,2)), '%4.3f')],...
            ['r: ', num2str(R(1,2), '%4.3f')],...
            ['p: ', num2str(P(1,2), '%4.3f')]};
    ntitle(str, 'FontWeight', 'bold', 'FontSize', 14, 'location', 'center');
    
    set(gca,'FontWeight', 'bold', 'FontSize',14,'LineWidth', 1.5, 'GridColor', 'k', 'box', 'on');
    set(gca,'XLim',[0 1], 'XTickLabel', [0 0.5 1])
    set(gca,'YLim',[0 1], 'YTickLabel', [0 0.5 1])
end

delete(ha(15))

axes(ha(7))
ylabel('\alpha_{BOX}')

axes(ha(14))

xlabel('\alpha_{MODIS}')
                
cbh = colorbar;
cbh.Ticks = [1.333 2 2.633];
cbh.TickLabels = {'Glacier','Lake','Soil'};

%% Facet Plot 1:1 of by Flight by Type - CORRECTED

type = {'gl', 'sl', 'lk'};

for t = 1:3

    figure (7+t); clf; clear ha;  ha = tight_subplot(5,3, [0.05 0.05], [.07 .03], [.1 .03]);
    set(gcf,'units','normalized','outerposition',[0 0 0.5 1]);
    
    % Start plotting loop through flights
    for f = 1:14
        
        axes(ha(f)); hold all;
        
        byFlight = albedo(albedo.flight == flights(f),:);
        byFlight = byFlight(byFlight.type == type(t),:);
        
        xData   = (byFlight.Albedo_BSA_shortwave + byFlight.Albedo_WSA_shortwave)/2000;
        yData   = byFlight.cor_alb;
        sz      = 10;
        c = cmap(t,:);
        
        for i = 1: length (gls)
            temp = byFlight.locid == gls(i) & byFlight.type == 'gl';
            scatter(xData(temp), yData(temp), sz, c, mrkGls{i});
        end
        for i = 1: length (lks)
            temp = byFlight.locid == lks(i) & byFlight.type =='lk';
            scatter(xData(temp), yData(temp), sz, c, mrkLks{i});
        end
        for i = 1: length (sls)
            temp = byFlight.locid == sls(i) & byFlight.type == 'sl';
            scatter(xData(temp), yData(temp), sz, c, mrkSls{i});
        end
        
%         scatter(xData, yData, sz, c, 'filled');
        line([0 1], [0 1],'Color','k','LineStyle','--','LineWidth', 1.5)
        
        %ntitle(char(flights(f)), 'location', 'north')
        
        % Plot line of best fit
        obs = yData;
        mod = xData;
        idy = ~isnan(mod);
        fit = polyfit(obs(idy), mod(idy), 1);
        [R,P] = corrcoef(obs(idy),mod(idy));
        xFit = linspace(0, 1, 1000);
        yFit = polyval(fit, xFit);
        plot(xFit, yFit, 'r','LineStyle','--','LineWidth', 1)
        
        % Calculate RMSE
        err = (obs - mod);
        SE = err.^2;
        MSE = nansum(SE)/length(~isnan(SE));
        RMSE(f) = sqrt(MSE);
        
        % Display
        str = { ['RMS Error: ', num2str(RMSE(f), '%4.3f')],...
                ['r^{2}: ', num2str((R(1,2)*R(1,2)), '%4.3f')],...
                ['r: ', num2str(R(1,2), '%4.3f')],... 
                ['p: ', num2str(P(1,2), '%4.3f')]};
        ntitle(str, 'FontWeight', 'bold', 'FontSize', 14, 'location', 'center');
        
        set(gca,'FontWeight', 'bold', 'FontSize',14,'LineWidth', 1.5, 'GridColor', 'k', 'box', 'on');
        set(gca,'XLim',[0 1], 'XTickLabel', [0 0.5 1])
        set(gca,'YLim',[0 1], 'YTickLabel', [0 0.5 1])
    end
    
    delete(ha(15))
    
    axes(ha(7))
    ylabel('\alpha_{BOX}')
    
    axes(ha(14))
    
    xlabel('\alpha_{MODIS}')
    
end