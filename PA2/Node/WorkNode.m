classdef WorkNode < Node
    %WORKNODE ? WorkNodes are non Input Nodes. They have a weight matrix,
    % a delta, and retrieve inputs.
    
    properties
        inputs % An {n x 1} cell of Nodes. The first Node is the first input.%
        weights    % An m x n matrix of weights. m = numOuts, n = numIns %
        activationFunc % Polymorphic. Allows for dif actFuncts %
        delta % A col vec of the deltas for each output node
    end
    
    methods (Abstract, Access = protected)
        calcDelta(obj)
    end
    
    methods
        function updateWeights(obj, alpha)
            obj.calcDelta();
            % alpha * delta * inputs
            weightChanges = alpha * obj.delta * obj.getInputs()';
            % weights = weights + (alpha * delta * inputs)
            obj.weights = obj.weights + weightChanges;
        end
        
        function calcOutput(obj)
            inputVals = obj.getInputs();
            a = obj.calcA(inputVals);
            y = obj.calcY(a);
            for i = 1:size(obj.outputNodes,1)
                obj.outputNodes{i,1} = y(i,1);
            end
        end
       
        function deltaSum = getDelta(obj)
            deltaSum = 0;
            for i = obj.delta(:,1)
                deltaSum = deltaSum + i;
            end
        end
        
        function sumOfWeights = getSumOfWeights(obj, idx)
            sumOfWeights = 0;
            for i = 1:size(obj.weights,1)
                sumOfWeights = sumOfWeights + obj.weights(i,idx);
            end
        end         
    end
    
    methods (Access = private)
        function inputVals = getInputs(obj)
            inputVals = zeros(size(obj.inputs,1),1);
            for i = 1:size(obj.inputs,1)
                childNode = obj.inputs{i,1};
                parentIdx = i;
                for j = 1:size(childNode.outputNodes,1)
                    if childNode.outputNodes{j,2} == parentIdx
                        inputVals(i,1) = childNode.outputNodes{j,1};
                    end
                end
            end 
            
            inputVals = [inputVals;1];
        end
        
        function a = calcA(obj, inputs)
            a = obj.weights * inputs;
        end
        
        function y = calcY(obj, a)
            y = zeros(size(a,1),1);
            for i = 1:size(a,1)
                y(i,1) = obj.activationFunc.activationFunction(a(i,1), a');
            end
        end
    end
end

