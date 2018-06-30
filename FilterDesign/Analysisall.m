%% set basic values and load all fitlers
Decimation_Factor=64;
Passband_Ripple=.006; %dB
Stopband_Attenuation=90; %dB
Fs=48e3;
Passband=21.6e3;  %Hz
Stopband=26.4e3; %Hz
Input_Sampling_Rate = Decimation_Factor*Fs;

% calculate normalised frequencies
fp0 = Passband/(Input_Sampling_Rate/2);
fs0 = Stopband/(Input_Sampling_Rate/2);
TW = (Stopband-Passband)/(Input_Sampling_Rate/2);
Ast = Stopband_Attenuation;

%cost table:
% Filter  NM  NA  M/I  A/I
% Kaiser  3659  3658  57.1719   57.1562
% Eqrip  3024  3023  47.25  47.2344
% 3-stage  243  240  8.5938  8.3906
% 3-min  249  246  8.9688  8.7656
% CIC  1  38  1  19.2969
% CICom  109  145  2.6875  20.9688
% 6hb  96  90  6.9531  5.9688
% 6hbmin  174  168  10.9531  9.9688
% 6IIR  19  38  1.6719  3.3438
% 6IIRlin  33  66  1.9062  3.8125
% Table 5 Implementation cost of different filters 

%no.    code        varname                 order
load('Hglowpass_kaiserwin'); 
%a)    kaiser      Hglowpass_kaiserwin     3658

load('Hglowpass_equiripple2');
%b)    Eqrip   Hglowpass_equiripple_improve 3023

load('Hgfir_muti.mat');
%c)    3-stage  Hgfir_muti              39+14+193=246

load('Hfir_minphase_multi_improved.mat');
%d)    3-min    Hfir_minphase_improved  39+14+193=246

load('Hcic_all');
%e)    CIC      Hcic_nor    (1 scalar + 19 sections) 
%f)    CICom    Hcic_all    (CIC+107 FIR filter)

load('H6halfbandFIR');
%g)    6hb      H6halfbandFIR   6+10+10+14+22+106=168 
load('H6hbFIRmin');
%h)    6hbmin   H6hbFIRmin      6+10+10+14+22+106=168

load('Hmiirpolyfinal6stages');
%i)    6IIR     Hmiirpolyfinal6stages (most of 2nd order)

load('Hmiirlinfinal6stages');
%j)   6IIRlin   Hmiirlinfinal6stages (2nd order, lastone 9 sections 2nd
%order)

%Latency estimation table at 48khz
% Group delay for linear phase filters
% Kaiser  1829  595
% Eqrip  1511.5  492
% 3-stage  1619.5  527
% CIC  598.5  195
% CICom  4022.5  1309
% 6hb  1961  638
% 6IIRlin  1514  493
% Group Delay for nonlinear phase filters
% 3-min  155 - 380  50 - 123
% 6hbmin  164.4 - 387  53 - 126
% 6IIR  176.6 – 410.5  57 - 134
% Table 4 Group delay of different evaluated filters 

%% finished loading

NFIR = FIRdecimatord(Passband_Ripple,db2mag(-Ast),Stopband-Passband,Input_Sampling_Rate);
disp(NFIR)

order(Hglowpass_equiripple_improve)


FIRresp=fvtool(Hgfir_muti, Hfir_minphase_improved, Hglowpass_equiripple_improve,Hglowpass_kaiserwin,'Fs',Input_Sampling_Rate);
% FIRresp=fvtool(h,hmhalf,hmminFIR,sixfirhalfband,'Fs',Input_Sampling_Rate);
legend(FIRresp, '3-stage FIR','3-stage minphase FIR ', 'equiripple FIR',...
   'Kaiserwin FIR');
% axis([0 0.03 -0.02 0.02])
% axis([0 0.03 -100 10])
% axis([0 0.03 -0.1 0.1])
% axis([0 0.03 -100 1500])
axis([0 0.04 -120 10])
% axis([0 0.03 -100 3000])

FIRresp=fvtool(Hgfir_muti, Hfir_minphase_improved,Hcic_all,'Fs',Input_Sampling_Rate);
% FIRresp=fvtool(h,hmhalf,hmminFIR,sixfirhalfband,'Fs',Input_Sampling_Rate);
legend(FIRresp, '3-stage FIR','3-stage minphase FIR ', 'CIC with compensator');
axis([0 0.03 -100 10])


FIRresp=fvtool(H6hbFIRmin, Hfir_minphase_improved,'Fs',Input_Sampling_Rate);
legend(FIRresp, '6-stage Halfband MinPhase FIR','3-stage minphase FIR ');
axis([0 0.03 -100 10])


FIRresp=fvtool(Hmiirpolyfinal6stages, H6hbFIRmin, Hfir_minphase_improved,'Fs',Input_Sampling_Rate);
legend(FIRresp,'6-stage Halfband IIR filter', '6-stage Halfband MinPhase FIR','3-stage minphase FIR ');
axis([0 0.025 -0.01 0.01])

%% CIC figures

FIRresp=fvtool(Hgfir_muti, Hcic_all, 'Fs',Input_Sampling_Rate);
legend(FIRresp,'3-stage FIR', 'CIC with compensator');


%% halfband plot
FIRresp=fvtool( H6hbFIRmin, Hfir_minphase_improved,'Fs',Input_Sampling_Rate);
legend(FIRresp, '6-stage Halfband MinPhase FIR','3-stage minphase FIR ');
axis([0 0.025 -0.006 0.006])

%% IIR plot
FIRresp=fvtool( Hmiirpolyfinal6stages, Hmiirlinfinal6stages, Hfir_minphase_improved,'Fs',Input_Sampling_Rate);
legend(FIRresp, '6-stage Halfband IIR filter','6-stage quasilinear IIR','3-stage minphase FIR ');
axis([0 0.025 -0.006 0.006])

%% group delay eq with IIR fitler 3-min compare with 3min and 3stage
F0=0;
F1=15000/24000;
F2=20000/24000;
N1 = 8;         % Filter order
N2 = 10;       % Alternate filter order
F = [F0 F1 F2 1]; % Frequency vector
Gd = [2 1 0 0];  % Desired group delay
R = 0.99;      % Pole-radius constraint
hiirall = fdesign.arbgrpdelay('N,F,Gd',N1,F,Gd);
H1 = design(hiirall,'MaxPoleRadius',R);
newtest =mfilt.cascade(Hfir_minphase_improved,H1);
save newtest
load('newtest')
IIRlinearRe=fvtool(Hgfir_muti, Hfir_minphase_improved, newtest,'Fs',Input_Sampling_Rate);
% FIRresp=fvtool(h,hmhalf,hmminFIR,sixfirhalfband,'Fs',Input_Sampling_Rate);
legend(IIRlinearRe, '3-stage FIR','3-stage minphase FIR ','3-Min with linear phase');
% axis([0 0.03 -0.02 0.02])
% axis([0 0.03 -100 10])
% axis([0 0.03 -0.1 0.1])
axis([0 0.03 -100 2000])
% axis([0 0.04 -120 10])
% axis([0 0.03 -100 3000])
