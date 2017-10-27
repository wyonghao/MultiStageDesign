% Sorting Set

function DFData = SortingSet (Osr,Stage)
    [NSMax TElement DFTemp] = Factorization(Osr);
    if Stage >= NSMax
        if Stage > NSMax
            disp(sprintf('Warning: Only %d stages is available, the input stage number is %d\n',NSMax, Stage));
        elseif Stage == NSMax
            disp('MSG: Unique set found!');
        end
        DFunsorted = factor(Osr);
        DFTemp = fliplr(DFunsorted); % we need number desending"
    else
        if length(find(TElement(2,:)>=(Stage+2))) >= 1
            DFTemp = [];
            [DFTemp] = ReduceDF (TElement,Stage);
        end
        [Matrix_Possible_Combination] = PossibleCombinations (DFTemp,Stage,Osr);
        DFTemp = unique(fliplr(sort(Matrix_Possible_Combination')'),'rows');
    end
    DFData = DFTemp;
end