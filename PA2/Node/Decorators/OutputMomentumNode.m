classdef OutputMomentumNode < MomentumNode & OutputNodeDecorator 
    %OUTPUTMOMENTUMNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = OutputMomentumNode(workNode, beta)
            obj = obj@MomentumNode(workNode, beta);
            obj.work_node = workNode;
        end
        
        %override
        function updateWeights(obj, alpha)
            updateWeights@MomentumNode(obj, obj.work_node, alpha);
        end
    end
    
end
