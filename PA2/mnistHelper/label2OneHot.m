function [ t ] = label2OneHot( label )
%LABEL2ONEHOT - takes a decimal digit and converts to a one hot vector
t = zeros(10,1);

for i=1:10
    if (i-1) == label
        t(i,1) = 1;
    end
end
end

