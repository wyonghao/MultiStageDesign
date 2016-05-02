% Find Decimation Factors Database

function [DF_Computational,DF_Mmeory,DFData] = FindDFData(Factors,TElement,NSMax,Stage,Df_Ref,Osr)
    if NSMax == Stage
        DF_Computational = fliplr(Factors);
        DF_Mmeory = DF_Computational;
        DFData = DF_Computational;
    else
        if length(TElement(2,:)>=(Stage+2))>=1
            Factors = ReduceDF (TElement,Stage);
            TElement = [];
            [TElement(2,:),TElement(1,:)] = hist(Factors,unique(Factors));
            [~,c] = find(TElement(2,:) == 0);
            TElement(:,c) = [];
        end
        [DFData] = FindCombonations (Factors,TElement,Stage);
        DF_Computational = zeros(length(Df_Ref),Stage);
        DF_Mmeory = zeros(length(Df_Ref),Stage);
        for i = 1:length(Df_Ref)
            [DF_Computational(i,:),DF_Mmeory(i,:)] = ...
                    DFSelection_multi(DFData,Df_Ref(i),Osr,Stage);
        end
    end
end