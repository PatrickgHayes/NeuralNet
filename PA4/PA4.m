function rnn = PA4( trainingText)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

 training_text = fopen(trainingText,'r');
 characters = fscanf(training_text,'%c');
 disp(size(characters))

 fclose(training_text);

rnn = NeuralNet(256, 256, 50, ActFuncEnum.ReLU, .01, 10, 30);

[errorRates, finalIdx] = rnn.teach(characters);

Grapher.graphErrorRate(errorRates, finalIdx-1, 'Recurrent Neural Net Error Rate Over Training');

rnn.generateText(2000, 100, characters);


end

