% EDFx2 is using function CalT instead of CalS

function [DFb] = EDFx2(Stage,Df,D)
    Osr = D;
    f2 = 2-Df;
    alp = f2/(2*Osr);
    R = zeros(1,40);
    Tnt = zeros(1,40);
    Mark = zeros(1,40);
    DFb = zeros(1,Stage);
    
    switch Stage
        case 1
            DFb = Osr;
        case 2
            Q1 = ((2*Osr)/(f2))*(1/(1+((sqrt(2*Osr*Df))/(f2))));
            DFb(1) = Q1;
            Q2 = Osr/DFb(1);
            DFb(2) = Q2;
        case 3
            D1 = sym('D1','positive');
            D2 = ((2*Osr)/(f2))*(1/(D1+((sqrt(2*D1*Osr*Df))/(f2))));
            Y = -((2*Osr)/(Df*(D1^2)*D2))+(1/((1-(alp*D1))^2))+(alp*(sqrt(((2*Osr)/(Df))*(1/D1))*D2));
            S = double(solve(Y == 0, 'D1'));
            X = imag(S);
            S(X ~= 0) = [];
            for i = 1:length(S)
                if S(i) <= Osr && S(i) > 0
                    R(i) = S(i);
                end
            end
            R(R==0) = [];
            R = unique(R);
            DFbTemp = zeros(length(R),3);
            for m = 1:length(R)
                % Stage 1
                DFbTemp(m,1) = R(m);
                % Stage 2
                DFbTemp(m,2) = ((2*Osr)/f2)*(1/(DFbTemp(m,1)+(sqrt(2*DFbTemp(m,1)*Osr*Df)/f2)));
                % Stage 3
                DFbTemp(m,3) = Osr/(DFbTemp(m,1)*DFbTemp(m,2));
                % Delete the result which not ahcieve the requirements
                Temp = DFbTemp(m,:);
                if or(isempty(Temp(Temp<=0)),isempty(Temp(Temp>=Osr)))
                    Tnt(m) = CalT (Df,Stage,Osr,DFbTemp(m,:));
                else
                    Mark(m) = m;
                end
            end
            Tnt(Tnt==0) = [];
            Mark(Mark==0) = [];
            Tnt(Mark) = max(Tnt)*2;
            [~,l] = min(Tnt);
            DFb = DFbTemp(l,:);
    end
end