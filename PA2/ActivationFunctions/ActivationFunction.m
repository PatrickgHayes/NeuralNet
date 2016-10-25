classdef ActivationFunction < handle
    %ACTIVATIONFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    properties
        Name
    end
    
    methods (Abstract)
        result = activationFunction(a)
        yOut = derivOfActFunct(yIn)
    end
    
    methods
        function name = get.Name(obj)
            name = obj.Name;
        end
    end       
end


