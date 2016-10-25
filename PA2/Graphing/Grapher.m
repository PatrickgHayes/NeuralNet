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
            sigmoidError = sigmoidError(1:finalIdxs(1), 1);
            tanhError = tanhError(1:finalIdxs(2), 1);
            reluError = reluError(1:finalIdxs(3), 1);
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
        
        
    end
end

