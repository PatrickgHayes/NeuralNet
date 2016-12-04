classdef ReLU < ActivationFunction
    %RELU Summary of this class goes here
    %   Detailed explanation goes here
    properties
    end
    
    methods
        function obj = ReLU()
            obj.Name = ActFuncEnum.ReLU;
            obj.temp = 1;
        end
            
        function result = activationFunction(~, a)
            result = (a > 0) .* a;
        end
        
        function yOut = derivOfActFunct(~, yIn)
            yOut = yIn > 0;
        end
    end
end

