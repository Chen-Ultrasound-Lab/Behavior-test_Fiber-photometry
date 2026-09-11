function PlotColor = getPlotColor(MouseType)
    % Function to return specific plot color based on MouseType
    % Input: 
    %   MouseType - A string representing the type of mouse
    % Output:
    %   PlotColor - A string representing the hex color code for the plot

   switch MouseType
        case 'mtTRPV4'
            PlotColor = '#52BE80'; 
        case 'Control'
            PlotColor = '#808080'; % Grey
        otherwise
            error('Unknown MouseType: %s. Please use mtTRPV4 or Control.', MouseType);
   end


end
