function DatabaseCreation (DtRange,DfRange,Stage)
    % Process Input Parameters
    RefHz = 1/24000;
    if nargin == 0
        DtRange = [1,5000];
        DfRange = [RefHz,0.5+RefHz];
        Stage = [2,3,4];
    elseif nargin == 1
        DfRange = [RefHz,0.5+RefHz];
        Stage = [2,3,4];
    elseif nargin == 2
        Stage = [2,3,4];
    end
    Dt_Range = DtRange(1):DtRange(2);
    if DfRange(2)-DfRange(1) <= 0.2
        Df_Ref = DfRange(1):(DfRange(2)-DfRange(1))/2:DfRange(2);
        Df_Ref = unique([Df_Ref,DfRange(2)]);
    else
        Df_Ref = DfRange(1):0.1:DfRange(2);
        Df_Ref = unique([Df_Ref,DfRange(2)]);
    end
    % Initial Global Variables
    Dt = cell(1,length(Stage));
    DFData = cell(1,length(Stage));
    Factors = cell(1,length(Stage));
    TElement = cell(1,length(Stage));
    NSMax = cell(1,length(Stage));
    DF_Computational = cell(1,length(Stage));
    DF_Memory = cell(1,length(Stage));
	Final_Df_C = cell(1,length(Stage));
    Final_Df_M = cell(1,length(Stage));
    Final_DF_Computational = cell(1,length(Stage));
    Final_DF_Memory = cell(1,length(Stage));
    % Database Creation
    for i = 1:length(Stage)
        [Dt{i},Factors{i},TElement{i},NSMax{i}] = FindPossibleDt(Dt_Range,Stage(i));
        DFData{i} = cell(length(Dt{i}),1);
        DF_Computational{i} = cell(length(Dt{i}),1);
        DF_Memory{i} = cell(length(Dt{i}),1);
        Final_DF_Computational{i} = cell(length(Dt{i}),1);
        Final_DF_Memory{i} = cell(length(Dt{i}),1);
        Final_Df_C{i} = cell(length(Dt{i}),1);
        Final_Df_M{i} = cell(length(Dt{i}),1);
        for j = 1:length(Dt{i})
            [DF_Computational{i}{j},DF_Memory{i}{j},DFData{i}{j}] ...
             = FindDFData(Factors{i}{j},TElement{i}{j},...
                          NSMax{i}{j},Stage(i),Df_Ref,Dt{i}(j));
            if length(DF_Computational{i}{j}(:,1)) == 1
                DF_Computational{i}{j} = repmat(DF_Computational{i}{j},length(Df_Ref),1);
            end
            if length(DF_Memory{i}{j}(:,1)) == 1
                DF_Memory{i}{j} = repmat(DF_Memory{i}{j},length(Df_Ref),1);
            end
            [TempUniqueSets_C,ia_c,~] = unique(DF_Computational{i}{j},'stable','rows');
            [TempUniqueSets_M,ia_m,~] = unique(DF_Memory{i}{j},'stable','rows');
            TempChangingTimes_C = length(ia_c);
            TempChangingTimes_M = length(ia_m);
            if TempChangingTimes_C > 1
                [Final_DF_Computational{i}{j},Final_Df_C{i}{j}] = FindChangingDf(TempUniqueSets_C,ia_c,Df_Ref,RefHz,Dt{i}(j),Stage(i),'C');
            else
                Final_DF_Computational{i}{j} = repmat(DF_Computational{i}{j}(1,:),2,1);
                Final_Df_C{i}{j} = [Df_Ref(1),Df_Ref(end)];
            end
            if TempChangingTimes_M > 1
                [Final_DF_Memory{i}{j},Final_Df_M{i}{j}] = FindChangingDf(TempUniqueSets_M,ia_m,Df_Ref,RefHz,Dt{i}(j),Stage(i),'M');
            else
                Final_DF_Memory{i}{j} = repmat(DF_Memory{i}{j}(1,:),2,1);
                Final_Df_M{i}{j} = [Df_Ref(1),Df_Ref(end)];
            end
        end
    end
    DesignInfo.Stage = Stage;
    DesignInfo.DRange = DtRange;
    DesignInfo.DfRange = DfRange;
    DesignInfo.D = Dt;
    DesignInfo.Type = ['C','M'];
    save('Database.mat','DesignInfo','Final_DF_Computational','Final_DF_Memory','Final_Df_C','Final_Df_M');
end