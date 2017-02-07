
clear
clc

% program interface
% paremeters : mean cov sd cm
% circle time : totalNum
% file system: datafolder,exefolder,codefolder
global xmean xcov xsd corrMatrix xr
global totalNum
global dataFolder exeFolder codeFolder

dataFolder = 'F:\graduate\data';
exeFolder = 'E:\biye\FLAC700_002\Exe32';
codeFolder = 'F:\graduate';


ksatcvt = 1.03e-3;
% interface
xmean = [8000 38 1-0.2863 4641 2.00E-05*ksatcvt];  
xsd = [4000 6 0.065 8808 1.55E-05*ksatcvt];
 xcov = xsd./xmean;
corrMatrix=[1,0,0,0,0
    0,1,0,0,0
    0,0,1,0,0
    0,0,0,1,0
    0,0,0,0,1];
xr = corrMatrix;

totalNum = 100;
lowerBound = -4;
upperBound = 0.25;

% program settings
TEMPRSTNAME = 'fosList.dat';
PAUSE_FLAC = 1;
TEMPLOC = [exeFolder '\temp.txt'];
INILOC = [exeFolder '\flac.ini'];
FLACCMD = 'call ';
FLACF_NAME = ['rainfall1.dat';'rainfall2.dat';'rainfall3.dat';'rainfall4.dat'];
RSTF_NAME = ['result1.txt';'result2.txt';'result3.txt';'result4.txt'];
FLAG = 4;
% program settings

orgPara_notscreened = genParaFun(lowerBound,upperBound);

% sstv structure
% rainfall amount: unit 1e-7
% rainfall time: unit hour
% initial suction: unit kpa ; positive
sstv = [2 36 10
        2 72 10];
[sstvm,sstvn] = size(sstv);

for sstv_id = 1:sstvm

  orgPara = betascreen(orgPara_notscreened,1,4);
  tempa = 1-orgPara(:,3);
  orgPara(:,3) = tempa;

  % program parameters
  circlePara = addNum(orgPara);
  % program parameters

  check_flacenv
  flacscript


end





