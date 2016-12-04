function [ out_char ] = oneHot2Char( oneHotVector )
%ONEHOT2CHAR Part1 used to convert 1hot into text

idx = -1;
maxVal = -1;
for i=1:size(oneHotVector,1)
    if (oneHotVector(i,1) > maxVal)
        idx = i;
        maxVal = oneHotVector(i,1);
    end
end
out_char = char(idx);
end

