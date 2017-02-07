
clear
clc

% program interface
% paremeters : mean cov sd cm
% circle time : totalNum
% file system: datafolder,exefolder,codefolder
global xmean xcov xsd corrMatrix xr
global totalNum
global dataFolder exeFolder codeFolder


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
totalNum = 1000;
dataFolder = 'F:\mjz\svm\reliability1206\data';
exeFolder = 'F:\mjz\svm\FLAC700_001\Exe32';
codeFolder = 'F:\mjz\svm\reliability1206';
lowerBound = -4;
upperBound = 0.5;



orgPara_notscreened = genParaFun(lowerBound,upperBound);
orgPara = betascreen(orgPara_notscreened,2.5,5);
% save .\data\example_01.txt -ASCII -DOUBLE orgPara
% xlswrite('.\data\example_01.xls',orgPara)
tempa = 1-orgPara(:,3);
orgPara(:,3) = tempa;

circlePara = addNum(orgPara);
% iniResult = circulSlope(circlePara);
% iniResult = circulSlopeAsynchronous(circlePara);

F = circlePara

    
    tempLocation = [exeFolder '\temp.txt'];
    iniLocation = [exeFolder '\flac.ini'];

    temp = 0;
    fosList = [0 0 0 0 0 0 0];
    FLAG = 4;
    i = 1;

cd(exeFolder);

flaccmd = 'call ';
flacf_name = ['rainfall1.dat';'rainfall2.dat';'rainfall3.dat';'rainfall4.dat'];
rstf_name = ['result1.txt';'result2.txt';'result3.txt';'result4.txt'];

while i <totalNum
  flagcount = 0;
  while flagcount<FLAG
      flagcount=flagcount+1;
      para=[F(i,:)];
      dlmwrite(tempLocation,para,'delimiter','\t','newline','pc');
      fosListFile = fopen(iniLocation,'w');
      try
          fprintf(fosListFile,[flaccmd flacf_name(flagcount,:)]);
      catch
          disp('fuck!!!!!!!!!!!!!!!!');
      end
      fclose(fosListFile);
      pause(1.5)
      open flac700.exe
      pause(1.5)
      i = i+1
  end
  while 1
      pause(5);
      [sysrsp,rspstr] = system('tasklist /FO "CSV"|findstr flac');%0.25
      
      if(length(strfind(rspstr,'flac700'))<1)
          flagcount = 0;
          rstList = [];
          while flagcount<FLAG
              flagcount=flagcount+1;
              rst = load(rstf_name(flagcount,:));
              rstList = [rstList;rst];
          end
          dlmwrite('fosList.dat',rstList,'-append','delimiter','\t','newline','pc');
          break;
      end

  end
  

end
