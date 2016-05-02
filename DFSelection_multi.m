% DF Selection Based on S's Value

function [DF_Computational,DF_Mmeory] = DFSelection_multi (DFData,Df,Osr,Stage)
    S = zeros(1,length(DFData(:,1)));
    T = zeros(1,length(DFData(:,1)));
    for i = 1:length(DFData(:,1))
        S(i) = CalS(Df,Stage,Osr,DFData(i,:));
        T(i) = CalT(Df,Stage,Osr,DFData(i,:));
    end
    [MinS,Ls] = min(S);
    [MinT,Lt] = min(T);
%     DF = DFData(L,:);
    [rows,~] = find(S == MinS);
    [rowt,~] = find(T == MinT);
% If the minimum S is not unique (normally, the following parts are not needed)
    if length(rows) == 1
        DF_Computational = DFData(Ls,:);
    else
        Ref = 0;
        Temp = 0;
        DT = zeros(length(rows),1);
        [DF_Ref] = EDFx1(Stage,Df,Osr);
        Ref = Ref + sum(DF_Ref);
        for m = 1:length(rows)
            Temp = Temp + sum(DFData(rows(m)));
            DT(m) = abs(Temp-Ref);
        end
        [MinDR,ls] = min(DT);
        [rs,~] = find(DT == MinDR);
        if length(rs) == 1
            DF_Computational = DFData(rows(ls),:);
        else
        % If the number of result is not unique, further selection will be
        % needed. But currently I didn't find an exception (in theory there
        % should not have non-unique answer for this selection).
        end
    end
% If the minimum T is not unique (normally, the following parts are not needed)
    if length(rowt) == 1
        DF_Mmeory = DFData(Lt,:);
    else
        Ref = 0;
        Temp = 0;
        DT = zeros(length(rowt),1);
        [DF_Ref] = EDFx2(Stage,Df,Osr);
        Ref = Ref + sum(DF_Ref);
        for n = 1:length(rowt)
            Temp = Temp + sum(DFData(rowt(n)));
            DT(n) = abs(Temp-Ref);
        end
        [MinDT,lt] = min(DT);
        [rt,~] = find(DT == MinDT);
        if length(rt) == 1
            DF_Mmeory = DFData(rowt(lt),:);
        else
        % If the number of result is not unique, further selection will be
        % needed. But currently I didn't find an exception (in theory there
        % should not have non-unique answer for this selection).
        end
    end
end