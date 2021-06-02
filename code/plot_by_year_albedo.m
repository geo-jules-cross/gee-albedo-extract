clear;

%% Load Albedo Structure

dataDir = '/Users/Julian/Documents/!School/PSU GEOG MS/MDV-Lakes-Thesis/albedo-model/data/';

structure = load([dataDir 'albedo_new.mat']);

albedo.new = structure.albedo;

clear structure

structure = load([dataDir 'albedo_old.mat']);

albedo.old = structure.albedo;

clear structure

structure = load([dataDir 'met_data.mat']);

met = structure.metdata;

clear dataDir structure

%% Single Year TARM v. MODIS Plots

years = 2000:1:2014;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.TAR.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.TAR.date==datenum([yr+1 2 28]));
    
    figure(100+year); clf;
    set(gcf, 'Name', ['fig-TARM-stn-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.6, 8, 3]);
    
    make_it_tight = true;
    opt = {0.08, 0.08, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Albedo Timeseries
    subplot(3,3,1:6); hold on; box on;

    name = get(gcf, 'Name');
    %ntitle(name,'FontWeight', 'bold', 'location','south');
    
    plot(albedo.old.TAR.date(strt:fnsh), albedo.old.TAR.swirsmooth(strt:fnsh), 'o', 'LineWidth',2, 'MarkerSize',2);
    plot(albedo.old.TAR.date(strt:fnsh), albedo.old.TAR.swir(strt:fnsh), ':','Color',[0.5 0.5 0.5], 'LineWidth',1.5);
    
    shadedErrorBar(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.TAR.measured(strt:fnsh),...
        (albedo.old.TAR.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legend('MCD43A3 \alpha_{sw} 7-day running mean', 'MCD43A3 \alpha_{sw}', '7% Inst. Error','\alpha_{station}',...
        'Location','west')
    
    title ('TARM Station');
    
    ylabel('Albedo')
    ylim([0.3 1])
    datetick('x','mmm yyyy','keeplimits')
    xlim([datenum([yr 10 15]) datenum([yr+1 3 15])]);
    yticklabels('auto')
    xticklabels('')
    
    % Snow Timeseries
    subplot(3,3,7:9); hold on; box on;
    
    start=find(met.dates==datenum([yr 11 1]));
    finish=find(met.dates==datenum([yr+1 2 28]));
   
    bar(met.dates(start:finish,1), met.SNOWFALL(start:finish,10), 'k');
    ylim([0 10])
    ylabel('mm w.e.');
    datetick('x','mmm yyyy','keeplimits')
    xlim([datenum([yr 10 15]) datenum([yr+1 3 15])]);

    
    % Validate w/ RMSE
    x = albedo.old.TAR.measured(strt:fnsh);
    y = albedo.old.TAR.swir(strt:fnsh);
    err = (x - y);
    NumDays(year,1) = sum(~isnan(y));
    RMSEstation(year,1) =  sqrt( nansum( err.^2 ) / sum(~isnan(err)));
    
end

%% Single Year CAAM v. MODIS Plots

years = 2000:1:2014;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.CAA.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.CAA.date==datenum([yr+1 2 28]));
    
    figure(200+year); clf;
    set(gcf, 'Name', ['fig-CAAM-stn-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.8, 8, 3]);
    
    make_it_tight = true;
    opt = {0.08, 0.08, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Albedo Timeseries
    subplot(3,3,1:6); hold on; box on;

    name = get(gcf, 'Name');
    %ntitle(name,'FontWeight', 'bold', 'location','south');
    
    plot(albedo.old.CAA.date(strt:fnsh), albedo.old.CAA.swirsmooth(strt:fnsh), 'o', 'LineWidth',2, 'MarkerSize',2);
    plot(albedo.old.CAA.date(strt:fnsh), albedo.old.CAA.swir(strt:fnsh), ':','Color',[0.5 0.5 0.5], 'LineWidth',1.5);
    
    shadedErrorBar(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.CAA.measured(strt:fnsh),...
        (albedo.old.CAA.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    title ('CAAM Station');
    
    ylabel('Albedo')
    ylim([0.3 1])
    datetick('x','mmm yyyy','keeplimits')
    xticklabels(' ')
    xlim([datenum([yr 10 15]) datenum([yr+1 3 15])]);
    yticklabels('auto')
    
    % Snow Timeseries
    subplot(3,3,7:9); hold on; box on;
    
    start=find(met.dates==datenum([yr 11 1]));
    finish=find(met.dates==datenum([yr+1 2 28]));
   
    bar(met.dates(start:finish,1), met.SNOWFALL(start:finish,3), 'k');
    ylim([0 10])
    %ntitle('              Snowfall', 'Location','northwest')
    ylabel('mm w.e.');
    xlim([datenum([yr 10 15]) datenum([yr+1 3 15])]);
    datetick('x','mmm yyyy','keeplimits')

    % Validate w/ RMSE
    x = albedo.old.CAA.measured(strt:fnsh);
    y = albedo.old.CAA.swir(strt:fnsh);
    err = (x - y);
    NumDays(year,2) = sum(~isnan(y));
    RMSEstation(year,2) =  sqrt( nansum( err.^2 ) / sum(~isnan(err)));
    
end

%% Single Year Snow HODM v. MODIS Plots

years = 2000:1:2014;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.HOD.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.HOD.date==datenum([yr+1 2 28]));
    
    figure(300+year); clf;
    set(gcf, 'Name', ['fig-HODM-stn-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.5, 8, 3]);
    
    make_it_tight = true;
    opt = {0.08, 0.08, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Albedo Timeseries
    subplot(3,3,1:6); hold on; box on;

    name = get(gcf, 'Name');
    %ntitle(name,'FontWeight', 'bold', 'location','south');
    
    plot(albedo.old.HOD.date(strt:fnsh), albedo.old.HOD.swirsmooth(strt:fnsh), 'o', 'LineWidth',2, 'MarkerSize',2);
    plot(albedo.old.HOD.date(strt:fnsh), albedo.old.HOD.swir(strt:fnsh), ':','Color',[0.5 0.5 0.5], 'LineWidth',1.5);
    
    shadedErrorBar(albedo.old.HOD.date(strt:fnsh),...
        albedo.old.HOD.measured(strt:fnsh),...
        (albedo.old.HOD.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    title ('HODM Station');

    ylabel('Albedo')
    ylim([0.3 1])
    datetick('x','mmm yyyy','keeplimits')
    xticklabels(' ')
    xlim([datenum([yr 10 15]) datenum([yr+1 3 15])]);
    yticklabels('auto')
    
    % Snow Timeseries
    subplot(3,3,7:9); hold on; box on;
    
    start=find(met.dates==datenum([yr 11 1]));
    finish=find(met.dates==datenum([yr+1 2 28]));
   
    bar(met.dates(start:finish,1), met.SNOWFALL(start:finish,9), 'k');
    ylim([0 10])
    ylabel('mm w.e.');
    xlim([datenum([yr 10 15]) datenum([yr+1 3 15])]);
    datetick('x','mmm yyyy','keeplimits')
    
    % Validate w/ RMSE
    x = albedo.old.HOD.measured(strt:fnsh);
    y = albedo.old.HOD.swir(strt:fnsh);
    err = (x - y);
    NumDays(year,3) = sum(~isnan(y));
    RMSEstation(year,3) =  sqrt( nansum( err.^2 ) / sum(~isnan(err)));
    
end

%% Single Year COHM v. MODIS Plots

years = 2000:1:2014;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.COH.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.COH.date==datenum([yr+1 2 28]));
    
    figure(400+year); clf;
    set(gcf, 'Name', ['fig-COHM-stn-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.5, 8, 3]);
    
    make_it_tight = true;
    opt = {0.08, 0.08, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Albedo Timeseries
    subplot(3,3,1:6); hold on; box on;

    name = get(gcf, 'Name');
    %ntitle(name,'FontWeight', 'bold', 'location','south');
    
    plot(albedo.old.COH.date(strt:fnsh), albedo.old.COH.swirsmooth(strt:fnsh), 'o', 'LineWidth',2, 'MarkerSize',2);
    plot(albedo.old.COH.date(strt:fnsh), albedo.old.COH.swir(strt:fnsh), ':','Color',[0.5 0.5 0.5], 'LineWidth',1.5);
    
    shadedErrorBar(albedo.old.COH.date(strt:fnsh),...
        albedo.old.COH.measured(strt:fnsh),...
        (albedo.old.COH.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    title ('COHM Station');

    ylabel('Albedo')
    ylim([0.3 1])
    datetick('x','mmm yyyy','keeplimits')
    xticklabels(' ')
    xlim([datenum([yr 10 15]) datenum([yr+1 3 15])]);
    yticklabels('auto')
    
    % Snow Timeseries
    subplot(3,3,7:9); hold on; box on;
    
    start=find(met.dates==datenum([yr 11 1]));
    finish=find(met.dates==datenum([yr+1 2 28]));
   
    bar(met.dates(start:finish,1), met.SNOWFALL(start:finish,4), 'k');
    ylim([0 10])
    ylabel('mm w.e.')
    xlim([datenum([yr 10 15]) datenum([yr+1 3 15])])
    datetick('x','mmm yyyy','keeplimits')
    
    % Validate w/ RMSE
    x = albedo.old.COH.measured(strt:fnsh);
    y = albedo.old.COH.swir(strt:fnsh);
    err = (x - y);
    NumDays(year,4) = sum(~isnan(y));
    RMSEstation(year,4) =  sqrt( nansum( err.^2 ) / sum(~isnan(err)));
    
end

%% Single Year TARM v. Glacier Plots

years = 2000:1:2014;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.TAR.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.TAR.date==datenum([yr+1 2 28]));
    
    figure(500+year); clf;
    set(gcf, 'Name', ['fig-TARM-glc-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [0, 2, 17, 8]);
    
    make_it_tight = true;
    opt = {0.05, 0.05, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Title
    name = get(gcf, 'Name');
    color = jet(12);
    
    % Timeseries SWIR
    subplot(3,6,1:12); hold on; box on;
    
     ntitle ({[''], ['\alpha_{TARM} vs. \alpha_{sw}']}, 'FontWeight', 'bold');
    %ntitle(name,'FontWeight', 'bold');
    
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,1), ':', 'Color', color(1,:), 'LineWidth', 1.5);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,7), ':', 'Color', color(7,:), 'LineWidth', 1.5);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,8), ':', 'Color', color(8,:), 'LineWidth', 1.5);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,9), ':', 'Color', color(9,:), 'LineWidth', 1.5);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,10), ':', 'Color', color(10,:), 'LineWidth', 1.5);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,11), ':', 'Color', color(11,:), 'LineWidth', 1.5);
    
    shadedErrorBar(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.TAR.measured(strt:fnsh),...
        (albedo.old.TAR.measured(strt:fnsh)*0.03),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.old.glaciers.names{1}],...
        ['\alpha ' albedo.old.glaciers.names{7}],...
        ['\alpha ' albedo.old.glaciers.names{8}],...
        ['\alpha ' albedo.old.glaciers.names{9}],...
        ['\alpha ' albedo.old.glaciers.names{10}],...
        ['\alpha ' albedo.old.glaciers.names{11}],...
        '3% Inst. Error',...
        '\alpha_{TARM}'};
    
    legend(legendArray,'Location','southeast')
    
    ylabel('Albedo')
    ylim([0 1])
    datetick('x','mmm yyyy','keeplimits')
    yticklabels('auto')
    
    err = zeros(6,1);
    %RMSE = zeros(6,1);
    
    c = 13;
    
    % 1:1 MODIS SWIR
    for s=[1 7 8 9 10 11]
        
        subplot(3,6,c); hold on;
        
        % Plot albedo data
        scatter(albedo.old.TAR.measured(strt:fnsh), albedo.old.glaciers.swir(strt:fnsh,s), 25, color(s,:), 'filled');
        
        % Plot line of best fit
        x = albedo.old.TAR.measured(strt:fnsh);
        y = albedo.old.glaciers.swirsmooth(strt:fnsh,s);
        idy = ~isnan(y);
        coeffs = polyfit(x(idy), y(idy), 1);
        xFit = linspace(0, 1, 1000);
        yFit = polyval(coeffs, xFit);
        plot(xFit, yFit, 'r')
        
        % Calculate RMSE and dispaly
        err = (albedo.old.glaciers.swirsmooth(strt:fnsh,s) - albedo.old.TAR.measured(strt:fnsh));
        RMSE(year,s,1) =  sqrt( nansum( err.^2 ) / sum(~isnan(err)));
        str = {[albedo.old.glaciers.names{s}], ['RMSE: ', num2str(RMSE(year,s,1), '%4.3f')]};
            %['\alpha_{MOD} = ', num2str(coeffs(1),'%4.3f'), '\alpha_{TARM} + ', num2str(coeffs(2),'%4.3f')]};
        ntitle(str);
        
        if s==1
            ylabel('MODIS SWIR Mean Albedo')
            
        end
        xlabel('TAR Station Albedo')
        line([0 1], [0 1],'Color','black','LineStyle','--');
        ylim([0 1])
        xlim([0 1])
        xticklabels('auto')
        yticklabels('auto')
        box on
        
        c = c+1;
    end
end

%% Single Year CAAM v. Glacier Plots

years = 2000:1:2000;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.CAA.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.CAA.date==datenum([yr+1 2 28]));
    
    figure(600+year); clf;
    set(gcf, 'Name', ['fig-CAAM-glc-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [0, 2, 17, 8]);
    
    make_it_tight = true;
    opt = {0.05, 0.05, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Title
    name = get(gcf, 'Name');
    color = jet(12);
    
    % Timeseries SWIR
    subplot(3,6,1:12); hold on; box on;
    
    ntitle(name,'FontWeight', 'bold');
    
    plot(albedo.old.CAA.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,2), ':', 'Color', color(2,:), 'LineWidth', 1.5);
    plot(albedo.old.CAA.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,3), ':', 'Color', color(3,:), 'LineWidth', 1.5);
    
    shadedErrorBar(albedo.old.CAA.date(strt:fnsh),...
        albedo.old.CAA.measured(strt:fnsh),...
        (albedo.old.CAA.measured(strt:fnsh)*0.05),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    title ('\alpha_{CAAM} vs. \alpha_{MOD-swir}');
    
    legendArray = {['\alpha ' albedo.old.glaciers.names{2}],...
        ['\alpha ' albedo.old.glaciers.names{3}],...
        '3% Inst. Error',...
        '\alpha_{CAAM}'};
    
    legend(legendArray,'Location','southeast')
    
    ylabel('Albedo')
    ylim([0 1])
    datetick('x','mmm yyyy','keeplimits')
    yticklabels('auto')
    
    err = zeros(6,1);
    %RMSE = zeros(6,1);
    
    c=13;
    
    % 1:1 MODIS SWIR
    for s=[2, 3]
        
        subplot(3,6,c); hold on;
        
        % Plot albedo data
        scatter(albedo.old.CAA.measured(strt:fnsh), albedo.old.glaciers.swir(strt:fnsh,s), 25, color(s,:), 'filled');
        
        % Plot line of best fit
        x = albedo.old.CAA.measured(strt:fnsh);
        y = albedo.old.glaciers.swir(strt:fnsh,s);
        idy = ~isnan(y);
        coeffs = polyfit(x(idy), y(idy), 1);
        xFit = linspace(0, 1, 1000);
        yFit = polyval(coeffs, xFit);
        plot(xFit, yFit, 'r')
        
        % Calculate RMSE and dispaly
        err = (albedo.old.glaciers.swir(strt:fnsh,s) - albedo.old.CAA.measured(strt:fnsh));
        RMSE(year,s,2) =  sqrt( nansum( err.^2 ) / sum(~isnan(err)));
        str = {[albedo.old.glaciers.names{s}], ['RMSE: ', num2str(RMSE(year,s,2), '%4.3f')]};
            %['\alpha_{MOD} = ', num2str(coeffs(1),'%4.3f'), '\alpha_{CAAM} + ', num2str(coeffs(2),'%4.3f')]};
        ntitle(str);
        
        if s==1
            ylabel('MODIS SWIR Mean Albedo')
            
        end
        xlabel('CAA Station Albedo')
        line([0 1], [0 1],'Color','black','LineStyle','--');
        ylim([0 1])
        xlim([0 1])
        xticklabels('auto')
        yticklabels('auto')
        box on
        
        c = c +1;
        
    end
end

%% Single Year HODM v. Glacier Plots

years = 2000:1:2000;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.HOD.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.HOD.date==datenum([yr+1 2 28]));
    
    figure(700+year); clf;
    set(gcf, 'Name', ['fig-HODM-glc-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [0, 2, 17, 8]);
    
    make_it_tight = true;
    opt = {0.05, 0.05, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Title
    name = get(gcf, 'Name');
    color = jet(6);
    
    % Timeseries SWIR
    subplot(3,6,1:12); hold on; box on;
    
    ntitle(name,'FontWeight', 'bold');
    
    plot(albedo.old.HOD.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,1), '-o', 'Color', color(1,:));
    plot(albedo.old.HOD.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,2), '-o', 'Color', color(2,:));
    plot(albedo.old.HOD.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,3), '-o', 'Color', color(3,:));
    plot(albedo.old.HOD.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,4), '-o', 'Color', color(4,:));
    plot(albedo.old.HOD.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,5), '-o', 'Color', color(5,:));
    plot(albedo.old.HOD.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,6), '-o', 'Color', color(6,:));
    
    shadedErrorBar(albedo.old.HOD.date(strt:fnsh),...
        albedo.old.HOD.measured(strt:fnsh),...
        (albedo.old.HOD.measured(strt:fnsh)*0.03),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    title ('\alpha_{HODM} vs. \alpha_{MOD-swir}');
    
    legendArray = {['\alpha ' albedo.old.glaciers.names{1}],...
        ['\alpha ' albedo.old.glaciers.names{2}],...
        ['\alpha ' albedo.old.glaciers.names{3}],...
        ['\alpha ' albedo.old.glaciers.names{4}],...
        ['\alpha ' albedo.old.glaciers.names{5}],...
        ['\alpha ' albedo.old.glaciers.names{6}],...
        '3% Inst. Error',...
        '\alpha_{HODM}'};
    
    legend(legendArray,'Location','southeast')
    
    ylabel('Albedo')
    ylim([0 1])
    datetick('x','mmm yyyy','keeplimits')
    yticklabels('auto')
    
    err = zeros(6,1);
    %RMSE = zeros(6,1);
    
    % 1:1 MODIS SWIR
    for s=1:6
        
        subplot(3,6,s+12); hold on;
        
        % Plot albedo data
        scatter(albedo.old.HOD.measured(strt:fnsh), albedo.old.glaciers.swir(strt:fnsh,s), 25, color(s,:), 'filled');
        
        % Plot line of best fit
        x = albedo.old.HOD.measured(strt:fnsh);
        y = albedo.old.glaciers.swir(strt:fnsh,s);
        idy = ~isnan(y);
        coeffs = polyfit(x(idy), y(idy), 1);
        xFit = linspace(0, 1, 1000);
        yFit = polyval(coeffs, xFit);
        plot(xFit, yFit, 'r')
        
        % Calculate RMSE and dispaly
        err = (albedo.old.glaciers.swir(strt:fnsh,s) - albedo.old.HOD.measured(strt:fnsh));
        RMSE(year,s,3) =  sqrt( nansum( err.^2 ) / sum(~isnan(err)));
        str = {[albedo.old.glaciers.names{s}], ['RMSE: ', num2str(RMSE(year,s,3), '%4.3f')]};
            %['\alpha_{MOD} = ', num2str(coeffs(1),'%4.3f'), '\alpha_{HODM} + ', num2str(coeffs(2),'%4.3f')]};
        ntitle(str);
        
        if s==1
            ylabel('MODIS SWIR Mean Albedo')
            
        end
        xlabel('HOD Station Albedo')
        line([0 1], [0 1],'Color','black','LineStyle','--');
        ylim([0 1])
        xlim([0 1])
        xticklabels('auto')
        yticklabels('auto')
        box on
    end
end

%% Single Year COHM v. Glacier Plots

years = 2000:1:2000;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.COH.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.COH.date==datenum([yr+1 2 28]));
    
    figure(800+year); clf;
    set(gcf, 'Name', ['fig-COHM-glc-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [0, 2, 17, 8]);
    
    make_it_tight = true;
    opt = {0.05, 0.05, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Title
    name = get(gcf, 'Name');
    color = jet(6);
    
    % Timeseries SWIR
    subplot(3,6,1:12); hold on; box on;
    
    ntitle(name,'FontWeight', 'bold');
    
    plot(albedo.old.COH.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,1), '-o', 'Color', color(1,:));
    plot(albedo.old.COH.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,2), '-o', 'Color', color(2,:));
    plot(albedo.old.COH.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,3), '-o', 'Color', color(3,:));
    plot(albedo.old.COH.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,4), '-o', 'Color', color(4,:));
    plot(albedo.old.COH.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,5), '-o', 'Color', color(5,:));
    plot(albedo.old.COH.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,6), '-o', 'Color', color(6,:));
    
    shadedErrorBar(albedo.old.COH.date(strt:fnsh),...
        albedo.old.COH.measured(strt:fnsh),...
        (albedo.old.COH.measured(strt:fnsh)*0.03),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    title ('\alpha_{COHM} vs. \alpha_{MOD-swir}');
    
    legendArray = {['\alpha ' albedo.old.glaciers.names{1}],...
        ['\alpha ' albedo.old.glaciers.names{2}],...
        ['\alpha ' albedo.old.glaciers.names{3}],...
        ['\alpha ' albedo.old.glaciers.names{4}],...
        ['\alpha ' albedo.old.glaciers.names{5}],...
        ['\alpha ' albedo.old.glaciers.names{6}],...
        '3% Inst. Error',...
        '\alpha_{COHM}'};
    
    legend(legendArray,'Location','southeast')
    
    ylabel('Albedo')
    ylim([0 1])
    datetick('x','mmm yyyy','keeplimits')
    yticklabels('auto')
    
    err = zeros(6,1);
    %RMSE = zeros(6,1);
    
    % 1:1 MODIS SWIR
    for s=1:12
        
        subplot(3,6,s+12); hold on;
        
        % Plot albedo data
        scatter(albedo.old.COH.measured(strt:fnsh), albedo.old.glaciers.swir(strt:fnsh,s), 25, color(s,:), 'filled');
        
        % Plot line of best fit
        x = albedo.old.COH.measured(strt:fnsh);
        y = albedo.old.glaciers.swir(strt:fnsh,s);
        idy = ~isnan(y);
        coeffs = polyfit(x(idy), y(idy), 1);
        xFit = linspace(0, 1, 1000);
        yFit = polyval(coeffs, xFit);
        plot(xFit, yFit, 'r')
        
        % Calculate RMSE and dispaly
        err = (albedo.old.glaciers.swir(strt:fnsh,s) - albedo.old.COH.measured(strt:fnsh));
        RMSE(year,s,4) =  sqrt( nansum( err.^2 ) / sum(~isnan(err)));
        str = {[albedo.old.glaciers.names{s}], ['RMSE: ', num2str(RMSE(year,s,4), '%4.3f')]};
            %['\alpha_{MOD} = ', num2str(coeffs(1),'%4.3f'), '\alpha_{COHM} + ', num2str(coeffs(2),'%4.3f')]};
        ntitle(str);
        
        if s==1
            ylabel('MODIS SWIR Mean Albedo')
            
        end
        xlabel('COH Station Albedo')
        line([0 1], [0 1],'Color','black','LineStyle','--');
        ylim([0 1])
        xlim([0 1])
        xticklabels('auto')
        yticklabels('auto')
        box on
    end
end

%% Single Year All Met v. Glacier Plots - OLD

years = 2000:1:2014;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.old.TAR.date==datenum([yr 11 1]));
    fnsh=find(albedo.old.TAR.date==datenum([yr+1 2 28]));
    
    figure(500+year); clf;
    set(gcf, 'Name', ['fig-TARM-glc-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [2, 1, 8, 10]);
    
    make_it_tight = true;
    opt = {0.025, 0.05, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Title
    name = get(gcf, 'Name');
    color = jet(12);
    
    % Timeseries SWIR
    
    subplot(4,1,1); hold on; box on;
    
    % Plot Taylor
    %ntitle (['\alpha_{TARM} vs. \alpha_{MOD-swir}'], 'FontWeight', 'bold');
    
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,1), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,7), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,8), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,8), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,9), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,10), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,11), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,1), ':', 'Color', color(1,:), 'LineWidth', 2);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,7), ':', 'Color', color(7,:), 'LineWidth', 2);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,8), ':', 'Color', color(8,:), 'LineWidth', 2);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,9), ':', 'Color', color(9,:), 'LineWidth', 2);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,10), ':', 'Color', color(10,:), 'LineWidth', 2);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,11), ':', 'Color', color(11,:), 'LineWidth', 2);
    shadedErrorBar(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.TAR.measured(strt:fnsh),...
        (albedo.old.TAR.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.old.glaciers.names{1}],...
        ['\alpha ' albedo.old.glaciers.names{7}],...
        ['\alpha ' albedo.old.glaciers.names{8}],...
        ['\alpha ' albedo.old.glaciers.names{9}],...
        ['\alpha ' albedo.old.glaciers.names{10}],...
        ['\alpha ' albedo.old.glaciers.names{11}],...
        '7% Inst. Error',...
        '\alpha_{MET}'};
    legend(legendArray,'Location','southeast')
    ylabel('Albedo')
    ylim([0 1])
    yticklabels('auto')
    xticklabels('')
    datetick('x','mmm yyyy','keeplimits')
    
    subplot(4,1,2); hold on; box on;
    
    % Plot Canada
    %ntitle (['\alpha_{CAAM} vs. \alpha_{MOD-swir}'], 'FontWeight', 'bold');
    
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,2), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,3), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'HandleVisibility','off');
    
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,2), ':', 'Color', color(2,:), 'LineWidth', 2);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,3), ':', 'Color', color(3,:), 'LineWidth', 2);
    shadedErrorBar(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.CAA.measured(strt:fnsh),...
        (albedo.old.CAA.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.old.glaciers.names{2}] ['\alpha ' albedo.old.glaciers.names{3}]};
    legend(legendArray,'Location','southeast')
    ylabel('Albedo')
    ylim([0 1])
    yticklabels('auto')
    xticklabels(' ')
    datetick('x','mmm yyyy','keeplimits')
    
    
    subplot(4,1,3); hold on; box on;
    
    % Plot Commonwealth
    %ntitle (['\alpha_{COHM} vs. \alpha_{MOD-swir}'], 'FontWeight', 'bold');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,4), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'HandleVisibility','off');
    
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,4), ':', 'Color', color(4,:), 'LineWidth', 2);
    shadedErrorBar(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.COH.measured(strt:fnsh),...
        (albedo.old.COH.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.old.glaciers.names{4}]};
    legend(legendArray,'Location','southeast')
    ylabel('Albedo')
    ylim([0 1])
    datetick('x','mmm yyyy','keeplimits')
    xticklabels(' ')
    yticklabels('auto')
    
    subplot(4,1,4); hold on; box on;
    
    % Plot Howard
    %ntitle (['\alpha_{HODM} vs. \alpha_{MOD-swir}'], 'FontWeight', 'bold');
    
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,5), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,6), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'HandleVisibility','off');
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swir(strt:fnsh,12), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'HandleVisibility','off');
    
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,5), ':', 'Color', color(5,:), 'LineWidth', 2);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,6), ':', 'Color', color(6,:), 'LineWidth', 2);
    plot(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.glaciers.swirsmooth(strt:fnsh,12), ':', 'Color', color(12,:), 'LineWidth', 2);
    shadedErrorBar(albedo.old.TAR.date(strt:fnsh),...
        albedo.old.HOD.measured(strt:fnsh),...
        (albedo.old.HOD.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.old.glaciers.names{5}],...
        ['\alpha ' albedo.old.glaciers.names{6}],...
        ['\alpha ' albedo.old.glaciers.names{12}]};
    legend(legendArray,'Location','southeast')
    ylabel('Albedo')
    ylim([0 1])
    datetick('x','mmm yyyy','keeplimits')
    yticklabels('auto')
    
end

%% Single Year All Met v. Glacier Plots - NEW

% 'TAR', 'RHO', 'MTN', 'LCX','HUS'
% 'SUS', 'CAA'
% 'HOD' 
% 'COH'

years = 2000:1:2014;

for year=1:length(years)
    yr = years(year);
    
    strt=find(albedo.new.TAR.date==datenum([yr 11 1]));
    fnsh=find(albedo.new.TAR.date==datenum([yr+1 2 28]));
    
    figure(500+year); clf;
    set(gcf, 'Name', ['fig-TARM-glc-', num2str(yr)]);
    
    set(gcf, 'Units', 'inches', 'OuterPosition', [2, 1, 8, 10]);
    
    make_it_tight = true;
    opt = {0.025, 0.05, 0.05};
    subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
    if ~make_it_tight,  clear subplot;  end
    
    % Title
    name = get(gcf, 'Name');
    color = jet(9);
    
    % Timeseries SWIR
    
    subplot(4,1,1); hold on; box on;
    
    % Plot Taylor
    %ntitle (['\alpha_{TARM} vs. \alpha_{MOD-swir}'], 'FontWeight', 'bold');
    
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,1), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,2), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,3), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,4), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,5), ':', 'Color', [0.8 0.8 0.8], 'LineWidth', 1.5,'HandleVisibility','off');
    
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,1), ':', 'Color', color(1,:), 'LineWidth', 2);
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,2), ':', 'Color', color(2,:), 'LineWidth', 2);
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,3), ':', 'Color', color(3,:), 'LineWidth', 2);
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,4), ':', 'Color', color(4,:), 'LineWidth', 2);
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,5), ':', 'Color', color(5,:), 'LineWidth', 2);
    shadedErrorBar(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.TAR.measured(strt:fnsh),...
        (albedo.new.TAR.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.new.glaciers.names{1}],...
        ['\alpha ' albedo.new.glaciers.names{2}],...
        ['\alpha ' albedo.new.glaciers.names{3}],...
        ['\alpha ' albedo.new.glaciers.names{4}],...
        ['\alpha ' albedo.new.glaciers.names{5}],...
        '7% Inst. Error',...
        '\alpha_{MET}'};
    legend(legendArray,'Location','southeast')
    ylabel('Albedo')
    ylim([0 1])
    yticklabels('auto')
    xticklabels('')
    datetick('x','mmm yyyy','keeplimits')
    
    subplot(4,1,2); hold on; box on;
    
    % Plot Canada
    %ntitle (['\alpha_{CAAM} vs. \alpha_{MOD-swir}'], 'FontWeight', 'bold');
    
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,6), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5,'HandleVisibility','off');
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,7), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'HandleVisibility','off');
    
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,6), ':', 'Color', color(6,:), 'LineWidth', 2);
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,7), ':', 'Color', color(7,:), 'LineWidth', 2);
    shadedErrorBar(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.CAA.measured(strt:fnsh),...
        (albedo.new.CAA.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.new.glaciers.names{6}] ['\alpha ' albedo.new.glaciers.names{7}]};
    legend(legendArray,'Location','southeast')
    ylabel('Albedo')
    ylim([0 1])
    yticklabels('auto')
    xticklabels(' ')
    datetick('x','mmm yyyy','keeplimits')
    
    
    subplot(4,1,3); hold on; box on;
    
    % Plot Commonwealth
    %ntitle (['\alpha_{COHM} vs. \alpha_{MOD-swir}'], 'FontWeight', 'bold');
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,8), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'HandleVisibility','off');
    
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,8), ':', 'Color', color(8,:), 'LineWidth', 2);
    shadedErrorBar(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.COH.measured(strt:fnsh),...
        (albedo.new.COH.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.new.glaciers.names{8}]};
    legend(legendArray,'Location','southeast')
    ylabel('Albedo')
    ylim([0 1])
    datetick('x','mmm yyyy','keeplimits')
    xticklabels(' ')
    yticklabels('auto')
    
    subplot(4,1,4); hold on; box on;
    
    % Plot Howard
    %ntitle (['\alpha_{HODM} vs. \alpha_{MOD-swir}'], 'FontWeight', 'bold');
    
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swir(strt:fnsh,9), ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, 'HandleVisibility','off');
    
    plot(albedo.new.TAR.date(strt:fnsh),...
        albedo.new.glaciers.swirsmooth(strt:fnsh,9), ':', 'Color', color(5,:), 'LineWidth', 2);
    shadedErrorBar(albedo.old.TAR.date(strt:fnsh),...
        albedo.new.HOD.measured(strt:fnsh),...
        (albedo.new.HOD.measured(strt:fnsh)*0.07),...
        'lineProps', {'k-','markerfacecolor','k'});
    
    legendArray = {['\alpha ' albedo.new.glaciers.names{9}]};
    legend(legendArray,'Location','southeast')
    ylabel('Albedo')
    ylim([0 1])
    datetick('x','mmm yyyy','keeplimits')
    yticklabels('auto')
    
end

%% Export Figures
% 
% cd '/Users/jucross/Documents/MDV-Lakes-Thesis/albedo-model/figures/'
% 
% % Get all active figures
% figHandles = handle(sort(double(findall(0, 'type', 'figure'))));
% 
% % Save figures with loop
% for h = 1:length(figHandles)
%     
%     f = figHandles(h);
%     figName = get(f, 'Name');
%     
%     set(f,'PaperOrientation','landscape');
%     %set(f,'PaperUnits','inches','PaperPosition',[0 0 17 8])
%     set(f, 'Color', 'white');
%     
%     savefig(f, ['images/', figName]);
%     
%     export_fig(f, figName, '-png', '-nocrop');
%     
% end
% 
% DirList     = dir('*.pdf');
% listOfFiles = {DirList.name};
% 
% append_pdfs('albedo_results.pdf', listOfFiles{:});
% delete fig*