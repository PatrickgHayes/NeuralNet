classdef HiddenRegularizedNode < HiddenNodeDecorator & RegularizedNode
    %HIDDENREGULARIZEDNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = HiddenRegularizedNode(hidNode, lamda)
            obj = obj@RegularizedNode(lamda);
            obj.hid_node = hidNode;
        end
        
        %overide
        function wsDelta = updateWeights(obj, alpha, tar, out, in)
            wsDelta = updateWeights@RegularizedNode(obj, obj.hid_node, alpha, tar,out, in);
        end
    end
    
end

