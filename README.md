README - Fiber Photometry and Behavior Analysis (TRPV4 Project)

Author: Tianqi Xu
Date updated: 2026-09-09

1. Project Overview

This repository contains MATLAB scripts and example experimental data for
analyzing fiber photometry (calcium fluorescence) and behavioral responses
to ultrasound stimulation. The current group-level analysis uses mtTRPV4
and Control groups.

The workflow processes raw recordings, saves behavioral and calcium summary
databases, normalizes calcium signals using baseline statistics, and
summarizes responses at the mouse level. The supplied raw-data example is
mouse TX135, recorded on January 13, 2025, with stimulation label 120mVpp-2
(mtTRPV4). This example is not a complete dataset for both groups.

2. Folder Structure

Paths below are relative to the folder containing this README.txt.

01_Read data/
    Trigger detection, behavioral analysis, calcium extraction, and plotting.
    Entry script: FiberBehavirAnalysis_main_v12_250717.m
    Workflow function: runFiberBehavior_02_250717.m

02_Data analysis/
    Step10a_CalciumBaseline_01.m
    Step10b_MergeMat.m
    Step11_Zscore.m
    Step12_Cleanup.m
    Step13_CllectData_TRPV4_40DC_mouse07.m
    getPlotColor.m

03_Experiment data/
    20250113/TX135/       Example raw CSV recordings
    Analysis Results/    Processed example data and figures, including
                         behaviorData.mat and calciumData.mat

3. Requirements and Data Availability

- MATLAB with graphical figure support. The minimum release has not been
  validated.
- Signal Processing Toolbox: scripts use butter, filtfilt, and findpeaks.
- Write access to the configured results directory.
- Interactive trigger selection may be required when no saved trigger file
  exists; follow the figure prompts.

Before running Step10b, provide splitData_20250619_SuccessAng.mat
(the behavioral trial dataset), which is not included in this folder.

4. Process the Example Raw Data

Open 01_Read data in MATLAB and edit runFiberBehavior_02_250717.m:

- Set dataFolderPath to the absolute path of 03_Experiment data.
- Set resultFolderPath to the absolute path of
  03_Experiment data/Analysis Results (or another writable results folder).

The existing paths refer to the author's local folders and must be changed
for another computer. Use the variable names above to locate the settings;
line numbers may change when scripts are edited.

Run FiberBehavirAnalysis_main_v12_250717.m, or call:

    runFiberBehavior_02_250717('20250113', 'TX135', '120mVpp-2', 'mtTRPV4')

Arguments are experiment date, mouse ID, stimulation label, and group type.
Use mtTRPV4 or Control for the current raw-data workflow. The stimulation
label must match the input filenames. The function maps 104mVpp, 113mVpp,
and 120mVpp to 1.3, 1.4, and 1.5 MPa, respectively. Duty cycle is read from
10DC, 20DC, or 40DC in the label; it defaults to 40 when no such tag exists.
Review these experiment-specific settings before processing other data.

The function runs S0_USTriggerTest_01 when the saved trigger file is missing,
then S1_BehaviorFiber_06, S2_FiberSelectData_05, and S3_FiberAnalysisData_07.
Outputs include per-experiment MAT/CSV files and figures, plus the summary
databases behaviorData.mat and calciumData.mat in resultFolderPath.

5. Downstream Analysis

Run each script from a working directory containing its required MAT inputs,
or edit its load/save paths explicitly. For example, use 02_Data analysis
as the working directory and copy calciumData.mat there from the configured
results folder. Also supply the behavioral trial file described in Section 3.
Outputs use fixed filenames and may overwrite earlier results.

Step10a_CalciumBaseline_01.m
    Input:  calciumData.mat
    Output: splitCalciumData_20250719.mat
    Splits each recording into five stimulation trials, retaining baseline
    data. This step does not merge behavioral data.

Step10b_MergeMat.m
    Inputs: splitData_20250619_SuccessAng.mat
            splitCalciumData_20250719.mat
    Output: splitData_20250719.mat
    Adds CalciumData and BaselineData to behavioral trials by matching
    dataName and stimNumber. Ensure the inputs describe matching trials.

Step11_Zscore.m
    Input:  splitData_20250719.mat
    Output: splitData_20250719_withBaselineZscore.mat
    Calculates (calcium - baseline mean) / baseline standard deviation and
    stores BaselineZscore and preCalciumNew. Empty signals or zero baseline
    standard deviation produce empty/NaN results for the affected entry.

Step12_Cleanup.m
    Input:  splitData_20250719_withBaselineZscore.mat
    Outputs: splitData_20250719_cleanup.mat
             preCalciumNew_distribution.bmp and .fig
    Selects usable mtTRPV4/Control entries matching targetPressureList,
    plots their preCalciumNew distribution, and copies these values into
    preCalcium. It retains the full splitData structure and does not
    automatically calculate a signal threshold.

Step13_CllectData_TRPV4_40DC_mouse07.m
    Input:  splitData_20250719_withBaselineZscore.mat
    Output: outputData.mat (variable: outputData)
    Selects trials and averages responses within each mouse for mtTRPV4
    and Control. Outputs include pre/post values, changes, maxima, angular
    displacement, calcium/angular AUC measures, and mean curves.

    Current settings: fs = 30, targetDC = 40, pressureCond = '120mVpp',
    threshold = 3.5 for preCalciumNew. Analysis windows correspond to
    10-20 and 30-40 seconds in the trial arrays. A mouse-specific exception
    for TX144, TX145, and TX146 bypasses the preCalciumNew threshold
    criterion. Review these settings before analyzing new data.

Step12 is for baseline inspection. Step13 reads Step11's output directly
and uses the threshold configured in its script.

6. Workflow Summary

Raw recordings -> behaviorData.mat and calciumData.mat
calciumData.mat -> Step10a -> splitCalciumData_20250719.mat
Prepared behavioral trials + split calcium data -> Step10b -> merged trials
Merged trials -> Step11 -> baseline-normalized trials
Baseline-normalized trials -> Step12 -> distribution plots and cleanup copy
Baseline-normalized trials -> Step13 -> outputData.mat

The two code folders contain different getPlotColor.m implementations.
Keep the folder relevant to the current analysis first on the MATLAB path
to avoid using the other version unintentionally.

7. Contact

Tianqi Xu
Washington University in St. Louis
