classdef NeuralNet
    properties 
        inputArray % [n x 1] array of input values
        hiddenNodes % {hidUnits x numLayers} cell of hidden nodes
        hiddenOutputs % [hiddenUnits x hiddenLayers] array of outputs
        outputNodes % {m x 1} cell of output nodes
        outputValues % [outputClasses x 1] array of output values
        alpha % Learning rate
    end
    methods
        function teachPattern(obj, pattern, targetLabel)
            disp('Start')
            disp('Set Inputs')
            tStart = tic;
            obj.setInputVals(pattern);
            disp('Done')
            timeElapsed = toc(tStart)
            disp('Set Targets')
            tStart = tic;
            obj.setTarget(targetLabel);
            disp('Done')
            timeElapsed = toc(tStart)
            disp('CalcOutput')
            tStart = tic;
            obj.calcOutput();
            disp('Done')
            timeElapsed = toc(tStart)
            disp('UpdateWeights')
            tStart = tic;
            obj.updateWeights();
            disp('Finish')
            timeElapsed = toc(tStart)
        end
        
        function obj = NeuralNet(numOfInputs, numOfOutputs, ...
                                 numOfHiddenUnits, numOfHiddenLayers, ...
                                 actFunct, alpha, beta, lamda)
             obj.inputNodes = cell(numOfInputs, 1);
             obj.hiddenNodes = cell(numOfHiddenUnits, numOfHiddenLayers);
             obj.outputNodes = cell(numOfOutputs, 1);
             obj.alpha = alpha;
             
             
             obj = obj.buildNeuralNet(numOfInputs, numOfOutputs, ...
                                 numOfHiddenUnits, numOfHiddenLayers, ...
                                 actFunct, beta, lamda);
         
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
                                                        validationLabels)
                
                if validationErrorRate < minError
                    minError = validationErrorRate;
                    minErrorEpochIdx = epochIdx;
                end
                
                errorRates(epochIdx,1) = trainningErrorRate;
                errorRates(epochIdx,2) = validationErrorRate;
                
                epochIdx = epochIdx + 1;
            end
            
            finalEpoch = epochIdx - 1;
            errorRates(finalEpoch,:) = [];
            errorRates([finalEpoch, finalEpoch; errorRates]);
        end
        
        function errorRate = calcErrorRate(obj, patterns, labels)
            numOfSuccess = 0;
            
            for i = 1:size(patterns,2)
                numOfSuccess = numOfSuccess + obj.determineSuccess( ...
                                               patterns(:,i), labels(i,1));
            end
            
            errorRate = (size(labels,1) - numOfSuccess) / size(labels,1);
            
        end
        
    end
    
    methods (Access = private) 
        function obj = buildNeuralNet(obj, numOfInputs, numOfOutputs, ...
                                numOfHiddenUnits, numOfHiddenLayers, ...
                                actFunct, beta, lamda)
                            
            obj = obj.buildInputNodes(numOfInputs, numOfHiddenUnits);
            
             
            obj = obj.buildHiddenNodes(numOfInputs, numOfOutputs, ...
                                 numOfHiddenUnits, numOfHiddenLayers, ...
                                 actFunct, beta, lamda);
                             
            obj = obj.buildOutputNodes(numOfOutputs, numOfHiddenUnits, ...
                                 numOfHiddenLayers, beta, lamda);
        end
        
        function obj = buildInputNodes(obj, numOfInputs, numOfHiddenUnits)
             %build the neural net from bottom to top
             %first create all the input nodes
             for i = 1:numOfInputs
                 inputNode = InputNode(numOfHiddenUnits);
                 obj.inputNodes{i, 1} = inputNode;
             end
        end
        
        function obj = buildHiddenNodes(obj, numOfInputs, numOfOutputs, ...
                                numOfHiddenUnits, numOfHiddenLayers, ...
                                actFunct, beta, lamda)
             %build the first layer of hidden node and connect them to the
             %input layer
             for i = 1:numOfHiddenUnits
                 if 1 ~= numOfHiddenLayers
                     numOfHiddenOutputs = numOfHiddenUnits;
                 else
                     numOfHiddenOutputs = numOfOutputs;
                 end
                 tempHidNode = HiddenNode(actFunct, obj.inputNodes, ...
                                        numOfHiddenOutputs);
                 if (beta == 0 && lamda == 0)
                     hidNode = tempHidNode;
                 elseif beta > 0
                     hidNode = HiddenMomentumNode(tempHidNode, beta);
                 elseif lamda > 0
                     hidNode = HiddenRegularizedNode(tempHidNode, lamda);
                 end
                 obj.hiddenNodes{i, 1} = hidNode;
                                    
                 %Connect all the input units to this node
                 for j = 1:numOfInputs
                     prevLayerNode = obj.inputNodes{j,1};
                     prevLayerNode.setOutputNode(i, j, hidNode);
                 end
             end
             
             %build the rest of the layers of hidden nodes and connect them
             %to the previous layer
             for k = 2:numOfHiddenLayers
                 for i = 1:numOfHiddenUnits
                     if k ~= numOfHiddenLayers
                        numOfHiddenOutputs = numOfHiddenUnits;
                     else
                        numOfHiddenOutputs = numOfOutputs;
                     end
                     tempHidNode = HiddenNode(actFunct, ...
                                          obj.hiddenNodes(:, k-1), ...
                                          numOfHiddenOutputs);
                     if (beta == 0 && lamda == 0)
                        hidNode = tempHidNode;
                     elseif beta > 0
                        hidNode = HiddenMomentumNode(tempHidNode, beta);
                     elseif lamda > 0
                        hidNode = HiddenRegularizedNode(tempHidNode, lamda);
                     end
                     
                     obj.hiddenNodes{i, k} = hidNode;
                                      
                     %Connect all the nodes in the layer before to this node                 
                     for j = 1:numOfHiddenUnits
                         prevLayerNode = obj.hiddenNodes{j, k-1};
                         prevLayerNode.setOutputNode(i, j, hidNode);
                     end
                 end
             end
        end
        
        function obj = buildOutputNodes(obj, numOfOutputs, numOfHiddenUnits, ...
                                  numOfHiddenLayers, beta, lamda)  
             %build the outputlayer and connect it to the top hidden layer
             for i = 1:numOfOutputs
                 tempOutNode = OutputNode(ActFuncEnum.Softmax, ...
                                      obj.hiddenNodes(:,numOfHiddenLayers));
                 if (beta == 0 && lamda == 0)
                     outNode = tempOutNode;
                 elseif beta > 0
                     outNode = OutputMomentumNode(tempOutNode, beta);
                 elseif lamda > 0
                     outNode = OutputRegularizedNode(tempOutNode, lamda);
                 end  
                 
                 obj.outputNodes{i,1} = outNode;
                 
                 for j = 1:numOfHiddenUnits
                     prevLayerNode = obj.hiddenNodes{j, numOfHiddenLayers};
                     prevLayerNode.setOutputNode(i, j, outNode);
                 end
             end 
        end
        
        function  success = determineSuccess(obj, pattern, targetLabel)
            obj.setInputVals(pattern);
            obj.calcOutput();
            output = obj.getOutput();
            outputLabel = oneHot2Label(output);
            if outputLabel == targetLabel
                success = true;
            else
                success = false;
            end
        end
        
        
        
        function teachEpoch(obj, patterns, labels)
            shuffle = randperm(size(labels,1));
            for i = 1:size(labels,1)
                disp(i)
                idx = shuffle(1, i);
                obj.teachPattern(patterns(:,idx), labels(idx,1));
            end
            disp('Done with one epoch');
        end
        
        function updateWeights(obj)
            % For loop and cell which takes a while but there are only
            % ten outputs
            for i = 1:size(obj.outputNodes,1)
                outNode = obj.outputNodes{i,1};
                outNode.updateWeights(obj.alpha);
            end
            
            for i = size(obj.hiddenNodes, 2):-1:1
                for j = 1:size(obj.hiddenNodes,1)
                    hidNode = obj.hiddenNodes{j,i};
                    hidNode.updateWeights(obj.alpha);
                end
            end
        end
        
        function calcOutput(obj)
            for i = 1:size(obj.hiddenNodes, 2)
                for j = 1:size(obj.hiddenNodes,1)
                    hidNode = obj.hiddenNodes{j,i};
                    hidNode.calcOutput();
                end
            end
            
            for i = 1:size(obj.outputNodes,1)
                outNode = obj.outputNodes{i,1};
                outNode.calcOutput();
            end
        end
        
        % Takes a [n x 1] vector of ints and distributes them to the 
        % inputArray.
        function obj = setInputVals(obj, inputVals)
            obj.inputArray = inputVals;
        end
        
        % Retrieves the one hot encoded output from outputNodes
        function outputVals = getOutput(obj)
            outputVals = zeros(size(obj.outputNodes,1),1);
            for i = 1:size(outputVals,1)
                outputNode = obj.outputNodes{i,1};
                outputVals(i,1) = outputNode.getOutputs();
            end
        end
        
        function setTarget(obj, targetLabel)
            target = label2OneHot(targetLabel);
            for i = 1:size(obj.outputNodes)
                outputNode = obj.outputNodes{i,1};
                outputNode.setTarget(target(i,1));
            end
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
        

 