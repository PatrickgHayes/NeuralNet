classdef WorkNodeDecorator < handle
    %WORKNODEDECORATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        work_node %Each WorkNodeDecorator is a wrapper around a worknode
    end
    
    methods
        function updateWeights(obj, alpha)
            obj.work_node.updateWeights(alpha);
        end
        
        function calcOutput(obj)
            obj.work_node.calcOutput();
        end
        
        function deltaSum = getDelta(obj)
            deltaSum = obj.work_node.getDelta();
        end
        
        function sumOfWeights = getSumOfWeights(obj,idx)
            sumOfWeights = obj.work_node(idx);
        end
        
        function setOutputNode(obj, setIdx, inputIdx, node)
            obj.work_node.setOutputNode(setIdx, inputIdx, node);
        end
        
        function outputVals = getOutputs(obj)
            outputVals = obj.work_node.outputNodes(:,1);
        end
    end
end

