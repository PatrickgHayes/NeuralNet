function [ output_args ] = PA4( trainingText)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

training_text = fopen(trainingText,'r');
characters = fscanf(training_text,'%c');
fclose(training_text);

char_vectors = zeros(1, size(characters,2));

for i=1:size(characters,2)
    char_vectors(:,i) = char2OneHot(characters(i));
end

rnn = NeuralNet(256, 256, 35, ActFuncEnum.Tanh, .01, 5, 5);

errorRates = rnn.teach(char_vectors);

Grapher.graphErrorRate(errorRates, 'Recurrent Neural Net Error Rate Over Training');


end

