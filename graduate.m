
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
xsd = [4000 6 0.065 8808 1.55E-05*ksatcvt];
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


totalNum = 100;
lowerBound = -4;
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
FLACF_NAME = ['rainfall1.dat';'rainfall2.dat';'rainfall3.dat';'rainfall4.dat'];
RSTF_NAME = ['result1.txt';'result2.txt';'result3.txt';'result4.txt'];
FLAG = 4;
% program settings


for i = 4:5
  ztemp = zeros(1,5);
  ztemp(1,i) = -1;
  testfp(i,:) = getx(ztemp);
  rvsfp(i,:) = binary_flac(testfp(i,:));
end



% sstv structure
% rainfall amount: unit 1e-7
% rainfall time: unit hour
% initial suction: unit kpa ; positive
sstv = [2 24 10
        2 48 10
        2 72 10];
[sstvm,sstvn] = size(sstv);

for sstv_id = 1:sstvm
    
  testl = 0;
  testu = 5;
  orgPara = betascreen(orgPara_notscreened,testl,testu);
  orgPara(:,3) = tempa;

  % program parameters
  circlePara = addNum(orgPara);
  % program parameters

  check_flacenv
  flacscript


end





