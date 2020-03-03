clear;

%% Load Albedo Data Structures

dataDir = '/Users/Julian/Documents/!School/PSU GEOG MS/MDV-Lakes-Thesis/albedo-model/data/';

structure = load([dataDir 'albedo_new.mat']);

albedo = structure.albedo;

clear structure

%% Fill Gaps

% 'TAR' 'RHO' 'MTN' 'LCX' 'HUS'
% 'SUS' 'CAA' 'COH' 'HOD'

% Glacier loop
for g=1:9
    
    % Initialize array
    data = zeros(length(albedo.CAA.date),4);
    
    % Day loop
    for d=1:length(data)
        
        % get dates
        data(d,1) = year(albedo.CAA.date(d));
        data(d,2) = month(albedo.CAA.date(d));
        data(d,3) = day(albedo.CAA.date(d));
        
        if (~isnan(albedo.glaciers.swirsmooth(d,g))) % We have MODIS albedo this date
            data(d,4)=albedo.glaciers.swirsmooth(d,g);
        else % Otherwise pull from met station
            switch g
                case {1,2,3,4,5} % Average of TAR and CAA for Bonney
%                     data(d,4)=albedo.TAR.measured(d);
                    data(d,4)=albedo.AVG.measured(d);
                case {6,7} % Average of TAR and CAA for Hoare
%                     data(d,4)=albedo.CAA.measured(d);
                    data(d,4)=albedo.AVG.measured(d);
                case {8,9} % Average of TAR and CAA -0.05 for Fryxell
%                     data(d,4)=albedo.CAA.measured(d)-0.05;
                    data(d,4)=albedo.AVG.measured(d);
            end    
        end
    end
    
    % Save table to structure and text file
    switch g
        case 1
            albedo.model.TAR = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.TAR'], albedo.model.TAR, '\t');
        case 2
            albedo.model.RHO = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.RHO'], albedo.model.RHO, '\t');
        case 3
            albedo.model.MTN = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.MTN'], albedo.model.MTN, '\t');
        case 4
            albedo.model.LCX = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.LCX'], albedo.model.LCX, '\t');
        case 5
            albedo.model.HUS = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.HUS'], albedo.model.HUS, '\t');
        case 6
            albedo.model.SUS = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.SUS'], albedo.model.SUS, '\t');
        case 7
            albedo.model.CAA = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.CAA'], albedo.model.CAA, '\t');
        case 8
            albedo.model.COH = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.COH'], albedo.model.COH, '\t');
        case 9
            albedo.model.HOD = data;
            dlmwrite([dataDir '/model-inputs/' 'MODIS_alb_new.HOD'], albedo.model.HOD, '\t');
    end
end
