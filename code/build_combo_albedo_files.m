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
        
        % Before 2007
        %if(albedo.CAA.date(d)<733590)
        % Before 01-July-2007 or 2007-08 summer
        if(albedo.CAA.date(d)<733224)
            switch g
                % Bonney
                case {1,2,3,4,5}
                    data(d,4)=albedo.AVG.measured(d);
%                     data(d,4)=albedo.TAR.measured(d);
                % Hoare
                case {6,7,9} 
                    data(d,4)=albedo.AVG.measured(d);
%                     data(d,4)=albedo.CAA.measured(d);
                % Fryxell
                case {8} 
                    if (~isnan(albedo.glaciers.swirsmooth(d,g))) % We have MODIS albedo this date
                        data(d,4)=albedo.glaciers.swirsmooth(d,g);
                    else % Otherwise pull from met station
                        data(d,4)=albedo.AVG.measured(d);
%                         data(d,4)=albedo.CAA.measured(d);
                    end
            end
        
        % After 2007
        elseif(albedo.CAA.date(d)>=733224)
            switch g
                % Bonney
                case {1,2,3,4,5}
                    if (~isnan(albedo.glaciers.swirsmooth(d,g))) % We have MODIS albedo this date
                        data(d,4)=albedo.glaciers.swirsmooth(d,g)*0.93;
                    else % Otherwise pull from met station
                        data(d,4)=albedo.AVG.measured(d)*0.93;
%                         data(d,4)=albedo.TAR.measured(d)*0.93;
                    end
                % Hoare
                case {6,7,9}
                    if (~isnan(albedo.glaciers.swirsmooth(d,g))) % We have MODIS albedo this date
                        data(d,4)=albedo.glaciers.swirsmooth(d,g)*0.93;
                    else % Otherwise pull from met station
                        data(d,4)=albedo.AVG.measured(d)*0.93;
%                         data(d,4)=albedo.CAA.measured(d)*0.93;
                    end
                % Fryxell
                case {8}
                    if (~isnan(albedo.glaciers.swirsmooth(d,g))) % We have MODIS albedo this date
                        data(d,4)=albedo.glaciers.swirsmooth(d,g)*0.93;
                    else % Otherwise pull from met station
                        data(d,4)=albedo.AVG.measured(d)*0.93;
%                         data(d,4)=albedo.CAA.measured(d)*0.93;
                    end
            end
        end
    end
    
    % Save table to structure and text file
    switch g
        case 1
            albedo.model.TAR = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.TAR'], albedo.model.TAR, '\t');
        case 2
            albedo.model.RHO = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.RHO'], albedo.model.RHO, '\t');
        case 3
            albedo.model.MTN = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.MTN'], albedo.model.MTN, '\t');
        case 4
            albedo.model.LCX = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.LCX'], albedo.model.LCX, '\t');
        case 5
            albedo.model.HUS = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.HUS'], albedo.model.HUS, '\t');
        case 6
            albedo.model.SUS = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.SUS'], albedo.model.SUS, '\t');
        case 7
            albedo.model.CAA = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.CAA'], albedo.model.CAA, '\t');
        case 8
            albedo.model.COH = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.COH'], albedo.model.COH, '\t');
        case 9
            albedo.model.HOD = data;
            dlmwrite([dataDir '/model-inputs/' 'combo_alb_new3.HOD'], albedo.model.HOD, '\t');
    end
end