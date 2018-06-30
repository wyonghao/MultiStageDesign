%% Reference Designing different decimation filter. Mathwork code Modified by Y.WANG
% filter specification is from the AD1877 Anolog Devices Sigma-Delta
% data sheet. You can find the data sheet at
% http://www.analog.com/UploadedFiles/Data_Sheets/AD1877.pdf
% The original design has been commented out!
clc;
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

%% Design two lowpass fitlers with Kaiserwin and Equripple(long time)
% the methods can be equiripple ifir kaiserwin and multistage

flowpass=fdesign.decimator(Decimation_Factor,'lowpass',fp0,fs0,...
    Passband_Ripple,Stopband_Attenuation);
Hglowpass_kaiserwin=design(flowpass,'kaiserwin');
% 3658 order, cost 3659  : 3658  : 3648 : 57.1719 : 57.1562
save Hglowpass_kaiserwin Hglowpass_kaiserwin
save filterspec_lowpass flowpass

Hglowpass_equiripple=design(flowpass);
save Hglowpass_equiripple1 Hglowpass_equiripple %N is underestimated, so 81.7 dB and 2921 order

flowpass_eq = flowpass;
%After trial and error, we use the following improved design to match the
%kaiserwin design!! passband Ripple/1.5 and AST 90+1 db
setspecs(flowpass_eq,'Fp,Fst,Ap,Ast', fp0,fs0,Passband_Ripple/1.5,Stopband_Attenuation+1);
Hglowpass_equiripple_improve=design(flowpass_eq);
measure(Hglowpass_equiripple_improve)
save Hglowpass_equiripple2 Hglowpass_equiripple_improve
% RESULT order 3024 COST: : 3024:3023:3008: 47.25 47.2344

%% Design Multistage optimised FIR lowpass
load('filterspec_lowpass.mat');
Hgfir_muti=design(flowpass,'multistage', 'UseHalfbands', true);
% RESULT: 3 stage FIR, Equiripple 8(39)*2(14)*4(193), One halfband, Meet spec.
% cost 243, 240 238, 8.6, 8.4
save Hgfir_muti.mat Hgfir_muti

%% Design Multistage minimum phase FIR
% ?? approch one as just old 
% ?? approach two use nyquist to force all as n-band
FIRstage1=measure(Hgfir_muti.Stage(1));%no problem decimation 8
FIRstage2=measure(Hgfir_muti.Stage(2));%halfband decimation 2
FIRstage3=measure(Hgfir_muti.Stage(3));% we need to limit n//decimation 4

%minphase only with equiripple see Professor Tapio Saramäki, Docent http://www.cs.tut.fi/~ts/ and
%http://www.cs.tut.fi/~ts/FIR_minimumphase.pdf it based on "Design of
%nonrecursive digital filters with minimum phase" by Herrmann, O.; Schuessler, W.;  
fm1 = fdesign.decimator(8,'lowpass',FIRstage1.Fpass, FIRstage1.Fstop,FIRstage1.Apass, FIRstage1.Astop);
hmm1 = design(fm1,'MinPhase',true);
fm2 = fdesign.decimator(2,'halfband',FIRstage2.TransitionWidth,95); %ast 116dB is too high,95 is the best value?
% when design fm2 when spec ast over 96 db the result design is
% regressed!!! such as 90-->91 95-->93 97-->77dB
hmm2 = design(fm2,'MinPhase',true);

%The default spec results in "Incorrect number of zeros on unit circle.
%Algorithm failed." so we specify the order of 3rd stage to make it happen
fm3 = fdesign.decimator(4,'lowpass','n,fc,ap,ast', 194, FIRstage3.F3dB, FIRstage3.Apass, FIRstage3.Astop+10);
%fm3 = fdesign.decimator(4,'lowpass',FIRstage3.Fpass, FIRstage3.Fstop,FIRstage3.Apass, FIRstage3.Astop);
hmm3 = design(fm3,'MinPhase',true); %Result in 93.4dB which is good!

Hfir_minphase = mfilt.cascade(hmm1,hmm2,hmm3);
%RESULT: 8(36)*2(13)*4(194) COST: 246,243,236,8.5, 8.3 VERY GOOD ONE!
save Hfir_minphase_multi_all Hfir_minphase hmm1 hmm2 hmm3

%NEW improved Method using Hilbert MinPhase design YWang
Fir3multi1coe = coeffs(Hgfir_muti.Stage(1));
hfir3multi1coe = minphase2(Fir3multi1coe.Numerator);
Hfir3multimin1 = mfilt.firdecim(8,hfir3multi1coe);

Fir3multi2coe = coeffs(Hgfir_muti.Stage(2));
hfir3multi2coe = minphase2(Fir3multi2coe.Numerator);
Hfir3multimin2 = mfilt.firdecim(2,hfir3multi2coe);

Fir3multi3coe = coeffs(Hgfir_muti.Stage(3));
hfir3multi3coe = minphase2(Fir3multi3coe.Numerator);
Hfir3multimin3 = mfilt.firdecim(4,hfir3multi3coe);

Hfir_minphase_improved = copy(mfilt.cascade(Hfir3multimin1,Hfir3multimin2,Hfir3multimin3));
save Hfir_minphase_multi_improved.mat Hfir_minphase_improved Hfir3multimin1 Hfir3multimin2 Hfir3multimin3


% axis([0 0.03 -120 10])
% axis([0 0.03 -1 1])
% axis([0 0.03 -0.1 0.1])
% axis([0 0.03 -100 1000])
% axis([0 0.03 -100 4000])
% axis([0 0.03 -100 3000])

%% Design the Nyquist filter with same parameters
%YW ?? is half band filter a Nyquist fitler? so we just design the Nyquist
%fitler with all possible ways. Do we need to use other methods?
fnyquist = fdesign.decimator(Decimation_Factor,'nyquist');
Ast = Stopband_Attenuation;
setspecs(fnyquist,Decimation_Factor,TW,Ast);
%YW Hg -> general fitler automatically designed by Matlab
Hnyquist_multi= design(fnyquist, 'multistage');
%YW it acutlly results in 5-stages nyquist filter using equiriplle... the
%maximum stages supported is 5; but we need 6, the fifth is 4bands.
save Hg_Nyquist_5stage Hnyquist_multi;
save fnyquist fnyquist;
%COST: Number of Multipliers   : 203 : 198: 268 : 8.4219: 7.4688

%% Design 6-stage halfband using Nyquist 
% split the 5th stage into 2 stage then Done! see "Pulse Shaping Filter
% Design" example in Matlab for proven 
load('Hg_Nyquist_5stage.mat');
Nyquiststage5 = measure(Hnyquist_multi.stage(5));
fnyquist5 = fdesign.decimator(4,'nyquist');
setspecs(fnyquist5,4,Nyquiststage5.TransitionWidth,Nyquiststage5.astop);
Hhalfband5= design(fnyquist5, 'multistage','NStages',2);

H6halfbandFIR = copy(mfilt.cascade(Hnyquist_multi.stage(1),Hnyquist_multi.stage(2),...
    Hnyquist_multi.stage(3),Hnyquist_multi.stage(4),Hhalfband5));
%RESULT COST:Number of Multipliers : 96 : 90: 168: 6.9531: 5.9688, Very Low
%cost GOOD filter performance
save H6halfbandFIR H6halfbandFIR

%% Design 6-stage minimum phase if halfband is possible
FIR6halfband1=measure(Hnyquist_multi.stage(1));% order 6
FIR6halfband2=measure(Hnyquist_multi.stage(2));% order 10
FIR6halfband3=measure(Hnyquist_multi.stage(3));% order 10
FIR6halfband4=measure(Hnyquist_multi.stage(4));% order 14
FIR6halfband5=measure(Hhalfband5.stage(1)); % order 22
FIR6halfband6=measure(Hhalfband5.stage(2)); % order 106

%1-stage cannot generate the halfband minimum phase so we use the miniphase
%but don't care halfband since it is only 6 order
Fir6hb1coe = coeffs(Hnyquist_multi.stage(1));
hmin61coe = minphase2(Fir6hb1coe.Numerator);
H6min1 = mfilt.firdecim(2,hmin61coe);

%The following method cannot be done so.. 
%Fir6hb2  = fdesign.halfband(FIR6halfband2.TransitionWidth, FIR6halfband2.Astop);%162dB
% H6min2 = design(Fir6hb2,'MinPhase',true);
Fir6hb2coe = coeffs(Hnyquist_multi.stage(2));
hmin62coe = minphase2(Fir6hb2coe.Numerator);
H6min2 = mfilt.firdecim(2,hmin62coe);

% Fir6hb3  = fdesign.halfband(FIR6halfband3.TransitionWidth, FIR6halfband3.Astop-35);%162dB
% H6min3 = design(Fir6hb3,'MinPhase',true);
Fir6hb3coe = coeffs(Hnyquist_multi.stage(3));
hmin63coe = minphase2(Fir6hb3coe.Numerator);
H6min3 = mfilt.firdecim(2,hmin63coe);

Fir6hb4coe = coeffs(Hnyquist_multi.stage(4));
hmin64coe = minphase2(Fir6hb4coe.Numerator);
H6min4 = mfilt.firdecim(2,hmin64coe);

Fir6hb5coe = coeffs(Hhalfband5.stage(1));
hmin65coe = minphase2(Fir6hb5coe.Numerator);
H6min5 = mfilt.firdecim(2,hmin65coe);

Fir6hb6coe = coeffs(Hhalfband5.stage(2));
hmin66coe = minphase2(Fir6hb6coe.Numerator);
H6min6 = mfilt.firdecim(2,hmin66coe);

H6hbFIRmin=copy(mfilt.cascade(H6min1,H6min2,H6min3,...
    H6min4,H6min5,H6min6));

save H6hbFIRmin H6hbFIRmin

FIRresp=fvtool(Hgfir_muti,Hfir_minphase,H6hbFIRmin,Hfir_minphase_improved,'Fs',Input_Sampling_Rate);
% FIRresp=fvtool(h,hmhalf,hmminFIR,sixfirhalfband,'Fs',Input_Sampling_Rate);
legend(FIRresp, 'Multistage FIR', '3 stage minimum phase FIR',...
  '6 Halfband FIR Min', '3 stage minimum phase FIR improved');

axis([0 0.03 -1 1]) % Magnitude scale
axis([0 0.03 -100 4000]) %Group delay scale 

%% CIC decimation filter design
load('Hgfir_muti.mat');
D = 1;  % Differential delay =1 
fcic = fdesign.decimator(Decimation_Factor,'CIC',D,Passband,Ast,Input_Sampling_Rate);
 % is 4 sections enough??
Hcic = design(fcic); %gain needs t be normalised

Hcic_nor = mfilt.cascade(dfilt.scalar(1/gain(Hcic)),Hcic);

fciccomp= fdesign.ciccomp(Hcic.differentialdelay, ...
            Hcic.numberofsections,Passband,24000,Passband_Ripple,Ast,Fs);
% Stopband is greater than the 0.5 Fs/m, so we use 24000

%Hciccomp = design(fciccomp,'equiripple','StopBandShape','linear','StopBandDecay',20);
Hciccomp = design(fciccomp,'equiripple');
%Hciccomp=FIRminphase_decimator(Hciccomp,1);
Hcic_all=mfilt.cascade(Hcic_nor, Hciccomp);
save Hcic_all Hcic_all Hciccomp Hcic_nor;

fvtool(Hcic_all,Hgfir_muti,'Fs', Input_Sampling_Rate);

%% axis([0 0.03 -1 1]) % Magnitude scale
axis([0 0.1 -300 10]) % Magnitude scale
axis([0 0.03 -100 4000]) %Group delay scale 


%% IIR Lowpass multistage--with mixed FIR initally-------------------------
load('fnyquist.mat');

Hmiirpoly = design(fnyquist,'multistage','HalfbandDesignMethod','ellip');
Hmiirlin = design(fnyquist,'multistage','HalfbandDesignMethod','iirlinphase');
% they both have FIR filter on stage(5) so we redesign stage 5.

%% IIR elliptic poly:
iirstage5measure = measure(Hmiirpoly.Stage(5));
iir5m = fdesign.decimator(4,'nyquist');
setspecs(iir5m,4,iirstage5measure.TransitionWidth,iirstage5measure.astop);
HmiirpolyStage5 = design(iir5m,'multistage','HalfbandDesignMethod','ellip');

Hmiirpolyfinal6stages = copy(mfilt.cascade(Hmiirpoly.Stage(1),Hmiirpoly.Stage(2),Hmiirpoly.Stage(3),...
    Hmiirpoly.Stage(4),HmiirpolyStage5.stage(1),HmiirpolyStage5.stage(2)));
%RESULT COST: Number of Multipliers : 19 : 38 : 30 : 1.6719: 3.3438
save Hmiirpolyfinal6stages Hmiirpolyfinal6stages;

fvtool(Hmiirpolyfinal6stages);

%% IIR quasi-Linear:
iirlinstage5measure = measure(Hmiirlin.Stage(5));
iirlin5m = fdesign.decimator(4,'nyquist');
setspecs(iirlin5m,4,iirlinstage5measure.TransitionWidth,85); 
%order greater than 85 the algorithm fail to converge
HmiirlinStage5 = design(iirlin5m,'multistage','HalfbandDesignMethod','iirlinphase');

Hmiirlinfinal6stages = copy(mfilt.cascade(Hmiirlin.Stage(1),Hmiirlin.Stage(2),Hmiirlin.Stage(3),...
   Hmiirlin.Stage(4),HmiirlinStage5.stage(1),HmiirlinStage5.stage(2)));
%RESULT COST: Number of Multipliers : 19 : 38 : 30 : 1.6719: 3.3438
save Hmiirlinfinal6stages Hmiirlinfinal6stages;

fvtool(Hmiirpolyfinal6stages,Hmiirlinfinal6stages);

%% REFERENCE
% Matlab Pulse Shaping Filter Design for cost matrix!
% Matlab FIR Halfband Filter Design
% IIR Polyphase Filter Design