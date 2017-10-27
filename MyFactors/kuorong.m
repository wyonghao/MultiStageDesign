function [Y,Qout] = kuorong (X,Q,u)

    [LXC,LXR] = size(X);
    [LQC,LQR] = size(Q);
    TempX = X;
    TempQ = Q;
    
    for i = 1:length(TempX(:,1))                           % È«¼¯
        for j = 1:LXR
            TempX_1(LXR*(i-1)+j,:) = TempX(i,:);
            TempQ_1(LXR*(i-1)+j,:) = TempQ(i,:);
        end
    end
    
    TempY = TempX;
    Y = TempX_1;
    Qout = TempQ_1;

    for m = 1:length(X(:,1))
        for n = 1:LXR
            Y(LXR*(m-1)+n,n) = TempY(m,n)*Q(m,u);
        end
	end
    
end