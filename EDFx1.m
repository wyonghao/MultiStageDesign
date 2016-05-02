function [DFb] = EDFx1(Stage,Df,D)
Osr = D;
f2 = 2-Df;
alp = f2/(2*Osr);
R = zeros(1,40);
Srt = zeros(1,40);
Mark = zeros(1,40);
DFb = zeros(1,Stage);
% Mark = 0;
% DeleteArray = [];
% DeleteArrayDFb = [];

    switch Stage
        case 1
            DFb = Osr;
        case 2
            Q1 = ((2*Osr)/f2)*(1/(1+(sqrt(Osr*Df/f2))));
            DFb(1) = Q1;
%             DFb(1) = panduan(Q1);
            Q2 = Osr/DFb(1);
            DFb(2) = Q2;
%             DFb(2) = panduan(Q2);
        case 3
            D1 = sym('D1','positive');
            D2 = ((2*Osr)/f2)*(1/(D1+sqrt(Osr*Df/f2)*sqrt(D1)));
            Y = -(2/(Df*D2))+(f2/(2*Osr))*((D1^2)/(1-(f2*D1)/(2*Osr))^2)-...
                1/(1-f2*D1*D2/(2*Osr))+(f2/(2*Osr))*...
                ((D1*D2)/(1-f2*D1*D2/(2*Osr))^2);
            S = (solve(Y==0,'D1'));
            X = imag(S);
            S(X ~= 0) = [];
            for i = 1:length(S)
                if S(i) <= Osr && S(i) > 0
                    R(i) = S(i);
                end
            end
            R(R==0) = [];
            DFbTemp = zeros(length(R),3);
            for m = 1:length(R);
                % Stage 1
                DFbTemp(m,1) = R(m);
                % Stage 2
                DFbTemp(m,2) = ((2*Osr)/f2)*(1/(DFbTemp(m,1)+sqrt(Osr*(Df/f2))*sqrt(DFbTemp(m,1))));
                % Stage 3
                DFbTemp(m,3) = Osr/(DFbTemp(m,1)*DFbTemp(m,2));
                % Delete the result which not ahcieve the requirements
                Temp = DFbTemp(m,:);
                if or(isempty(Temp(Temp<=0)),isempty(Temp(Temp>=Osr)))
                    Srt(m) = CalS (Df,Stage,Osr,DFbTemp(m,:));
                else
                    Mark(m) = m;
                end
            end
            Srt(Srt==0) = [];
            Mark(Mark==0) = [];
            Srt(Mark) = max(Srt)*2;
            [~,l] = min(Srt);
            DFb = DFbTemp(l,:);
%             DFb(1) = max(R);%DFb(1) = panduan(max(R));
%             Q2 = ((2*Osr)/f2)*(1/(DFb(1)+sqrt(Osr*(Df/f2))*sqrt(DFb(1))));
%             DFb(2) = Q2;
% %             DFb(2) = panduan(Q2);
%             Q3 = Osr/(DFb(1)*DFb(2));
%             DFb(3) = Q3;
% %             DFb(3) = panduan(Q3);
        case 4
            D1 = sym('D1','positive');
            
            D2 = ((alp*(D1^2))-((alp^2)*(D1^2))+(2*alp*D1)-1)/((alp^2)*(D1^3));

            D3 = ((alp*D1*(D2^2))-((alp^2)*(D1^2)*(D2^2))+(2*alp*D1*D2)-1)/((alp^2)*(D1^2)*(D2^3));

            Y = -(2/(Df*D1*D3))+(f2/(2*D))*((D2^2)/((1-((f2*D1*D2)/(2*D)))^2))...
                -((1/D1)*(1/(1-((f2*D1*D2*D3)/(2*D)))))+((f2/(2*D))*...
                ((D2*D3)/((1-((f2*D1*D2*D3)/(2*D)))^2)));
            
            S = (solve(Y==0,'D1'));
            
            X = imag(S);
            S(X ~= 0) = [];
            for i = 1:length(S)
                if S(i) <= Osr && S(i) > 0
                    R(i) = double(S(i));
                end
%                 if R(i) == 0
%                     DeleteArray = [DeleteArray i];
%                 end
            end

            R(R==0) = [];
            R = unique(R);
            % panduan
            DFbTemp = zeros(length(R),4);
            for m = 1:length(R)
                % Stage 1
                DFbTemp(m,1) = R(m);
%                 if DFbTemp(m,1) <= 0
%                     Mark = 1;
%                 end
                % Stage 2
                Q2 = (alp*(DFbTemp(m,1)^2)-(alp^2)*(DFbTemp(m,1)^2)+2*alp*DFbTemp(m,1)-1)/...
                     ((alp^2)*(DFbTemp(m,1)^3));
                DFbTemp(m,2) = Q2;
%                 if DFbTemp(m,2) <= 0
%                     Mark = 1;
%                 end
                % Stage 3
                Q3 = (alp*DFbTemp(m,1)*(DFbTemp(m,2))^2-(alp^2)*(DFbTemp(m,1)^2)*(DFbTemp(m,2)^2)...
                     +2*alp*DFbTemp(m,1)*DFbTemp(m,2)-1)/((alp^2)*(DFbTemp(m,1)^2)*(DFbTemp(m,2)^3));
                DFbTemp(m,3) = Q3;
%                 if DFbTemp(m,3) <= 0
%                     Mark = 1;
%                 end
                % Stage 4
                Q4 = Osr/(DFbTemp(m,1)*DFbTemp(m,2)*DFbTemp(m,3));
                DFbTemp(m,4) = Q4;
%                 if DFbTemp(m,4) <= 0
%                     Mark = 1;
%                 end
            %     for n = 1:length(DFb(1,:))
            %         if DFb(m,n) <= 0
            %             DeleteArrayDFb = [m,DeleteArrayDFb];
            %         end
            %     end
%                 if Mark == 1
%                     DeleteArrayDFb = [DeleteArrayDFb m];
%                     Mark =0;
%                 end
                % Delete the result which not ahcieve the requirements
                Temp = DFbTemp(m,:);
                if or(isempty(Temp(Temp<=0)),isempty(Temp(Temp>=Osr)))
                    Srt(m) = CalS (Df,Stage,Osr,DFbTemp(m,:));
                else
                    Mark(m) = m;
                end
%                 Srt(m) = CalS (Df,Stage,Osr,DFbTemp(m,:));
            end
            Srt(Srt==0) = [];
            Mark(Mark==0) = [];
            Srt(Mark) = max(Srt)*2;
            [~,l] = min(Srt);
            DFb = DFbTemp(l,:);
            
            % panduan
            
            
%             DFb(1) = max(R);%DFb(1) = panduan(max(R));
% %             DFb(1) = panduan(R,Osr,Stage);
%             Q2 = (alp*(DFb(1)^2)-(alp^2)*(DFb(1)^2)+2*alp*DFb(1)-1)/...
%                  ((alp^2)*(DFb(1)^3));
%             DFb(2) = Q2;
% %             DFb(2) = panduan(Q2);
%             Q3 = (alp*DFb(1)*(DFb(2))^2-(alp^2)*(DFb(1)^2)*(DFb(2)^2)...
%                  +2*alp*DFb(1)*DFb(2)-1)/((alp^2)*(DFb(1)^2)*(DFb(2)^3));
%             DFb(3) = Q3;
% %             DFb(3) = panduan(Q3);
%             Q4 = Osr/(DFb(1)*DFb(2)*DFb(3));
%             DFb(4) = Q4;
% %             DFb(4) = panduan(Q4);
    end
end