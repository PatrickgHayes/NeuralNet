classdef OutputNode < handle
    %OUTPUTNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        weights % An m x n matrix of weights. m = numOuts,
                % n = numIns + 1
        activationFunc %Polymorphic. Allows for dif actFuncts
    end
    
    methods
        function obj = OutputNode(actFunct, numInputs, numOutputs)
            if nargin >0
                obj.activationFunc = ActFuncEnum.getFunct(actFunct);
                obj.weights = (1/numInputs) * rand(numOutputs, numInputs + 1);
            end
        end
          
        function wsDelta = updateWeights(obj, alpha, tarVals, outVals, ...
                                        inputs)
                           
            delta = (tarVals - outVals);
            deltaWeights = bsxfun(@times, delta, obj.weights(:,1:end-1));
            wsDelta = sum(deltaWeights,1)';
            obj.weights = obj.weights + alpha * delta * inputs';
            
        end
        
        function wsDelta = updateWeightsTest(obj, gTester, alpha, ...
                                             tarVals, outVals, inputs)
            delta = (tarVals - outVals);
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
        
        function outVals = calcOutput(obj, inVals)
            outVals = obj.calcY(obj.calcA(inVals));
        end
        
        function aproxWeightInc(obj, row, col, eps)
            obj.weights(row, col) = obj.weights(row, col) + eps;
        end
        
        function aproxWeightDec(obj, row, col, eps)
            obj.weights(row, col) = obj.weights(row, col) - eps;
        end
    end
    
    methods (Access = private)
        function a = calcA(obj, inputs)
            a = obj.weights * inputs;
        end
        
        function y = calcY(obj, a)
            y = obj.activationFunc.activationFunction(a);
        end 
    end
end

