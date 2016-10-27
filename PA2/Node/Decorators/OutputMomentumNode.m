classdef OutputMomentumNode < MomentumNode & OutputNodeDecorator 
    %OUTPUTMOMENTUMNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = OutputMomentumNode(outNode, beta)
            obj = obj@MomentumNode(outNode, beta);
            obj.out_node = outNode;
        end
        
        %override
        function wsDelta = updateWeights(obj, alpha, tar, out, in)
            wsDelta = updateWeights@MomentumNode(obj, obj.out_node, alpha, tar, out, in);
        end
    end
    
end

