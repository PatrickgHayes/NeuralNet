classdef ReLU < ActivationFunction
    %RELU Summary of this class goes here
    %   Detailed explanation goes here
    properties
    end
    
    methods
        function obj = ReLU()
            obj.Name = ActFuncEnum.ReLU;
        end
            
        function result = activationFunction(~, a, ~)
            if a > 0
                result = a;
            else 
                result = 0;
            end
        end
        
        function yOut = derivOfActFunct(~, yIn)
            if yIn <= 0
                yOut = 0;
            else
                yOut = 1;
            end
        end
    end
end

