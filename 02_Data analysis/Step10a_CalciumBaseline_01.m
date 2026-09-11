%% Split calciumData into 5 individual stim trials
% Author: TianqiXU
% Date: 2025-07-19

close all; clear; clc;

%% Load calciumData
load('calciumData.mat');  % should load a struct array: calciumData

% Initialize new structure array
splitCalciumData = struct('serialNumber', {}, 'mouseType', {}, 'mouseID', {}, ...
    'dataName', {}, 'stimNumber', {}, 'ZscoreData', {}, ...
    'CalciumData', {}, 'BaselineData', {});

index = 0;  % Counter for splitCalciumData

for i = 1:length(calciumData)
    % Extract base information
    mouseType = calciumData(i).mouseType;
    mouseID = calciumData(i).mouseID;
    dataName = calciumData(i).dataName;
    Zdata = calciumData(i).ZscoreData;      % [2400×5]
    Cdata = calciumData(i).CalciumData;     % [2400×5]
    Bdata = calciumData(i).BaselineData;    % [600×1]

    % Loop through 5 stimulations
    for stim = 1:5
        index = index + 1;
        splitCalciumData(index).serialNumber = index;
        splitCalciumData(index).mouseType = mouseType;
        splitCalciumData(index).mouseID = mouseID;
        splitCalciumData(index).dataName = dataName;
        splitCalciumData(index).stimNumber = stim;

        % Extract 1 column of data (2400×1)
        splitCalciumData(index).ZscoreData = Zdata(:, stim);
        splitCalciumData(index).CalciumData = Cdata(:, stim);

        % Baseline remains the same for each split
        splitCalciumData(index).BaselineData = Bdata;
    end
end

%% Save result
save('splitCalciumData_20250719.mat', 'splitCalciumData');
fprintf('Split data saved as splitCalciumData_20250719.mat\n');

