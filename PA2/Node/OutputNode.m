classdef OutputNode < WorkNode
    %OUTPUTNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %inherits a lot of properties from WorkNode Abstract class
        target % a 1x1 matrix
    end
    
    methods
        function obj = OutputNode(actFunct, inputNodes)
            if nargin >0
                obj.inputs = inputNodes;
                obj.outputNodes = {0};
                obj.activationFunc = ActFuncEnum.getFunct(actFunct);
                obj.weights = zeros(1, size(inputNodes,1) + 1);
                obj.delta = 0;
                obj.target = 0;
            end
        end
        
        function setTarget(obj, newTarget)
            obj.target = newTarget;
        end         
    end
    
    methods (Access = protected)
        function calcDelta(obj)
            y = obj.getOutputs();
            obj.delta = obj.target - y;
        end
    end
end

