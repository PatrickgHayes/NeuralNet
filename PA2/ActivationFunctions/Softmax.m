classdef Softmax < ActivationFunction
    %SOFTMAX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Softmax()
            obj.Name = ActFuncEnum.Softmax;
        end
        
        function result = activationFunction(~,a)
            sumOfAllExpAs = exp(sum(a));
            result = exp(a) ./ sumOfAllExpAs;
        end
        
        function yOut = derivOfActFunct(~, yIn)
            yOut = yIn .* (1 - yIn);
        end
    end
end

