classdef Grapher
    %GRAPHER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        function graphValidationErrorRate(errorRates, finalIdx, gTitle)
            trainningError = errorRates(1:finalIdx, 1);
            validationError = errorRates(1:finalIdx, 2);
            epochs = 1:1:size(trainningError,1);
            h = zeros(2,1);
            figure
            hold all;
            h(1) = plot(epochs, trainningError);
            h(2) = plot(epochs, validationError);
            xlabel('Epochs');
            ylabel('Error Rate (Misclassified/#Patterns)');
            legend(h,'Trainning  Data', 'Validation Error');
            title(gTitle);
            hold off;
        end 
        
        function graphActFunctErrorRates(sigmoidError, tanhError, ...
                                         reluError, finalIdxs)
            sigmoidError = sigmoidError(1:finalIdxs(1), 2);
            tanhError = tanhError(1:finalIdxs(2), 2);
            reluError = reluError(1:finalIdxs(3), 2);
            epochsSigmoid = 1:1:finalIdxs(1);
            epochsTanh = 1:1:finalIdxs(2);
            epochsRelu = 1:1:finalIdxs(3);
            h = zeros(3,1);
            figure
            hold all;
            h(1) = plot(epochsSigmoid, sigmoidError);
            h(2) = plot(epochsTanh, tanhError);
            h(3) = plot(epochsRelu, reluError);
            xlabel('Epochs');
            ylabel('Error Rate (Misclassified/#Patterns)');
            legend(h,'Sigmoid', 'TanH', 'ReLu');
            title('Compare Hidden Unit Activation Functions');
            hold off;
        end 
        
        function compareTopology(firstErr, secondErr, ...
                                 firstIdx, secIdx, ...
                                 firstLabel, secondLabel, ...
                                 iTitle)
            firstErr = firstErr(1:firstIdx, 2);
            secondErr = secondErr(1:secIdx, 2);
            epochsFirst = 1:1:firstIdx;
            epochsSec = 1:1:secIdx;
            h = zeros(2,1);
            figure
            hold all;
            h(1) = plot(epochsFirst, firstErr);
            h(2) = plot(epochsSec, secondErr);
            xlabel('Epochs');
            ylabel('Error Rate (Misclassified/#Patterns)');
            legend(h, firstLabel, secondLabel);
            title(iTitle);
            hold off;
        end
            
        
        
    end
end

