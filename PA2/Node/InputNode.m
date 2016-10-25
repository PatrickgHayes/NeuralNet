classdef InputNode < Node
    %INPUTNODE ? Each node stores an input to the neural network.
    
    properties
        %inherits all its properties from Node Abstract class
    end
    
    methods
        function obj = InputNode(numOfOutputNodes)
            if nargin >0
                obj.outputNodes = cell(numOfOutputNodes, 3);
            end
        end
        
        function setOutputs(obj, inputVal)
            obj.outputNodes(:,1) = {inputVal};
        end
    end
end

