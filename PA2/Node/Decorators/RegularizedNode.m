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
        
        function updateWeights(obj, work_node, alpha)
            regularization = (alpha * obj.lamda * work_node.weights);
            work_node.updateWeights(alpha);
            work_node.weights = work_node.weights - regularization;
        end
    end
end