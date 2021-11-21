clear;

%% Load Albedo Structure

dataDir = '/Users/Julian/Documents/_Projects/MDV-Lakes-Thesis/albedo-model/data/';

structure = load([dataDir 'albedo_new.mat']);

albedo.new = structure.albedo;

clear structure

structure = load([dataDir 'albedo_old.mat']);

albedo.old = structure.albedo;

clear structure

structure = load([dataDir 'met_data.mat']);

met = structure.metdata;

clear dataDir structure

%% All Years TARM v. MODIS Plots
    
strt=find(albedo.new.TAR.date==datenum([2000 07 01]));
fnsh=find(albedo.new.TAR.date==datenum([2015 06 30]));

figure(100); clf;
set(gcf, 'Name', ['fig-TARM-stn-AllYears']);

set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.5, 11, 4]);

make_it_tight = true;
opt = {0.04, 0.15, 0.06};
subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
if ~make_it_tight,  clear subplot;  end

% Albedo 1:1 Scatterplot
xData1 = {albedo.new.TAR.visBSA(strt:fnsh), albedo.new.TAR.swirWSA(strt:fnsh), albedo.new.TAR.swirBSA(strt:fnsh), albedo.new.TAR.swir(strt:fnsh)}; % Removed albedo.new.TAR.snow(strt:fnsh)
xData = {albedo.new.TAR.visBSAsmooth(strt:fnsh), albedo.new.TAR.swirWSAsmooth(strt:fnsh), albedo.new.TAR.swirBSAsmooth(strt:fnsh), albedo.new.TAR.swirsmooth(strt:fnsh)};
varName = {'MCD43A3 \alpha_{vis}', 'MCD43A3 WSA \alpha_{sw}', 'MCD43A3 BSA \alpha_{sw}' 'MCD43A3 \alpha_{sw}'};

for s=1:4
    subplot(1,4,s); hold on;
    
    % Plot albedo data
    scatter(xData1{s}, albedo.new.TAR.measured(strt:fnsh), 25,[0.5 0.5 0.5],'filled');
    scatter(xData{s}, albedo.new.TAR.measured(strt:fnsh), 10,'k','filled');
    
    % Plot line of best fit
    obs = albedo.new.TAR.measured(strt:fnsh);
    mod = xData1{s};
    idy = ~isnan(mod);
    coeffs = polyfit(obs(idy), mod(idy), 1);
    xFit = linspace(0, 1, 1000);
    yFit = polyval(coeffs, xFit);
    %plot(xFit, yFit, 'r')
    % Calculate RMSE
    err = (obs - mod);
    SE = err.^2;
    MSE = nansum(SE)/length(~isnan(SE));
    RMSE(s) = sqrt(MSE);
    % Calculate RMSPE
    errPerc = err./obs;
    SPE = errPerc.^2;
    MSPE = nansum(SPE)/length(~isnan(SPE));
    RMSPE(s) = sqrt(MSPE);
    % Display
    str = {['RMS Error: ', num2str(RMSE(s), '%4.3f'), ' ', num2str(RMSPE(s)*100, '(%4.1f'), '%)']};
    title(str, 'FontWeight', 'bold', 'FontSize', 12);
    
    if s==1
        ylabel('\alpha TARM Station', 'FontWeight', 'bold', 'FontSize', 12)
    end
    %xlabel(varName{s})
    line([0 1], [0 1],'Color','red','LineStyle','--');
    ylim([0 1])
    xlim([0 1])
    xticks('auto')
    xticklabels('auto')
    yticks('auto')
    yticklabels('auto')
    set(gca,'TickLength',[0.03, 0.03])
    box on
end

%% All Years CAAM v. MODIS Plots - New

strt=find(albedo.new.TAR.date==datenum([2000 07 01]));
fnsh=find(albedo.new.TAR.date==datenum([2015 06 30]));

figure(101); clf;
set(gcf, 'Name', ['fig-CAAM-stn-AllYears']);

set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.5, 11, 4]);

make_it_tight = true;
opt = {0.04, 0.15, 0.06};
subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
if ~make_it_tight,  clear subplot;  end

% Albedo 1:1 Scatterplot
xData1 = {albedo.new.CAA.visBSA(strt:fnsh), albedo.new.CAA.swirWSA(strt:fnsh), albedo.new.CAA.swirBSA(strt:fnsh), albedo.new.CAA.swir(strt:fnsh)};
xData = {albedo.new.CAA.visBSAsmooth(strt:fnsh), albedo.new.CAA.swirWSAsmooth(strt:fnsh), albedo.new.CAA.swirBSAsmooth(strt:fnsh), albedo.new.CAA.swirsmooth(strt:fnsh)};
varName = {'MCD43A3 \alpha_{vis}', 'MCD43A3 WSA \alpha_{sw}', 'MCD43A3 BSA \alpha_{sw}' 'MCD43A3 \alpha_{sw}'};

for s=1:4
    subplot(1,4,s); hold on;
    
    % Plot albedo data
    scatter(xData1{s}, albedo.new.CAA.measured(strt:fnsh), 25,[0.5 0.5 0.5],'filled');
    scatter(xData{s}, albedo.new.CAA.measured(strt:fnsh), 10,'k','filled');
    
    % Plot line of best fit
    obs = albedo.new.CAA.measured(strt:fnsh);
    mod = xData1{s};
    idy = ~isnan(mod);
    coeffs = polyfit(obs(idy), mod(idy), 1);
    xFit = linspace(0, 1, 1000);
    yFit = polyval(coeffs, xFit);
    %plot(xFit, yFit, 'r')
    % Calculate RMSE
    err = (obs - mod);
    SE = err.^2;
    MSE = nansum(SE)/length(~isnan(SE));
    RMSE(s) = sqrt(MSE);
    % Calculate RMSPE
    errPerc = err./obs;
    SPE = errPerc.^2;
    MSPE = nansum(SPE)/length(~isnan(SPE));
    RMSPE(s) = sqrt(MSPE);
    % Display
    str = {['RMS Error: ', num2str(RMSE(s), '%4.3f'), ' ', num2str(RMSPE(s)*100, '(%4.1f'), '%)']};
    title(str, 'FontWeight', 'bold', 'FontSize', 12);
    
    if s==1
        ylabel('\alpha CAAM Station', 'FontWeight', 'bold', 'FontSize', 12)
    end
    %xlabel(varName{s})
    line([0 1], [0 1],'Color','red','LineStyle','--');
    ylim([0 1])
    xlim([0 1])
    xticks('auto')
    xticklabels('auto')
    yticks('auto')
    yticklabels('auto')
    set(gca,'TickLength',[0.03, 0.03])
    box on
end

%% All Years HODM v. MODIS Plots - New

strt=find(albedo.new.HOD.date==datenum([2000 11 1]));
fnsh=find(albedo.new.HOD.date==datenum([2015 2 28]));

figure(102); clf;
set(gcf, 'Name', ['fig-HODM-stn-AllYears']);

set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.5, 11, 4]);

make_it_tight = true;
opt = {0.04, 0.15, 0.06};
subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
if ~make_it_tight,  clear subplot;  end

% Albedo 1:1 Scatterplot
xData1 = {albedo.new.HOD.visBSA(strt:fnsh), albedo.new.HOD.swirWSA(strt:fnsh), albedo.new.HOD.swirBSA(strt:fnsh), albedo.new.HOD.swir(strt:fnsh)};
xData = {albedo.new.HOD.visBSAsmooth(strt:fnsh), albedo.new.HOD.swirWSAsmooth(strt:fnsh), albedo.new.HOD.swirBSAsmooth(strt:fnsh), albedo.new.HOD.swirsmooth(strt:fnsh)};
varName = {'MCD43A3 \alpha_{vis}', 'MCD43A3 WSA \alpha_{sw}', 'MCD43A3 BSA \alpha_{sw}' 'MCD43A3 \alpha_{sw}'};

for s=1:4
    subplot(1,4,s); hold on;
    
    % Plot albedo data
    scatter(xData1{s}, albedo.new.HOD.measured(strt:fnsh), 25,[0.5 0.5 0.5],'filled');
    scatter(xData{s}, albedo.new.HOD.measured(strt:fnsh), 10,'k','filled');
    
    % Plot line of best fit
    obs = albedo.new.HOD.measured(strt:fnsh);
    mod = xData1{s};
    idy = ~isnan(mod);
    coeffs = polyfit(obs(idy), mod(idy), 1);
    xFit = linspace(0, 1, 1000);
    yFit = polyval(coeffs, xFit);
    %plot(xFit, yFit, 'r')
    % Calculate RMSE
    err = (obs - mod);
    SE = err.^2;
    MSE = nansum(SE)/length(~isnan(SE));
    RMSE(s) = sqrt(MSE);
    % Calculate RMSPE
    errPerc = err./obs;
    SPE = errPerc.^2;
    MSPE = nansum(SPE)/length(~isnan(SPE));
    RMSPE(s) = sqrt(MSPE);
    % Display
    str = {['RMS Error: ', num2str(RMSE(s), '%4.3f'), ' ', num2str(RMSPE(s)*100, '(%4.1f'), '%)']};
    title(str, 'FontWeight', 'bold', 'FontSize', 12);
    
    if s==1
        ylabel('\alpha HODM Station', 'FontWeight', 'bold', 'FontSize', 12)
    end
    %xlabel(varName{s})
    line([0 1], [0 1],'Color','red','LineStyle','--');
    ylim([0 1])
    xlim([0 1])
    xticks('auto')
    xticklabels('auto')
    yticks('auto')
    yticklabels('auto')
    set(gca,'TickLength',[0.03, 0.03])
    box on
end

%% All Year COHM v. MODIS Plots - New

strt=find(albedo.new.COH.date==datenum([2000 11 1]));
fnsh=find(albedo.new.COH.date==datenum([2015 2 28]));

figure(103); clf;
set(gcf, 'Name', ['fig-COHM-stn-AllYears']);

set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.5, 11, 4.2]);

make_it_tight = true;
opt = {0.04, 0.17, 0.06};
subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
if ~make_it_tight,  clear subplot;  end

% Abedo 1:1 Scatterplot
xData1 = {albedo.new.COH.visBSA(strt:fnsh),albedo.new.COH.swirWSA(strt:fnsh), albedo.new.COH.swirBSA(strt:fnsh), albedo.new.COH.swir(strt:fnsh)};
xData = {albedo.new.COH.visBSAsmooth(strt:fnsh), albedo.new.COH.swirWSAsmooth(strt:fnsh), albedo.new.COH.swirBSAsmooth(strt:fnsh), albedo.new.COH.swirsmooth(strt:fnsh)};
varName = {'MCD43A3 \alpha_{vis}', 'MCD43A3 WSA \alpha_{sw}', 'MCD43A3 BSA \alpha_{sw}' 'MCD43A3 \alpha_{sw}'};

for s=1:4
    subplot(1,4,s); hold on;
    
    % Plot albedo data
    scatter(xData1{s}, albedo.new.COH.measured(strt:fnsh), 25,[0.5 0.5 0.5],'filled');
    scatter(xData{s}, albedo.new.COH.measured(strt:fnsh), 10,'k','filled');

    % Plot line of best fit
    obs = albedo.new.COH.measured(strt:fnsh);
    mod = xData1{s};
    idy = ~isnan(mod);
    coeffs = polyfit(obs(idy), mod(idy), 1);
    xFit = linspace(0, 1, 1000);
    yFit = polyval(coeffs, xFit);
    %plot(xFit, yFit, 'r')
    % Calculate RMSE
    err = (obs - mod);
    SE = err.^2;
    MSE = nansum(SE)/length(~isnan(SE));
    RMSE(s) = sqrt(MSE);
    % Calculate RMSPE
    errPerc = err./obs;
    SPE = errPerc.^2;
    MSPE = nansum(SPE)/length(~isnan(SPE));
    RMSPE(s) = sqrt(MSPE);
    % Display
    str = {['RMS Error: ', num2str(RMSE(s), '%4.3f'), ' ', num2str(RMSPE(s)*100, '(%4.1f'), '%)']};
    title(str, 'FontWeight', 'bold', 'FontSize', 12);
    
    if s==1
        ylabel('\alpha COHM Station', 'FontWeight', 'bold', 'FontSize', 12)
    end
    xlabel(varName{s}, 'FontWeight', 'bold', 'FontSize', 12)
    line([0 1], [0 1],'Color','red','LineStyle','--');
    ylim([0 1])
    xlim([0 1])
    xticks('auto')
    xticklabels('auto')
    yticks('auto')
    yticklabels('auto')
    set(gca,'TickLength',[0.03, 0.03])
    box on
end

%% All Years Met station v. Glacier Plots OLD
    
strt=find(albedo.old.TAR.date==datenum([2000 11 1]));
fnsh=find(albedo.old.TAR.date==datenum([2015 2 28]));

figure(500); clf;
set(gcf, 'Name', ['fig-TARM-glc-AllYears']);

set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.25, 9, 10.5]);

make_it_tight = true;
opt = {0.05, 0.04, 0.05};
subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
if ~make_it_tight,  clear subplot;  end

% Title
name = get(gcf, 'Name');
color = jet(12);
stationName = {'TARM', 'CAAM', 'COHM', 'HODM'};

% 1:1 MODIS SWIR
for s=1:12
    
    subplot(4,3,s); hold on;
    
    if s==1||s==7||s==8||s==9||s==10||s==11
        % Plot Taylor
        mod = albedo.old.glaciers.swirsmooth(strt:fnsh,s);
        obs = albedo.old.TAR.measured(strt:fnsh);
        scatter(albedo.old.glaciers.swir(strt:fnsh,s), albedo.old.TAR.measured(strt:fnsh), 25, [0.5 0.5 0.5], 'filled');
        scatter(albedo.old.glaciers.swirsmooth(strt:fnsh,s), albedo.old.TAR.measured(strt:fnsh), 10, color(s,:), 'filled');
        % RMSE
        % Calculate RMSE
        err = (obs - mod);
        SE = err.^2;
        MSE = nansum(SE)/length(~isnan(SE));
        RMSE = sqrt(MSE);
        str = {[albedo.old.glaciers.names{s} ' - ' stationName{1}, '  RMS Error: ', num2str(RMSE, '%4.3f')]};
    elseif s==2||s==3
        % Plot Canada
        mod = albedo.old.glaciers.swirsmooth(strt:fnsh,s);
        obs = albedo.old.CAA.measured(strt:fnsh);
        scatter(albedo.old.glaciers.swir(strt:fnsh,s), albedo.old.CAA.measured(strt:fnsh), 25, [0.5 0.5 0.5], 'filled');
        scatter(albedo.old.glaciers.swirsmooth(strt:fnsh,s), albedo.old.CAA.measured(strt:fnsh), 10, color(s,:), 'filled');
        % Calculate RMSE
        err = (obs - mod);
        SE = err.^2;
        MSE = nansum(SE)/length(~isnan(SE));
        RMSE = sqrt(MSE);
        str = {[albedo.old.glaciers.names{s} ' - ' stationName{2}, '  RMS Error: ', num2str(RMSE, '%4.3f')]};
    elseif s==4
        strt=find(albedo.old.TAR.date==datenum([2000 11 1]));
        fnsh=find(albedo.old.TAR.date==datenum([2007 2 28]));
        % Plot Commonwealth
        mod = albedo.old.glaciers.swirsmooth(strt:fnsh,s);
        obs = albedo.old.COH.measured(strt:fnsh);
        scatter(albedo.old.glaciers.swir(strt:fnsh,s), albedo.old.COH.measured(strt:fnsh), 25, [0.5 0.5 0.5], 'filled');
        scatter(albedo.old.glaciers.swirsmooth(strt:fnsh,s), albedo.old.COH.measured(strt:fnsh), 10, color(s,:), 'filled');
        % Display
        str = {[albedo.old.glaciers.names{s} ' - ' stationName{3}, '  RMS Error: ', num2str(RMSE, '%4.3f')]};
    elseif s==5||s==6||s==12
        strt=find(albedo.old.TAR.date==datenum([2000 11 1]));
        fnsh=find(albedo.old.TAR.date==datenum([2007 2 28]));
        % Plot Howard
        mod = albedo.old.glaciers.swirsmooth(strt:fnsh,s);
        obs = albedo.old.HOD.measured(strt:fnsh);
        scatter(albedo.old.glaciers.swir(strt:fnsh,s), albedo.old.HOD.measured(strt:fnsh), 25, [0.5 0.5 0.5], 'filled');
        scatter(albedo.old.glaciers.swirsmooth(strt:fnsh,s), albedo.old.HOD.measured(strt:fnsh), 10, color(s,:), 'filled');
        % Calculate RMSE
        err = (obs - mod);
        SE = err.^2;
        MSE = nansum(SE)/length(~isnan(SE));
        RMSE = sqrt(MSE);
        str = {[albedo.old.glaciers.names{s} ' - ' stationName{4}, '  RMS Error: ', num2str(RMSE, '%4.3f')]};
    end
    
    title(str, 'FontWeight', 'bold');
    
    if s==1||s==4||s==7||s==10
        ylabel('Station \alpha')
    end
    if s==10 ||s==11||s==12
        xlabel('Glacier Mean MCD43A \alpha')
    end
    line([0 1], [0 1],'Color','black','LineStyle','--');
    ylim([0 1])
    xlim([0 1])
    xticks('auto')
    xticklabels('auto')
    yticks('auto')
    yticklabels('auto')
    set(gca,'TickLength',[0.03, 0.03])
    box on
end

%% All Years Met station v. Glacier Plots NEW
    
strt=find(albedo.new.TAR.date==datenum([2000 11 1]));
fnsh=find(albedo.new.TAR.date==datenum([2015 2 28]));

figure(600); clf;
set(gcf, 'Name', ['fig-TARM-glc-AllYears']);

set(gcf, 'Units', 'inches', 'OuterPosition', [2, 0.25, 13, 13]);

make_it_tight = true;
opt = {0.05, 0.05, 0.08};
subplot = @(m,n,p) subtightplot (m, n, p, opt{:});
if ~make_it_tight,  clear subplot;  end

% Title
name = get(gcf, 'Name');
color = jet(9);
stationName = {'TARM', 'CAAM', 'COHM', 'HODM'};

% 'TAR', 'RHO', 'MTN', 'LCX','HUS'
% 'SUS', 'CAA', 'HOD' 'COH'

% 1:1 MODIS SWIR
for s=1:9
    
    subplot(3,3,s); hold on;
    
    if s<=5
        % Plot Taylor
        mod = albedo.new.glaciers.swirsmooth(strt:fnsh,s);
        obs = albedo.new.TAR.measured(strt:fnsh);
        scatter(albedo.new.glaciers.swir(strt:fnsh,s), albedo.new.TAR.measured(strt:fnsh), 25, [0.5 0.5 0.5], 'filled');
        scatter(albedo.new.glaciers.swirsmooth(strt:fnsh,s), albedo.new.TAR.measured(strt:fnsh), 10, color(s,:), 'filled');
        % RMSE
        % Calculate RMSE
        err = (obs - mod);
        SE = err.^2;
        MSE = nansum(SE)/length(~isnan(SE));
        RMSE = sqrt(MSE);
        str = {[albedo.new.glaciers.names{s} ' - ' stationName{1}, '  RMS Error: ', num2str(RMSE, '%4.3f')]};
    elseif s==6||s==7
        % Plot Canada
        mod = albedo.new.glaciers.swirsmooth(strt:fnsh,s);
        obs = albedo.new.CAA.measured(strt:fnsh);
        scatter(albedo.new.glaciers.swir(strt:fnsh,s), albedo.new.CAA.measured(strt:fnsh), 25, [0.5 0.5 0.5], 'filled');
        scatter(albedo.new.glaciers.swirsmooth(strt:fnsh,s), albedo.new.CAA.measured(strt:fnsh), 10, color(s,:), 'filled');
        % Calculate RMSE
        err = (obs - mod);
        SE = err.^2;
        MSE = nansum(SE)/length(~isnan(SE));
        RMSE = sqrt(MSE);
        str = {[albedo.new.glaciers.names{s} ' - ' stationName{2}, '  RMS Error: ', num2str(RMSE, '%4.3f')]};
    elseif s==8
        strt=find(albedo.new.TAR.date==datenum([2000 11 1]));
        fnsh=find(albedo.new.TAR.date==datenum([2007 2 28]));
        % Plot Commonwealth
        mod = albedo.new.glaciers.swirsmooth(strt:fnsh,s);
        obs = albedo.new.COH.measured(strt:fnsh);
        scatter(albedo.new.glaciers.swir(strt:fnsh,s), albedo.new.COH.measured(strt:fnsh), 25, [0.5 0.5 0.5], 'filled');
        scatter(albedo.new.glaciers.swirsmooth(strt:fnsh,s), albedo.new.COH.measured(strt:fnsh), 10, color(s,:), 'filled');
        % Display
        str = {[albedo.new.glaciers.names{s} ' - ' stationName{3}, '  RMS Error: ', num2str(RMSE, '%4.3f')]};
    elseif s==9
        % Plot Howard
        mod = albedo.new.glaciers.swirsmooth(strt:fnsh,s);
        obs = albedo.new.HOD.measured(strt:fnsh);
        scatter(albedo.new.glaciers.swir(strt:fnsh,s), albedo.new.HOD.measured(strt:fnsh), 25, [0.5 0.5 0.5], 'filled');
        scatter(albedo.new.glaciers.swirsmooth(strt:fnsh,s), albedo.new.HOD.measured(strt:fnsh), 10, color(s,:), 'filled');
        % RMSE
        % Calculate RMSE
        err = (obs - mod);
        SE = err.^2;
        MSE = nansum(SE)/length(~isnan(SE));
        RMSE = sqrt(MSE);
        str = {[albedo.new.glaciers.names{s} ' - ' stationName{4}, '  RMS Error: ', num2str(RMSE, '%4.3f')]};
    end
    
    title(str, 'FontWeight', 'bold');
    
    if s==1||s==4||s==7
        ylabel('In-situ Station \alpha', 'FontWeight', 'bold')
    end
    if s==7||s==8||s==9
        xlabel('Glacier Mean MCD43A \alpha', 'FontWeight', 'bold')
    end
    line([0 1], [0 1],'Color','black','LineStyle','--');
    ylim([0 1])
    xlim([0 1])
    xticks(linspace(0.1,1,10))
    xticklabels('auto')
    yticks(linspace(0.1,1,10))
    yticklabels('auto')
    set(gca,'TickLength',[0.03, 0.03])
    box on
end

%% Export Figures

% cd '/Users/jucross/Documents/MDV-Lakes-Thesis/albedo-model/figures'
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
%     export_fig(f, ['images/', figName], '-png', '-nocrop');
%     
%     export_fig(f, figName, '-pdf', '-nocrop');
%     
% end
% 
% DirList     = dir('*.pdf');
% listOfFiles = {DirList.name};
% 
% append_pdfs('albedo_results.pdf', listOfFiles{:});
% delete fig*