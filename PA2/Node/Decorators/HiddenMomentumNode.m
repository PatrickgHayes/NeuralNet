classdef HiddenMomentumNode < HiddenNodeDecorator & MomentumNode
    %HIDDENMOMENTUMNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = HiddenMomentumNode(hidNode, beta)
            obj = obj@MomentumNode(hidNode, beta);
            obj.hid_node = hidNode;
        end
        
        %override
        function wsDelta = updateWeights(obj, alpha, tar, out, in)
            wsDelta = updateWeights@MomentumNode(obj, obj.hid_node, alpha, tar, out, in);
        end
    end
end

