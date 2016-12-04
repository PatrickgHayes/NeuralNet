classdef OutputNode < handle
    %OUTPUTNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        weights % An m x n matrix of weights. m = numOuts,
                % n = numIns + 1
        weight_deltas % [m x n] matirx for storing the weight updates
                      % over one BPTT
        activationFunc %Polymorphic. Allows for dif actFuncts
    end
    
    methods
        % Constructor
        function obj = OutputNode(actFunct, numInputs, numOutputs)
            obj.activationFunc = ActFuncEnum.getFunct(actFunct);
            obj.weights = (1/numInputs) * rand(numOutputs, numInputs + 1);
            obj.weight_deltas = zeros(numOutputs, numInputs + 1);
        end
        
        % Forward Pass
        function outVals = calcOutput(obj, inVals)
            outVals = obj.calcY(obj.calcA(inVals));
        end
        
        function wsDelta = calcWeightUpdate(obj, alpha, tarVals, outVals, ...
                                        inputs)
            delta = (tarVals - outVals);
            obj.weight_deltas = obj.weight_deltas + alpha * delta * inputs';
            deltaWeights = bsxfun(@times, delta, obj.weights(:,1:end-1));
            wsDelta = sum(deltaWeights,1)';
        end
          
        function updateWeights(obj)              
            obj.weights = obj.weights + obj.weight_deltas;
            obj.weight_deltas = zeros(numOutputs, numInputs + 1);
        end
        
        
        
%         Test using numerical approximation
%         ---------------------------------------------------------------
%         function wsDelta = updateWeightsTest(obj, gTester, alpha, ...
%                                              tarVals, outVals, inputs)
%             delta = (tarVals - outVals);
%             deltaWeights = bsxfun(@times, delta, obj.weights(:,1:end-1));
%             wsDelta = sum(deltaWeights,1)';
%             obj.weights = obj.weights + alpha * delta * inputs';
%             
%             dev = delta * inputs';
%             for i = 1:size(dev,1)
%                 for j = 1:size(dev,2)
%                     gTester.addDev(dev(i,j));
%                 end
%             end
%         end
%         
%         
%         
%         function aproxWeightInc(obj, row, col, eps)
%             obj.weights(row, col) = obj.weights(row, col) + eps;
%         end
%         
%         function aproxWeightDec(obj, row, col, eps)
%             obj.weights(row, col) = obj.weights(row, col) - eps;
%         end
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

