% Calculate baseline z-score and save to new field
% Author: TianqiXU
% Date: 2025-07-19

clear; clc;

% Load splitData
load('splitData_20250719.mat');  % variable: splitData

% Loop over each entry
for i = 1:length(splitData)
    calcium = splitData(i).CalciumData;     % 2401x1
    baseline = splitData(i).BaselineData;   % 600x1

    % Skip empty data
    if isempty(calcium) || isempty(baseline)
        splitData(i).BaselineZscore = [];
        splitData(i).preCalciumNew = NaN;
        continue;
    end

    % Compute mean and std of baseline
    mu = mean(baseline);
    sigma = std(baseline);

    % Avoid divide by 0
    if sigma == 0
        warning('Baseline std = 0 at entry %d (%s)', i, splitData(i).dataName);
        splitData(i).BaselineZscore = [];
        splitData(i).preCalciumNew = NaN;
        continue;
    end

    % Compute baseline z-score
    baselineZ = (calcium - mu) / sigma;

    % Save to structure
    splitData(i).BaselineZscore = baselineZ;

    % Calculate mean of first 600 points in baselineZ
    splitData(i).preCalciumNew = mean(baselineZ(1:600));
end

% Save updated structure
save('splitData_20250719_withBaselineZscore.mat', 'splitData');
disp('Saved as splitData_20250719_withBaselineZscore.mat');
