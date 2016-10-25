classdef OutputNodeDecorator < WorkNodeDecorator
    %OUTPUTNODEDECORATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %inherits work_node from WorkNodeDecorator
    end
    
    methods
        function setTarget(obj, newTarget)
            obj.work_node.setTarget(newTarget);
        end
    end
    
end

