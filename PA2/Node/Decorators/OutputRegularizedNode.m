classdef OutputRegularizedNode < OutputNodeDecorator & RegularizedNode
    %OUTPUTREGULARIZEDNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = OutputRegularizedNode(workNode, lamda)
            obj = obj@RegularizedNode(lamda);
            obj.work_node = workNode;
        end
        
        %overide
        function updateWeights(obj, alpha)
            updateWeights@Regularized(obj, obj.work_node, alpha);
        end
    end 
end

