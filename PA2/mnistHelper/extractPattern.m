function [ pattern ] = extractPattern( image)
%EXTRACTPATTERN Summary of this function goes here
%   Detailed explanation goes here
biasWeight = 1;
pattern = [biasWeight; image];
end

