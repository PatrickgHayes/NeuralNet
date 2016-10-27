classdef GradientTester < handle
    %GRADIENTTESTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        asize
        est_idx
        dev_idx
        est_grad
        dev_grad
        eps
    end
    
    methods
        function obj = GradientTester(eps)
            obj.est_grad = zeros(100,1);
            obj.dev_grad = zeros(100,1);
            obj.est_idx = 1;
            obj.dev_idx = 1;
            obj.asize = 100;
            obj.eps = eps;
        end
        
        function addDev(obj, dev)
            if obj.dev_idx > obj.asize
                newSize = obj.asize * 2;
                obj.est_grad(newSize,1) = 0;
                obj.dev_grad(newSize,1) = 0;
                obj.asize = newSize;
            end
            
            obj.dev_grad(obj.dev_idx,1) = dev;
            obj.dev_idx = obj.dev_idx + 1;
        end
        
        function addEst(obj, inc, dec)
            if obj.est_idx > obj.asize
                newSize = obj.asize * 2;
                obj.est_grad(newSize,1) = 0;
                obj.dev_grad(newSize,1) = 0;
                obj.asize = newSize;
            end
            estimate = (inc - dec) / (2 * obj.eps);
            obj.est_grad(obj.est_idx, 1) = estimate;
            obj.est_idx = obj.est_idx + 1;
        end
        
        function graph(obj)
            dev = obj.dev_grad(1:(obj.dev_idx-1),1);
            est = obj.est_grad(1:(obj.est_idx-1),1);
           
            disp(size(dev))
            disp(size(est))
            diff = abs(dev - est);
            weights = 1:1:size(diff,1);
            figure
            hold all;
            scatter(weights, diff);
            xlabel('One Weight Change');
            ylabel('Difference Between Calculated and Approximated Derivatives');
            title('Test Gradient Calculations');
            hold off;
            difference = sum(diff) / size(diff,1)
        end
    end
    
end

