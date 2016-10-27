classdef HiddenNodeDecorator < handle
    %HIDDENNODEDECORATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hid_node
    end
    
    methods
        function wsDelta = updateWeights(obj, alpha, wsDeltaUp, outVals, inputs)
            wsDelta = obj.hid_node.updateWeights(alpha, wsDeltaUp, outVals, inputs);
        end
        
        function wsDelta = updateWeightsTest(obj, gTester, alpha, wsDeltaUp, outVals, inputs)
           wsDelta = obj.hid_node.updateWeightsTest(gTester, alpha, wsDeltaUp, outVals, inputs);
        end
        
        function aproxWeightInc(obj, row, col, eps)
            obj.hid_node.aproxWeightInc(row, col, eps);
        end
        
        function aproxWeightDec(obj, row, col, eps)
            obj.hid_node.aproxWeightDec(row, col, eps);
        end
        
        function outVals = calcOutput(obj, inVals)
            outVals = obj.hid_node.calcOutput(inVals);
        end
    end
end

