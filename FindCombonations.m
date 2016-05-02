% Possible Combinations

function [DFCombinations] = FindCombonations (Factors,TElement,Stage)

    A1 = nchoosek(Factors,Stage);
    A1 = unique(sort(A1,2),'rows');
    A2 = zeros(length(A1(:,1)),length(Factors)-Stage);
    TElementA1 = cell(length(A1(:,1)),1);
    TElementA2 = cell(length(A1(:,1)),1);
% Separate factors into two parts
    for i = 1: length(A1(:,1))
        [TElementA1{i}(2,:),TElementA1{i}(1,:)] = hist(A1(i,:),TElement(1,:));
        [~,c] = setdiff(TElementA1{i}(1,:),TElement(1,:));
        TElementA1{i}(:,c) = [];
        TElementA2{i}(1,:) = TElement(1,:);
        TElementA2{i}(2,:) = TElement(2,:) - TElementA1{i}(2,:);
        [~,c1] = find(TElementA2{i}(2,:)==0);
        TElementA2{i}(:,c1) = [];
        for j = 1:length(TElementA2{i}(1,:))
            if j == 1
                A2(i,1:TElementA2{i}(2,j)) = TElementA2{i}(1,j);
            else
                A2(i,(1+sum(TElementA2{i}(2,1:(j-1)))):sum(TElementA2{i}(2,1:j))) = TElementA2{i}(1,j);
            end
        end
    end
% Permutation
    TempMatrixA1 = A1;
    TempMatrixA2 = A2;
    for n = 1:length(A2(1,:))
        RowN = length(TempMatrixA1(:,1));
        TempMatrixA1 = repmat(TempMatrixA1,Stage,1);
        TempMatrixA2 = repmat(TempMatrixA2,Stage,1);
        for m = 1:Stage
            if m == 1
                TempMatrixA1(1:RowN,m) = TempMatrixA1(1:RowN,m).*TempMatrixA2(1:RowN,n);
            else
                TempMatrixA1(((RowN*(m-1))+1):(RowN*m),m) = TempMatrixA1(((RowN*(m-1))+1):(RowN*m),m).*TempMatrixA2(((RowN*(m-1))+1):(RowN*m),n);
            end
        end
    end
% Delete duplicated array
    DFCombinations = fliplr(unique(sort(TempMatrixA1,2),'rows'));
end