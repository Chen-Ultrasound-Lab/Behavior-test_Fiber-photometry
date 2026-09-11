function [] = S0_USTriggerTest_01(...
    dataPath, stimulationLevel, trig_thre, mouseID, experimentDate, ...
    resultPath, framerate, US_time, US_offset)
% clear 
% close all
% clc

% trig_thre = 20000; %previously it was 3000, change to 6000 %70000
% dataPath = 'C:\Users\徐田奇\Box\ChenUltrasoundLab\38_Tianqi Xu\01_Tianqi_Projects_02_TRPV4\2024-12\20241209\TX133';
% stimulationLevel = '106mVpp-1';
% 
% % framerate = 30;         % [s], Frame rate of the camera.
% % US_time = 15;           % [s], US duration.
% % US_offset = 85;         % [s], Offset time after the end of US treatment.


        file_path = fullfile(dataPath, [stimulationLevel, '_trigger.csv']);
        data = xlsread(file_path, 'A:A');

        % Plot Raw Trigger Data
        figure;
        plot(data, 'k');
        xlabel('Index');
        ylabel('Data from Trigger Data');
        title('Plot of Raw Trigger from Excel');

        % Plot Trigger Data
        trig = detrend(xlsread(file_path, 'A:A'))*0.002;
        figure;
        plot(trig, 'b');
        xlabel('Index');
        ylabel('Data from Trigger Data');
        title('Plot of Trigger from Excel');
        
%         % Automatically determine the rising edge of US
%         % Adjust the US time to remove any possible "end effects." 调整US时间，以消除任何可能的 "终端效应"。
%         usend = length(trig)-100;

        % Convert the trigger signal to binary (index).
        trig_ind = zeros(size(trig)); % Pre-allocate trigger vector with zeros.
        trig_ind(data > trig_thre) = 2; % Convert trigger signal to binary. 

        figure;
        plot(trig_ind, 'b');
        xlabel('Index');
        ylabel('Data from Trigger Data');
        title('Plot of Trigger from Excel');



        trigger_data = trig_ind; % Replace this with your loaded data
        time_axis = 1:length(trigger_data);
        
        % Plot the trigger data
        figure;
        plot(time_axis, trigger_data, 'g', 'LineWidth', 1);
        title('Interactive Trigger Selection');
        xlabel('Index');
        ylabel('Trigger Signal');
        hold on;
        
        % User instructions
        disp('Click on the first rising edge of the trigger signal.');
        
        % Initialize variables
        selected_triggers = [];
        rising_edges = [];
        
        % Interactive point selection for rising edges
        while true
            % User clicks on a point
            [x, ~] = ginput(1);
            x = round(x); % Convert to nearest integer
        
            % Find the closest rising edge near the clicked point
            search_window = 100; % Adjust this based on data density
            window_start = max(1, x - search_window);
            window_end = min(length(trigger_data), x + search_window);
            [~, idx] = max(diff(trigger_data(window_start:window_end)));
            exact_rising_edge = window_start + idx - 1;
        
            % Store the rising edge
            rising_edges = [rising_edges, exact_rising_edge];
        
            % Plot the selected point
            plot(exact_rising_edge, trigger_data(exact_rising_edge), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
        
            % Check if this is the last rising edge (interval check)
            if length(rising_edges) > 1
                interval = (rising_edges(end) - rising_edges(end - 1)) / 30; % Assuming 30 fps
                if abs(interval - 100) > 15 % Adjust the tolerance as needed
                    disp('The interval between rising edges is not 100 seconds. Retrying...');
                    rising_edges(end) = []; % Remove the invalid rising edge
                    continue;
                end
            end
        
            % Check for 5 valid triggers
            if length(rising_edges) == 5
                disp('Five valid triggers selected.');
                break;
            else
                disp('Click on the next rising edge.');
            end
        end
        
        % Validate and display results
        disp('Selected rising edges:');
        disp(rising_edges);
        
        % Check if the duration between rising and falling edges is valid
        falling_edges = zeros(1, 5);
        % 1 Check if there is a falling edge within US_time (±1s) of each rising edge
        for i = 1:length(rising_edges)
            % Search for the falling edge after each rising edge
            window_start = rising_edges(i) + (US_time - 1) * framerate;
            window_end = min(length(trigger_data), window_start + (US_time + 1) * framerate); % Assuming 30 fps and 15s duration
            [~, idx] = min(diff(trigger_data(window_start:window_end)));
            exact_falling_edge = window_start + idx;
        
            % Validate falling edge
            duration = (exact_falling_edge - rising_edges(i)) / framerate; % Convert to seconds
            if duration < (US_time - 1) || duration > (US_time + 1)
                disp(['Falling edge duration invalid at trigger ', num2str(i), '. Duration: ', num2str(duration), ' seconds.']);
                error('Invalid trigger duration detected.');
            end
        
            % Store the falling edge
            falling_edges(i) = exact_falling_edge;
        end
        
        % 2. Check if the interval between each pair of rising edges is within the specified range
        valid_intervals = true; % Initialize the validation flag
        expected_interval = (US_time + US_offset) * framerate; % Calculate the expected frame interval
        tolerance = 1 * framerate; % Set tolerance (1 second in frames)
        for i = 1:length(rising_edges) - 1
            % Calculate the interval between adjacent rising edges
            actual_interval = rising_edges(i + 1) - rising_edges(i);
        
            % Check if the interval is within the expected range
            if abs(actual_interval - expected_interval) > tolerance
                fprintf('Error: Invalid interval between rising edge %d and %d. Interval: %d frames.\n', i, i + 1, actual_interval);
                valid_intervals = false; % Set to invalid
            end
        end
        if valid_intervals
            fprintf('All intervals between rising edges are valid.\n');
        else
            fprintf('Some intervals between rising edges are invalid.\n');
        end
        
        % Display validated rising and falling edges
        disp('Validated rising edges:');
        disp(rising_edges);
        disp('Validated falling edges:');
        disp(falling_edges);
        
        % Mark falling edges on the plot
        for i = 1:length(falling_edges)
            plot(falling_edges(i), trigger_data(falling_edges(i)), 'go', 'MarkerSize', 8, 'LineWidth', 2);
        end
        
        hold off;   

        % Save
        fileName = sprintf('triggers_%s_%s_%s.mat', mouseID, experimentDate, stimulationLevel);
        fileFullPath = fullfile(resultPath, fileName);
        if ~exist(resultPath, 'dir')
            mkdir(resultPath);
            fprintf('Created result folder: %s\n', resultPath);
        end
        usonset = rising_edges;
        save(fileFullPath, 'rising_edges');
        fprintf('Rising edges saved to: %s\n', fileFullPath);
end