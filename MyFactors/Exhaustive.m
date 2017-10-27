% This function is separate the original prime number array A into two
% matrix A1 and A2. One of them is the list of every possible combinations
% of k elemetns, and the other one is just list the elements which are not
% be chosen by the fist array. This step is a preparation step of next
% combination step.
% _________________________________________________________________________
%| Inputs|                          Definitions                           |
%|_______|________________________________________________________________|
%|  A    |      Prime number array (decimation or interpolation rates for |
%|       |      each stages), their product (the result of multiply each  |
%|       |      of them together) is equal to the oversampling rate.      |
%|_______|________________________________________________________________|
%|  k    |      Number of stage (how many stages that filter has)         |
%|_______|________________________________________________________________|
% _________________________________________________________________________
%|Outputs|                          Definitions                           |
%|_______|________________________________________________________________|
%|  A1   |      Output matrix A1 is a matrix which list the remaining     |
%|       |      elements (not be chosen by the output matrix A2).         |
%|_______|________________________________________________________________|
%|  A2   |      Output matrix A2 is a matrix which list every possible    |
%|       |      combinations of k elements (all elements are come from the|
%|       |      prime number array and each of element can only be used   |
%|       |      once).                                                    |
%|_______|________________________________________________________________|

function [A1,A2] = Exhaustive (A,k)

    L = length(A);
    Temp = perms(A);            % Full permutation of prime number array
    
%     for i = 1:k                 % Cut the prime number matrix and make the first k column to be matrix A2
%         TempA2(:,i) = Temp(:,i);
%     end
    TempA2 = Temp(:,1:k);

%     for j = 1:L-k               % Make the rest column to be matrix A1
%         TempA1(:,j) = Temp(:,j+k);
%     end
    TempA1 = Temp(:,k+1:L);

    [A2,ia,ic] = unique(TempA2,'rows');     % Remove the duplicate arrays in A2

%     for m = 1:length(A2(:,1))        % Extract the corresponding arrays in A1
%         A1(m,:) = TempA1(ia(m),:);
%     end
    A1 = TempA1(ia,:);
    
end