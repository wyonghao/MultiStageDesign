% Reduce the number of factors

% clear;clc;
% 
% DF = [2 2 2 2 2 2 2 2 2 2 2 2];
% Stage = 2;
% % TElement = [2 3 5;12 3 5];
% [TElement(2,:),TElement(1,:)] = hist(DF,unique(DF));
% [x l] = find(TElement(2,:) == 0);
% TElement(:,l) = [];

function [DF] = ReduceDF (TElement,Stage)
    Temp = TElement;
    Temp1 = [];
    Temp2 = [];
    Temp3 = [];
    Temp4 = [];
    AAA = [];
    BBB = [];

    [r c] = find(TElement(2,:) >= (Stage + 2));

    for n = 1:length(c)%(length(TElement(1,:))-length(c))
        Temp(:,n) = [];
    end

    for m = 1:length(Temp(1,:))
        Temp1(1:Temp(2,m)) = Temp(1,m);
        Temp2 = [Temp2 Temp1];
    end

    for i = 1:length(c)
        if mod(TElement(2,c(i))-Stage,2) == 0
            AAA = [AAA TElement(1,c(i))]; % Test
            Temp3(1:((TElement(2,c(i))-Stage)/2)) = TElement(1,c(i))^2;
            Temp4(1:Stage) = TElement(1,c(i));
        elseif mod(TElement(2,c(i))-Stage,2) == 1
            BBB = [BBB TElement(1,c(i))]; % Test
            Temp3(1:((TElement(2,c(i))-(Stage+1))/2)) = TElement(1,c(i))^2;
            Temp4(1:(Stage+1)) = TElement(1,c(i));
        end
        Temp2 = [Temp2 Temp3 Temp4];
    end
    DF = sort(Temp2);
%     Temp2 = sort(Temp2);
%     [Temp5(2,:),Temp5(1,:)] = hist(Temp2,unique(Temp2));
%     disp(Temp2);
%     disp(Temp5);
end