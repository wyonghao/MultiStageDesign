function Num_Df = FindDf (DfData,Num_Stage,Num_D,Df)
    TempDf = DfData{Num_Stage}{Num_D};
    Temp = Df - TempDf;
    Num_Df = length(Temp(Temp >= 0))+1;
end