% this file is better be a script for usability
clear
clc

% program interface
% paremeters : mean cov sd cm
% circle time : totalNum
% file system: datafolder,exefolder,codefolder
global xmean xcov xsd corrMatrix
global totalNum
global dataFolder exeFolder codeFolder


% interface
xmean=[8000 38];
% xcov=[0.3 0.3 0.2 0.2];% coefficient of variation 
xsd=[3000 4];
corrMatrix=[1 0  
            0 1];
totalNum = 350;
dataFolder = 'E:\biye\reliability1115\data';
exeFolder = 'E:\biye\FLAC700\Exe32';
codeFolder = 'E:\biye\reliability1115';
lowerBound = -5;
upperBound = 0.5;



orgPara = genParaFun(lowerBound,upperBound);
% save .\data\example_01.txt -ASCII -DOUBLE orgPara
% xlswrite('.\data\example_01.xls',orgPara)

circlePara = addNum(orgPara);
% iniResult = circulSlope(circlePara);
% iniResult = circulSlopeAsynchronous(circlePara);

F = circlePara

    mfLocation = [codeFolder '\reliability.dat'];
    % mf stands for file MainFlac
    tempLocation = [exeFolder '\temp.txt'];
    iniLocation = [exeFolder '\flac.ini'];

    temp = 0;
    fosList = [0 0 0 0];
    FLAG = 12;
    i = 1;

      rstcount = 0;
 while i <= totalNum
      temp = temp+1
      para=[F(i,:)];
      dlmwrite(tempLocation,para,'delimiter','\t','newline','pc');
      cd(exeFolder);
      %system('flac700.exe &');
      !flac700.exe
          tempFos = load('result.txt');        
          fosList = [fosList;tempFos];
            rstTempIO=fopen('result.txt','r');
            tempResult=fgets(rstTempIO)
            fclose(rstTempIO);
            fosListFile = fopen('fosList.dat','a')
            fprintf(fosListFile,tempResult);
            fclose(fosListFile);
            rstcount = rstcount+1;
      temp = temp - 1
      i = i+1
      cd(codeFolder);
    end
    
