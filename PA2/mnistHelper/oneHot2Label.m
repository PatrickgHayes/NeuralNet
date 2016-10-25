function [ label ] = oneHot2Label( oneHotVector )
%ONEHOT2LABEL 
label = -1;
for i=1:size(oneHotVector,1)
    if (oneHotVector(i,1) == 1)
        label = i - 1;
    end
end


end

