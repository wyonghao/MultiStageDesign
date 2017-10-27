% ¼ì²éºÍÊä³ö
function [R] = CheckandExport (Rtemp,Osr)

    Temp = Rtemp;
    TempL = ones(length(Rtemp(:,1)),1);
    DeleteArray = [];
    
    for i = 1:length(Rtemp(:,1))
        for j = 1:length(Rtemp(1,:))
            TempL(i,:) = TempL(i,:)*Rtemp(i,j);
        end
        if TempL(i,:) ~= Osr
        	DeleteArray = [DeleteArray;i];
        end
    end
    
    Temp(DeleteArray,:) = [];
    R = Temp;
    [R,ia,ic] = unique(R,'rows');
    
end