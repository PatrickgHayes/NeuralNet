classdef OutputNodeDecorator < handle
    %OUTPUTNODEDECORATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        out_node
    end
    
    methods
        function wsDelta = updateWeights(obj, alpha, tarVals, outVals, inputs)
            wsDelta = obj.out_node.updateWeights(inputs, tarVals, outVals, alpha);
        end
        
        function wsDelta = updateWeightsTest(obj, gTester, alpha, tarVals, outVals, inputs)
           wsDelta = obj.out_node.updateWeightsTest(gTester, alpha, tarVals, outVals, inputs);
        end
        
        function aproxWeightInc(obj, row, col, eps)
            obj.out_node.aproxWeightInc(row, col, eps);
        end
        
        function aproxWeightDec(obj, row, col, eps)
            obj.out_node.aproxWeightDec(row, col, eps);
        end
        
        function outVals = calcOutput(obj, inVals)
            outVals = obj.out_node.calcOutput(inVals);
        end
    end
end

