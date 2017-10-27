% Test
function [Matrix_Possible_Combination] = PossibleCombinations (A,k,Osr)
    % clear;                  % Clear the workspace
    % clc;                    % Clear the command window

    % Osr = 2310;             % Set the oversampling rate to XXXX
    % k = 3;                  % Set the stage to X

%     A = factor(Osr);          % Find out the prime number array

%     if length(A) < k                % Error message and message box
%         asm = NET.addAssembly('System.Windows.Forms');
%         import System.Windows.Forms.*;
%         MessageBox.Show('Please reduce the stage number!','Overflow');
%         ['Maximum available stage number is: ',num2str(length(A(1,:)))]
%     end

%     if k == 1               % If the filter is signal stage filter
% 
%         Matrix_Possible_Combination = Osr;
% 
%     elseif k == length(A)   % If the number of stage is equal to the length of array
% 
%         Matrix_Possible_Combination = perms(A);
%         [Matrix_Possible_Combination,ia,ic] = unique(Matrix_Possible_Combination,'rows');
% 
%     else                    % If the number of stage is less than the length of array (not equal to one)
        [A1,A2] = Exhaustive (A,k);	% 

        [Temp_Matrix_Possible_Combination] = LastStep (A1,A2);

        [Matrix_Possible_Combination] = CheckandExport (Temp_Matrix_Possible_Combination,Osr);

%     end
    
end