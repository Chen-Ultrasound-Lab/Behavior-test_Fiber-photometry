clc; clear; close all;
% Add the Angular distence
% For the distence, I should only care about the post

load('splitData_20250719_withBaselineZscore.mat');
%% 
for i = 1:length(splitData)
    if isfield(splitData(i), 'BaselineZscore') && length(splitData(i).BaselineZscore) == 2401
        splitData(i).BaselineZscore = splitData(i).BaselineZscore(1:end-1);
    end
end

% Parameters
fs = 30;
initialTime = 30;
endTime = 40;
threshold = 3.5;
targetDC = 40;
dt = 1 / fs;
dt_min = dt/60;
pressureCond = '120mVpp';
mouseTypes = {'mtTRPV4','Control'};

% Initialize output struct
outputData = struct();

% Initialize fields
for mt = 1:length(mouseTypes)
    mtLabel = mouseTypes{mt};
    outputData.([mtLabel '_Zscore_pre']) = [];
    outputData.([mtLabel '_Zscore_post']) = [];
    outputData.([mtLabel '_Zscore_mean_delta']) = [];
    outputData.([mtLabel '_Zscore_max']) = [];

    outputData.([mtLabel '_Angular_pre']) = [];
    outputData.([mtLabel '_Angular_post']) = [];
    outputData.([mtLabel '_Angular_mean_delta']) = [];
    outputData.([mtLabel '_Angular_max']) = [];

    outputData.([mtLabel '_AngularDis_pre']) = [];
    outputData.([mtLabel '_AngularDis_post']) = [];
    outputData.([mtLabel '_AngularDis_delta']) = [];

    outputData.([mtLabel '_Linear_pre']) = [];
    outputData.([mtLabel '_Linear_post']) = [];
    outputData.([mtLabel '_Linear_mean_delta']) = [];
    outputData.([mtLabel '_Linear_max']) = [];

    outputData.([mtLabel '_MeanCurve_Zscore']) = {};
    outputData.([mtLabel '_MeanCurve_Calcium']) = {};
    outputData.([mtLabel '_MeanCurve_Angular']) = {};



    % === AUC for BaselineZscore & AngularSpeed ===

    outputData.([mtLabel '_Zscore_AUC_pre'])        = [];
    outputData.([mtLabel '_Zscore_AUC_post'])       = [];
    outputData.([mtLabel '_Zscore_AUC_postCorr'])   = [];

    outputData.([mtLabel '_Angular_AUC_pre'])       = [];
    outputData.([mtLabel '_Angular_AUC_post'])      = [];
    outputData.([mtLabel '_Angular_AUC_postCorr'])  = [];
end


% Get all unique mouseIDs
allMouseIDs = unique({splitData.mouseID});

for m = 1:length(allMouseIDs)
    mouseID = allMouseIDs{m};

    % Select valid entries for this mouse
    isSpecialMouse = ismember(mouseID, {'TX144','TX145','TX146'});

    entries = splitData(strcmp({splitData.mouseID}, mouseID) & ...
        arrayfun(@(x) isfield(x,'isUsable') && x.isUsable, splitData) & ...
        arrayfun(@(x) isfield(x,'DutyCycle') && x.DutyCycle == targetDC, splitData) & ...
        arrayfun(@(x) isfield(x,'dataName') && contains(x.dataName, pressureCond), splitData) & ...
        (isSpecialMouse | ...
         arrayfun(@(x) isfield(x,'preCalciumNew') && ...
                        ~isempty(x.preCalciumNew) && ...
                        ~isnan(x.preCalciumNew) && ...
                        x.preCalciumNew <= threshold, splitData)) );


    if isempty(entries), continue; end

    mouseType = entries(1).mouseType;

    % Skip if not in target mouseTypes
    if ~ismember(mouseType, mouseTypes)
        fprintf('Skipping unknown mouseType: %s\n', mouseType);
        continue;
    end


    % Initialize temporary storage
    z_pre = []; z_post = []; z_delta = []; z_max = [];
    a_pre = []; a_post = []; a_delta = []; a_max = [];
    ad_pre = []; ad_post = []; ad_delta = [];
    l_pre = []; l_post = []; l_delta = []; l_max = [];



z_auc_pre      = [];  z_auc_post      = [];  z_auc_postCorr      = [];
a_auc_pre      = [];  a_auc_post      = [];  a_auc_postCorr      = [];


    % Initialize curve collection
    zscoreMatrix = [];
    angularMatrix = [];
    calciumMatrix = [];

    for i = 1:length(entries)
        x = entries(i);

        % Skip empty fields
        if isfield(x,'CalciumData') && ~isempty(x.CalciumData)
            c = x.CalciumData;
            if length(c) >= endTime*fs
                calciumMatrix = [calciumMatrix, x.CalciumData(:)];  % column vector
            end
        end


        if isfield(x,'BaselineZscore') && ~isempty(x.BaselineZscore)
            z = x.BaselineZscore;
            if length(z) >= endTime*fs
                z_pre(end+1) = mean(z((initialTime-20)*fs+1:(endTime-20)*fs));
                z_post(end+1) = mean(z(initialTime*fs+1:endTime*fs));
                z_delta(end+1) = z_post(end) - z_pre(end);
                z_max(end+1) = max(z(initialTime*fs+1:endTime*fs)) - mean(z((initialTime-20)*fs+1:(endTime-20)*fs));
                zscoreMatrix = [zscoreMatrix, x.BaselineZscore(:)];  % column vector

                % AUC
                idx_pre  = (initialTime-20)*fs+1:(endTime-20)*fs;
                idx_post =  initialTime*fs+1:endTime*fs;

                z_auc_pre(end+1)      = trapz(z(idx_pre))  * dt;                      
                z_auc_post(end+1)     = trapz(z(idx_post)) * dt;                      
                z_auc_postCorr(end+1) = trapz(z(idx_post) - mean(z(idx_pre))) * dt;   
            end
        end

        if isfield(x,'angularSpeedData') && ~isempty(x.angularSpeedData)
            a = x.angularSpeedData;
            if length(a) >= endTime*fs
                a_pre(end+1) = mean(a((initialTime-20)*fs+1:(endTime-20)*fs));
                a_post(end+1) = mean(a(initialTime*fs+1:endTime*fs));
                a_delta(end+1) = a_post(end) - a_pre(end);
                a_max(end+1) = max(a(initialTime*fs+1:endTime*fs)) - mean(a((initialTime-20)*fs+1:(endTime-20)*fs));
                angularMatrix = [angularMatrix, x.angularSpeedData(:)];


                % AUC
                idx_pre  = (initialTime-20)*fs+1:(endTime-20)*fs;
                idx_post =  initialTime*fs+1:endTime*fs;
                a_auc_pre(end+1) = trapz(a(idx_pre))  * dt_min;                      
                a_auc_post(end+1) = trapz(a(idx_post)) * dt_min;                      
                a_auc_postCorr(end+1) = trapz(a(idx_post) - mean(a(idx_pre))) * dt_min;
            end
            ad = cumtrapz(a) * dt_min;  % Turn to rev
            if length(ad) >= endTime*fs
                ad_pre(end+1) = ad((endTime-20)*fs) - ad((initialTime-20)*fs);
                ad_post(end+1) = ad(endTime*fs) - ad(initialTime*fs);
                ad_delta(end+1) = ad_post(end) - ad_pre(end);
            end
        end

        if isfield(x,'linearSpeedData') && ~isempty(x.linearSpeedData)
            l = x.linearSpeedData;
            if length(l) >= endTime*fs
                l_pre(end+1) = mean(l((initialTime-20)*fs+1:(endTime-20)*fs));
                l_post(end+1) = mean(l(initialTime*fs+1:endTime*fs));
                l_delta(end+1) = l_post(end) - l_pre(end);
                l_max(end+1) = max(l(initialTime*fs+1:endTime*fs)) - mean(l((initialTime-20)*fs+1:(endTime-20)*fs));
            end
        end
    end

    % Save mean value of each mouse into output struct
    if ~isempty(mouseType)
        outputData.([mouseType '_Zscore_pre'])          = [outputData.([mouseType '_Zscore_pre']); mean(z_pre)];
        outputData.([mouseType '_Zscore_post'])         = [outputData.([mouseType '_Zscore_post']); mean(z_post)];
        outputData.([mouseType '_Zscore_mean_delta'])   = [outputData.([mouseType '_Zscore_mean_delta']); mean(z_delta)];
        outputData.([mouseType '_Zscore_max'])          = [outputData.([mouseType '_Zscore_max']); mean(z_max)];
        
        outputData.([mouseType '_Angular_pre'])         = [outputData.([mouseType '_Angular_pre']); mean(a_pre)];
        outputData.([mouseType '_Angular_post'])        = [outputData.([mouseType '_Angular_post']); mean(a_post)];
        outputData.([mouseType '_Angular_mean_delta'])  = [outputData.([mouseType '_Angular_mean_delta']); mean(a_delta)];
        outputData.([mouseType '_Angular_max'])         = [outputData.([mouseType '_Angular_max']); mean(a_max)];

        outputData.([mouseType '_AngularDis_pre'])      = [outputData.([mouseType '_AngularDis_pre']); mean(ad_pre)];
        outputData.([mouseType '_AngularDis_post'])     = [outputData.([mouseType '_AngularDis_post']); mean(ad_post)];
        outputData.([mouseType '_AngularDis_delta'])    = [outputData.([mouseType '_AngularDis_delta']); mean(ad_delta)];

        
        outputData.([mouseType '_Linear_pre'])          = [outputData.([mouseType '_Linear_pre']); mean(l_pre)];
        outputData.([mouseType '_Linear_post'])         = [outputData.([mouseType '_Linear_post']); mean(l_post)];
        outputData.([mouseType '_Linear_mean_delta'])   = [outputData.([mouseType '_Linear_mean_delta']); mean(l_delta)];
        outputData.([mouseType '_Linear_max'])          = [outputData.([mouseType '_Linear_max']); mean(l_max)];

        % AUC
        outputData.([mouseType '_Zscore_AUC_pre'])       = [outputData.([mouseType '_Zscore_AUC_pre']);       mean(z_auc_pre,      'omitnan')];
        outputData.([mouseType '_Zscore_AUC_post'])      = [outputData.([mouseType '_Zscore_AUC_post']);      mean(z_auc_post,     'omitnan')];
        outputData.([mouseType '_Zscore_AUC_postCorr'])  = [outputData.([mouseType '_Zscore_AUC_postCorr']);  mean(z_auc_postCorr, 'omitnan')];

        outputData.([mouseType '_Angular_AUC_pre'])      = [outputData.([mouseType '_Angular_AUC_pre']);      mean(a_auc_pre,      'omitnan')];
        outputData.([mouseType '_Angular_AUC_post'])     = [outputData.([mouseType '_Angular_AUC_post']);     mean(a_auc_post,     'omitnan')];
        outputData.([mouseType '_Angular_AUC_postCorr']) = [outputData.([mouseType '_Angular_AUC_postCorr']); mean(a_auc_postCorr, 'omitnan')];
    end

    if ~isempty(zscoreMatrix)
        meanZ = mean(zscoreMatrix, 2);  % 2400x1
        outputData.([mouseType '_MeanCurve_Zscore']){end+1} = meanZ;
    end
    if ~isempty(angularMatrix)
        meanA = mean(angularMatrix, 2);  % 2400x1
        outputData.([mouseType '_MeanCurve_Angular']){end+1} = meanA;
    end
    if ~isempty(calciumMatrix)
        meanC = mean(calciumMatrix, 2);  % 2401x1
        meanC = meanC(1:2400);  % keep only the first 2400 points
        outputData.([mouseType '_MeanCurve_Calcium']){end+1} = meanC;
    end

end

disp('✅ All mouse-level data extracted.');

% outputData.Control_Linear_max
ResultA_ConPreUSMean = mean(outputData.Control_Angular_pre);
ResultA_ConPreUSStd = std(outputData.Control_Angular_pre);
ResultA_ConPostUSMean = mean(outputData.Control_Angular_post);
ResultA_ConPostUSStd = std(outputData.Control_Angular_post);
ResultA_mtPreUSMean = mean(outputData.mtTRPV4_Angular_pre);
ResultA_mtPreUSStd = std(outputData.mtTRPV4_Angular_pre);
ResultA_mtPostUSMean = mean(outputData.mtTRPV4_Angular_post);
ResultA_mtPostUSStd = std(outputData.mtTRPV4_Angular_post);

ResultB_Delta_Con_mean = mean(outputData.Control_Angular_mean_delta);
ResultB_Delta_Con_std = std(outputData.Control_Angular_mean_delta);
ResultB_Delta_mt_mean = mean(outputData.mtTRPV4_Angular_mean_delta);
ResultB_Delta_mt_std = std(outputData.mtTRPV4_Angular_mean_delta);

ResultC_Max_Con_mean = mean(outputData.Control_Angular_max);
ResultC_Max_Con_std = std(outputData.Control_Angular_max);
ResultC_Max_mt_mean = mean(outputData.mtTRPV4_Angular_max);
ResultC_Max_mt_std = std(outputData.mtTRPV4_Angular_max);

save('outputData.mat', 'outputData');