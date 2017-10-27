% Subfunction to calculate if Osr can be separate into Stage parts

function [NSMax TElement TempD] = Factorization(Osr)
    NSMax = 0;
    TempD = factor(Osr);
    [TElement(2,:),TElement(1,:)] = hist(TempD,unique(TempD));
    
    [r c] = find(TElement(2,:) == 0);
    TElement(:,c) = [];

    NSMax = sum(TElement(2,:));
end