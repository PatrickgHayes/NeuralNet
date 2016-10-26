function neuralNet = Problem3( trainImageFile, trainLabelFile, testImageFile, ...
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

plainNet = NeuralNet(784, 10, 30, 1, ActFuncEnum.Sigmoid, .01, 0, 0);
disp('Done Building Neural Net');

errorRatesAndIdx = plainNet.teach(images, labels);
 
errorRates = errorRatesAndIdx(2:end,:);
finalIdx = errorRatesAndIdx(1,1);
Grapher.graphValidationErrorRate(errorRates, finalIdx, 'Neural Network with 1 hidden layer with 30 hidden units');

PlainNetFinalErrorRate = plainNet.calcErrorRate(testImages, testLabels)

testNet = NeuralNet(784, 10, 5, 1, ActFuncEnum.Sigmoid, .01, 0, 0);

testNet.testGradients(images(:,1:5, labels(1:5,1));
neuralNet = plainNet;
end

