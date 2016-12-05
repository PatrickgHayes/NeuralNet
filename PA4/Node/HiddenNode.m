classdef HiddenNode < handle
    %HIDDENNODE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        weights
        weight_deltas
        rec_weights
        rec_deltas
        activationFunc
    end
    
    methods
        % Constructor
        function obj = HiddenNode(actFunct, numInputs, numOutputs)
            obj.activationFunc = ActFuncEnum.getFunct(actFunct);
            obj.weights = (1/numInputs) * rand(numOutputs, numInputs + 1);
            obj.weight_deltas = zeros(numOutputs, numInputs + 1);
            obj.rec_weights = (1/numOutputs) * rand(numOutputs, numOutputs + 1);
            obj.rec_deltas = zeros(numOutputs, numOutputs + 1);
        end
        
        %forward pass
        function outVals = calcOutput(obj, inVals, prevVals)
            outVals = obj.calcY(obj.calcA(inVals) + obj.calcArec(prevVals));
        end
        
        function wsDelta = calcWeightUpdate(obj, alpha, wsDeltaUp, outVals, inVals, prevVals)
            derivOfActFunc = obj.activationFunc.derivOfActFunct(outVals);
            delta = wsDeltaUp .* derivOfActFunc;
            obj.rec_deltas = obj.rec_deltas + alpha * (delta * prevVals');
            obj.weight_deltas = obj.weight_deltas + alpha * (delta * inVals');
            deltaWeights = bsxfun(@times, delta, obj.rec_weights(:,1:end-1));
            wsDelta = sum(deltaWeights,1)';
        end
        
        function updateWeights(obj)
            obj.weights = obj.weights + obj.weight_deltas;
            obj.weight_deltas = zeros(size(obj.weights));
            obj.rec_weights = obj.rec_weights + obj.rec_deltas;
            obj.rec_deltas = zeros(size(obj.rec_weights));
        end 
    end
    
    methods (Access = protected) 
        
        function a = calcA(obj, inputs)
            a = obj.weights * inputs;
        end
        
        function a = calcArec(obj, inputs)
            a = obj.rec_weights * inputs;
        end
        
        function y = calcY(obj, a)
            y = obj.activationFunc.activationFunction(a);
        end 
    end
end

