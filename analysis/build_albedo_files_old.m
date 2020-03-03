clear;

%% Load Albedo Data Structures

dataDir = '/Users/Julian/Documents/!School/PSU GEOG MS/MDV-Lakes-Thesis/albedo-model/data/';

structure = load([dataDir 'albedo_old.mat']);

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
        
        if (~isnan(albedo.glaciers.swir(d,g))) % We have MODIS albedo this date
            data(d,4)=albedo.glaciers.swir(d,g);
        else % Otherwise pull from met station
            switch g
                case {1,7,8,9,10,11} % Average of TAR and CAA for Bonney
%                     data(d,4)=albedo.TAR.measured(d);
                    data(d,4)=albedo.AVG.measured(d);
                case {2,3} % Average of TAR and CAA for Hoare
%                     data(d,4)=albedo.CAA.measured(d);
                    data(d,4)=albedo.AVG.measured(d);
                case {4,5,6,12} % Average of TAR and CAA -0.05 for Fryxell
%                     data(d,4)=albedo.CAA.measured(d)-0.05;
                    data(d,4)=albedo.AVG.measured(d);
            end    
        end
    end
    
    % Save table to structure and text file
    switch g
        case 1
            albedo.model.TAR = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.TAR'], albedo.model.TAR, '\t');
        case 2
            albedo.model.SUS = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.SUS'], albedo.model.SUS, '\t');
        case 3
            albedo.model.CAA = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.CAA'], albedo.model.CAA, '\t');
        case 4
            albedo.model.COH = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.COH'], albedo.model.COH, '\t');
        case 5
            albedo.model.CRS = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.CRS'], albedo.model.CRS, '\t');
        case 6
            albedo.model.HOD = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.HOD'], albedo.model.HOD, '\t');
        case 7
            albedo.model.RHO = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.RHO'], albedo.model.RHO, '\t');
        case 8
            albedo.model.LCX = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.LCX'], albedo.model.LCX, '\t');
        case 9
            albedo.model.MTN = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.MTN'], albedo.model.MTN, '\t');
        case 10
            albedo.model.BNS = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.BNS'], albedo.model.BNS, '\t');
        case 11
            albedo.model.SLS = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.SLS'], albedo.model.SLS, '\t');
        case 12
            albedo.model.WLS = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_old.WLS'], albedo.model.WLS, '\t');
    end
end
