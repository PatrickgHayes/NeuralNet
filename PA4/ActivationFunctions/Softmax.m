classdef Softmax < ActivationFunction
    %SOFTMAX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Softmax()
            obj.Name = ActFuncEnum.Softmax;
            obj.temp = 1;
        end
        
        function result = activationFunction(obj,a)
            aTemp = a ./ obj.temp;
            sumOfAllExpAs = sum(exp(aTemp));
            result = exp(aTemp) ./ sumOfAllExpAs;
        end
        
        function yOut = derivOfActFunct(~, yIn)
            yOut = yIn .* (1 - yIn);
        end
    end
end

