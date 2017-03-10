
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
xmean = [8000 38 0.2863 4641 2.00E-05*ksatcvt];  
xsd = [3000 4 0.065 8808 1.55E-05*ksatcvt];
 xcov = xsd./xmean;
corrMatrix=[1,0,0,0,0
    0,1,0,0,0
    0,0,1,0,0
    0,0,0,1,0
    0,0,0,0,1];
xr = corrMatrix;

Cx=(xsd'*xsd).*corrMatrix;
for i=1:length(xmean)
           kexi(i)=sqrt(log(1+(xsd(i)/xmean(i))^2)) ;
           lamda(i)=log(xmean(i))-0.5*kexi(i)^2;
end

PARADIR = [1 1 -1 1 -1];


totalNum = 50;
lowerBound = -3;
upperBound = 0.25;
lbdir = lowerBound*PARADIR;
ubdir = upperBound*PARADIR;

for i = 1:length(PARADIR)
  xmin(i)=exp(lamda(i)+lbdir(i)*kexi(i));
  xmax(i)=exp(lamda(i)+ubdir(i)*kexi(i));
end


orgPara_notscreened = lhsu(xmin,xmax,totalNum);


% program settings
TEMPRSTNAME = 'fosList.dat';
PAUSE_FLAC = 1;
TEMPLOC = [exeFolder '\temp.txt'];
INILOC = [exeFolder '\flac.ini'];
FLACCMD = 'call ';
FLACF_NAME = ['rainfallfos1.dat';'rainfallfos2.dat';'rainfallfos3.dat';'rainfallfos4.dat'];
%FLACF_NAME = ['rainfall1.dat';'rainfall2.dat';'rainfall3.dat';'rainfall4.dat'];
RSTF_NAME = ['result1.txt';'result2.txt';'result3.txt';'result4.txt'];
FLAG = 4;
% program settings


% sstv structure
% rainfall amount: unit 1e-4
% rainfall time: unit hour
% initial suction: unit kpa ; positive
sstv = [0.75 2 5
        1.25 2 5
        0.25 2 5
        0.5 2 5
        1 5 5
        1 3 5
        1 4 15
        1 4 25
        1 4 20
        1 1 5];
[sstvm,sstvn] = size(sstv);

for sstv_id = 1:sstvm
    
  testl = 0;
  testu = 3.5;
  %orgPara = betascreen(orgPara_notscreened,testl,testu);
  %size(orgPara)
  orgPara = orgPara_notscreened;
  
  % program parameters
  circlePara = addNum(orgPara);
  % program parameters

  check_flacenv
  flacscript


end





