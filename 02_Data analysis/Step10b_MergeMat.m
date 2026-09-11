% Merge CalciumData and BaselineData into splitData
% Author: TianqiXU
% Date: 2025-07-19

clear; clc;

% Load original data
load('splitData_20250619_SuccessAng.mat');   % 主数据 splitData
load('splitCalciumData_20250719.mat');       % 含 calcium 信息的 splitCalciumData

% Loop through each entry in splitData
for i = 1:length(splitData)
    name1 = splitData(i).dataName;         % Get dataName
    stim1 = splitData(i).stimNumber;       % Get stimNumber

    % Look for matching entry in splitCalciumData
    for j = 1:length(splitCalciumData)
        name2 = splitCalciumData(j).dataName;
        stim2 = splitCalciumData(j).stimNumber;

        % If both name and stimNumber match
        if strcmp(name1, name2) && stim1 == stim2
            splitData(i).CalciumData = splitCalciumData(j).CalciumData;
            splitData(i).BaselineData = splitCalciumData(j).BaselineData;
            break;  % Stop searching after match
        end
    end
end

% Save updated splitData
save('splitData_20250719.mat', 'splitData');
disp('Saved as splitData_20250719.mat');
