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
                obj.weights = (1/numInputs) * rand(numOutputs, numInputs + 1);
            end
        end
        
        function wsDelta = updateWeights(obj, alpha, wsDelta, outVals, inputs)
            derivOfActFunc = obj.activationFunc.derivOfActFunct(outVals);
            delta = wsDelta .* derivOfActFunc;
            deltaWeights = bsxfun(@times, delta, obj.weights(:,1:end-1));
            wsDelta = sum(deltaWeights,1)';
            obj.weights = obj.weights + alpha * (delta * inputs');
        end
        
        function aproxWeightInc(obj, row, col, eps)
            obj.weights(row, col) = obj.weights(row, col) + eps;
        end
        
        function aproxWeightsDec(obj, row, col, eps)
            obj.weights(row, col) = obj.weights(row, col) - eps;
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

