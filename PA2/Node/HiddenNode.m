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
        
        function wsDelta = updateWeights(obj, alpha, wsDeltaUp, outVals, inputs)
            derivOfActFunc = obj.activationFunc.derivOfActFunct(outVals);
            delta = wsDeltaUp .* derivOfActFunc;
            deltaWeights = bsxfun(@times, delta, obj.weights(:,1:end-1));
            wsDelta = sum(deltaWeights,1)';
            obj.weights = obj.weights + alpha * (delta * inputs');
        end
        
        function wsDelta = updateWeightsTest(obj, gTester, alpha, ...
                                             wsDeltaUp, outVals, inputs)
            derivOfActFunc = obj.activationFunc.derivOfActFunct(outVals);
            delta = wsDeltaUp .* derivOfActFunc;
            deltaWeights = bsxfun(@times, delta, obj.weights(:,1:end-1));
            wsDelta = sum(deltaWeights,1)';
            obj.weights = obj.weights + alpha * delta * inputs';
            
            dev = delta * inputs';
            for i = 1:size(dev,1)
                for j = 1:size(dev,2)
                    gTester.addDev(dev(i,j));
                end
            end
        end
        
        function aproxWeightInc(obj, row, col, eps)
            obj.weights(row, col) = obj.weights(row, col) + eps;
        end
        
        function aproxWeightDec(obj, row, col, eps)
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

