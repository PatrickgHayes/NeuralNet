classdef HiddenNode < handle
    %HIDDENNODE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        weights
        activationFunc
    end
    
    methods
        function obj = HiddenNode(actFunct, numInputs, numOutputs)
            if nargin > 0
                obj.activationFunc = ActFuncEnum.getFunct(actFunct);
                obj.weights = rand(numOutputs, numInputs + 1);
            end
        end
        
        function wsDelta =updateWeights(obj, alpha, wsDelta, outVals, inputs)
            derivOfActFunc = obj.activationFunc.derivOfActFunct(outVals);
            delta = wsDelta .* derivOfActFunc;
            deltaS = sum(delta, 1);
            sumOfWeights = sum(obj.weights(:,1:end-1),1);
            wsDelta = deltaS * sumOfWeights';
            obj.weights = obj.weights + alpha * (delta * inputs');
        end
        
        function outVals = calcOutput(obj, inVals)
            outVals = obj.calcY(obj.calcA(inVals));
        end
    end
    
    methods (Access = protected) 
        
        function a = calcA(obj, inputs)
            a = obj.weights * inputs;
        end
        
        function y = calcY(obj, a)
            y = obj.activationFunc.activationFunction(a);
        end 
    end
end

