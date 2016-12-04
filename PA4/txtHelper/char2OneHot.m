function [ one_hot ] = char2OneHot( input_char )
%CHAR2ONEHOT Part1 used to convert training date into 1hot

one_hot = zeros(256,1);
one_hot(uint(input_char)) = 1;
end

