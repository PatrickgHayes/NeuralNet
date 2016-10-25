function [ ] = Problem3( trainImageFile, trainLabelFile, testImageFile, ...
                         testLabelFile, fast)
%PROBLEM3 Summary of this function goes here
%   Detailed explanation goes here

%load training data
images = loadMNISTImages(trainImageFile);
labels = loadMNISTLabels(trainLabelFile);
testImages = loadMNISTImages(testImageFile);
testLabels = loadMNISTLabels(testLabelFile);

if fast == true
    %Trim to onlyuse the first 20,000 entries
    images = images(:,1:20000);
    labels = labels(1:20000,:);
    testImages = testImages(:,1:2000);
    testLabels = testLabels(1:2000,:);
end

plainNet = NeuralNet(784, 10, 11, 1, ActFuncEnum.Sigmoid, .0001, 0, 0);
disp('Done Building Neural Net');

plainNet.teachPattern(images(:,1), labels(1,1));

errorRatesAndIdx = plainNet.teach(images, labels);
 
errorRates = errorRatesAndIdx(2:end,:);
finalIdx = errorRatesAndIdx(1,1);
Grapher.graphValidationErrorRate(errorRates, finalIdx, 'Test');

disp('Calc Error Rate')
testErrorRate = plainNet.calcErrorRate(testImages, testLabels)
disp('Finish')
end
