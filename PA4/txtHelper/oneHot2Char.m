function [ out_char ] = oneHot2Char( oneHotVector )
%ONEHOT2CHAR Part1 used to convert 1hot into text

idx = -10;
maxVal = -10;
for i=1:size(oneHotVector,1)
    if (abs(oneHotVector(i,1) - maxVal) < .000001)
        idx(size(idx,2)+1) = i;
        
    elseif (oneHotVector(i,1) > maxVal)
            idx = i;
            maxVal = oneHotVector(i,1);
    end
end

randIdx = randi([1 size(idx,2)],1,1);
out_char = char(idx(randIdx));
end

