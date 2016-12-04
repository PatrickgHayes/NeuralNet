classdef ActFuncEnum
    %ACTFUNCENUM Summary of this class goes here
    %   Detailed explanation goes here
    
    enumeration
        Sigmoid
        Softmax
        Tanh
        ReLU
    end
    
    methods (Static)
        function obj = getFunct(functEnum)
            switch functEnum
                case ActFuncEnum.Sigmoid
                    obj = Sigmoid();
                case ActFuncEnum.Softmax
                    obj = Softmax();
                case ActFuncEnum.Tanh
                    obj = Tanh();
                case ActFuncEnum.ReLU
                    obj = ReLU();
            end
        end
    end
end

