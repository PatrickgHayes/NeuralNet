function PA4( trainingText)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

 training_text = fopen(trainingText,'r');
 characters = fscanf(training_text,'%c');
 disp('Number of characters in training set:');
 disp(size(characters, 2));

 fclose(training_text);
 epochs = 2;
 k = 15;
 alpha = .01;
 numHidUnits = 100;
 rnn = NeuralNet(256, 256, numHidUnits, ActFuncEnum.ReLU, alpha, k, epochs);

 errorRates = rnn.teach(characters);
 disp('After 2 epochs')
 rnn.generateText(3500, 1000, characters);
 disp(' ')
 disp(' ')
 
 errorRate1 = rnn.teach(characters);
 disp('After 4 epochs')
 rnn.generateText(3500, 1000, characters);
 disp(' ')
 disp(' ')
 
 errorRate2 = rnn.teach(characters);
 disp('After 6 epochs')
 rnn.generateText(3500, 1000, characters);
 disp(' ')
 disp(' ')
 
 errorRate3 = rnn.teach(characters);
 disp('After 8 epochs')
 rnn.generateText(3500, 1000, characters);
 disp(' ')
 disp(' ')
 
 errorRate4 = rnn.teach(characters);
 disp('After 10 epochs')
 rnn.generateText(3500, 100, characters);
 
 errorRates = [errorRates(1:epochs); errorRate1(1:epochs); errorRate2(1:epochs); errorRate3(1:epochs); errorRate4(1:epochs)];
 disp(errorRates)
 finalIdx = epochs * 5;
 Grapher.graphErrorRate(errorRates, finalIdx, 'Recurrent Neural Net Loss Vs. Training Epochs');
end

