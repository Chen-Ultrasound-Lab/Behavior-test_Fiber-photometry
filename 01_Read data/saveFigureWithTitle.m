function saveFigureWithTitle(fullPath, figTitle, fileName)
    % Set the title of the figure
    title(figTitle, 'FontName', 'Arial', 'Fontsize', 12); % Assuming figure_FontSize is 12
    

    saveas(gcf, fullfile(fullPath, [fileName, '.fig']));
    saveas(gcf, fullfile(fullPath, [fileName, '.png']));
end