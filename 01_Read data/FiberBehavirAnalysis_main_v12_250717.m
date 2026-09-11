% % Behavior test & Fiber Photometry data processing
% % Tianqi Xu 
% % 02/05/2025
% % The purpose of this version is to be able to process the Behavior test and Fiber Photometry data

%%
clear
close all
clc

clear; close all; clc;

% Experiment date as a string (e.g., '20250113')
% Mouse ID as a string (e.g., 'TX135')
% Stimulation level string (e.g., '104mVpp-1' or '120mVpp-1')
% Mouse type string (e.g., 'mtTRPV4', or 'Control')

runFiberBehavior_02_250717('20250113', 'TX135', '120mVpp-2', 'mtTRPV4')
clear; close all; clc;
