function [] = runFiberBehavior_02_250717 (experimentDate, mouseID, stimulationLevel, mouseType)
% runExperiment - Run the complete experiment processing workflow.
%
% Syntax:  runExperiment(experimentDate, mouseID, stimulationLevel, mouseType)
%
% Inputs:
%    experimentDate   - Experiment date as a string (e.g., '20250113')
%    mouseID          - Mouse ID as a string (e.g., 'TX135')
%    stimulationLevel - Stimulation level string (e.g., '104mVpp' or '120mVpp')
%    mouseType        - Mouse type string (e.g., 'mtTRPV4', 'Control')
%
% Example:
%    runExperiment('20250113', 'TX135', '104mVpp', 'mtTRPV4')
%
% When stimulationLevel contains '104mVpp', pressureValue is set to 1.3.
% When stimulationLevel contains '120mVpp', pressureValue is set to 1.5.
% 20250520

    % Automatically assign pressureValue based on stimulationLevel
    if contains(stimulationLevel, '104mVpp')
         pressureValue = 1.3;
    elseif contains(stimulationLevel, '120mVpp')
         pressureValue = 1.5;
    elseif contains(stimulationLevel, '113mVpp')
         pressureValue = 1.4;
    else
         error('Unsupported stimulationLevel. Please use a string containing "104mVpp" or "113mVpp" or "120mVpp".');
    end

    % Automatically determine duty cycle
    if contains(stimulationLevel, '10DC')
        dutycycle = 10;
    elseif contains(stimulationLevel, '20DC')
        dutycycle = 20;
    elseif contains(stimulationLevel, '40DC')
        dutycycle = 40;
    else
        dutycycle = 40; % 
    end
    fprintf('Stimulation Level: %s | Duty Cycle: %d%% | Pressure: %.1f MPa\n', ...
        stimulationLevel, dutycycle, pressureValue);



    % Fixed parameters
    framerate = 30;         % [s], Frame rate of the camera.
    US_time = 15;           % [s], US duration.
    Analysis_US_time = 20;  % [s], Analysis time.
    US_offset = 85;         % [s], Offset time after the end of US treatment.
    triger_thre = 20000;
    pulse_num = 5;
    
    %% Data Path
%     dataFolderPath = 'C:\Users\xu.t\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Project_03_TRPV1\04_Experimental data\';
    dataFolderPath = 'C:\Users\xu.t\Box\Sonogenetics shared folder\12_Manuscript\Tianqi Code and Data\01_Matlab Code\03_Github\03_Experiment data\';
    experimentDate_ID = fullfile(experimentDate, mouseID);
    dataPath = fullfile(dataFolderPath, experimentDate_ID);     % Path where data is located
    
    %% Code Path
    [codePath, ~, ~] = fileparts(mfilename('fullpath'));        % Path where the code is located
    
    %% Results Path
    resultFolderName = [mouseType, '_', mouseID, '_', experimentDate, '_', stimulationLevel];
%     resultFolderPath = 'C:\Users\xu.t\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Project_03_TRPV1\05_Data analysis\02_Analysis Results\';
    resultFolderPath = 'C:\Users\xu.t\Box\Sonogenetics shared folder\12_Manuscript\Tianqi Code and Data\01_Matlab Code\03_Github\03_Experiment data\Analysis Results\';
    % resultFolderPath = 'C:\Users\xu.t\Box\ChenUltrasoundLab\01_Publications\90_ZhaoningTianqi_TUFFC_System\06_Behavior test\02_Result images\';
    resultPath = fullfile(resultFolderPath, resultFolderName);   % Path where results are located
    if ~exist(resultPath, 'dir')
        mkdir(resultPath);
    end
    
    %% Check if the trigger data file exists (e.g., triggers_TX135_20250113_104mVpp.mat)
    triggerFileName = sprintf('triggers_%s_%s_%s.mat', mouseID, experimentDate, stimulationLevel);
    triggerFilePath = fullfile(resultPath, triggerFileName);
    
    if exist(triggerFilePath, 'file')
        disp(['Found trigger file: ', triggerFilePath, '. Proceeding with S1, S2, and S3.']);
    else
        disp(['Trigger file not found: ', triggerFilePath, '. Running S0_USTriggerTest first.']);
        S0_USTriggerTest_01(dataPath, stimulationLevel, triger_thre, mouseID, experimentDate, resultPath, framerate, US_time, US_offset);
    end
    
    % Run the remaining processing scripts
    S1_BehaviorFiber_06(experimentDate, mouseID, stimulationLevel, pressureValue, ...
        mouseType, dataFolderPath, experimentDate_ID, dataPath, codePath, ...
        resultFolderName, resultFolderPath, resultPath, triger_thre, ...
        framerate, US_time, Analysis_US_time, US_offset, pulse_num, dutycycle);
    
    S2_FiberSelectData_05(experimentDate, mouseID, stimulationLevel, pressureValue, ...
        mouseType, dataFolderPath, experimentDate_ID, dataPath, codePath, ...
        resultFolderName, resultFolderPath, resultPath, triger_thre, ...
        framerate, US_time, pulse_num, dutycycle);

    S3_FiberAnalysisData_07(experimentDate, mouseID, stimulationLevel, pressureValue, mouseType, dataFolderPath, ...
        experimentDate_ID, resultFolderName, resultFolderPath, resultPath, ...
        framerate, US_time, Analysis_US_time, dutycycle);

end