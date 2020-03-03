clear;

%% Load Albedo Data Structures

dataDir = '/Users/Julian/Documents/!School/PSU GEOG MS/MDV-Lakes-Thesis/albedo-model/data/';

structure = load([dataDir 'albedo.mat']);

albedo = structure.albedo;

clear structure

%% Fill Gaps

% Glacier loop
for g=1:12
    
    % Initialize array
    data = zeros(length(albedo.CAA.date),4);
    
    % Day loop
    for d=1:length(data)
        
        % get dates
        data(d,1) = year(albedo.CAA.date(d));
        data(d,2) = month(albedo.CAA.date(d));
        data(d,3) = day(albedo.CAA.date(d));
        
        % Before 2008
        if(albedo.CAA.date(d)<733590)
            switch g
                % Bonney
                case {1,7,8,9,10,11}
                    data(d,4)=albedo.AVG.measured(d);
                % Hoare
                case {2,3,5,6} 
                    data(d,4)=albedo.AVG.measured(d);
                % Fryxell
                case {4,12} 
                    if (~isnan(albedo.glaciers.swir(d,g))) % We have MODIS albedo this date
                        data(d,4)=albedo.glaciers.swir(d,g);
                    else % Otherwise pull from met station
                        data(d,4)=albedo.AVG.measured(d);
                    end
            end
        
        % After 2008
        elseif(albedo.CAA.date(d)>=733590)
            if (~isnan(albedo.glaciers.swir(d,g))) % We have MODIS albedo this date
                data(d,4)=albedo.glaciers.swir(d,g);
            else % Otherwise pull from met station
                switch g
                    % Bonney
                    case {1,7,8,9,10,11}
                        % data(d,4)=albedo.TAR.measured(d);
                        data(d,4)=albedo.AVG.measured(d);
                    % Hoare
                    case {2,3,5,6}
                        % data(d,4)=albedo.CAA.measured(d);
                        data(d,4)=albedo.AVG.measured(d);
                    % Fryxell
                    case {4,12}
                        % data(d,4)=albedo.CAA.measured(d)-0.05;
                        data(d,4)=albedo.AVG.measured(d);
                end    
            end
        end
    end
    
    % Save table to structure and text file
    switch g
        case 1
            albedo.model.TAR = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.TAR'], albedo.model.TAR, '\t');
        case 2
            albedo.model.SUS = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.SUS'], albedo.model.SUS, '\t');
        case 3
            albedo.model.CAA = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.CAA'], albedo.model.CAA, '\t');
        case 4
            albedo.model.COH = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.COH'], albedo.model.COH, '\t');
        case 5
            albedo.model.CRS = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.CRS'], albedo.model.CRS, '\t');
        case 6
            albedo.model.HOD = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.HOD'], albedo.model.HOD, '\t');
        case 7
            albedo.model.RHO = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.RHO'], albedo.model.RHO, '\t');
        case 8
            albedo.model.LCX = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.LCX'], albedo.model.LCX, '\t');
        case 9
            albedo.model.MTN = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.MTN'], albedo.model.MTN, '\t');
        case 10
            albedo.model.BNS = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.BNS'], albedo.model.BNS, '\t');
        case 11
            albedo.model.SLS = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.SLS'], albedo.model.SLS, '\t');
        case 12
            albedo.model.WLS = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb.WLS'], albedo.model.WLS, '\t');
    end
end