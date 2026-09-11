function [] = S1_BehaviorFiber_06(experimentDate, mouseID, stimulationLevel, ...
    pressureValue, mouseType, dataFolderPath, experimentDate_ID, dataPath, ...
    codePath, resultFolderName, resultFolderPath, resultPath, triger_thre, ...
    framerate, US_time, Analysis_US_time, US_offset, pulse_num, dutycycle)

%% process_rotation_from_bonsai_driver_v1 
% This is the code combining "process_rotation_from_bonsai_driver_v1" and "process_rotation_from_bonsai_v5"
% in an automatic way.
% close all
% clear
% clc

%% Load the .mat file
% Construct file path
fileName = sprintf('triggers_%s_%s_%s.mat', mouseID, experimentDate, stimulationLevel); % File name
% fileFullPath = fullfile(resultFolderPath, sprintf('%s_%s_%s', mouseID, experimentDate, resultFolderName), fileName); % Full path
fileFullPath = fullfile(resultFolderPath, sprintf('%s', resultFolderName), fileName); % Full path

% Load the .mat file
if exist(fileFullPath, 'file') % Check if file exists
    loadedData = load(fileFullPath); % Load the .mat file
    fprintf('File successfully loaded: %s\n', fileFullPath); % Display success message

    % Extract rising_edges data
    if isfield(loadedData, 'rising_edges')
        usonset = loadedData.rising_edges; % Extract rising_edges data
        fprintf('Loaded usonset data:\n');
        disp(usonset); % Display data
    else
        error('The variable "usonset" was not found in the file.'); % 提示缺少变量 Missing variable error
    end
else
    error('File not found: %s\nPlease check if the path or file name is correct.', fileFullPath); % 文件不存在提示 File not found error
end


% risePoint = [18250,21257,24264,27270,30276]; % 105mVpp-1

PlotColor = getPlotColor(mouseType);

analyzed_data_folder_path = dataFolderPath;
folderPath = dataPath;

% Replace underscores with hyphens
% experimentDate_ID_title = strrep(resultFolderName, '_', '-');
experimentDate_ID_title = [mouseType, '-', mouseID, '-', experimentDate, '-', stimulationLevel];


% Define the analyzed data folder path
%% 修改
% analyzed_data_folder_path = 'C:\Users\徐田奇\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Projects_02_TRPV4\2024-12\';
% folderPath = fullfile(analyzed_data_folder_path, experimentDate_ID);

% Extract and record the name of the folder
% The fileparts function separates the path, returning parent directory, folder name, and extension
[~, mice_ID, ~] = fileparts(folderPath);
mice_ID = resultFolderName;
disp(['Folder name: ', mice_ID]);


% Define mouse numbers and stimulation levels (adjust as needed)
N_mouse = [1];
level = {stimulationLevel};

% Code Path
% myFolder = '20241022_NewAnalysis';
% folderChange = fullfile(analyzed_data_folder_path, myFolder);
folderChange = codePath;

%% Automatically generate titles and filenames
% Angular Speed
% figureTitle_angularSpeed = sprintf('%s - High Titer - Angular Speed (%.1f MPa)', experimentDate_ID_title, pressureValue);
% fileName_angularSpeedEach = sprintf('%s_AngularSpeedEach_%s', experimentDate_ID, stimulationLevel);
% fileName_angularSpeedEach_smo = sprintf('%s_AngularSpeedEach_smo_%s', experimentDate_ID, stimulationLevel);
% fileName_angularSpeedMean = sprintf('%s_AngularSpeedMean_%s', experimentDate_ID, stimulationLevel);
% fileName_angularSpeedMean_smo = sprintf('%s_AngularSpeedMean_smo_%s', experimentDate_ID, stimulationLevel);
% fileName_angularSpeed = sprintf('%s_AngularSpeed_%s', experimentDate_ID, stimulationLevel);
% 
% % Linear Speed
% figureTitle_linearSpeed = sprintf('%s - High Titer - Linear Speed (%.1f MPa)', experimentDate_ID_title, pressureValue);
% fileName_linearSpeedEach = sprintf('%s_LinearSpeedEach_%s', experimentDate_ID, stimulationLevel);
% fileName_linearSpeedEach_smo = sprintf('%s_LinearSpeedEach_smo_%s', experimentDate_ID, stimulationLevel);
% fileName_linearSpeedMean = sprintf('%s_LinearSpeedMean_%s', experimentDate_ID, stimulationLevel);
% fileName_linearSpeedMean_smo = sprintf('%s_LinearSpeedMean_smo_%s', experimentDate_ID, stimulationLevel);
% fileName_linearSpeed = sprintf('%s_LinearSpeed_%s', experimentDate_ID, stimulationLevel);

figureTitle_angularSpeed = sprintf('%s-AngularSpeed(%.1fMPa)', experimentDate_ID_title, pressureValue);
fileName_angularSpeedEach = sprintf('%s_AngularSpeedEach_%s', experimentDate_ID_title, stimulationLevel);
fileName_angularSpeedEach_smo = sprintf('%s_AngularSpeedEach_smo_%s', experimentDate_ID_title, stimulationLevel);
fileName_angularSpeedMean = sprintf('%s_AngularSpeedMean_%s', experimentDate_ID_title, stimulationLevel);
fileName_angularSpeedMean_smo = sprintf('%s_AngularSpeedMean_smo_%s', experimentDate_ID_title, stimulationLevel);
fileName_angularSpeed = sprintf('%s_AngularSpeed_%s', experimentDate_ID_title, stimulationLevel);

% Linear Speed
figureTitle_linearSpeed = sprintf('%s-LinearSpeed(%.1fMPa)', experimentDate_ID_title, pressureValue);
fileName_linearSpeedEach = sprintf('%s_LinearSpeedEach_%s', experimentDate_ID_title, stimulationLevel);
fileName_linearSpeedEach_smo = sprintf('%s_LinearSpeedEach_smo_%s', experimentDate_ID_title, stimulationLevel);
fileName_linearSpeedMean = sprintf('%s_LinearSpeedMean_%s', experimentDate_ID_title, stimulationLevel);
fileName_linearSpeedMean_smo = sprintf('%s_LinearSpeedMean_smo_%s', experimentDate_ID_title, stimulationLevel);
fileName_linearSpeed = sprintf('%s_LinearSpeed_%s', experimentDate_ID_title, stimulationLevel);

% Save outputFolder
% outputFolder = fullfile(analyzed_data_folder_path, 'Generated_Output');
% if ~exist(outputFolder, 'dir')
%     mkdir(outputFolder);
% end

%% Results Path
outputFolder = resultPath;

moreBehaviorData = [];
for n = 1:length(N_mouse)
    for m = 1:length(level)
        % mice_ID = ['20240207_Control-', num2str(N_mouse(n))];
        
        intensity = level{m};
 %         Check if the folder exists. If the folder does not exist, break
%         out of the for loop during the current mice_ID iteration.
%         if exist(mice_ID, 'dir') == 0
%             break
%         end
        
        % Run code


        %% process_rotation_from_bonsai_v5.m
        % The purpose of this code is to analyze the mice rotation behavior
        % acquired from the Bonsai software. In version 5, the code is optimized so
        % that plots and data sets are saved and stored automatically.
        
        % Last updated: Sept 7, 2021 KX
        % Modified by Tianq 20231016
        % Read: Feb 5, 2024 TX
        
        %% Define the parameters.
        % close all; clear
        
        framerate = framerate;         % [s], Frame rate of the camera.
        ustime_orig = US_time;       % [s], US duration. %%%
        offset = US_offset;            % [s], Offset time after the end of US treatment. %%%
        % ustime = ustime_orig;   % [s], Adjusted US duration.
        ustimeduring = Analysis_US_time;   % [s], Adjusted US duration. % edited by 20/22/2024
        % For the Cre mice, ustime = ustime_orig + offset; 
        % For the normal mice, ustime = ustime_orig;
        
        pulse_num = pulse_num;          % [unitless], Number of ultrasound treatments %%%
        speed_co = 20;          % [unitless], Convert the speed from pixel_unit/frame to mm/s ?
        trig_thre = 2;          % [unitless], Threshold to define the onset of US ?
        pixel_length = 0.145; % [cm], The true length of one pixel in the video acquired. ?
        % usend=6800*pulse_num; %the end of the us; 
        
        % Calcium 
        triger_thre = triger_thre; %previously it was 3000, change to 6000 %70000

        % Pre-allocate the data matrix with zeros.
        trunk_data = zeros(framerate*ustimeduring*6, pulse_num);
        
        %% Load the data.
        
        % Add portable hard drive to the MATLAB path.
        % Specify mice ID.
        % mice_ID = 'KX1'; %Input 1
        % addpath(append('D:\02_Thermosensitive Ion
        % Channels\BehaviorTest\02_Data_MackRepeat\0_ArrangedData\', mice_ID)); 
        % addpath('D:\02_Thermosensitive Ion Channels\BehaviorTest\Data\data_quantification');
        % addpath(append('C:\Users\xu.t\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Projects_01_US parameters - TRPV1\01_US multi-parameters\e. Behavior test\Kevin code copy', mice_ID));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % addpath(append('C:\Users\xu.t\Box\ChenUltrasoundLab\38_Tianqi Xu\00_From Labmates\From Kevin\20231009_Process rotation\data', mice_ID)); % Original Data %%%%%
       
        
        %% updated code TX
        addpath(folderPath); % Original Data %%%%%


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Modified by Tianqi 20231016
        
        % Specify the intensity, orientation, and trigger csv files.
        % intensity = '70mVpp'; %Input 2
        x_name = append(intensity,'_x.csv');
        y_name = append(intensity,'_y.csv');
        orit_name = append(intensity,'_ori.csv');
        trig_name = append(intensity,'_trigger.csv');
        % Calcium
        calcium_name = append(intensity,'_calcium.csv');
        time_step = 1/30;
        fs = 1/time_step;
        calcium_all = xlsread([folderPath '\' calcium_name]);
        calcium = calcium_all(:,5);
%         triger_thre = 20000; %previously it was 3000, change to 6000 %70000

        % calcium_all = sig0;
        % calcium = sig


        % triger_thre = 6000; %previously it was 3000, change to 6000 %70000
        % % 
        % triger0 = imresize(triger0, [length(sig), 1]);
        % time0 = 1:length(triger0);
        % time = time0 * time_step/60;
        % triger2 = triger0;

        % Trigger Plot 
        triggerData = xlsread([folderPath '\' trig_name], 'A:A');
        figure;
        plot(triggerData);
        xlabel('Index');
        ylabel('Data from Trigger Data');
        title('Plot of Trigger Data from Excel');
        
        % Process the data.
        % Load the trigger data, remove best straight-fit line from data in the
        % trigger data, and scale the data by 0.002.
        trig = detrend(xlsread(trig_name))*0.002; %  ???????????????????????????
        
        % Load the x, y, and orientation data.
        orit = xlsread(orit_name);
        x = xlsread(x_name);
        y = xlsread(y_name);
        
        % Adjust the US time to remove any possible "end effects." 调整US时间，以消除任何可能的 "终端效应"。
        usend = length(trig)-100;
        
        % Pre-allocate time vector with zeros.用零预先分配时间矢量。
        time = 1:length(orit); 
        time = time.'*(1/framerate); % Convert from frames to sec.
        
        % Convert the trigger signal to binary (index).
        trig_ind = zeros(size(trig)); % Pre-allocate trigger vector with zeros.
        trig_ind(trig > trig_thre) = 2; % Convert trigger signal to binary. 
        trig_ind = trig_ind(1:length(orit)); % Match the length of the vector with the orientation vector.
        
        
        

        % Plot the figures for positional, orientation, and trigger index data.
        figure;
        plot(time, orit);
        hold on;
        plot(time, trig_ind, 'r');
        hold off;
        % title(append(mice_ID, '\_', intensity, '\_orientation'))
        title(append(mice_ID, '\_', intensity, '\_orientation'))
        
        xlabel('Time (s)')
        ylabel('Angular orientation (radians)')
        legend('Angular orientation', 'Trigger synchronization', 'Location', 'southeast')
        
        % Change the folder to the location where you want to save the analyzed
        % data, then save the data in the specific mouse folder.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        % Save images
        % cd('C:\Users\xu.t\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Projects_01_US parameters - TRPV1\01_US multi-parameters\e. Behavior test\Kevin code copy');
      
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        % cd('1_AnalyzedData')
        % mkdir(mice_ID)
        cd(folderPath)
        mkdir(mice_ID)

%         saveas(gcf, append(mice_ID, '\',mice_ID,'_', intensity, '_orientation', '.fig'))
%         saveas(gcf, append(mice_ID, '\',mice_ID,'_', intensity, '_orientation', '.png'))
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_orientation', '.fig')));
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_orientation', '.png')));

%         %% 20250522
%         figure;
%         plot(x, y);
%         % title(append(mice_ID, '\_', intensity, '\_position'))
%         title(append(mice_ID, '\_', intensity, '\_position'))
%         xlabel('Position along x axis (0.145 cm/point)')
%         ylabel('Position along y axis (0.145 cm/point)')
%         
        % Save the plot
        % saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_position', '.fig'))
        % saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_position', '.png'))
        % saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_position', '.fig'))
        % saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_position', '.png'))
%         saveas(gcf, append(mice_ID, '\_', intensity, '_position', '.fig'))
%         saveas(gcf, append(mice_ID, '\_', intensity, '_position', '.png'))
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_position', '.fig')));
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_position', '.png')));



       


      
usonset

        
        % Pre-allocate all vectors with zeros (before, during, and after US).
        beforeus = zeros(framerate*ustimeduring,pulse_num); 
        duringus = zeros(framerate*ustimeduring,pulse_num);
        afterus = zeros(framerate*ustimeduring,pulse_num);
        extraus = zeros(framerate*ustimeduring,pulse_num); % TX added 2024-08-29
        beforeus_orit = beforeus;
        duringus_orit = duringus;
        afterus_orit = afterus;
        extraus_orit = extraus;
        
        % Calculate the index of US (before, during and after) by looping through
        % the number of pulses delivered. 循环计算 US 指数（之前、期间和之后 脉冲数。
        for i = 1:pulse_num
            beforeus(:,i) = usonset(i)-framerate*ustimeduring+1:usonset(i); % TX
            duringus(:,i) = usonset(i)+1:usonset(i)+framerate*ustimeduring;
            afterus(:,i) = usonset(i)+framerate*ustimeduring+1:usonset(i)+2*framerate*ustimeduring;
            extraus(:,i) = usonset(i)+2*framerate*ustimeduring+1:usonset(i)+3*framerate*ustimeduring;
        end


        % %% Added begin by T.X. 2/8/2024
        % X = beforeus(:,1);
        % X = X(X>0);
        % % beforeus(:,1) = X;
        % 
        % % Calculate the orientation before, during and after US by looping through
        % % the number of pulses delivered.
        % for i=1:1
        %     beforeus_orit(:,i) = orit(X);
        %     afterus_orit(:,i) = orit(afterus(:,i));
        %     duringus_orit(:,i) = orit(duringus(:,i));
        % end
        % %% Added finish by T.X. 2/8/2024

        % calcium
        beforeus_calcium = zeros(framerate*ustimeduring,pulse_num); 
        duringus_calcium = zeros(framerate*ustimeduring,pulse_num);
        afterus_calcium = zeros(framerate*ustimeduring,pulse_num);
        extraus_calcium = zeros(framerate*ustimeduring,pulse_num); % TX 2024-08-29
        for i=1:pulse_num
            beforeus_calcium(:,i) = calcium(beforeus(:,i));
            duringus_calcium(:,i) = calcium(duringus(:,i));
            afterus_calcium(:,i) = calcium(afterus(:,i));
            extraus_calcium(:,i) = calcium(extraus(:,i));
        end
        % Compute the mean Calcium from the three bins.
        calcium_mean_before = mean(beforeus_calcium,1);
        calcium_mean_during = mean(duringus_calcium,1);
        calcium_mean_after = mean(afterus_calcium,1);
        calcium_mean_extra = mean(extraus_calcium,1);
        calcium_mean_mat = [calcium_mean_before; calcium_mean_during; calcium_mean_after; calcium_mean_extra];
        calcium_mean_mat = calcium_mean_mat';



        
        for i=1:pulse_num
            beforeus_orit(:,i) = orit(beforeus(:,i));            
            duringus_orit(:,i) = orit(duringus(:,i));
            afterus_orit(:,i) = orit(afterus(:,i));
            extraus_orit(:,i) = orit(extraus(:,i));
        end
        
        %% Calculate the rotation speed before, during, and after US. 计算 US 之前、期间和之后的转速。
        
        % Differentiate the orientation vector to find the orientation speed. 微分方向矢量，找出方向速度。
        orit_spd_0 = diff(orit); 
        orit_spd = orit_spd_0;
        orit_spd(isnan(orit_spd)) = 0; % If NaN occurs, change all the NaN to zeros. 如果出现 NaN，则将所有 NaN 变为零。
        
        % De-noise the data by setting any sudden orientation speeds to zero.
        % 通过将任何突然的定向速度设置为零来消除数据噪声。?
        orit_spd(orit_spd>1) = 0; 
        orit_spd(orit_spd<-1) = 0;
        
        % Convert the orientation speed from radians/frame to revolutions/min. 
        orit_spd = orit_spd*framerate*60/(2*pi);
        
        % Smooth the orientation speed by calculating the mean over a sliding
        % window of 60 frames.
        orit_spd_smo = movmean(orit_spd, 60); 
        % Alternatively, can use orit_spd_smo=smooth(orit_spd,60);
        
        % Define a separate time vector to graph the angular speed
        time2 = time(1:end-1);
        
        figure;
        plot(time2, orit_spd_smo);
        hold on;
        plot(time, trig_ind*10,'r');
        hold off;
        title(append(mice_ID, '\_', intensity, '\_angular\_speed'));
        xlabel('Time (s)')
        ylabel('Angular speed (rev/min)')
        legend('Angular speed', 'Trigger synchronization', 'Location', 'southeast')
        
        % Save the plot
%         saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_angular_speed', '.fig'))
%         saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_angular_speed', '.png'))
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_angular_speed', '.png')));
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_angular_speed', '.fig')));

        
        %% Analysis for orit_spd
        % Pre-allocate the orientation vectors with zeros.
        beforeus_orit_spd = zeros(framerate*ustimeduring,pulse_num);
        duringus_orit_spd = zeros(framerate*ustimeduring,pulse_num);
        afterus_orit_spd = zeros(framerate*ustimeduring,pulse_num);
        extraus_orit_spd = zeros(framerate*ustimeduring,pulse_num);

        angular_speed = zeros(framerate*ustimeduring*4,pulse_num); % TX added 2024-08-29
        % Split the angular speed into three bins: before, during, and after US.
        for i = 1:pulse_num
            beforeus_orit_spd(:,i) = orit_spd(beforeus(:,i));            
            duringus_orit_spd(:,i) = orit_spd(duringus(:,i));
            afterus_orit_spd(:,i) = orit_spd(afterus(:,i));
            extraus_orit_spd(:,i) = orit_spd(extraus(:,i));
            % beforeus_orit_spd(:,i) = orit_spd_smo(beforeus(:,i));            
            % duringus_orit_spd(:,i) = orit_spd_smo(duringus(:,i));
            % afterus_orit_spd(:,i) = orit_spd_smo(afterus(:,i));
            % extraus_orit_spd(:,i) = orit_spd_smo(extraus(:,i));
            angular_speed(:,i) = [beforeus_orit_spd(:,i); duringus_orit_spd(:,i); afterus_orit_spd(:,i); extraus_orit_spd(:,i)];
        end
        % Compute the mean angular speeds from the bins.
        speed_mean_before = mean(beforeus_orit_spd,1);
        speed_mean_during = mean(duringus_orit_spd,1);
        speed_mean_after = mean(afterus_orit_spd,1);
        speed_mean_extra = mean(extraus_orit_spd,1);
        analy_angularSpeed_mean_mat = [speed_mean_before; speed_mean_during; speed_mean_after; speed_mean_extra];
        
        analy_angularSpeed_mean_mat = analy_angularSpeed_mean_mat';
        analy_angularSpeed_mean = mean(analy_angularSpeed_mean_mat); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        analy_angularSpeed_std = std(analy_angularSpeed_mean_mat);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        analy_angularSpeed_mt = [analy_angularSpeed_mean, analy_angularSpeed_std];

        %% Analysis for orit_spd_smo
        % Pre-allocate the orientation vectors with zeros.
        beforeus_orit_spd_smo = zeros(framerate*ustimeduring,pulse_num);
        duringus_orit_spd_smo = zeros(framerate*ustimeduring,pulse_num);
        afterus_orit_spd_smo = zeros(framerate*ustimeduring,pulse_num);
        extraus_orit_spd_smo = zeros(framerate*ustimeduring,pulse_num);

        angular_speed_smo = zeros(framerate*ustimeduring*4,pulse_num); % TX added 2024-08-29
        % Split the angular speed_smo into three bins: before, during, and after US.
        for i = 1:pulse_num
            beforeus_orit_spd_smo(:,i) = orit_spd_smo(beforeus(:,i));            
            duringus_orit_spd_smo(:,i) = orit_spd_smo(duringus(:,i));
            afterus_orit_spd_smo(:,i) = orit_spd_smo(afterus(:,i));
            extraus_orit_spd_smo(:,i) = orit_spd_smo(extraus(:,i));
            % beforeus_orit_spd_smo(:,i) = orit_spd_smo_smo(beforeus(:,i));            
            % duringus_orit_spd_smo(:,i) = orit_spd_smo_smo(duringus(:,i));
            % afterus_orit_spd_smo(:,i) = orit_spd_smo_smo(afterus(:,i));
            % extraus_orit_spd_smo(:,i) = orit_spd_smo_smo(extraus(:,i));
            angular_speed_smo(:,i) = [beforeus_orit_spd_smo(:,i); duringus_orit_spd_smo(:,i); afterus_orit_spd_smo(:,i); extraus_orit_spd_smo(:,i)];
        end
        % Compute the mean angular speed_smos from the bins.
        speed_smo_mean_before = mean(beforeus_orit_spd_smo,1);
        speed_smo_mean_during = mean(duringus_orit_spd_smo,1);
        speed_smo_mean_after = mean(afterus_orit_spd_smo,1);
        speed_smo_mean_extra = mean(extraus_orit_spd_smo,1);
        analy_angularSpeed_smo_mean_mat = [speed_smo_mean_before; speed_smo_mean_during; speed_smo_mean_after; speed_smo_mean_extra];
        
        analy_angularSpeed_smo_mean_mat = analy_angularSpeed_smo_mean_mat';
        analy_angularSpeed_smo_mean = mean(analy_angularSpeed_smo_mean_mat); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        analy_angularSpeed_smo_std = std(analy_angularSpeed_smo_mean_mat);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        analy_angularSpeed_smo_mt = [analy_angularSpeed_smo_mean, analy_angularSpeed_smo_std];

        % TX 2024-08-29 Normalized
        %{
        normalized_angular_speed = zeros(framerate*ustime*4,pulse_num); % TX added 2024-08-29
        for i = 1:pulse_num
            % **Calculate mean value for the 'before' segment** 2024-08-29
            mean_before = mean(abs(beforeus_orit_spd(:,i)));
            normalized_before_angular_speed(:, i) = beforeus_orit_spd(:,i) / mean_before;
            normalized_during_angular_speed(:, i) = duringus_orit_spd(:,i) / mean_before;
            normalized_after_angular_speed(:, i) = afterus_orit_spd(:,i) / mean_before;
            normalized_extra_angular_speed(:, i) = extraus_orit_spd(:,i) / mean_before;
            % **Combine the normalized segments** 2024-08-29
            normalized_angular_speed(:, i) = [normalized_before_angular_speed(:, i); normalized_during_angular_speed(:, i); normalized_after_angular_speed(:, i); normalized_extra_angular_speed(:, i)];
        end
        % Modified from speed to normalized speed 2024-08-29
        % Compute the mean angular speeds from the three bins.
        speed_mean_before = mean(normalized_before_angular_speed,1);
        speed_mean_during = mean(normalized_during_angular_speed,1);
        speed_mean_after = mean(normalized_after_angular_speed,1);
        speed_mean_extra = mean(normalized_extra_angular_speed,1);
        speed_mean_mat = [speed_mean_before; speed_mean_during; speed_mean_after; speed_mean_extra];
        speed_mean_mat = speed_mean_mat';
        %}



        %{
        % TX
        % Plot the figure for angular speed data. 
        % This is to mainly check that the values from the bin make sense.
        figure;
        hold on;
        plot(beforeus_orit_spd,'b');
        hold on
        plot(afterus_orit_spd,'g');
        hold on
        plot(duringus_orit_spd,'r');
        hold off;
        title ('Angular Speed (rev/min)');
        %}
        %% Calculate the angular displacement.
        
        % Compute the integral of the smoothed angular speed vector by calculating
        % the cumulative sum of the derivative and multiplying with the step size.
        angular_position2 = cumsum(orit_spd_smo);
        angular_position = angular_position2/(60*framerate); % [rev]
        
        % Compute angular displacement from the three bins. [rev]
        angular_disp_before_cumsum = cumsum(movmean(beforeus_orit_spd, 60))./(60*framerate);
        angular_disp_before = angular_disp_before_cumsum(end,:) - angular_disp_before_cumsum(1,:);
        angular_disp_during_cumsum = cumsum(movmean(duringus_orit_spd, 60))./(60*framerate);
        angular_disp_during = angular_disp_during_cumsum(end,:) - angular_disp_during_cumsum(1,:);
        angular_disp_after_cumsum = cumsum(movmean(afterus_orit_spd, 60))./(60*framerate);
        angular_disp_after = angular_disp_after_cumsum(end,:) - angular_disp_after_cumsum(1,:);
        angular_disp_extra_cumsum = cumsum(movmean(extraus_orit_spd, 60))./(60*framerate);
        angular_disp_extra = angular_disp_extra_cumsum(end,:) - angular_disp_extra_cumsum(1,:);
        angular_disp = [angular_disp_before; angular_disp_during; angular_disp_after; angular_disp_extra];
        angular_disp = angular_disp';
        
        % Plot the figures for angular displacement data.
        figure;
        plot(time(1:end-1), angular_position);
        hold on;
        plot(time, trig_ind,'r');
        hold off;
        title(append(mice_ID, '\_', intensity, '\_angular\_displacement'))
        xlabel('Time (s)')
        ylabel('Angular displacement (rev)')
        legend('Angular displacement', 'Trigger synchronization')
        
        % Save the plot
%         saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_angular_displacement', '.fig'))
%         saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_angular_displacement', '.png'))
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_angular_displacement', '.fig')));
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_angular_displacement', '.png')));

        %% Calculate the linear speed and total distance travelled.
        % Pre-allocate x and y vectors with zeros (before, during, and after US).
        beforeus_lin_speed = zeros(framerate*ustimeduring,pulse_num); % TX
        duringus_lin_speed = zeros(framerate*ustimeduring,pulse_num);
        afterus_lin_speed = zeros(framerate*ustimeduring,pulse_num);
        extraus_lin_speed = zeros(framerate*ustimeduring,pulse_num);
        
        %% 针对Position TX
        % Calculate the x and y position before, during and after US by looping through
        % the number of pulses delivered.

        for i=1:pulse_num
            beforeus_x(:,i) = x(beforeus(:,i));
            beforeus_y(:,i) = y(beforeus(:,i));            
            duringus_x(:,i) = x(duringus(:,i));
            duringus_y(:,i) = y(duringus(:,i));
            afterus_x(:,i) = x(afterus(:,i));
            afterus_y(:,i) = y(afterus(:,i));
            extraus_x(:,i) = x(extraus(:,i));
            extraus_y(:,i) = y(extraus(:,i));

            % xx = x(beforeus(:,i));
            % yy = y(beforeus(:,i));
            % figure
            % plot(xx, yy);
            % % title(append(mice_ID, '\_', intensity, '\_position'))
            % title(append(mice_ID, '\_', intensity, '\_position'))
            % xlabel('Position along x axis (0.145 cm/point)')
            % ylabel('Position along y axis (0.145 cm/point)')
        end
        % added by TX 02132024
        figure
        % first US
        plot(beforeus_x(:,1), beforeus_y(:,1),"Color",[230, 230, 230]/255);
        hold on
        plot(duringus_x(:,1), duringus_y(:,1),"Color",[255, 204, 204]/255);
        hold on
        plot(afterus_x(:,1), afterus_y(:,1),"Color",[204, 229, 255]/255);
        % second US
        hold on
        plot(beforeus_x(:,2), beforeus_y(:,2),"Color",[192, 192, 192]/255);
        hold on
        plot(duringus_x(:,2), duringus_y(:,2),"Color",[255, 153, 153]/255);
        hold on
        plot(afterus_x(:,2), afterus_y(:,2),"Color",[153, 204, 255]/255);
        % 3rd US
        hold on
        plot(beforeus_x(:,3), beforeus_y(:,3),"Color",[160, 160, 160]/255);
        hold on
        plot(duringus_x(:,3), duringus_y(:,3),"Color",[255, 102, 102]/255);
        hold on
        plot(afterus_x(:,3), afterus_y(:,3),"Color",[102, 178, 255]/255);
        % 4nd US
        hold on
        plot(beforeus_x(:,4), beforeus_y(:,4),"Color",[128, 128, 128]/255);
        hold on
        plot(duringus_x(:,4), duringus_y(:,4),"Color",[255, 51, 51]/255);
        hold on
        plot(afterus_x(:,4), afterus_y(:,4),"Color",[51, 153, 255]/255);
        % 5nd US
        hold on
        plot(beforeus_x(:,5), beforeus_y(:,5),"Color",[0, 128, 255]/255);
        hold on
        plot(duringus_x(:,5), duringus_y(:,5),"Color",[204, 0, 0]/255);
        hold on
        plot(afterus_x(:,5), afterus_y(:,5),"Color",[96, 96, 96]/255);
        % xlim ([40 140])
        % ylim ([50 150])
        xlim ([0 200])
        ylim ([0 200])
        % title(append(mice_ID, '\_', intensity, '\_position'))
        title(append(mice_ID, '\_', intensity, '\_position'))
        xlabel('Position along x axis (0.145 cm/point)')
        ylabel('Position along y axis (0.145 cm/point)')
%         saveas(gcf, append(mice_ID, '\_', intensity, '_position_unit', '.fig'))
%         saveas(gcf, append(mice_ID, '\_', intensity, '_position_unit', '.png'))
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_position_unit', '.fig')));
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_position_unit', '.png')));

        %% Select track
        Nth_pulse = 5; % Select the 1st track
        for i=1:Nth_pulse
            beforeus_xS = x(beforeus(:,i));
            beforeus_yS = y(beforeus(:,i));            
            duringus_xS = x(duringus(:,i));
            duringus_yS = y(duringus(:,i));
            afterus_xS = x(afterus(:,i));
            afterus_yS = y(afterus(:,i));
            extraus_xS = x(extraus(:,i));
            extraus_yS = y(extraus(:,i));

            % xx = x(beforeus(:,i));
            % yy = y(beforeus(:,i));
            % figure
            % plot(xx, yy);
            % % title(append(mice_ID, '\_', intensity, '\_position'))
            % title(append(mice_ID, '\_', intensity, '\_position'))
            % xlabel('Position along x axis (0.145 cm/point)')
            % ylabel('Position along y axis (0.145 cm/point)')
        
        % added by TX 02132024
        figure
        plot(beforeus_xS, beforeus_yS,"Color",[90, 130, 209]/255,"LineWidth", 1.5);
        hold on
        plot(duringus_xS, duringus_yS,"Color",[217, 63, 63]/255, "LineWidth", 1.5);
        hold on
        plot(afterus_xS, afterus_yS,"Color",[143, 143, 143]/255, "LineWidth", 1.5);

        % xlim ([40 140])
        % ylim ([50 150])
        xlim ([120 180])
        ylim ([140 200])
        % title(append(mice_ID, '\_', intensity, '\_position'))
        title(append(mice_ID, '\_', intensity,'_', num2str(i), '\_position_Select'))
        xlabel('Position along x axis (0.145 cm/point)')
        ylabel('Position along y axis (0.145 cm/point)')
%         saveas(gcf, append(mice_ID, '\_', intensity, '_position_unit', '.fig'))
%         saveas(gcf, append(mice_ID, '\_', intensity, '_position_unit', '.png'))
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity,'_', num2str(i), '_position_selected', '.fig')));
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity,'_', num2str(i), '_position_selected', '.png')));
        end



        % Differentiate the orientation vector to find the orientation speed.
        x_velocity = diff(x); 
        y_velocity = diff(y); 
        
        % Convert the velocity components from pixels/frame to cm/s. 
        x_velocity = x_velocity*framerate*pixel_length;
        y_velocity = y_velocity*framerate*pixel_length;
        
        % Calculate the net speed
        lin_speed = sqrt(x_velocity.^2 + y_velocity.^2);
        lin_speed(isnan(lin_speed)) = 0; % Change all NaN to zeros
        
        % % De-noise the data by setting any sudden velocities to zero.
        % *** CHECK THIS CRITERION ***
        % lin_speed(lin_speed > 30) = 0; Found that upper limit does not impact the
        % average distances / speeds to a significant degree.
        lin_speed(lin_speed < 3) = 0;
        
        % Smooth the linear speed by calculating the mean over a sliding
        % window of 60 frames.
        lin_speed_smo = movmean(lin_speed, 60); %orit_spd_smo=smooth(orit_spd,60);
        
        % Plot the figures for linear speed data.
        figure;
        plot(time(1:end-1), lin_speed_smo);
        hold on;
        plot(time, trig_ind*10,'r');
        hold off;
        title(append(mice_ID, '\_', intensity, '\_linear\_speed'))
        xlabel('Time (s)')
        ylabel('Linear speed (cm/s)')
        legend('Linear speed', 'Trigger synchronization')
        
        % Save the plot
%         saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_linear_speed', '.fig'))
%         saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_linear_speed', '.png'))
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_linear_speed', '.fig')));
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_linear_speed', '.png')));
       
        linear_speed = zeros(framerate*ustimeduring*4,pulse_num); % TX added 2024-08-29
        % Split the angular speed into three bins: before, during, and after US.
        for i = 1:pulse_num
            beforeus_lin_speed(:,i) = lin_speed(beforeus(:,i));            
            duringus_lin_speed(:,i) = lin_speed(duringus(:,i));
            afterus_lin_speed(:,i) = lin_speed(afterus(:,i));
            extraus_lin_speed(:,i) = lin_speed(extraus(:,i));
            linear_speed(:,i) = [beforeus_lin_speed(:,i); duringus_lin_speed(:,i); afterus_lin_speed(:,i); extraus_lin_speed(:,i)];
        end
        % Compute the mean angular speeds from the bins.
        lin_speed_mean_before = mean(beforeus_lin_speed,1);
        lin_speed_mean_during = mean(duringus_lin_speed,1);
        lin_speed_mean_after = mean(afterus_lin_speed,1);
        lin_speed_mean_extra = mean(extraus_lin_speed,1);
        analy_linear_speed_mean_mat = [lin_speed_mean_before; lin_speed_mean_during; lin_speed_mean_after; lin_speed_mean_extra];
        
        analy_linear_speed_mean_mat = analy_linear_speed_mean_mat';
        analy_linear_speed_mean = mean(analy_linear_speed_mean_mat); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        analy_linear_speed_std = std(analy_linear_speed_mean_mat);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        analy_linear_speed_mt = [analy_linear_speed_mean, analy_linear_speed_std];

        linear_speed_smo = zeros(framerate*ustimeduring*4,pulse_num); % TX added 2024-08-29
        % Split the angular speed_smo into three bins: before, during, and after US.
        for i = 1:pulse_num
            beforeus_lin_speed_smo(:,i) = lin_speed_smo(beforeus(:,i));            
            duringus_lin_speed_smo(:,i) = lin_speed_smo(duringus(:,i));
            afterus_lin_speed_smo(:,i) = lin_speed_smo(afterus(:,i));
            extraus_lin_speed_smo(:,i) = lin_speed_smo(extraus(:,i));
            linear_speed_smo(:,i) = [beforeus_lin_speed_smo(:,i); duringus_lin_speed_smo(:,i); afterus_lin_speed_smo(:,i); extraus_lin_speed_smo(:,i)];
        end
        % Compute the mean angular speed_smos from the bins.
        lin_speed_smo_mean_before = mean(beforeus_lin_speed_smo,1);
        lin_speed_smo_mean_during = mean(duringus_lin_speed_smo,1);
        lin_speed_smo_mean_after = mean(afterus_lin_speed_smo,1);
        lin_speed_smo_mean_extra = mean(extraus_lin_speed_smo,1);
        analy_lin_speed_smo_mean_mat = [lin_speed_smo_mean_before; lin_speed_smo_mean_during; lin_speed_smo_mean_after; lin_speed_smo_mean_extra];
        
        analy_lin_speed_smo_mean_mat = analy_lin_speed_smo_mean_mat';
        analy_linear_speed_smo_mean = mean(analy_lin_speed_smo_mean_mat); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        analy_linear_speed_smo_std = std(analy_lin_speed_smo_mean_mat);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        analy_linear_speed_smo_mt = [analy_linear_speed_smo_mean, analy_linear_speed_smo_std];


        % TX 2024-08-29 Normalized
        %{
        normalized_linear_speed = zeros(framerate*ustime*4,pulse_num); % TX added 2024-08-29
        % Split the linear speed into three bins: before, during, and after US.
        for i = 1:pulse_num
            beforeus_lin_speed(:,i) = lin_speed(beforeus(:,i));            
            duringus_lin_speed(:,i) = lin_speed(duringus(:,i));
            afterus_lin_speed(:,i) = lin_speed(afterus(:,i));
            extraus_lin_speed(:,i) = lin_speed(extraus(:,i));
        end

        % TX 2024-08-29 Normalized
        for i = 1:pulse_num
            % **Calculate mean value for the 'before' segment** 2024-08-29
            mean_before = mean(abs(beforeus_lin_speed(:,i)));
            normalized_before_linear_speed(:, i) = beforeus_lin_speed(:,i) / mean_before;
            normalized_during_linear_speed(:, i) = duringus_lin_speed(:,i) / mean_before;
            normalized_after_linear_speed(:, i) = afterus_lin_speed(:,i) / mean_before;
            normalized_extra_linear_speed(:, i) = extraus_lin_speed(:,i) / mean_before;
            % **Combine the normalized segments** 2024-08-29
            normalized_linear_speed(:, i) = [normalized_before_linear_speed(:, i); normalized_during_linear_speed(:, i); normalized_after_linear_speed(:, i); normalized_extra_linear_speed(:, i)];
        end

        %% Modified from speed to normalized speed 2024-08-29
        % Compute the mean angular speeds from the three bins.
        lin_speed_mean_before = mean(normalized_before_linear_speed,1);
        lin_speed_mean_during = mean(normalized_during_linear_speed,1);
        lin_speed_mean_after = mean(normalized_after_linear_speed,1);
        lin_speed_mean_extra = mean(normalized_extra_linear_speed,1);
        lin_speed_mean_mat = [lin_speed_mean_before; lin_speed_mean_during; lin_speed_mean_after; lin_speed_mean_extra];
        lin_speed_mean_mat = lin_speed_mean_mat';
        %}

        % Compute total distance traveled
        distance_traveled2 = cumsum(lin_speed_smo);
        distance_traveled = distance_traveled2/(framerate); % [cm]
        
        % Plot the figures for linear distance data.
        figure;
        plot(time(1:end-1), distance_traveled);
        hold on;
        plot(time, trig_ind*250,'r');
        hold off;
        title(append(mice_ID, '\_', intensity, '\_distance\_traveled'))
        xlabel('Time (s)')
        ylabel('Distance (cm)')
        legend('Distance traveled', 'Trigger synchronization', 'Location', 'southeast')
        
        % Save the plot
%         saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_distance_traveled', '.fig'))
%         saveas(gcf, append(mice_ID, '\', mice_ID, '_', intensity, '_distance_traveled', '.png'))
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_distance_traveled', '.fig')));
        saveas(gcf, fullfile(outputFolder, append(mice_ID, '_', intensity, '_distance_traveled', '.png')));
        
        
        % Compute distance traveled from the three bins. [cm]
        distance_before_cumsum = cumsum(movmean(beforeus_lin_speed, 60))./(framerate);
        distance_before = distance_before_cumsum(end,:) - distance_before_cumsum(1,:);
        distance_during_cumsum = cumsum(movmean(duringus_lin_speed, 60))./(framerate);
        distance_during = distance_during_cumsum(end,:) - distance_during_cumsum(1,:);
        distance_after_cumsum = cumsum(movmean(afterus_lin_speed, 60))./(framerate);
        distance_after = distance_after_cumsum(end,:) - distance_after_cumsum(1,:);
        distance_extra_cumsum = cumsum(movmean(extraus_lin_speed, 60))./(framerate);
        distance_extra = distance_extra_cumsum(end,:) - distance_extra_cumsum(1,:);
        distance = [distance_before; distance_during; distance_after; distance_extra];
        distance = distance';
        
        %% Combine and save data
        % Re-allocate pertinent data with proper headings and place in a table.
        % Temporal values
        P01_Time = time(1:end-1);
        P02_X_Position = x(1:end-1);
        P03_Y_Position = y(1:end-1);
        P04_Orientation = orit(1:end-1);
        P05_Trigger_Binary = trig_ind(1:end-1);
        P06_Angular_Speed = orit_spd_smo;
        P07_Angular_Displacement = angular_position;
        P08_Linear_Speed = lin_speed_smo;
        P09_Linear_Distance = distance_traveled;
        
        % Average values
        P10_Average_Angular_Speed = analy_angularSpeed_mean_mat;
        P11_Average_Linear_Speed = analy_linear_speed_mean_mat;
        P12_Angle_Traveled = angular_disp;
        P13_Distance_Traveled = distance;
        
        % T1 will be the Excel file with time dependent parameters.
        T1 = table(P01_Time, P02_X_Position, P03_Y_Position, P04_Orientation, P05_Trigger_Binary, ...
            P06_Angular_Speed, P07_Angular_Displacement, P08_Linear_Speed, P09_Linear_Distance);
        
        % writetable(T1, append(mice_ID, '\', mice_ID, '_', intensity, '_temporal_values.csv'))
%         writetable(T1, append(mice_ID, '\', mice_ID, '_', intensity, '_temporal_values_241022.csv'))
        writetable(T1, fullfile(outputFolder, append(mice_ID, '_', intensity, '_temporal_values_241022.csv')));

        
        % T2 will be the Excel file with average values from the time bins before,
        % during, and after FUS stimulation.
        T2 = table(P10_Average_Angular_Speed, P11_Average_Linear_Speed, ...
            P12_Angle_Traveled, P13_Distance_Traveled);
        
        % writetable(T2, append(mice_ID, '\', mice_ID, '_', intensity, '_average_values.csv'))
%         writetable(T2, append(mice_ID, '\', mice_ID, '_', intensity, '_average_values_240122.csv'))
        writetable(T2, fullfile(outputFolder, append(mice_ID, '_', intensity, '_average_values_240122.csv')));


        %% calculating AUC
        % Initialize AUC storage arrays
        AUC_beforeus_orit_spd = zeros(1, 5);
        AUC_duringus_orit_spd = zeros(1, 5);
        AUC_beforeus_lin_speed = zeros(1, 5);
        AUC_duringus_lin_speed = zeros(1, 5);
        % Calculate the AUC for each column (each ultrasound stimulation)
        for i = 1:pulse_num
            % Calculate AUC for each stimulation for before and during ultrasound data
            AUC_beforeus_lin_speed(i) = trapz(beforeus_lin_speed_smo(:, i));
            AUC_duringus_lin_speed(i) = trapz(duringus_lin_speed_smo(:, i));
            AUC_beforeus_orit_spd(i) = trapz(beforeus_orit_spd_smo(:, i));
            AUC_duringus_orit_spd(i) = trapz(duringus_orit_spd_smo(:, i));
        end
        AngularBeforeAUC = AUC_beforeus_orit_spd';
        AngularDuringAUC = AUC_duringus_orit_spd';
        LinearBeforeAUC = AUC_beforeus_lin_speed';
        LinearDuringAUC = AUC_duringus_lin_speed';


        T3 = table(analy_angularSpeed_mean_mat, analy_angularSpeed_smo_mean_mat, analy_linear_speed_mean_mat, analy_lin_speed_smo_mean_mat, AngularBeforeAUC, AngularDuringAUC, LinearBeforeAUC, LinearDuringAUC);        
        % writetable(T3, append(mice_ID, '\', mice_ID, '_', intensity, '_AngularAndLinear_240903.csv'))
%         writetable(T3, append(mice_ID, '\', mice_ID, '_', intensity, '_AngularAndLinear_241029.csv'))
        writetable(T3, fullfile(outputFolder, append(mice_ID, '_', intensity, '_AngularAndLinear_241029.csv')));
       

        
        %% Archived code
        
        %% Calculate the onset time for rotation after US stimulation. 
        
        % General strategy: Instead of using the orientation speed, use the angular
        % displacement since the data is less noisy. 
        % v3: skip this step because expreiment is not optimized for 
        
        % t_before_fus = 10;                       % [s], the time before US on.
        % t_before_fus = t_before_fus*framerate;  % [frames], the time before FUS on.
        % 
        % 
        % thre_mat = zeros(1,pulse_num);
        % t_tot = size(beforeus_orit_spd,1);
        % thre = -1;%the threshold that above 1 will be counted in to the value 
        % for i = 1:pulse_num
        %     thre_mat(i) = abs(max(thre,mean(beforeus_orit_spd((t_tot-t_before_fus):t_tot,i))+3*std(beforeus_orit_spd((t_tot-t_before_fus):t_tot,i))));
        % end
        % 
        % t_onset = zeros(1,pulse_num);
        % 
        % duringus_orit_spd1 = duringus_orit_spd;
        % for i=1:pulse_num
        %     duringus_orit_spd1(:,i) = duringus_orit_spd(:,i);
        %     %duringus_orit_spd1(:,i)=smooth(duringus_orit_spd(:,i),3);
        %     if find(duringus_orit_spd1(:,i) > thre_mat(i),1)
        %         t_onset(i) = find(duringus_orit_spd1(:,i)>thre_mat(i),1);
        %     else
        %         t_onset(i) = 0;
        %     end
        %     
        % end
        % 
        % t_onset=t_onset/framerate;  
        % t_onset=t_onset*10;
        % t_onset=round(t_onset)/10;
        % 
        %% Calculate the time spent travelling.
        
        % Mobile time and episodes were defined as periods (excluding rearing ...
        % and sniffing) when the movement of the mouse center-point was...
        % >2.0 cm/s for at least 0.5 s
        
        % % Three main data sets to compute with respect to the entire acquisition
        % % period
        % % (1) Orientation, (2) Rotation Speed, (3) Angular Displacement
        % rotation_data = zeros(length(orit)-1,3);
        % rotation_data(:,1) = orit(1:end-1); % To match the dimensions of the vector
        % rotation_data(:,2) = orit_spd_smo(:); 
        % rotation_data(:,3) = angular_position(:);
        % 
        % % Three main data sets to compute with respect to the entire acquisition
        % % period
        % % (1) X position, (2) Y position, (3) Linear Speed, (4) Distance traveled
        % distance_data = zeros(length(x)-1,4);
        % distance_data(:,1) = x(1:end-1); % To match the dimensions of the vector
        % distance_data(:,2) = y(1:end-1); % To match the dimensions of the vector
        % distance_data(:,3) = lin_speed_smo(:); 
        % distance_data(:,4) = distance_traveled(:);
        % 
        % % Save all the matrices
        % writematrix(rotation_data, append(mice_ID, '\rotation_data', '_', intensity, '.csv'));
        % writematrix(distance_data, append(mice_ID, '\distance_data', '_', intensity, '.csv'));
        % 
        % writematrix(speed_mean_mat, append(mice_ID, '\speed_mean_mat', '_', intensity, '.csv'));
        % writematrix(lin_speed_mean_mat, append(mice_ID, '\lin_speed_mean_mat', '_', intensity, '.csv'));
        % 
        

%         cd('C:\Users\xu.t\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Projects_02_TRPV4\2024-07_TRPV1_TRPV4_Experiment\02_Data\20240717_TRPV1_h-2_TX081\Code'); 
        % cd('C:\Users\徐田奇\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Projects_02_TRPV4\2024-07_TRPV1_TRPV4_Experiment\02_Data\20240718_TRPV1_h-1_TX080\Code\');
        cd(folderChange);

%         % 15 s before and 300s after
%         usoffset = find(trig_diff(1:usend)<0);
        

        lengthTrigOn = length(usonset);

        % %{

        if lengthTrigOn == 5
            firstUSPoint = usonset(1)+1;
            secondUSPoint = usonset(2)+1;
            thirdUSPoint = usonset(3)+1;
            forthUSPoint = usonset(4)+1;
            fifthUSPoint = usonset(5)+1;
        else
            firstUSPoint = usonset(2)+1;
            secondUSPoint = usonset(3)+1;
            thirdUSPoint = usonset(4)+1;
            forthUSPoint = usonset(5)+1;
            fifthUSPoint = usonset(6)+1;
            % usonset
        end
        

        % myTimePoint = usonset(1)+1-framerate*ustime:usonset(5)+1+framerate*ustime+framerate*300;
        myTimePoint = firstUSPoint-framerate*ustimeduring:firstUSPoint+framerate*4*100+framerate*ustimeduring+framerate*300;
        size(myTimePoint)
        
        newTime = time - firstUSPoint/framerate; % Set the first US as 0
        
        % Re-set the data
        myName = append(mice_ID, '_',  intensity);
        myTime = newTime(myTimePoint);
        myUSTrig = [firstUSPoint, secondUSPoint, thirdUSPoint, forthUSPoint, fifthUSPoint];
        myAngularDisplacemen = angular_position(myTimePoint); % Angular displacement
        myAngularSpeed = orit_spd_smo(myTimePoint); % Angular speed
        myLinearSpeed = lin_speed_smo(myTimePoint); % Linear speed
        myDistanceTraveled = distance_traveled(myTimePoint); % Distance traveled
        myAngularOrientation = orit(myTimePoint); % Angular orientation
        myCalcium = calcium(myTimePoint);
        
        oneBehaviorData = BehaviorCalciumClass_1(myName, myTime, myUSTrig, myAngularDisplacemen, myAngularSpeed, myLinearSpeed, myDistanceTraveled, myAngularOrientation, myCalcium);
        moreBehaviorData = [moreBehaviorData,oneBehaviorData];
        % %}


        % orit_spd_smo: Angular speed
        % lin_speed_smo: Linear speed
        % distance_traveled: Distance traveled
        % orit

        % Modified by TX


    end

end

% save('moreBehaviorDataFile.mat','moreBehaviorData')
save(fullfile(outputFolder, 'moreBehaviorDataFile.mat'), 'moreBehaviorData');



%% 步骤
%{
1. 运行并且注释保存信息
2. 单独运行保存信息
3. 在saveBehaviorData.TX中load（注意将allBehaviorData=[]注释，否则都变成0了）
%}


%% Add 08/14/2024

USTimePoint_1 = 0;%ustime;
USTimePoint_2 = USTimePoint_1 + 3005/framerate;
USTimePoint_3 = USTimePoint_2 + 3005/framerate;
USTimePoint_4 = USTimePoint_3 + 3005/framerate;
USTimePoint_5 = USTimePoint_4 + 3005/framerate;

% TRPV1_h - Dark Pink: #AC316E
% TRPV1_l - Pink: #DBA5CB
% mtTRPV4_l - green: #80BA7F
% Control_l - grey: #808080

%% Image TX 2024-08-29
num_each_time = framerate*ustimeduring*4;
each_time = (1:num_each_time)/fs;
y_low = min(min(angular_speed));
y_high = max(max(angular_speed));
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围

%% Angular speed
% Angular speed for each US
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,angular_speed(:,1), 'Color', '#666666','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,angular_speed(:,2), 'Color', '#0099CC','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,angular_speed(:,3), 'Color', '#66CC99','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,angular_speed(:,4), 'Color', '#FFCC66','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,angular_speed(:,5), 'Color', '#CC6666','LineStyle','-','LineWidth',1);
hold on;
% US stimulationlegend('filtered signal', 'raw signal','Trigger');
x_patch = [(framerate*ustimeduring+1)/framerate, (framerate*ustimeduring+1)/framerate, framerate*(ustimeduring+ustime_orig)/framerate, framerate*(ustimeduring+ustime_orig)/framerate];
% x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+time_during/fs, (time_before+1)/fs+time_during/fs];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
legend('Data 1', 'Data 2','Data 3','Data 4','Data 5','Ultrasound','Location','southeast');
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Angular Speed (rev/min)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_angularSpeed, fileName_angularSpeedEach);

% Angular Speed Image for mean+std
angularSpeed_mean = mean(angular_speed,2);
angularSpeed_std = std(angular_speed,0,2);
% Calculate the upper and lower bounds
upper_bound = angularSpeed_mean + angularSpeed_std;  % 上边界 Upper bound
lower_bound = angularSpeed_mean - angularSpeed_std;  % 下边界 Lower bound
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,angularSpeed_mean, 'Color', PlotColor,'LineStyle','-','LineWidth',1);
hold on;
% Optional: Plot the upper and lower bounds as dashed lines
plot(each_time, upper_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
% US stimulation
% x_patch = [(framerate*ustime+1)/framerate, (framerate*ustime+1)/framerate, framerate*ustime/framerate*2, framerate*ustime/framerate*2];
x_patch = [(framerate*ustimeduring+1)/framerate, (framerate*ustimeduring+1)/framerate, framerate*(ustimeduring+ustime_orig)/framerate, framerate*(ustimeduring+ustime_orig)/framerate];
% x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+time_during/fs, (time_before+1)/fs+time_during/fs];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
plot(each_time, lower_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
legend('Mean Angular Speed', 'Std Angular Speed','US Stimulation');
hold on;
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Angular Speed (rev/min)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_angularSpeed, fileName_angularSpeedMean);

% Angular speed_smo for each US
y_low = min(min(angular_speed_smo));
y_high = max(max(angular_speed_smo));
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,angular_speed_smo(:,1), 'Color', '#666666','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,angular_speed_smo(:,2), 'Color', '#0099CC','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,angular_speed_smo(:,3), 'Color', '#66CC99','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,angular_speed_smo(:,4), 'Color', '#FFCC66','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,angular_speed_smo(:,5), 'Color', '#CC6666','LineStyle','-','LineWidth',1);
hold on;
% US stimulationlegend('filtered signal', 'raw signal','Trigger');
% x_patch = [(framerate*ustime+1)/framerate, (framerate*ustime+1)/framerate, framerate*ustime/framerate*2, framerate*ustime/framerate*2];
x_patch = [(framerate*ustimeduring+1)/framerate, (framerate*ustimeduring+1)/framerate, framerate*(ustimeduring+ustime_orig)/framerate, framerate*(ustimeduring+ustime_orig)/framerate];
% x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+time_during/fs, (time_before+1)/fs+time_during/fs];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
legend('Data 1', 'Data 2','Data 3','Data 4','Data 5','Ultrasound','Location','southeast');
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Angular Speed (rev/min)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_angularSpeed, fileName_angularSpeedEach_smo);

% Angular Speed_smo Image for mean+std
angularSpeed_smo_mean = mean(angular_speed_smo,2);
angularSpeed_smo_std = std(angular_speed_smo,0,2);
% Calculate the upper and lower bounds
upper_bound = angularSpeed_smo_mean + angularSpeed_smo_std;  % 上边界 Upper bound
lower_bound = angularSpeed_smo_mean - angularSpeed_smo_std;  % 下边界 Lower bound
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,angularSpeed_smo_mean, 'Color', PlotColor,'LineStyle','-','LineWidth',1);
hold on;
% Optional: Plot the upper and lower bounds as dashed lines
plot(each_time, upper_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
% US stimulation
% x_patch = [(framerate*ustime+1)/framerate, (framerate*ustime+1)/framerate, framerate*ustime/framerate*2, framerate*ustime/framerate*2];
x_patch = [(framerate*ustimeduring+1)/framerate, (framerate*ustimeduring+1)/framerate, framerate*(ustimeduring+ustime_orig)/framerate, framerate*(ustimeduring+ustime_orig)/framerate];
% x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+time_during/fs, (time_before+1)/fs+time_during/fs];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
plot(each_time, lower_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
legend('Mean Angular Speed', 'Std Angular Speed','US Stimulation');
hold on;
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Angular Speed (rev/min)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_angularSpeed, fileName_angularSpeedMean_smo);

% Angular speed_all
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(myTime, myAngularSpeed, 'Color', PlotColor,'LineStyle','-','LineWidth',1);
hold on;
% y_low = -30;
% y_high = 30;
y_low = min(myAngularSpeed);
y_high = max(myAngularSpeed);
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围
% 1st US stimulation
x_patch = [USTimePoint_1, USTimePoint_1, USTimePoint_1+ustimeduring, USTimePoint_1+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', [255,217,102]/255); 
hold on
% 2nd US stimulation
x_patch = [USTimePoint_2, USTimePoint_2, USTimePoint_2+ustimeduring, USTimePoint_2+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', [255,217,102]/255); 
hold on
% 3th US stimulation
x_patch = [USTimePoint_3, USTimePoint_3, USTimePoint_3+ustimeduring, USTimePoint_3+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', [255,217,102]/255); 
hold on
% 4th US stimulation
x_patch = [USTimePoint_4, USTimePoint_4, USTimePoint_4+ustimeduring, USTimePoint_4+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', [255,217,102]/255); 
hold on
% 5th US stimulation
x_patch = [USTimePoint_5, USTimePoint_5, USTimePoint_5+ustimeduring, USTimePoint_5+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', [255,217,102]/255); 
hold on
hold off;
% title(append(mice_ID, '\_', intensity, '\_angular\_speed'))
xlim([-20 720])
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Angular speed (rev/min)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_angularSpeed, fileName_angularSpeed);


%% Linear Speed Image TX 2024-08-29
% linear speed for each US
y_low = min(min(linear_speed));
y_high = max(max(linear_speed));
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围

figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,linear_speed(:,1), 'Color', '#666666','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,linear_speed(:,2), 'Color', '#0099CC','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,linear_speed(:,3), 'Color', '#66CC99','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,linear_speed(:,4), 'Color', '#FFCC66','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,linear_speed(:,5), 'Color', '#CC6666','LineStyle','-','LineWidth',1);
hold on;
% US stimulationlegend('filtered signal', 'raw signal','Trigger');
% x_patch = [(framerate*ustime+1)/framerate, (framerate*ustime+1)/framerate, framerate*ustime/framerate*2, framerate*ustime/framerate*2];
x_patch = [(framerate*ustimeduring+1)/framerate, (framerate*ustimeduring+1)/framerate, framerate*(ustimeduring+ustime_orig)/framerate, framerate*(ustimeduring+ustime_orig)/framerate];
% x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+time_during/fs, (time_before+1)/fs+time_during/fs];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
legend('Data 1', 'Data 2','Data 3','Data 4','Data 5','Ultrasound','Location','southeast');
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Linear Speed (cm/s)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_linearSpeed, fileName_linearSpeedEach);

% Linear Speed Image for mean+std
linearSpeed_mean = mean(linear_speed,2);
linearSpeed_std = std(linear_speed,0,2);
% Calculate the upper and lower bounds
upper_bound = linearSpeed_mean + linearSpeed_std;  % 上边界 Upper bound
lower_bound = linearSpeed_mean - linearSpeed_std;  % 下边界 Lower bound
y_high = max(upper_bound);
y_low = min(lower_bound);
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,linearSpeed_mean, 'Color', PlotColor,'LineStyle','-','LineWidth',1);
hold on;
% Optional: Plot the upper and lower bounds as dashed lines
plot(each_time, upper_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
% US stimulation
% x_patch = [(framerate*ustime+1)/framerate, (framerate*ustime+1)/framerate, framerate*ustime/framerate*2, framerate*ustime/framerate*2];
x_patch = [(framerate*ustimeduring+1)/framerate, (framerate*ustimeduring+1)/framerate, framerate*(ustimeduring+ustime_orig)/framerate, framerate*(ustimeduring+ustime_orig)/framerate];
% x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+time_during/fs, (time_before+1)/fs+time_during/fs];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
plot(each_time, lower_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
legend('Mean Linear Speed (cm/s)', 'Std Linear Speed','US Stimulation');
hold on;
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Angular Speed (rev/min)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_linearSpeed, fileName_linearSpeedMean);


y_low = min(min(linear_speed_smo));
y_high = max(max(linear_speed_smo));
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围

figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,linear_speed_smo(:,1), 'Color', '#666666','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,linear_speed_smo(:,2), 'Color', '#0099CC','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,linear_speed_smo(:,3), 'Color', '#66CC99','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,linear_speed_smo(:,4), 'Color', '#FFCC66','LineStyle','-','LineWidth',1);
hold on;
plot(each_time,linear_speed_smo(:,5), 'Color', '#CC6666','LineStyle','-','LineWidth',1);
hold on;
% US stimulationlegend('filtered signal', 'raw signal','Trigger');
% x_patch = [(framerate*ustime+1)/framerate, (framerate*ustime+1)/framerate, framerate*ustime/framerate*2, framerate*ustime/framerate*2];
x_patch = [(framerate*ustimeduring+1)/framerate, (framerate*ustimeduring+1)/framerate, framerate*(ustimeduring+ustime_orig)/framerate, framerate*(ustimeduring+ustime_orig)/framerate];
% x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+time_during/fs, (time_before+1)/fs+time_during/fs];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
legend('Data 1', 'Data 2','Data 3','Data 4','Data 5','Ultrasound','Location','northeast');
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Linear Speed (cm/s)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_linearSpeed, fileName_linearSpeedEach_smo);

% Linear Speed Image for mean+std
linearSpeed_smo_mean = mean(linear_speed_smo,2);
linearSpeed_smo_std = std(linear_speed_smo,0,2);
% Calculate the upper and lower bounds
upper_bound = linearSpeed_smo_mean + linearSpeed_smo_std;  % 上边界 Upper bound
lower_bound = linearSpeed_smo_mean - linearSpeed_smo_std;  % 下边界 Lower bound
y_high = max(upper_bound);
y_low = min(lower_bound);
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(each_time,linearSpeed_smo_mean, 'Color', PlotColor,'LineStyle','-','LineWidth',1);
hold on;
% Optional: Plot the upper and lower bounds as dashed lines
plot(each_time, upper_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
% US stimulation
% x_patch = [(framerate*ustime+1)/framerate, (framerate*ustime+1)/framerate, framerate*ustime/framerate*2, framerate*ustime/framerate*2];
x_patch = [(framerate*ustimeduring+1)/framerate, (framerate*ustimeduring+1)/framerate, framerate*(ustimeduring+ustime_orig)/framerate, framerate*(ustimeduring+ustime_orig)/framerate];
% x_patch = [(time_before+1)/fs, (time_before+1)/fs, (time_before+1)/fs+time_during/fs, (time_before+1)/fs+time_during/fs];
patch(x_patch, y_patch, [249,233,138]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#F9E98A'); 
% patch(x_patch, y_patch, 'FaceColor', '#F9E98A', 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
plot(each_time, lower_bound, 'Color', PlotColor, 'LineStyle', '--', 'LineWidth', 1);
hold on
legend('Mean Linear Speed', 'Std Linear Speed','US Stimulation');
hold on;
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Angular Speed (rev/min)','FontName','Arial','Fontsize',figure_FontSize)
saveFigureWithTitle(outputFolder, figureTitle_linearSpeed, fileName_linearSpeedMean_smo);

% Linear speed_all
figure;
figure_FontSize = 12;
set(gca,'FontSize',figure_FontSize,'FontName','Arial')
plot(myTime, myLinearSpeed, 'Color', PlotColor,'LineStyle','-','LineWidth',1);
hold on;
y_low = min(myLinearSpeed);
y_high = max(myLinearSpeed);
y_patch = [y_low, y_high, y_high, y_low]; % 填充区域的Y范围
% 1st US stimulation
x_patch = [USTimePoint_1, USTimePoint_1, USTimePoint_1+ustimeduring, USTimePoint_1+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
% 2nd US stimulation
x_patch = [USTimePoint_2, USTimePoint_2, USTimePoint_2+ustimeduring, USTimePoint_2+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
% 3th US stimulation
x_patch = [USTimePoint_3, USTimePoint_3, USTimePoint_3+ustimeduring, USTimePoint_3+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
% 4th US stimulation
x_patch = [USTimePoint_4, USTimePoint_4, USTimePoint_4+ustimeduring, USTimePoint_4+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
% 5th US stimulation
x_patch = [USTimePoint_5, USTimePoint_5, USTimePoint_5+ustimeduring, USTimePoint_5+ustimeduring];
patch(x_patch, y_patch, [255,217,102]/255, 'FaceAlpha', 0.3, 'EdgeColor', '#ffd966'); 
hold on
hold off;
% title(append(mice_ID, '\_', intensity, '\_angular\_speed'))
xlim([-20 720])
xlabel('Time (s)','FontName','Arial','Fontsize',figure_FontSize)
ylabel('Linear Speed (cm/s)','FontName','Arial','Fontsize',figure_FontSize)
% Call the function to save the figure with the title
saveFigureWithTitle(outputFolder, figureTitle_linearSpeed, fileName_linearSpeed);



%% 统一保存5次超声刺激的数据到单一文件中 (Save 5-US stimulation data into one unified file)

% behaviorData.mat文件的完整路径 (Full path for behaviorData.mat)
behaviorDataFile = fullfile(resultFolderPath, 'behaviorData.mat');

if exist(behaviorDataFile, 'file')
    temp = load(behaviorDataFile, 'behaviorData');
    if isfield(temp, 'behaviorData')
        behaviorData = temp.behaviorData;
    else
        behaviorData = struct('serialNumber', {}, 'mouseType', {}, 'mouseID', {}, ...
                              'dataName', {}, 'angularSpeedData', {}, 'linearSpeedData', {});
    end
else
    behaviorData = struct('serialNumber', {}, 'mouseType', {}, 'mouseID', {}, ...
                          'dataName', {}, 'angularSpeedData', {}, 'linearSpeedData', {});
end


% 创建新的数据结构 (Create new data structure for current experiment)
newData.mouseType = mouseType;
newData.mouseID = mouseID;
newData.dataName = [mouseType '_' mouseID '_' experimentDate '_' stimulationLevel];
newData.angularSpeedData = angular_speed_smo(:,1:5); % 角速度数据 (Angular Speed Data)
newData.linearSpeedData = linear_speed_smo(:,1:5);   % 线速度数据 (Linear Speed Data)


% 检查 dataName 是否已经存在 (Check if dataName already exists)
existIdx = find(strcmp({behaviorData.dataName}, newData.dataName), 1);


if ~isempty(existIdx)
    % 如果存在，先删除旧数据 (Delete existing data completely)
    behaviorData(existIdx) = [];
    fprintf('数据 %s 已存在，已删除旧数据并替换为最新数据 (Old data deleted and replaced).\n', newData.dataName);
end

newData.serialNumber = length(behaviorData) + 1;
behaviorData = [behaviorData; newData];

%% 按mouseType分类，再按mouseID顺序排列 (Sort by mouseType, then by mouseID)
[~, sortIdx] = sortrows([{behaviorData.mouseType}' {behaviorData.mouseID}']);
behaviorData = behaviorData(sortIdx);
fprintf('数据 %s 已添加为最新数据 (Data added successfully).\n', newData.dataName);
% 保存更新后的behaviorData到统一文件中 (Save updated behaviorData into the unified file)
save(behaviorDataFile, 'behaviorData');

% fprintf('统一数据文件保存成功至 (Unified data file saved successfully to)：%s\n', behaviorDataFile);
% 
% if ~isempty(existIdx)
%     % 如果存在，则替换旧数据 (Replace existing data)
%     behaviorData(existIdx) = newData;
%     fprintf('数据 %s 已存在，已替换为最新数据 (Data exists. Updated to latest).\n', newData.dataName);
% else
%     % 不存在，则在末尾追加新数据，并添加serialNumber (Append new data at the end with serialNumber)
%     newData.serialNumber = length(behaviorData) + 1;
%     behaviorData = [behaviorData; newData];
%     fprintf('数据 %s 已添加为新数据 (Data added as new).\n', newData.dataName);
% end
% 
% % 保存更新后的behaviorData到统一文件中 (Save updated behaviorData into the unified file)
% save(behaviorDataFile, 'behaviorData');
% 
% fprintf('统一数据文件保存成功至 (Unified data file saved successfully to)：%s\n', behaviorDataFile);





end