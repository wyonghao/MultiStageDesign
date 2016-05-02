% Calculate S in Rt
function [S] = CalS (Df,K,Osr,D)
    
    Sum1 = 1;
    Sum2 = 0;
    Sum2_1 = 1;
    
    for m = 1:K-1
        Sum1 = Sum1*D(m);%*Df;%(m);
        for n = 1:m
            Sum2_1 = Sum2_1*D(n);
        end
        Sum2 = Sum2+(D(m)/(Sum2_1*(1-((2-Df)/(2*Osr))*Sum2_1)));
        Sum2_1 = 1;
    end
    
    Part1 = 2/(Sum1*Df);
    Part2 = Sum2;
    S = Part1+Part2;
       
end