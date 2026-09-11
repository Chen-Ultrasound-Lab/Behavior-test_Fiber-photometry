function [] = S2_FiberSelectData_05(experimentDate, mouseID, stimulationLevel, ...
    pressureValue, mouseType, dataFolderPath, experimentDate_ID, dataPath, ...
    codePath, resultFolderName, resultFolderPath, resultPath, triger_thre, ...
    framerate, US_time, pulse_num, dutycycle)


% baseFolder = 'C:\Users\徐田奇\Box\ChenUltrasoundLab\38_Tianqi Xu\01_TRPV1\05_Data analysis\01_Matlab Codes\2024-12-14_Test';
% experimentDate_ID = '20240812_TRPV1_l-3_TX085';  % This can be modified as needed
% FUSID = '\113mVpp-1';                 % Modify this variable as needed
% risePoint = [14584,17583,20586,23590,26597]; % 113mVpp-1
% save_folder = 'C:\Users\徐田奇\Box\ChenUltrasoundLab\38_Tianqi Xu\01_TRPV1\05_Data analysis\01_Matlab Codes\2024-12-14_Test\Generated_Output';
% triger_thre = 11000; %previously it was 3000, change to 6000 %70000
% baselineData 2025-03-28


%% Load the .mat file
% Construct file path
fileName = sprintf('triggers_%s_%s_%s.mat', mouseID, experimentDate, stimulationLevel); % File name
fileFullPath = fullfile(resultFolderPath, sprintf('%s', resultFolderName), fileName); % Full path

% Load the .mat file
if exist(fileFullPath, 'file') % Check if file exists
    loadedData = load(fileFullPath); % Load the .mat file
    fprintf('File successfully loaded: %s\n', fileFullPath); % Display success message

    % Extract rising_edges data
    if isfield(loadedData, 'rising_edges')
        risePoint = loadedData.rising_edges; % Extract rising_edges data
        fprintf('Loaded risePoint data:\n');
        disp(risePoint); % Display data
    else
        error('The variable "risePoint" was not found in the file.'); % 提示缺少变量 Missing variable error
    end
else
    error('File not found: %s\nPlease check if the path or file name is correct.', fileFullPath); % 文件不存在提示 File not found error
end
%}


baseFolder = dataFolderPath;
FUSID = stimulationLevel;
save_folder = resultPath;







% Combine paths
folder = fullfile(baseFolder, experimentDate_ID);
% save_folder = fullfile(baseFolder, experimentDate_ID, subFolder);
% Combine FUSID with other strings to form the file names
triger_name = sprintf('%s_trigger.csv', FUSID);
calcium_name = sprintf('%s_calcium.csv', FUSID);

trig_num = pulse_num; % %KX edit: how many triggers there are // original: which stimulatation usually it is 1 for the first stimulation 
% save_folder = 'C:\Users\徐田奇\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Projects_02_TRPV4\2024-07_TRPV1_TRPV4_Experiment\02_Data\20240718_TRPV1_h-3_TX082\Code\';
before_fus = 1; %min before fus start
after_fus = 1; %min after fus 
rest_time = 1; %before that is rest state, same as before_fus?

% plot the trigger calciumnal to synchronize with ultrasound stimulation
% triger0 = xlsread([folder triger_name]);
triger0 = xlsread(fullfile(folder, triger_name));

framerate = framerate;
time_step = 1/framerate;
% calcium_all = xlsread([folder calcium_name]);
calcium_all = xlsread(fullfile(folder, calcium_name));
calcium = calcium_all(:,5);

% 
triger0 = imresize(triger0, [length(calcium), 1]);
time0 = 1:length(triger0);
time = time0 * time_step/60;
triger2 = triger0;

%% just for the manual trigger of 20240817
% 初始化triger3为全零 Initialize triger3 as a zero vector
triger3 = zeros(size(triger0));

%% 定义五次超声刺激的起始点 Define the start points of the five ultrasound stimulations

    stim_start_points = risePoint;

% 设置上升沿和高电平持续时间，超声刺激持续时间为15秒 Set the duration of the high level during ultrasound stimulation (15 seconds)
stim_duration = US_time * framerate; % 15秒对应的样本点数 % 15 seconds corresponding to the number of sample points

for i = 1:length(stim_start_points)
    start_point = stim_start_points(i);
    end_point = start_point + stim_duration - 1; % 刺激结束的点 Point where stimulation ends
    triger3(start_point:end_point) = 0.1; % 设置高电平 Set the high level
end

% 绘制结果以检查识别的高电平和持续时间 Plot the result to check the high levels and their durations
figure;
plot(triger3);
ylim([-1 2]);
title('Trigger Signal with Specified Stimulation Points');
xlabel('Sample Points');
ylabel('Trigger Signal');


figure;
plot(time,calcium);
hold on;
% plot(time,calcium_zscore);
plot(time,triger3,'r');
hold off;
ylabel('F');
xlabel('time (min)');

figure;
plot(calcium);
hold on;
% plot(time,calcium_zscore);
plot(triger3,'r');
hold off;
ylabel('F');



%% trunk the data


trig_dif = diff(triger3);
% fus_time = find(trig_dif>0.05);
fus_time = risePoint;

trunk_start =  fus_time(1) - before_fus*framerate*60;

trunk_end = fus_time(trig_num) + after_fus*framerate*60; %+ 90*framerate; % extended by 90 s so that 100s blocks stay consistent

calcium_original = calcium;
calcium = calcium(trunk_start:trunk_end);
triger = triger3(trunk_start:trunk_end);
time_cut = time(trunk_start:trunk_end);


figure;
plot(time_cut,calcium);
hold on;
% plot(time,calcium_zscore);
plot(time_cut,triger,'r');
hold off;
ylabel('F');
xlabel('time (min)');

%{
FUSID_cleaned = strrep(FUSID, '\', '');
% Extract the numeric part of FUSID
numericPart = sscanf(FUSID_cleaned, '%d');
% Check if the numeric part is less than 100 or greater/equal to 100
if numericPart < 100
    savename_calcium = [save_folder '/' calcium_name(1:9) '_calcium.mat'];
    savename_triger = [save_folder '/' calcium_name(1:9)  '_trigger.mat'];
    savename_rest = [save_folder '/' calcium_name(1:9) '_rest.mat'];
    output = 1;
else
    savename_calcium = [save_folder '/' calcium_name(1:10) 'calcium.mat'];
    savename_triger = [save_folder '/' calcium_name(1:10)  'trigger.mat'];
    savename_rest = [save_folder '/' calcium_name(1:10) 'rest.mat'];
    output = 2;
end
%}

% Step 1: Remove '_calcium.csv' suffix from calcium_name
[~, baseName, ~] = fileparts(calcium_name);  % e.g., '120mVpp_10DC-1_calcium' -> '120mVpp_10DC-1'

% Step 2: 统一命名（不依赖字符长度）
savename_calcium = fullfile(save_folder, [baseName, '.mat']);
savename_triger  = fullfile(save_folder, strrep(baseName, 'calcium', 'trigger') + ".mat");
savename_rest    = fullfile(save_folder, strrep(baseName, 'calcium', 'rest') + ".mat");


save(savename_calcium,'calcium');
save(savename_triger,'triger');

rest_ind = rest_time*framerate*60;
rest = calcium(5:rest_ind);
figure;
plot(rest);
hold on;
plot(triger3(1:rest_ind));
title('Resting state');

save(savename_rest,'rest');

% savename_rest = [save_folder calcium_name(1:9) '-rest.mat'];
% savename_rest = [save_folder calcium_name(1:8) '-' fus_num '-rest.mat'];

%% Calculate Baseline (2 min/5 min)
% figure;
% plot(calcium_original);
% hold on;
% % plot(time,calcium_zscore);
% plot(triger3,'r');
% hold off;
% ylabel('F');
% title('2')

before_time_2min = 2; % min
before_time_5min = 5; % min
samples_2min = before_time_2min * framerate * 60; % Sample points for 2 min
samples_5min = before_time_5min * framerate * 60; % Sample points for 5 min
start_index_2min = max(1, fus_time(1) - samples_2min); % 
start_index_5min = max(1, fus_time(1) - samples_5min);
% obtain signal
% calcium_2min = calcium_original(start_index_2min:fus_time(1) - 1);
% calcium_5min = calcium_original(start_index_5min:fus_time(1) - 1);
%% Debleach and filter the high frequency signal
fl = 0.0005; %0.0005
fh = 5;
Wn1 = fl/(framerate/2);
Wn2 = fh/(framerate/2);

[b1,a1] = butter(3, Wn1, 'high');
calcium_new = filtfilt(b1,a1,calcium_original);
% obtain signal
calcium_2min = calcium_new(start_index_2min:fus_time(1) - 1);
calcium_5min = calcium_new(start_index_5min:fus_time(1) - 1);


calcium_new_zscore = zscore(calcium_new);

% obtain z-score signal
zscore_2min = calcium_new_zscore(start_index_2min:fus_time(1) - 1);
zscore_5min = calcium_new_zscore(start_index_5min:fus_time(1) - 1);

% Average
mean_calcium_2min = mean(calcium_2min);
mean_calcium_5min = mean(calcium_5min);

mean_zscore_2min = mean(zscore_2min);
mean_zscore_5min = mean(zscore_5min);

% AUC
auc_calcium_2min = trapz(calcium_2min);
auc_calcium_5min = trapz(calcium_5min);

auc_zscore_2min = trapz(zscore_2min);
auc_zscore_5min = trapz(zscore_5min);

baseline_mat = [mean_calcium_2min; mean_calcium_5min; mean_zscore_2min; mean_zscore_5min; ...
    auc_calcium_2min; auc_calcium_5min; auc_zscore_2min; auc_zscore_5min]';
variable_names = {'mean_calcium_2min', 'mean_calcium_5min', 'mean_zscore_2min', 'mean_zscore_5min', ...
                  'auc_calcium_2min', 'auc_calcium_5min', 'auc_zscore_2min', 'auc_zscore_5min'};

% % T1 = array2table(baseline_mat, 'VariableNames', variable_names);
% T1 = table(baseline_mat, 'VariableNames', variable_names);
% T1.FileName = cell(size(T1, 1), 1); % 
% T1.FileName{end} = experimentDate_ID; % 
% % FUSID_cleaned = strrep(FUSID, '\', '');
% writetable(T1, append(experimentDate_ID, '_', FUSID, '_Baseline_250204.csv'))


% T1 = table(baseline_mat, 'VariableNames', variable_names);
% writetable(T1, append(experimentDate_ID, '_', FUSID, '_Baseline_250204.csv'))

T1 = array2table(baseline_mat, 'VariableNames', variable_names);
% writetable(T1, append(resultPath, '_', FUSID, '_Baseline_250204.csv'))
writetable(T1, fullfile(resultPath, append(resultFolderName, '_', FUSID, '_Baseline_250204.csv')));

%{
 Baseline 200717
%% Save Baseline (5 min data before US stimulation) data into one onified file

% Full path for baselineData.mat
baselineDataFile = fullfile(resultFolderPath, 'baselineData.mat');

% If the baselineData file already exists, it is loaded; otherwise, it is initialized as an empty array of structures.
if exist(baselineDataFile, 'file')
    temp = load(baselineDataFile, 'baselineData');
    baselineData = temp.baselineData;
else
    %  Initialize this array of structure
    baselineData = struct('serialNumber', {}, 'mouseType', {}, 'mouseID', {}, 'dataName', {}, 'baseCalciData', {}, 'baseZscoreData', {});
end

% Create new data structure for current experiment
newData.mouseType = mouseType;
newData.mouseID = mouseID;
newData.dataName = [mouseType '_' mouseID '_' experimentDate '_' stimulationLevel];
newData.baseCalciData = calcium_5min; % baseline Calcium Data
newData.baseZscoreData = zscore_5min; % baseline Zscore Data

% Check if dataName already exists
existIdx = find(strcmp({baselineData.dataName}, newData.dataName), 1);

if ~isempty(existIdx)
    % Delete existing data completely
    baselineData(existIdx) = [];
    fprintf('The data %s already exists. The old data was deleted and replaced with the latest data.\n', newData.dataName);
end

newData.serialNumber = length(baselineData) + 1;
baselineData = [baselineData; newData];

% Sort by mouseType, then by mouseID
[~, sortIdx] = sortrows([{baselineData.mouseType}' {baselineData.mouseID}']);
baselineData = baselineData(sortIdx);
fprintf('Baseline data %s has been added as the latest data.\n', newData.dataName);

% Save updated baselineData into the unified file
save(baselineDataFile, 'baselineData');
%}

end
