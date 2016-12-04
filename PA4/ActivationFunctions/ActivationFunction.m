classdef ActivationFunction < handle
    %ACTIVATIONFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    properties
        Name
        temp
    end
    
    methods (Abstract)
        result = activationFunction(a)
        yOut = derivOfActFunct(yIn)
        
    end
    
    methods
        function name = get.Name(obj)
            name = obj.Name;
        end
        
        function setTemperature(obj, temp)
            obj.temp = temp;
        end
    end       
end


