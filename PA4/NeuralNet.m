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
        % Teaches the neural network over multiple epochs and
        % keeps track of the loss and error rate
        function errorRates = teach(obj, characters)
            mSize = 10;
            mIncreaseSize = 2;
            errorRates = zeros(mSize,1);
            epochIdx = 1;
            
            while epochIdx <= obj.epochs
                %increase the size of the array if it is full
                if (epochIdx >= mSize) 
                    mSize = mSize * mIncreaseSize;
                    errorRates(mSize,1) = 0;
                end
                
                obj.teachEpoch(characters);
                loss = obj.calcLoss(characters);
                errorRates(epochIdx,1) = loss
                epochIdx = epochIdx + 1;
            end
            
            finalEpoch = epochIdx;
            errorRates(finalEpoch,:) = [];
        end
        
        %
        %
        function generateText(obj, temperature, txt_length, characters)
            text = characters(txt_length);
            obj.outNode.activationFunc.setTemperature(temperature);
            obj.hidVals(:, obj.k) = rand(size(obj.hidVals,1),1);
            for i= 1:txt_length
                char = zeros(size(obj.outVals,1), 1);
                char(:,1) = char2OneHot(text(i));
           
                obj.calcSingleOutput(char)
                outputLabel = oneHot2Char(obj.outVals(:,obj.k));
                text(i+1) =outputLabel;
            end
            
            disp(text);
            obj.outNode.activationFunc.setTemperature(1);
         end
                
            
        
        %
        %
        function errorRate = calcErrorRate(obj, characters)
            numOfSuccess = 0;
            for i = (obj.k+1):size(characters,2)
                patterns = zeros(size(obj.outVals,1), obj.k+1);
                for j=1:obj.k+1
                    patterns(:,j) = char2OneHot(characters(i-(obj.k+1)+j));
                end
                numOfSuccess = numOfSuccess + obj.determineSuccess(patterns);
            end 
                  
            errorRate = (size(characters,2) - numOfSuccess) / size(characters,2); 
        end
        
        %
        %
        function loss = calcLoss(obj, characters)
            loss = 0;
            for i = (obj.k+1):size(characters,2)
                patterns = zeros(size(obj.outVals,1), obj.k+1);
                for j=1:obj.k+1
                    patterns(:,j) = char2OneHot(characters(i-(obj.k+1)+j));
                end
                loss = loss + obj.determineLoss(patterns);
            end
        end
               
  %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
       % Forward Pass
        function calcOutput(obj, patterns)    
            
            for i = 1:obj.k
                if (i == 1)
                    obj.hidVals(:, i) = obj.hidNode.calcOutput([patterns(:,i);1], [zeros(size(obj.hidVals,1),1);1]);
                else
                    obj.hidVals(:, i) = obj.hidNode.calcOutput([patterns(:,i);1], [obj.hidVals(:,i-1);1]);
                end
            end
            
            for i = 1:obj.k
                obj.outVals(:,i) = obj.outNode.calcOutput([obj.hidVals(:,i);1]);
            end
        end
        
        % Single character
        function calcSingleOutput(obj, char)
            obj.hidVals(:, obj.k) = obj.hidNode.calcOutput([char;1], [obj.hidVals(:,obj.k);1]);
            obj.outVals(:, obj.k) = obj.outNode.calcOutput([obj.hidVals(:,obj.k);1]);
        end
        
       % Do Forward Pass the BPTT
       function teachPattern(obj, patterns)
            obj.calcOutput(patterns);

            obj.updateWeights(patterns);
       end
        
        % BPTT
        % must have called calcOutput first
        function updateWeights(obj, patterns)            
%               for i = obj.k:-1:1
                obj.wsDelta = obj.outNode.calcWeightUpdate(obj.alpha, ...
                              patterns(:,obj.k+1), obj.outVals(:,obj.k), [obj.hidVals(:,obj.k);1]);
                
                for j = obj.k:-1:1
                    if (j == 1)
                        obj.wsDelta = obj.hidNode.calcWeightUpdate(obj.alpha, ...
                        obj.wsDelta, obj.hidVals(:,j), [patterns(:,j);1], zeros(size(obj.hidVals,1)+1,1));
                    else
                        obj.wsDelta = obj.hidNode.calcWeightUpdate(obj.alpha, ...
                        obj.wsDelta, obj.hidVals(:,j), [patterns(:,j);1], [obj.hidVals(:,j-1);1]);
                    end
                end
%               end
            obj.outNode.updateWeights();
            obj.hidNode.updateWeights();
        end
        
        %
        %
        function teachEpoch(obj, characters)
            for i = (obj.k+1):size(characters,2)
                patterns = zeros(size(obj.outVals,1), obj.k+1);              
                for j=1:obj.k+1
                    patterns(:,j) = char2OneHot(characters(i-(obj.k+1)+j));
                end
                obj.teachPattern(patterns);
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
            outputLabel = oneHot2Char(obj.outVals(:,obj.k));
            expectedLabel = oneHot2Char(patterns(:, obj.k+1));
            if outputLabel == expectedLabel
                success = true;
            else
                success = false;
            end
        end
        
        function loss = determineLoss(obj, patterns)
            obj.calcOutput(patterns);
            out = obj.outVals(:,obj.k);
            tar = patterns(:, obj.k+1);
            loss = -sum(tar .* log(out));
        end
    end
end
        

 