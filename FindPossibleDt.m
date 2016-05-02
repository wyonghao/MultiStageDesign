% Possible Dt

% function [Dt] = FindPossibleDt (MaxDt,Stage)  % Find Possible Decimation Rato
function [Dt,TempFactors,TElement,NSMax] = FindPossibleDt (Dt_DB,Stage)	% Find Possible Decimation Rato
    Dt = zeros(length(Dt_DB),1);
    TempFactors = cell(length(Dt_DB),1);
    TElement = cell(length(Dt_DB),1);
    NSMax = cell(length(Dt_DB),1);
    DeleteCell = zeros(length(Dt_DB),1);
    for i = 1:length(Dt_DB)
        TempFactors{i} = factor(Dt_DB(i));
        NSMax{i} = length(TempFactors{i});
        if Stage <= NSMax{i}
            Dt(i) = Dt_DB(i);
            [TElement{i}(2,:),TElement{i}(1,:)] = hist(TempFactors{i},unique(TempFactors{i}));
            [~,c] = find(TElement{i}(2,:) == 0);
            TElement{i}(:,c) = [];
        else
            DeleteCell(i) = i;
        end
    end
    Dt(Dt == 0) = [];
    DeleteCell(DeleteCell == 0) = [];
    NSMax(DeleteCell,:) = [];
    TElement(DeleteCell,:) = [];
    TempFactors(DeleteCell,:) = [];
end