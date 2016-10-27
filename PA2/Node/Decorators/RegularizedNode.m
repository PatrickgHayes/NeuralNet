classdef RegularizedNode < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    properties
        lamda
    end
    
    methods
        function obj = RegularizedNode(lamda)
            obj.lamda = lamda;
        end
        
        function wsDelta = updateWeights(obj, work_node, alpha, tar, out, in)
            regularization = (alpha * obj.lamda * work_node.weights);
            wsDelta = work_node.updateWeights(alpha, tar, out,in);
            work_node.weights = work_node.weights - regularization;
        end
    end
end