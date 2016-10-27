function Problem3( trainImageFile, trainLabelFile, testImageFile, ...
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

  disp('Please wait while we teach plain net')
  plainNet = NeuralNet(784, 10, 30, 1, ActFuncEnum.Sigmoid, .01, 0, 0);
  errorRatesAndIdx = plainNet.teach(images, labels); 
  errorRates = errorRatesAndIdx(2:end,:);
  finalIdx = errorRatesAndIdx(1,1);
  Grapher.graphValidationErrorRate(errorRates, finalIdx, 'Neural Network with 1 hidden layer with 30 hidden units');
  PlainNetFinalErrorRate = plainNet.calcErrorRate(testImages, testLabels)

 finalIdxs = zeros(1,3);
 disp('Please wait while we teach sigmoid net')
 sigNet =  NeuralNet(784, 10, 30, 1, ActFuncEnum.Sigmoid, .01, 0, 0);
 errorRatesAndIdx = sigNet.teach(images, labels); 
 sigmoidError = errorRatesAndIdx(2:end,:);
 finalIdxs(1) = errorRatesAndIdx(1,1);
 
 disp('Please wait while we teach tanh net')
 tanhNet =  NeuralNet(784, 10, 30, 1, ActFuncEnum.Tanh, .01, 0, 0);
 errorRatesAndIdx = tanhNet.teach(images, labels); 
 tanhError = errorRatesAndIdx(2:end,:);
 finalIdxs(2) = errorRatesAndIdx(1,1);

 disp('Please wait while we teach relu net')
 reluNet =  NeuralNet(784, 10, 30, 1, ActFuncEnum.ReLU, .01, 0, 0);
 errorRatesAndIdx = reluNet.teach(images, labels); 
 reluError = errorRatesAndIdx(2:end,:);
 finalIdxs(3) = errorRatesAndIdx(1,1);
 simoidFinalErrorRate = sigNet.calcErrorRate(testImages, testLabels)
 tanhFinalErrorRate = tanhNet.calcErrorRate(testImages, testLabels)
 reluFinalErrorRate = reluNet.calcErrorRate(testImages, testLabels)
 
 Grapher.graphActFunctErrorRates(sigmoidError, tanhError, reluError, finalIdxs);


 disp('Please wait while we teach a net with 16 hidden units')
 net = NeuralNet(784, 10, 16, 1, ActFuncEnum.ReLU, .01, 0, 0);
 errorRatesAndIdx = net.teach(images, labels);
 netErr = errorRatesAndIdx(2:end,:);
 netIdx = errorRatesAndIdx(1,1);
 
 disp('Please wait while we teach a net with 8 hidden units')
 halfnet = NeuralNet(784, 10, 8, 1, ActFuncEnum.ReLU, .01, 0, 0);
 errorRatesAndIdx = halfnet.teach(images, labels);
 halfnetErr = errorRatesAndIdx(2:end,:);
 halfnetIdx = errorRatesAndIdx(1,1);
 
 finalErrorRate_16units = net.calcErrorRate(testImages, testLabels)
 finalErrorRate_8units = halfnet.calcErrorRate(testImages, testLabels)
 
 Grapher.compareTopology(netErr, halfnetErr, netIdx, halfnetIdx, ...
                         '16 hidden units', '8 hidden units', ...
                         'How does the number of hidden units affect the network');
 
  disp('Please wait while we teach a net with 1 hidden layer')
 net = NeuralNet(784, 10, 16, 1, ActFuncEnum.ReLU, .01, 0, 0);
 errorRatesAndIdx = net.teach(images, labels);
 netErr = errorRatesAndIdx(2:end,:);
 netIdx = errorRatesAndIdx(1,1);
 
 disp('Please wait while we teach a net with 2 hidden layer')
 doublenet = NeuralNet(784, 10, 16, 2, ActFuncEnum.ReLU, .01, 0, 0);
 errorRatesAndIdx = doublenet.teach(images, labels);
 doublenetErr = errorRatesAndIdx(2:end,:);
 doublenetIdx = errorRatesAndIdx(1,1);
 
 finalErrorRate_1layer = net.calcErrorRate(testImages, testLabels)
 finalErrorRate_2layers = doublenet.calcErrorRate(testImages, testLabels)
 
 Grapher.compareTopology(netErr, doublenetErr, netIdx, doublenetIdx, ...
                         '1 hidden layer', '2 hidden layers', ...
                         'How does the number of hidden layers affect the network');


  disp('Please wait while we teach a regularized net')
  regnet = NeuralNet(784, 10, 8, 1, ActFuncEnum.Sigmoid, .01, 0, .0001);
  errorRatesAndIdx = regnet.teach(images, labels);
  regnetErr = errorRatesAndIdx(2:end,:);
  regnetIdx = errorRatesAndIdx(1,1);
  
  disp('Please wait while we teach a plain net')
   net = NeuralNet(784, 10, 8, 1, ActFuncEnum.Sigmoid, .01, 0, 0);
   errorRatesAndIdx = net.teach(images, labels);
   netErr = errorRatesAndIdx(2:end,:);
   netIdx = errorRatesAndIdx(1,1);
   
   finalErrorRate_plain = net.calcErrorRate(testImages, testLabels)
   finalErrorRate_regularized = regnet.calcErrorRate(testImages, testLabels)
   
   Grapher.compareTopology(netErr, regnetErr, netIdx, regnetIdx, ...
                           'Normal update', 'Regularized update', ...
                           'How does regularization affect convergence and accuracy');

 disp('Please wait while we teach a momentum net')
 monet = NeuralNet(784, 10, 30, 1, ActFuncEnum.Tanh, .01, .5, 0);
 errorRatesAndIdx = monet.teach(images, labels);
 monetErr = errorRatesAndIdx(2:end,:);
 monetIdx = errorRatesAndIdx(1,1);
 
 disp('Please wait while we teach a plain net')
  net = NeuralNet(784, 10, 30, 1, ActFuncEnum.Tanh, .01, 0, 0);
  errorRatesAndIdx = net.teach(images, labels);
  netErr = errorRatesAndIdx(2:end,:);
  netIdx = errorRatesAndIdx(1,1);
 
 
 
 finalErrorRate_plain = net.calcErrorRate(testImages, testLabels)
 finalErrorRate_momentum = monet.calcErrorRate(testImages, testLabels)
 
 Grapher.compareTopology(netErr, monetErr, netIdx, monetIdx, ...
                         'Normal update', 'Momentum update', ...
                         'How does momentum affect convergence and accuracy');

testNet = NeuralNet(784, 10, 5, 1, ActFuncEnum.Sigmoid, .01, 0, 0);
testNet.testGradients(images(:,1:5), labels(1:5,1), .01);
end

