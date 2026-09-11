classdef BehaviorCalciumClass_1
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Name
        Time
        USTrig
        AngularDisplacement
        AngularSpeed
        LinearSpeed
        DistanceTraveled
        AngularOrientation
        calcium
        
    end

    methods
        % 类的构造函数
        function obj = BehaviorCalciumClass_1(name, data1, data2, data3, data4, data5, data6, data7, data8)
            obj.Name = name;
            obj.Time = data1;
            obj.USTrig = data2;
            obj.AngularDisplacement = data3;
            obj.AngularSpeed = data4;
            obj.LinearSpeed = data5;
            obj.DistanceTraveled = data6;
            obj.AngularOrientation = data7;
            obj.calcium = data8;
        end
    end
end


% myName = append(mice_ID, '_',  intensity);
% myTime = newTime(myTimePoint);
% myAngularPosition = angular_position(myTimePoint);
% myUSTrig = [firstUSPoint, secondUSPoint, thirdUSPoint, forthUSPoint, fifthUSPoint];