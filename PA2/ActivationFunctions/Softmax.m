classdef Softmax < ActivationFunction
    %SOFTMAX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Softmax()
            obj.Name = ActFuncEnum.Softmax;
        end
        
        function result = activationFunction(~,a, allAs)
            sumOfAllExpAs = 0;
            for i = allAs
                sumOfAllExpAs = sumOfAllExpAs + exp(i);
            end
            result = exp(a) / sumOfAllExpAs;
        end
        
        function yOut = derivOfActFunct(~, yIn)
            yOut = yIn * (1 - yIn);
        end
    end
end

