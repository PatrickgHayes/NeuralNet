classdef HiddenNode < WorkNode
    %HIDDENNODE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        %inherits all its properties from WorkNode Abstract class
    end
    
    methods
        function obj = HiddenNode(actFunct, inputNodes, ...
                                  numOfOutputs)
            if nargin > 0
                obj.inputs = inputNodes;
                obj.outputNodes = cell(numOfOutputs, 3);
                obj.activationFunc = ActFuncEnum.getFunct(actFunct);
                obj.weights = zeros(numOfOutputs,size(inputNodes,1) + 1);
                obj.delta  = zeros(numOfOutputs, 1);
            end
        end
    end
    
    methods (Access = protected)
        function calcDelta(obj) 
            y = obj.getOutputs()
            weightedDeltas = obj.getWeightedDeltas();
            
            for i = 1:size(obj.delta,1)
                derivOfActFunc = obj.activationFunc.derivOfActFunct(y(i,1));
                obj.delta(i,1) = derivOfActFunc * weightedDeltas(i,1);
            end 
        end
        
        function weightedDeltas = getWeightedDeltas(obj)
            weightedDeltas = zeros(size(obj.outputNodes,1),1);
            for i = 1:size(weightedDeltas,1)
                outputNode = obj.outputNodes{i,3};
                idx = obj.outputNodes{i,2};
                weight = outputNode.getSumOfWeights(idx);
                delta = outputNode.getDelta();
                weightedDeltas(i,1) = weight * delta;
            end
        end
    end
end

