function PlotColor = getPlotColor(MouseType)
    % Function to return specific plot color based on MouseType
    % Input: 
    %   MouseType - A string representing the type of mouse
    % Output:
    %   PlotColor - A string representing the hex color code for the plot


  switch MouseType
        case 'TRPV1'
            PlotColor = '#D5695D'; %  Red
        case 'mtTRPV4'
            PlotColor = '#EF4156'; % Green
        case 'Control'
            PlotColor = '#808080'; % Grey
        otherwise
            error('Unknown MouseType: %s. Please use TRPV1, mtTRPV4, or Control.', MouseType);
   end

end
