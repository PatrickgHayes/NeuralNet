classdef Node < handle
    %NODE ? Abstract class which defines the some properties and functions
    %that all nodes classes should have.
    
    properties
        outputNodes % An m x 3 cell {output, idx, Node}. % 
                    % idx = the input we are for our parent %
                    % Except for output nodes where it is a single value %   
    end
    
    methods
        function outputVals = getOutputs(obj)
            outputVals = obj.outputNodes(:,1);
        end
        
        function setOutputNode(obj, setIdx, inputIdx, node)
            obj.outputNodes{setIdx,2} = inputIdx;
            obj.outputNodes{setIdx,3} = node;
        end
    end
end

