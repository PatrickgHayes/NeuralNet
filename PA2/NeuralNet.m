classdef NeuralNet < handle
    properties 
        hidNodes % {1 x numLayers} cell of hidden nodes
        hidVals % [hiddenNodes x hiddenLayers] array of output values
        hid_wsDelta % [hiddenNodes x hiddenLayers] 
                     % array of deltas and sum of weights for each
                     % hiddenNode on the layer below. Don't compute for the
                     % first hidden layer
        outNode % a single node that calutlates the output of the Neural Net
        outVals % a [m x 1] array of outputVals
        out_wsDelta % [szLayerBlw x 1 ] array of output
                           % deltas and sum of weights for each hiddenNode
                           % on the layer below
        alpha % Learning rate
    end
    methods
        function obj = NeuralNet(numOfInputs, numOfOutputs, ...
                                 numOfHiddenUnits, numOfHidLayers, ...
                                 actFunct, alpha, beta, lamda)
                             
             obj.hidVals = zeros(numOfHiddenUnits, numOfHidLayers);
             obj.hid_wsDelta = zeros(numOfHiddenUnits, numOfHidLayers);
             if numOfHidLayers > 0
                 inputsToOutNode = numOfHiddenUnits;
             else
                 inputsToOutNode = numOfInputs;
             end
             obj.outNode = OutputNode(ActFuncEnum.Softmax, ...
                                      inputsToOutNode, numOfOutputs);
             obj.outVals = zeros(numOfOutputs, 1);
             obj.out_wsDelta = zeros(numOfHiddenUnits, 1);
             obj.alpha = alpha;
             obj.hidNodes = cell(1, numOfHidLayers);
             
             for i = 1:numOfHidLayers
                 if i == 1
                     nIn = numOfInputs;
                 else
                     nIn = numOfHiddenUnits;
                 end
                 
                 
                 nOut = numOfHiddenUnits;
                 
                 obj.hidNodes{1,i} = HiddenNode(actFunct, nIn, nOut);
             end
        end
        
        function [errorRates] = teach(obj, patterns, labels)
            mSize = 10;
            mIncreaseSize = 2;
            errorRates = zeros(mSize,2);
            epochIdx = 1;
            
            minError = 1;
            minErrorEpochIdx = 0;
            split = obj.splitPatterns(patterns, labels);
            disp('Done Splitting Trainning data')
            validationPatterns = split{1};
            validationLabels = split{2};
            trainningPatterns = split{3};
            trainningLabels = split{4};
            
            while epochIdx - minErrorEpochIdx < 5
                %increase the size of the array if it is full
                if (epochIdx >= mSize) 
                    mSize = mSize * mIncreaseSize;
                    errorRates(mSize,1) = 0;
                end
                
                obj.teachEpoch(trainningPatterns, trainningLabels)
                trainningErrorRate = obj.calcErrorRate(trainningPatterns, ...
                                                      trainningLabels);
                validationErrorRate = obj.calcErrorRate(validationPatterns, ...
                                                        validationLabels);
                
                if validationErrorRate < minError
                    minError = validationErrorRate;
                    minErrorEpochIdx = epochIdx;
                end
                
                errorRates(epochIdx,1) = trainningErrorRate;
                errorRates(epochIdx,2) = validationErrorRate
                
                epochIdx = epochIdx + 1;
            end
            
            finalEpoch = epochIdx;
            errorRates(finalEpoch,:) = [];
            errorRates = [finalEpoch-1, finalEpoch; errorRates];
        end
        
        
        
        function errorRate = calcErrorRate(obj, patterns, labels)
            numOfSuccess = 0;
            
            for i = 1:size(patterns,2)
                numOfSuccess = numOfSuccess + obj.determineSuccess( ...
                                               patterns(:,i), labels(i,1));
            end
            
            errorRate = (size(labels,1) - numOfSuccess) / size(labels,1);
            
        end
        
        function teachPattern(obj, pattern, targetLabel)
%             disp('Start')
            bPattern = [pattern; 1];
            hotTarget = label2OneHot(targetLabel);
            
%             disp('CalcOutput')
%             tStart = tic;
            obj.calcOutput(bPattern);
%             disp('Done')
%             timeElapsed = toc(tStart)
%             
%             disp('UpdateWeights')
%             tStart = tic;
            obj.updateWeights(bPattern, hotTarget);
%             disp('Finis')
%             timeElapsed = toc(tStart)
        end
        
    end
    
    methods (Access = private)
        function  success = determineSuccess(obj, pattern, targetLabel)
            bPattern = [pattern;1];
            obj.calcOutput(bPattern);
            outputLabel = oneHot2Label(obj.outVals);
            if outputLabel == targetLabel
                success = true;
            else
                success = false;
            end
        end
        
        function teachEpoch(obj, patterns, labels)
            shuffle = randperm(size(labels,1));
            for i = 1:size(labels,1)
                idx = shuffle(1, i);
                obj.teachPattern(patterns(:,idx), labels(idx,1));
            end
            
        end
        
        
        
        %must have called calcOutput and calcDeltas first
        function updateWeights(obj, pattern, hotTarget)
            hidLayers = size(obj.hidNodes, 2);
            if hidLayers == 0
                nIn = pattern;
            else
                nIn = [obj.hidVals(:,hidLayers);1];
            end
     
            obj.out_wsDelta = obj.outNode.updateWeights(nIn, ...
                                       hotTarget, obj.outVals, obj.alpha);
            
            
            for i = hidLayers:-1:1
                hidNode = obj.hidNodes{i,1};
                if i == hidLayers
                    pDeltas = obj.out_wsDelta;
                else
                    pDeltas = obj.hid_wsDelta(:,i+1);
                end
                out = obj.hidVals(:,i);
                if i == 1
                    in = pattern;
                    hidNode.updateWeights(obj.alpha, pDeltas, out, in);
                else
                    in = [obj.hidVals(:,i-1);1];
                    obj.hid_wsDelta(:,i) =  ...
                        hidNode.updateWeights(obj.alpha, pDeltas, out, in);
                end
            end   
        end
        
        function calcOutput(obj, pattern)    
            hidLayers = size(obj.hidNodes, 2);
            
            for i = 1:hidLayers
                if i == 1
                    in = pattern;
                else
                    in = [obj.hidVals(:, i-1);1];
                end
                hidNode = obj.hidNodes{1,i};
                obj.hidVals(:, i) = hidNode.calcOutput(in);
            end
            
            if hidLayers == 0
                in = pattern;
            else
                in = [obj.hidVals(:, hidLayers);1];
            end
            
            obj.outVals = obj.outNode.calcOutput(in);
        end
        
        function [outputCell] = splitPatterns(~, patterns, labels)
              
              validationSize = floor(size(labels,1) / 6);
              validationPatterns = zeros(size(patterns,1), validationSize);
              validationLabels = zeros(validationSize, 1);
              trainningPatterns = zeros(size(patterns,1), ...
                                       size(labels,1) - validationSize);
              trainningLabels = zeros(size(labels,1) - validationSize, 1);
              
              shuffle = randperm(size(labels,1));
              for i = 1:validationSize
            
                  idx = shuffle(1, i);
                  validationPatterns(:, i) = patterns(:,idx);
                  validationLabels(i, 1) = labels(idx, 1);
              end
              
              for i = (validationSize + 1):1:size(labels,1)
                  idx = shuffle(1,i);
                  trainningPatterns(:, i) = patterns(:,idx);
                  trainningLabels(i,1) = labels(idx,1);
              end
              outputCell = {validationPatterns, validationLabels, ...
                            trainningPatterns, trainningLabels};
        end
    end
end
        

 