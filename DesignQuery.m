function DesignQuery(D,Df,K,Type)
    load('Database.mat');
    Num_Stage = find(DesignInfo.Stage == K);
    if ~ismember(K,DesignInfo.Stage)
        if length(DesignInfo.Stage) == 1
            fprintf('Stage can only be chosen as %d Stage',DesignInfo.Stage);
        else
            fprintf('Cannot find Stage %d in Database.\nPlease select one within %d-%d\n'...
                    ,K,min(DesignInfo.Stage),max(DesignInfo.Stage));
        end
    elseif Df < min(DesignInfo.DfRange) || Df> max(DesignInfo.DfRange)
        fprintf('Cannot find Df = %f in Database.\nPlease select one within %f-%f\n'...
                ,Df,DesignInfo.DfRange(1),DesignInfo.DfRange(2));
    elseif D < DesignInfo.D{Num_Stage}(1) || D > DesignInfo.D{Num_Stage}(end)
        fprintf('Cannot find D = %d in Database.\nPlease select one within %d-%d\n'...
                ,D,DesignInfo.DRange(1),DesignInfo.DRange(2));
    elseif ~ismember(Type,DesignInfo.Type)
        fprintf('Cannot find current input type in Database. \nPlease select one from');
        fprintf(' ''%c''',DesignInfo.Type);
        fprintf('\n');
    else
        Num_D = find(DesignInfo.D{Num_Stage} == D);
        if Type == 'C'
            Num_Df = FindDf(Final_Df_C,Num_Stage,Num_D,Df);
            DF = Final_DF_Computational{Num_Stage}{Num_D}(Num_Df,:);
            Typename = 'computational cost';
        elseif Type == 'M'
            Num_Df = FindDf(Final_Df_M,Num_Stage,Num_D,Df);
            DF = Final_DF_Memory{Num_Stage}{Num_D}(Num_Df,:);
            Typename = 'memory usage';
        end
        Delta = char(916);
        fprintf('The optimal %s decimation rate is:\n[%s] (%d-Stage, %sf = %.3f, D = %d)\n'...
                ,Typename,num2str(DF),K,Delta,Df,D);
    end
end