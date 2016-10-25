classdef Tanh < ActivationFunction
    %TANH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Tanh()
            obj.Name = ActFuncEnum.Tanh;
        end
            
        function result = activationFunction(~, a, ~)
            result = (exp(a) - exp(-a)) ...
                     / (exp(a) + exp(-a));
        end
        
        function yOut = derivOfActFunct(~, yIn)
            yOut = 1 - (yIn * yIn);
        end
    end
    
end

