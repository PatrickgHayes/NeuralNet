classdef NeuralNet < handle
    properties 
        %------------------ Values ----------------------------------%
        charVectors % [256 x k + 1] array of input vectors/target values
        hidVals % [numHidUnits x k] array of output values from hidNode
        outVals % a [256 x k] array of outputVals
        %------------------ Values ----------------------------------%
        
        %------------------ Nodes -----------------------------------%
        hidNode % a node that calutlates the hidVals of the Neural Net
        outNode % a node that calutlates the output of the Neural Net
        %------------------ Nodes -----------------------------------%

        %------------------ Deltas -----------------------------------%
        wsDelta % [numHidUnits x 1 ] array of output
                           % deltas and sum of weights for each hiddenNode
                           % on the layer below
        %------------------ Deltas -----------------------------------%
        
        %------------------ Other -----------------------------------%
        alpha % Learning rate
        k     % Number of time steps we propigate backwards
        epochs %Number of times we should train on the training set
        %------------------ Other -----------------------------------%

        
    end
    methods
        function obj = NeuralNet(numOfInputs, numOfOutputs, ...
                                 numOfHiddenUnits, actFunct, alpha, k, epochs)
             obj.charVectors = zeros(numOfInputs, k+1);
             obj.hidVals = zeros(numOfHiddenUnits, k);
             obj.outVals = zeros(numOfOutputs, k);
             
             obj.hidNode = HiddenNode(actFunct, numOfInputs, numOfHiddenUnits);
             obj.outNode = OutputNode(ActFuncEnum.Softmax, numOfHiddenUnits, numOfOutputs);
             
             obj.wsDelta = zeros(numOfHiddenUnits, 1);            
                        
             obj.alpha = alpha;
             obj.k = k;
             obj.epochs = epochs;
        end
        
       
        
        %
        %
        function [errorRates] = teach(obj, patterns)
            mSize = 10;
            mIncreaseSize = 2;
            errorRates = zeros(mSize,2);
            epochIdx = 1;
            
            while epochIdx < obj.epochs
                %increase the size of the array if it is full
                if (epochIdx >= mSize) 
                    mSize = mSize * mIncreaseSize;
                    errorRates(mSize,1) = 0;
                end
                
                obj.teachEpoch(patterns)
                errorRate = obj.calcErrorRate(patterns);
                
                errorRates(epochIdx,1) = errorRate
                epochIdx = epochIdx + 1;
            end
            
            finalEpoch = epochIdx;
            errorRates(finalEpoch,:) = [];
            errorRates = [finalEpoch-1, finalEpoch; errorRates];
        end
        
        %
        %
        function errorRate = calcErrorRate(obj, patterns)
            numOfSuccess = 0;
            for i = (obj.k+1):size(patterns,2)
                numOfSuccess = numOfSuccess + obj.determineSuccess(patterns(:,(i-obj.k):i));
            end 
            
            errorRate = (size(patterns,2) - numOfSuccess) / size(patterns,2); 
        end
               
  %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
       % Forward Pass
        function calcOutput(obj, patterns)    
            
            for i = 1:obj.k
                if (i == 1)
                    obj.hidVals(:, i) = obj.hidNode.calcOutput([patterns(:,i);1], [zeros(256,1);1]);
                else
                    obj.hidVals(:, i) = obj.hidNode.calcOutput([patterns(:,i);1], [obj.hidVals(:,i-1);1]);
                end
            end
            
            for i = 1:obj.k
                obj.outVals(:,i) = obj.outNode.calcOutput([obj.hidVals(:,i);1]);
            end
        end
        
       % Do Forward Pass the BPTT
       function teachPattern(obj, patterns)
            obj.calcOutput(patterns);

            obj.updateWeights(patterns);
       end
        
        % BPTT
        % must have called calcOutput first
        function updateWeights(obj, patterns)            
            for i = obj.k:-1:1
                obj.wsDelta = obj.outNode.calcWeightUpdate(obj.alpha, ...
                              patterns(:,i+1), obj.outVals(:,i), obj.hidVals(:,i));
                
                for j = i:-1:1
                    obj.wsDelta = obj.hidNode.calcWeightUpdate(obj.alpha, ...
                        obj.wsDelta, obj.hidVals(:,j), patterns(:,j), obj.hidVals(:,j-1));
                end
            end
            obj.outNode.updateWeights();
            obj.hidNode.updateWeights();
        end
        
        %
        %
        function teachEpoch(obj, patterns)
            for i = (obj.k+1):size(patterns,2)
                obj.teachPattern(patterns(:,(i-obj.k):i));
            end 
        end  
        
        %
        %
        function setLearningRate(obj, alpha)
            obj.alpha = alpha;
        end
    end
    
    
    
    methods (Access = private)
        function  success = determineSuccess(obj, patterns)
            obj.calcOutput(patterns);
            outputLabel = oneHot2Label(obj.outVals(:,obj.k));
            expectedLabel = oneHot2Label(patterns(:, obj.k+1));
            if outputLabel == expectedLabel
                success = true;
            else
                success = false;
            end
        end
    end
end
        

 