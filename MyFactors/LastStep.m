% 合并A1和A2，组成最终的矩阵
function [R] = LastStep (A1,A2)     % A1为取出数，A2为全排列矩阵
    
    [L1C,L1R] = size(A1);
%     [L2C,L2R] = size(A2);

    R = A2;
    Q = A1;

    for u = 1:L1R
        
        [R,Q] = kuorong (R,Q,u);
        
    end

end