classdef OutputRegularizedNode < OutputNodeDecorator & RegularizedNode
    %OUTPUTREGULARIZEDNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = OutputRegularizedNode(outNode, lamda)
            obj = obj@RegularizedNode(lamda);
            obj.out_node = outNode;
        end
        
        %overide
        function wsDelta = updateWeights(obj, alpha, tar, out, in)
           wsDelta = updateWeights@RegularizedNode(obj, obj.out_node, alpha, tar, out, in);
        end
    end 
end

