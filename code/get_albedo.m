clear;

%% Load Measured Albedo

dataDir = '/Users/Julian/Documents/!School/PSU GEOG MS/MDV-Lakes-Thesis/albedo-model/data/';

% TAR Met Station
path = [dataDir '9515_alb.TAR'];
fid=fopen(path);
station = textscan(fid,'%d %d %d %f');
fclose(fid);

% TAR structure
albedo.TAR.date = datenum(datetime([station{1} station{2} station{3}]));
albedo.TAR.measured = station{4};

% CAA Met Station
path = [dataDir '9515_alb.CAA'];
fid=fopen(path);
station = textscan(fid,'%d %d %d %f');
fclose(fid);

% CAA structure
albedo.CAA.date = datenum(datetime([station{1} station{2} station{3}]));
albedo.CAA.measured = station{4};

% Average of both CAA and TAR
albedo.AVG.date = datenum(datetime([station{1} station{2} station{3}]));
albedo.AVG.measured = (albedo.CAA.measured + albedo.TAR.measured)./2;

% COH Met Station
path = [dataDir '9515_alb.COH'];
fid=fopen(path);
station = textscan(fid,'%d %d %d %f');
fclose(fid);

% COH structure
albedo.COH.date = datenum(datetime([station{1} station{2} station{3}]));
albedo.COH.measured = station{4};

% HOD Met Station
path = [dataDir '9515_alb.HOD'];
fid=fopen(path);
station = textscan(fid,'%d %d %d %f');
fclose(fid);

% HOD structure
albedo.HOD.date = datenum(datetime([station{1} station{2} station{3}]));
albedo.HOD.measured = station{4};

%% Load MODIS Albedo for Met Stations

exportDirectory = '/Users/Julian/Documents/!School/PSU GEOG MS/MDV-Lakes-Thesis/albedo-model/data/gee-exports/';

opts = detectImportOptions([exportDirectory 'alb_extract_TARM_05.csv']);

% TAR Met Station
station = vertcat(table2cell(readtable([exportDirectory 'alb_extract_TARM_05.csv'],...
        'FileEncoding','ISO-8859-15', 'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')),...
    table2cell(readtable([exportDirectory 'alb_extract_TARM_10.csv'],...
        'FileEncoding','ISO-8859-15', 'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')),...
    table2cell(readtable([exportDirectory 'alb_extract_TARM_15.csv'],...
        'FileEncoding','ISO-8859-15', 'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')));
days = cellfun(@datenum, station(:,1));

for d=1:length(albedo.TAR.date)
    dayind = find(datenum(days)==albedo.TAR.date(d));
    if (length(dayind)==1) % we have an entry for this day
        if(station{dayind,2} > 0) 
            albedo.TAR.swirBSA(d,1)=station{dayind,2}/1000;
            albedo.TAR.swirWSA(d,1)=station{dayind,4}/1000;
            albedo.TAR.swir(d,1)=(((station{dayind,2}+station{dayind,4}))/2)/1000;
            albedo.TAR.visBSA(d,1)=station{dayind,3}/1000;
            albedo.TAR.snow(d,1)=station{dayind,8}/100;
        else % NAN value
            albedo.TAR.swirBSA(d,1)=NaN;
            albedo.TAR.swirWSA(d,1)=NaN;
            albedo.TAR.swir(d,1)=NaN;
            albedo.TAR.visBSA(d,1)=NaN;
            albedo.TAR.snow(d,1)=NaN;
        end
    else % no good data for the day
        albedo.TAR.swirBSA(d,1)=NaN;
        albedo.TAR.swirWSA(d,1)=NaN;
        albedo.TAR.swir(d,1)=NaN;
        albedo.TAR.visBSA(d,1)=NaN;
        albedo.TAR.snow(d,1)=NaN;
    end
end

% CAA Met Station
station = vertcat(table2cell(readtable([exportDirectory 'alb_extract_CAAM_05.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')),...
    table2cell(readtable([exportDirectory 'alb_extract_CAAM_10.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')),...
    table2cell(readtable([exportDirectory 'alb_extract_CAAM_15.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')));
days = cellfun(@datenum, station(:,1));

for d=1:length(albedo.CAA.date)
    dayind = find(datenum(days)==albedo.CAA.date(d));
    if (length(dayind)==1) % we have an entry for this day
        if(station{dayind,2} > 0) 
            albedo.CAA.swirBSA(d,1)=station{dayind,2}/1000;
            albedo.CAA.swirWSA(d,1)=station{dayind,4}/1000;
            albedo.CAA.swir(d,1)=(((station{dayind,2}+station{dayind,4}))/2)/1000;
            albedo.CAA.visBSA(d,1)=station{dayind,3}/1000;
            albedo.CAA.snow(d,1)=station{dayind,8}/100;
        else % NAN value
            albedo.CAA.swirBSA(d,1)=NaN;
            albedo.CAA.swirWSA(d,1)=NaN;
            albedo.CAA.swir(d,1)=NaN;
            albedo.CAA.visBSA(d,1)=NaN;
            albedo.CAA.snow(d,1)=NaN;
        end
    else % no good data for the day
        albedo.CAA.swirBSA(d,1)=NaN;
        albedo.CAA.swirWSA(d,1)=NaN;
        albedo.CAA.swir(d,1)=NaN;
        albedo.CAA.visBSA(d,1)=NaN;
        albedo.CAA.snow(d,1)=NaN;
    end
end

% COH Met Station
station = vertcat(table2cell(readtable([exportDirectory 'alb_extract_COHM_05.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')),...
    table2cell(readtable([exportDirectory 'alb_extract_COHM_10.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')),...
    table2cell(readtable([exportDirectory 'alb_extract_COHM_15.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')));
days = cellfun(@datenum, station(:,1));

for d=1:length(albedo.COH.date)
    dayind = find(datenum(days)==albedo.COH.date(d));
    if (length(dayind)==1) % we have an entry for this day
        if(station{dayind,2} > 0) 
            albedo.COH.swirBSA(d,1)=station{dayind,2}/1000;
            albedo.COH.swirWSA(d,1)=station{dayind,4}/1000;
            albedo.COH.swir(d,1)=(((station{dayind,2}+station{dayind,4}))/2)/1000;
            albedo.COH.visBSA(d,1)=station{dayind,3}/1000;
            albedo.COH.snow(d,1)=station{dayind,8}/100;
        else % NAN value
            albedo.COH.swirBSA(d,1)=NaN;
            albedo.COH.swirWSA(d,1)=NaN;
            albedo.COH.swir(d,1)=NaN;
            albedo.COH.visBSA(d,1)=NaN;
            albedo.COH.snow(d,1)=NaN;
        end
    else % no good data for the day
        albedo.COH.swirBSA(d,1)=NaN;
        albedo.COH.swirWSA(d,1)=NaN;
        albedo.COH.swir(d,1)=NaN;
        albedo.COH.visBSA(d,1)=NaN;
        albedo.COH.snow(d,1)=NaN;
    end
end

% HOD Met Station
station = vertcat(table2cell(readtable([exportDirectory 'alb_extract_HODM_05.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')),...
    table2cell(readtable([exportDirectory 'alb_extract_HODM_10.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')),...
    table2cell(readtable([exportDirectory 'alb_extract_HODM_15.csv'],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f %f %s %s %s %f %s %s')));
days = cellfun(@datenum, station(:,1));

for d=1:length(albedo.HOD.date)
    dayind = find(datenum(days)==albedo.HOD.date(d));
    if (length(dayind)==1) % we have an entry for this day
        if(station{dayind,2} > 0)
            albedo.HOD.swirBSA(d,1)=station{dayind,2}/1000;
            albedo.HOD.swirWSA(d,1)=station{dayind,4}/1000;
            albedo.HOD.swir(d,1)=(((station{dayind,2}+station{dayind,4}))/2)/1000;
            albedo.HOD.visBSA(d,1)=station{dayind,3}/1000;
            albedo.HOD.snow(d,1)=station{dayind,8}/100;
        else % NAN value
            albedo.HOD.swirBSA(d,1)=NaN;
            albedo.HOD.swirWSA(d,1)=NaN;
            albedo.HOD.swir(d,1)=NaN;
            albedo.HOD.visBSA(d,1)=NaN;
            albedo.HOD.snow(d,1)=NaN;
        end
    else % no good data for the day
        albedo.HOD.swirBSA(d,1)=NaN;
        albedo.HOD.swirWSA(d,1)=NaN;
        albedo.HOD.swir(d,1)=NaN;
        albedo.HOD.visBSA(d,1)=NaN;
        albedo.HOD.snow(d,1)=NaN;
    end
end

%% Load MODIS Albedo for Glaciers

exportDirectory = '/Users/Julian/Documents/!School/PSU GEOG MS/MDV-Lakes-Thesis/albedo-model/data/gee-exports/';

albedo.glaciers.names = {   'TAR', 'RHO', 'MTN', 'LCX','HUS',...
                            'SUS', 'CAA', 'COH', 'HOD'};
                     
for g=1:9
    
    name = albedo.glaciers.names{g};
    
    % Read glacier extract file
    glacier = vertcat(...
        table2cell(readtable([exportDirectory ['alb_new_extract_' name '_05.csv']],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f')),...
        table2cell(readtable([exportDirectory ['alb_new_extract_' name '_10.csv']],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f')),...
        table2cell(readtable([exportDirectory ['alb_new_extract_' name '_15.csv']],...
        'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false, 'Format', '%D %f %f')));
    
    days = cellfun(@datenum, glacier(:,1));
    
    for d=1:length(albedo.TAR.date)
        dayind = find(datenum(days)==albedo.TAR.date(d));
        if (length(dayind)==1) % we have an entry for this day
            if(glacier{dayind,2} > 0)
                albedo.glaciers.swirBSA(d,g)=glacier{dayind,2}/1000;
                albedo.glaciers.swirWSA(d,g)=glacier{dayind,3}/1000;
                albedo.glaciers.swir(d,g)=(((glacier{dayind,2}+glacier{dayind,3}))/2)/1000;
%                 albedo.glaciers.visBSA(d,g)=glacier{dayind,3}/1000;
%                 albedo.glaciers.snow(d,g)=glacier{dayind,8}/100;
            else % NAN value
                albedo.glaciers.swirBSA(d,g)=NaN;
                albedo.glaciers.swirWSA(d,g)=NaN;
                albedo.glaciers.swir(d,g)=NaN;
%                 albedo.glaciers.visBSA(d,g)=NaN;
%                 albedo.glaciers.snow(d,g)=NaN;
            end
        else % no good data for the day
            albedo.glaciers.swirBSA(d,g)=NaN;
            albedo.glaciers.swirWSA(d,g)=NaN;
            albedo.glaciers.swir(d,g)=NaN;
%             albedo.glaciers.visBSA(d,g)=NaN;
%             albedo.glaciers.snow(d,g)=NaN;
        end
    end
end

%% Generate Moving Average Albedo (Smoothing Filter)

windowSize = 7;

albedo.TAR.swirBSAsmooth=movmean(albedo.TAR.swirBSA(),windowSize,1);
albedo.TAR.swirWSAsmooth=movmean(albedo.TAR.swirWSA(),windowSize,1);
albedo.TAR.swirsmooth=movmean(albedo.TAR.swir(),windowSize,1);
albedo.TAR.visBSAsmooth=movmean(albedo.TAR.visBSA(),windowSize,1);
albedo.TAR.snowsmooth=movmean(albedo.TAR.snow(),windowSize,1);

albedo.CAA.swirBSAsmooth=movmean(albedo.CAA.swirBSA(),windowSize,1);
albedo.CAA.swirWSAsmooth=movmean(albedo.CAA.swirWSA(),windowSize,1);
albedo.CAA.swirsmooth=movmean(albedo.CAA.swir(),windowSize,1);
albedo.CAA.visBSAsmooth=movmean(albedo.CAA.visBSA(),windowSize,1);
albedo.CAA.snowsmooth=movmean(albedo.CAA.snow(),windowSize,1);

albedo.HOD.swirBSAsmooth=movmean(albedo.HOD.swirBSA(),windowSize,1);
albedo.HOD.swirWSAsmooth=movmean(albedo.HOD.swirWSA(),windowSize,1);
albedo.HOD.swirsmooth=movmean(albedo.HOD.swir(),windowSize,1);
albedo.HOD.visBSAsmooth=movmean(albedo.HOD.visBSA(),windowSize,1);
albedo.HOD.snowsmooth=movmean(albedo.HOD.snow(),windowSize,1);

albedo.COH.swirBSAsmooth=movmean(albedo.COH.swirBSA(),windowSize,1);
albedo.COH.swirWSAsmooth=movmean(albedo.COH.swirWSA(),windowSize,1);
albedo.COH.swirsmooth=movmean(albedo.COH.swir(),windowSize,1);
albedo.COH.visBSAsmooth=movmean(albedo.COH.visBSA(),windowSize,1);
albedo.COH.snowsmooth=movmean(albedo.COH.snow(),windowSize,1);

albedo.glaciers.swirBSAsmooth=movmean(albedo.glaciers.swirBSA(),windowSize,1);
albedo.glaciers.swirWSAsmooth=movmean(albedo.glaciers.swirWSA(),windowSize,1);
albedo.glaciers.swirsmooth=movmean(albedo.glaciers.swir(),windowSize,1);
% albedo.glaciers.visBSAsmooth=movmean(albedo.glaciers.visBSA(),windowSize,1);
% albedo.glaciers.snowsmooth=movmean(albedo.glaciers.snow(),windowSize,1);


%% Save structure

save([dataDir 'albedo_new.mat'], 'albedo');