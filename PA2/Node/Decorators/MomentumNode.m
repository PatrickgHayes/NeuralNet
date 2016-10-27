classdef MomentumNode < handle
    %MOMENTUMNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        prev_weights
        first_update
        beta
    end
    
    methods
        function obj = MomentumNode(workNode, beta)
            obj.prev_weights = workNode.weights;
            obj.first_update = true;
            obj.beta = beta;
        end
        
        function wsDelta = updateWeights(obj, work_node, alpha, tar, out, in)
            storeOldWeights = work_node.weights;
            wsDelta = work_node.updateWeights(alpha, tar, out, in);
            
            if obj.first_update == false
                weightDiffs = work_node.weights - obj.prev_weights;
                work_node.weights = work_node.weights ...
                                        - obj.beta * weightDiffs;
            end
            
            obj.prev_weights = storeOldWeights;
            obj.first_update = false;
        end
    end  
end

