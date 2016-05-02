% Find Changing Df

function [DFData,Df_add] = FindChangingDf(TempSets_C,ia,Df_Ref,RefHz,Osr,Stage,Mode)

    points = ((length(ia)+1)*2)-2;
    Temp_Df = Df_Ref(ia);
    
    Df_add = zeros(1,points);
    DFData = zeros(points,length(TempSets_C(1,:)));
    
    for i = 2:length(Temp_Df)
        if ~isequal(TempSets_C((i-1),:),TempSets_C((i),:))
            Df_Previous = Temp_Df(i-1);
            Df_Current = Temp_Df(i);
            DF_Previous = TempSets_C((i-1),:);
            DF_Current = TempSets_C(i,:);
            switch Mode
                case 'C'
                    while 1%(Df_Current-Df_Previous) > RefHz
                        Df_Temp = Df_Previous+((Df_Current-Df_Previous)/2);
                        [DF_Temp,~] = DFSelection_multi([DF_Previous;DF_Current],Df_Temp,Osr,Stage);
                        if isequal(DF_Temp,DF_Previous)
                            Df_Previous = Df_Temp;
                            DF_Previous = DF_Temp;
                        elseif isequal(DF_Temp,DF_Current)
                            Df_Current = Df_Temp;
                            DF_Current = DF_Temp;
                        end
                        if (Df_Current-Df_Previous) <= RefHz
                            break;
                        end
                    end
                case 'M'
                    while 1%(Df_Current-Df_Previous) > RefHz
                        Df_Temp = Df_Previous+((Df_Current-Df_Previous)/2);
                        [~,DF_Temp] = DFSelection_multi([DF_Previous;DF_Current],Df_Temp,Osr,Stage);
                        if isequal(DF_Temp,DF_Previous)
                            Df_Previous = Df_Temp;
                            DF_Previous = DF_Temp;
                        elseif isequal(DF_Temp,DF_Current)
                            Df_Current = Df_Temp;
                            DF_Current = DF_Temp;
                        end
                        if (Df_Current-Df_Previous) <= RefHz
                            break;
                        end
                    end
            end
            Df_add(i*2-2) = Df_Previous;
            Df_add(i*2-1) = Df_Current;
            DFData(i*2-2,:) = DF_Previous;
            DFData(i*2-1,:) = DF_Current;
        end
    end
    Df_add(1) = Df_Ref(1);
    Df_add(end) = Df_Ref(end);
    DFData(1,:) = TempSets_C(1,:);
    DFData(end,:) = TempSets_C(end,:);
end