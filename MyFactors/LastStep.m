% �ϲ�A1��A2��������յľ���
function [R] = LastStep (A1,A2)     % A1Ϊȡ������A2Ϊȫ���о���
    
    [L1C,L1R] = size(A1);
%     [L2C,L2R] = size(A2);

    R = A2;
    Q = A1;

    for u = 1:L1R
        
        [R,Q] = kuorong (R,Q,u);
        
    end

end