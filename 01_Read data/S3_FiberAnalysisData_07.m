function [] = S3_FiberAnalysisData_07(experimentDate, mouseID, stimulationLevel, ...
    pressureValue, mouseType, dataFolderPath, experimentDate_ID, ...
    resultFolderName, resultFolderPath, resultPath, ...
    framerate, US_time, Analysis_US_time, dutycycle)

%% Note: The Z-score normalization here is computed within each individual recording itself,
%% meaning the signal is normalized to its own ultrasound stimulation baseline (not across one experiment with 5 stimulations)

%% This code is original writted by Mack, and modified by Kevin, and modified by Tianqi Xu 2024-08:
%% this code is to calculate the following parameters: 
%peak_eachfus; peak_w_eachfus; freq_eachfus; top_peak_eachfus; top_peak_w_eachfus; top_freq_eachfus; fus_base
% The main final output is 'All_mat'. It should be copy to the excel file
% C:\Users\heng9\Box\ChenUltrasoundLab\09_Mack_Yang\35_Hibernation\Result\Photometry\Summary\!Study1_Round2_all_quantification

% % Define the new folder path
% output_folder = 'C:\Users\徐田奇\Box\ChenUltrasoundLab\38_Tianqi Xu\01_TRPV1\05_Data analysis\01_Matlab Codes\2024-12-14_Test\Generated_Output';
% baseFolder = 'C:\Users\xu.t\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Projects_02_TRPV4\2024-07_TRPV1_TRPV4_Experiment\02_Data';
% experimentDate_ID = '20240812_TRPV1_l-3_TX085';     % This can be modified as needed
% FUSID = '113mVpp-1';                                % Modify this variable as needed
% pressureValue = 1.4;                                % Modify as pressure

baseFolder = dataFolderPath;
FUSID = stimulationLevel;
output_folder = resultPath;
save_fig_folder = output_folder;
myLocation = 'northeast';

PlotColor = getPlotColor(mouseType);


% miceID = ''; % the POADMH-42 is represented as 'POADMH4_' '90mV2' miceID = 'POADMH4_';

% experimentDate_ID = '20240718_TRPV1_h-1_TX080'; % Modify this variable as needed
% Replace underscores with hyphens
% experimentDate_ID_title = strrep(experimentDate_ID, '_', '-');
% experimentDate_ID_title = resultFolderName;
experimentDate_ID_title = [mouseType, '-', mouseID, '-', experimentDate, '-', stimulationLevel];

% % Each Z-Score
% figureTitle_zscoreEach = sprintf('%s-High Titer-Z-Score(%.1f MPa)', experimentDate_ID_title, pressureValue);
% fileName_zscoreEach = sprintf('%s_zscoreEach_%s', experimentDate_ID, FUSID);
% % Mean Z-Score
% figureTitle_zscoreMean = sprintf('%s-High Titer-Z-Score(%.1f MPa)', experimentDate_ID_title, pressureValue);
% fileName_zscoreMean = sprintf('%s_zscoreMean_%s', experimentDate_ID, FUSID);
% % Calcium
% figureTitle_calcium = sprintf('%s-High Titer-Calcium(%.1f MPa)', experimentDate_ID_title, pressureValue);
% fileName_calcium = sprintf('%s_Calcium_%s', experimentDate_ID, FUSID);
% % Z-Score
% figureTitle_zscore = sprintf('%s-High Titer-Z-Score(%.1f MPa)', experimentDate_ID_title, pressureValue);
% fileName_zscore = sprintf('%s_zscore_%s', experimentDate_ID, FUSID);


% Each Z-Score
figureTitle_zscoreEach = sprintf('%s-Zscore(%.1f MPa)', experimentDate_ID_title, pressureValue);
fileName_zscoreEach = sprintf('%s_zscoreEach_%s', experimentDate_ID_title, FUSID);
% Mean Z-Score
figureTitle_zscoreMean = sprintf('%s-Zscore(%.1f MPa)', experimentDate_ID_title, pressureValue);
fileName_zscoreMean = sprintf('%s_zscoreMean_%s', experimentDate_ID_title, FUSID);
% Calcium
figureTitle_calcium = sprintf('%s-Calcium(%.1f MPa)', experimentDate_ID_title, pressureValue);
fileName_calcium = sprintf('%s_Calcium_%s', experimentDate_ID_title, FUSID);
% Z-Score
figureTitle_zscore = sprintf('%s-Zscore(%.1f MPa)', experimentDate_ID_title, pressureValue);
fileName_zscore = sprintf('%s_zscore_%s', experimentDate_ID_title, FUSID);


before_time = 1; %min before fus
after_time = 0.5; %min after fus

timebef = US_time; %(s) it is uesed to calculate each before FUS 
% For 20240716_TRPV1_h-1_TX080, the interval is not 85s, but about 45s, so
% total US time is 6.5 min
timeCal = Analysis_US_time; %(s) it is uesed to calculate each before FUS 
total_end = 8.4; % this is the maximun length of the timeline unit is min (8.3 min)
fs = framerate;
time_step = 1/fs;
stop = ceil(total_end * fs *60);

% Update file paths to point to the output folder
triger_name = fullfile(save_fig_folder, [FUSID '_trigger.mat']);
sig_name = fullfile(save_fig_folder, [FUSID '_calcium.mat']);
rest_name = fullfile(save_fig_folder, [FUSID '_rest.mat']);


% Load the files
load(triger_name);
load(sig_name);
load(rest_name);


% triger_name = [folder FUSID '_trigger.mat'];
% load(triger_name);
triger(stop:end) = 0;
% 
% sig_name = [folder FUSID '_calcium.mat'];
% load(sig_name);

% rest_name = [folder FUSID '_rest.mat'];
% load(rest_name);

time0 = 1:length(calcium);
time = time0 * time_step/60;

%% Debleach and filter the high frequency signal
fl = 0.0005; %0.0005
fh = 5;
Wn1 = fl/(fs/2);
Wn2 = fh/(fs/2);

[b1,a1] = butter(3, Wn1, 'high');
calcium_filt0 = filtfilt(b1,a1,calcium);
rest_filt0 = filtfilt(b1,a1,rest);

[b2,a2] = butter(3, Wn2, 'low');
calcium_filt = filtfilt(b2,a2,calcium_filt0);
rest_filt = filtfilt(b2,a2,rest_filt0);

%% Whole Z-Score
calcium_zscore = zscore(calcium_filt);
rest_zscore = zscore(rest_filt);
sig_zscore = zscore(calcium);

figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(time,calcium_zscore,'b','LineWidth',1.5);
hold on;
plot(time,sig_zscore,'r','LineWidth',1.5);
hold on
plot(time,triger,'y','LineWidth',1.5);
hold off;
legend('filtered signal', 'raw signal','Trigger');
ylabel('zscore');
xlabel('time (min)');

triger_dif = diff(triger);
eachfus_start = find(triger_dif>0);

% Define the number of sample points for each time segment
% before-during-after
time_before = timeCal * fs;  % Before each US 20s/Upadated 20/22/2024
time_during = timeCal * fs;  % During each US 20s/Upadated 20/22/2024
time_after = timeCal * fs;   % After each US 20s/Upadated 20/22/2024
time_extra = timeCal * fs;   % Extra after each US 20s/Upadated 20/22/2024
num_each_time = time_before + time_during + time_after + time_extra;

time_baseline = timeCal * fs;  % Before before each US 20s/Upadated 17/07/2025


% Initialize a cell array to store the data
num_stimuli = length(eachfus_start);  % 超声刺激的次数 (Number of stimuli)

each_US_data = zeros(num_each_time+1, num_stimuli);
each_zscore_data = zeros(num_each_time, num_stimuli);

each_baseline_data = zeros(time_baseline, num_stimuli); % 07/17/25

% added at 02/04/2024
beforeus_zscore = zeros(time_before, num_stimuli);
duringus_zscore = zeros(time_during, num_stimuli);
afterus_zscore = zeros(time_after, num_stimuli);
extraus_zscore = zeros(time_extra, num_stimuli);


% Loop through each ultrasound stimulation segment

baseline_data = calcium_filt(eachfus_start(1) - time_before - time_baseline : eachfus_start(1) - time_before - 1);
for i = 1:num_stimuli
    each_US_start_point = eachfus_start(i);
    % Extract data for each time segment
    before_data = calcium_filt(each_US_start_point - time_before : each_US_start_point - 1);
    during_data = calcium_filt(each_US_start_point : each_US_start_point + time_during - 1);
    after_data = calcium_filt(each_US_start_point + time_during : each_US_start_point + time_during + time_after - 1);
    extraafter_data = calcium_filt(each_US_start_point + time_during + time_after : each_US_start_point + time_during + time_after + time_extra);




    each_US = [before_data; during_data; after_data; extraafter_data];

    each_zscore_raw = zscore(each_US);
    
    % max_zscore = max(each_zscore_raw);
    % each_zscore = each_zscore_raw/max(each_zscore_raw);
    each_zscore = each_zscore_raw; % Method2: No normalization
    
    each_zscore = movmean(each_zscore, 5);
    each_zscore(end) = [];

    peak_before = [];
    peak_during = [];
    peak_after = [];
    peak_extra = [];
    freq_before = [];
    freq_during = [];
    freq_after = [];
    freq_extra = [];
    width_before = [];
    width_during = [];
    width_after = [];
    width_extra = [];

    % 在Z-score信号上找到所有峰值
    [pks, locs, w, p] = findpeaks(each_zscore);
    % 筛选出最显著的峰值（突出度在99百分位数以上）
    top_peak = prctile(p, 99);
    toppeak_ind0 = find(p > top_peak);  % 突出度超过99百分位数的峰值索引
    toppeak_ind = locs(toppeak_ind0);   % 这些峰值在信号中的位置

    before_idx = 1 : length(before_data);
    during_idx = length(before_data) + 1: length(before_data) + length(during_data);
    after_idx = length(before_data) + length(during_data) + 1 : length(before_data) + length(during_data) + length(after_data);
    extra_idx = length(before_data) + length(during_data) + length(after_data) + 1 : length(before_data) + length(during_data) + length(after_data) + length(extraafter_data) - 1;

    % 在特定时间段内匹配最显著的峰值
    before_ind = ismember(toppeak_ind, before_idx);
    during_ind = ismember(toppeak_ind, during_idx);
    after_ind = ismember(toppeak_ind, after_idx);
    extra_ind = ismember(toppeak_ind, extra_idx);

    % 计算每个时间段的峰值参数
    peak_before(i) = mean(pks(before_ind));
    peak_during(i) = mean(pks(during_ind));
    peak_after(i) = mean(pks(after_ind));
    peak_extra(i) = mean(pks(extra_ind));

    width_before(i) = mean(w(before_ind)) / fs;
    width_during(i) = mean(w(during_ind)) / fs;
    width_after(i) = mean(w(after_ind)) / fs;
    width_extra(i) = mean(w(extra_ind)) / fs;

    freq_before(i) = length(find(before_ind)) / (length(before_idx) / fs * 60);
    freq_during(i) = length(find(during_ind)) / (length(during_idx) / fs * 60);
    freq_after(i) = length(find(after_ind)) / (length(after_idx) / fs * 60);
    freq_extra(i) = length(find(extra_ind)) / (length(extra_idx) / fs * 60);
    

    % 提取标准化后的每个时间段的信号
    before_zscore = each_zscore(1 : length(before_data));
    during_zscore = each_zscore(length(before_data) + 1: length(before_data) + length(during_data));
    after_zscore = each_zscore(length(before_data) + length(during_data) + 1 : length(before_data) + length(during_data) + length(after_data));
    extra_zscore = each_zscore(length(before_data) + length(during_data) + length(after_data) + 1 : length(before_data) + length(during_data) + length(after_data) + length(extraafter_data) - 1);
    
    %% Segmented calcium-z score
    m_before_zscore = mean(before_zscore);
    m_during_zscore = mean(during_zscore);
    m_after_zscore = mean(after_zscore);
    m_extra_zscore = mean(extra_zscore);

    % Added at 10/29/2024
    beforeus_zscore(:,i) = before_zscore;
    duringus_zscore(:,i) = during_zscore;
    afterus_zscore(:,i) = after_zscore;
    extraus_zscore(:,i) = extra_zscore;

    % %% quantify the peak parameters
    % [pks,locs,w,p] = findpeaks(each_zscore);
    % top_peak = prctile(p,99);
    % toppeak_ind0 = find (p>top_peak);
    % toppeak_ind = locs(toppeak_ind0);

    each_US_data(:,i) = each_US;
    each_zscore_data(:,i) = each_zscore;
    %% Segmented calcium-z score 20/05/2025
    each_before(:,i) = m_before_zscore;
    each_during(:,i) = m_during_zscore;
    each_after(:,i) = m_after_zscore;
    each_extra(:,i) = m_extra_zscore;

    % figure
    % plot(each_US_data(:,i),'b')
    % figure
    % plot(each_zscore_data(:,i),'r')
    
end

zscore_mat = [each_before; each_during; each_after; each_extra]';
mean_each_before = mean(each_before);
mean_each_during = mean(each_during);
mean_each_after = mean(each_after);
mean_each_extra = mean(each_extra);

% analysis_Z-Score_each = [each_before;each_during;each_after;each_extra]';
% analysis_Z-Score_mean = [mean(each_before),mean(each_during),mean(each_after),mean(each_extra)];
% analysis_Z-Score_std = [std(each_before),std(each_during),std(each_after),std(each_extra)];

% analysis_Z-Score_each = [mean_each_before;mean_each_during;mean_each_after;mean_each_extra];
% analysis_Z-Score_mean = [mean(each_before),mean(each_during),mean(each_after),mean(each_extra)];
% analysis_Z-Score_std = [std(each_before),std(each_during),std(each_after),std(each_extra)];

%% Image
% Each Z-Score
each_time = (1:num_each_time)/fs;
y_low = min(min(each_zscore_data));
y_high = max(max(each_zscore_data));
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,each_zscore_data(:,1), 'Color', '#666666','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,each_zscore_data(:,2), 'Color', '#0099CC','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,each_zscore_data(:,3), 'Color', '#66CC99','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,each_zscore_data(:,4), 'Color', '#FFCC66','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,each_zscore_data(:,5), 'Color', '#CC6666','LineStyle','-','LineWidth',1);
hold on;

% US stimulationlegend('filtered signal', 'raw signal','Trigger');
x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+timebef, (time_before+1)/fs+timebef];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
legend('Data 1', 'Data 2','Data 3','Data 4','Data 5','Ultrasound','Location',myLocation);
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
% ylabel('Normalized Z-score','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Z-score','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(output_folder, figureTitle_zscoreEach, fileName_zscoreEach);

% Mean + Std
mean_data = mean(each_zscore_data,2);
std_data = std(each_zscore_data,0,2);
% Calculate the upper and lower bounds
upper_bound = mean_data + std_data;  % 上边界 Upper bound
lower_bound = mean_data - std_data;  % 下边界 Lower bound
y_low = min(min(lower_bound));
y_high = max(max(upper_bound));
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,mean_data, 'Color', PlotColor,'LineStyle','-','LineWidth',1);
hold on;
% Optional: Plot the upper and lower bounds as dashed lines
plot(each_time, upper_bound, 'Color', PlotColor', 'LineStyle', '--', 'LineWidth', 1);
hold on
% US stimulation
x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+timebef, (time_before+1)/fs+timebef];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
plot(each_time, lower_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
legend('Mean Z-Score', 'Std Z-Score','US Stimulation','Location',myLocation);
hold on;
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
% ylabel('Normalized Z-score','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Z-score','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(output_folder, figureTitle_zscoreMean, fileName_zscoreMean);

%{
F18793

A5EBC9
ACCEE9
A29DF7
BC97C0

F9E98A
([255,217,102]/255)
%}

% trig_before = triger; trig_before(:)=0;
% for i=1:size(eachfus_start)
%     trig_before(eachfus_start(i)-timebef*fs: eachfus_start(i))=1;
% end
% 
% figure
% plot(trig_before)

% %{
% image for the whole z-score
%% plot the signal 

% save_fig = [save_fig_folder miceID '_' FUSID];
time_view = (eachfus_start(1)-before_time*60*fs):(eachfus_start(num_stimuli)+after_time*90*fs); %
% TX image  
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(time(1:length(time_view)),calcium(1:length(time_view)), 'Color', PlotColor,'LineStyle','-','LineWidth',1);
hold on;
plot(time(1:length(time_view)),triger(1:length(time_view)),'Color', [255,217,102]/255,'LineWidth',2);
hold off;
%xlim ([3 35]);
xlabel('Time (min)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Calcium','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(output_folder, figureTitle_calcium, fileName_calcium);

figure;
figure_FontSize = 12;
y_n = 6*10;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(time(1:length(time_view)),calcium_zscore(1:length(time_view)), 'Color', PlotColor','LineStyle','-','LineWidth',1);
hold on;
plot(time(1:length(time_view)),triger(1:length(time_view))*y_n,'Color', [255,217,102]/255,'LineWidth',2);
hold off;
%xlim ([3 35]);
xlabel('Time (min)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Z-score','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(output_folder, figureTitle_zscore, fileName_zscore);
%}

%% calculating AUC
% Initialize AUC storage arrays
AUC_beforeus_zscore = zeros(1, 5);
AUC_duringus_zscore = zeros(1, 5);
AUC_afterus_zscore = zeros(1, 5);
AUC_extraus_zscore = zeros(1, 5);
% Calculate the AUC for each column (each ultrasound stimulation)
for i = 1:num_stimuli
    % Calculate AUC for each stimulation for before and during ultrasound data
    AUC_beforeus_zscore(i) = trapz(beforeus_zscore(:, i));
    AUC_duringus_zscore(i) = trapz(duringus_zscore(:, i));
    AUC_afterus_zscore(i) = trapz(afterus_zscore(:, i));
    AUC_extraus_zscore(i) = trapz(extraus_zscore(:, i));
end
ZScoreBeforeAUC = AUC_beforeus_zscore';
ZScoreDuringAUC = AUC_duringus_zscore';
ZScoreAfterAUC = AUC_afterus_zscore';
ZScoreExtraAUC = AUC_extraus_zscore';


% T1 = table(zscore_mat); 
% % writetable(T1, append(experimentDate_ID, '_', FUSID, '_ZScore_240903.csv'))
% % experimentDate_ID, '_', FUSID,
% 
% excelPath = fullfile(output_folder, append(experimentDate_ID_title, '_', FUSID, '_ZScore_240903.csv'));
% writetable(T1, excelPath);



T1 = table(zscore_mat, ZScoreBeforeAUC, ZScoreDuringAUC, ZScoreAfterAUC, ZScoreExtraAUC); 
% writetable(T1, append(experimentDate_ID, '_', FUSID, '_ZScore_250204.csv'))
% writetable(T1, append(resultPath, '_', FUSID, '_ZScore_250204.csv'))
writetable(T1, fullfile(resultPath, append(resultFolderName, '_', FUSID, '_ZScore_250204.csv')));
% experimentDate_ID, '_', FUSID,

% % Save the figures to the output folder
% saveFigureWithTitle(fullfile(save_fig_folder, figureTitle_zscoreEach), fileName_zscoreEach);
% saveFigureWithTitle(fullfile(save_fig_folder, figureTitle_zscoreMean), fileName_zscoreMean);
% saveFigureWithTitle(fullfile(save_fig_folder, figureTitle_calcium), fileName_calcium);


%% 统一保存5次超声刺激的数据到单一文件中 (Save 5-US stimulation data into one unified file)

% calciumData.mat文件的完整路径 (Full path for calciumData.mat)
calciumDataFile = fullfile(resultFolderPath, 'calciumData.mat');

% 如果calciumData文件已存在，则加载；否则初始化为空结构体数组
if exist(calciumDataFile, 'file')
    temp = load(calciumDataFile, 'calciumData');
    calciumData = temp.calciumData;
else
    % 一定要这样初始化结构体数组！
    calciumData = struct('serialNumber', {}, 'mouseType', {}, 'mouseID', {}, 'dataName', {}, 'ZscoreData', {}, 'CalciumData', {}, 'BaselineData', {});
end

% 创建新的数据结构 (Create new data structure for current experiment)
newData.mouseType = mouseType;
newData.mouseID = mouseID;
newData.dataName = [mouseType '_' mouseID '_' experimentDate '_' stimulationLevel];
newData.ZscoreData = each_zscore_data(:,1:5); % Zscore Data
newData.CalciumData = each_US_data(:,1:5); % Calcium Data
newData.BaselineData = baseline_data; % Baseline Data

% 检查 dataName 是否已经存在 (Check if dataName already exists)
existIdx = find(strcmp({calciumData.dataName}, newData.dataName), 1);

if ~isempty(existIdx)
    % 如果存在，先删除旧数据 (Delete existing data completely)
    calciumData(existIdx) = [];
    fprintf('数据 %s 已存在，已删除旧数据并替换为最新数据 (Old data deleted and replaced).\n', newData.dataName);
end

newData.serialNumber = length(calciumData) + 1;
calciumData = [calciumData; newData];

%% 按mouseType分类，再按mouseID顺序排列 (Sort by mouseType, then by mouseID)
[~, sortIdx] = sortrows([{calciumData.mouseType}' {calciumData.mouseID}']);
calciumData = calciumData(sortIdx);
fprintf('数据 %s 已添加为最新数据 (Data added successfully).\n', newData.dataName);

% 保存更新后的calciumData到统一文件中 (Save updated calciumData into the unified file)
save(calciumDataFile, 'calciumData');

% 


end