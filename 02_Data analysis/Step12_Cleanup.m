% Cleanup and plot histogram of preCalciumNew
% Author: TianqiXU
% Date: 2025-07-19

clear; close all; clc;

% Load updated splitData structure
load('splitData_20250719_withBaselineZscore.mat');  % variable: splitData

% Parameters to filter usable data
targetMouseTypes = {'mtTRPV4','Control'};
targetPressureList = {'120mVpp','104mVpp'};  % 可选多个压强

% Logical index for valid entries
isValid = false(length(splitData), 1);

for i = 1:length(splitData)
    if isfield(splitData(i), 'isUsable') && splitData(i).isUsable && ...
       isfield(splitData(i), 'dataName') && any(contains(splitData(i).dataName, targetPressureList)) && ...
       isfield(splitData(i), 'mouseType') && any(strcmp(splitData(i).mouseType, targetMouseTypes)) && ...
       isfield(splitData(i), 'BaselineZscore') && ~isempty(splitData(i).BaselineZscore)

        isValid(i) = true;
    end
end

% Extract preCalciumNew values from valid entries
validPreCalcium = arrayfun(@(x) x.preCalciumNew, splitData(isValid));

% Plot histogram
figure('Color', 'w');

GFP_green = [144 238 144]/255;

histogram(validPreCalcium, 50, ...
    'FaceColor', GFP_green, ...
    'EdgeColor', 'none');
xlabel('Pre-Stimulation Calcium Mean (Z-score)', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Count', 'FontSize', 12, 'FontName', 'Arial');
title('Distribution of Pre-Stimulation Calcium Signal (Baseline-Zscore)', 'FontSize', 14);
set(gca, 'FontSize', 12, 'FontName', 'Arial');
grid on;

% Save figure
saveas(gcf, 'preCalciumNew_distribution.bmp');
saveas(gcf, 'preCalciumNew_distribution.fig');
fprintf('Figure saved as preCalciumNew_distribution.*\n');

% Save values back to .preCalcium field if needed
validIndices = find(isValid);
for k = 1:length(validIndices)
    splitData(validIndices(k)).preCalcium = validPreCalcium(k);  % 添加一个冗余字段
end

% Save updated splitData
save('splitData_20250719_cleanup.mat', 'splitData');
fprintf('Updated splitData saved as splitData_20250719_cleanup.mat\n');
