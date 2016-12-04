classdef Sigmoid < ActivationFunction
    %Sigmoid Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Sigmoid()
            obj.Name = ActFuncEnum.Sigmoid;
            obj.temp = 1;
        end
            
        function result = activationFunction(~, a)
            result = 1 ./ (1 + exp(-a));
        end
        
        function yOut = derivOfActFunct(~, yIn)
            yOut = yIn .* (1 - yIn);
        end
    end
    
end

