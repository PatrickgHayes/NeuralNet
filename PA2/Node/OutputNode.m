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
          
        function wsDelta = updateWeights(obj, inputs, tarVals, ...
                                        outVals, alpha)
                           
            delta = (tarVals - outVals);
            deltaWeights = bsxfun(@times, delta, obj.weights(:,1:end-1));
            wsDelta = sum(deltaWeights,1)';
            obj.weights = obj.weights + alpha * delta * inputs';
            
        end
        
        function outVals = calcOutput(obj, inVals)
            outVals = obj.calcY(obj.calcA(inVals));
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

