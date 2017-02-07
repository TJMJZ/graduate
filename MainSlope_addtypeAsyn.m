% 每结束一个，就开启一个，保证�?��的程序�?数为FLAG�?


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
xmean = [8000 38 1-0.2863 4641 2.00E-05*1.03e-6];  
xsd = [4000 6 0.065 8808 1.55E-05*1.03e-6];

corrMatrix=[1,0,0,0,0
    0,1,0,0,0
    0,0,1,0,0
    0,0,0,1,0
    0,0,0,0,1];
totalNum = 3050;
dataFolder = 'E:\biye\reliability1115\data';
exeFolder = 'E:\biye\FLAC700\Exe32';
codeFolder = 'E:\biye\reliability1115';
lowerBound = -4;
upperBound = 0.5;



orgPara = genParaFun(lowerBound,upperBound);
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
    FLAG = 3;
    i = 1;

cd(exeFolder);
resultChangeTimeList = [];

flagcount = 0;
while flagcount<FLAG
    flagcount=flagcount+1
    para=[F(i,:)];
    dlmwrite(tempLocation,para,'delimiter','\t','newline','pc');
    pause(1.5)
    open flac700.exe
    pause(1.5)
    i = i+1;
end
disp('=======================')
rstFileInfo = dir('result.txt');
rstFileChangeTime = rstFileInfo.date;
rstFileChangeTimeLast = rstFileChangeTime;

while i <= totalNum

    while 1

        % read file info
        rstFileInfo = dir('result.txt');

        % do we read right
        try
          % right
          rstFileChangeTime = rstFileInfo.date;
        catch
          %not right 
          continue;
        end

        % if file changed  
        if(~strcmp(rstFileChangeTime,rstFileChangeTimeLast))
          
          resultChangeTimeList = [resultChangeTimeList;rstFileChangeTime];
          rstFileChangeTimeLast = rstFileChangeTime;

          tempFos = load('result.txt');

          % really changed
          if isempty(find(fosList(:,1)==tempFos(1)))
            fchange_flag = 1;
            break;
          end
        end

    end
    
    fosList = [fosList;tempFos];
    dlmwrite('fosList.dat',tempFos,'-append','delimiter','\t','newline','pc');

      para=[F(i,:)];
      i = i+1
      dlmwrite(tempLocation,para,'delimiter','\t','newline','pc');
      open flac700.exe
      
      if (~mod(i,50))
          [sysrsp,rspstr] = system('tasklist /FO "CSV"|findstr flac');%0.25
          if(length(strfind(rspstr,'flac700'))<FLAG)
              flagcount = 1;
              while flagcount<FLAG
                  flagcount=flagcount+1;
                  para=[F(i,:)];
                  dlmwrite(tempLocation,para,'delimiter','\t','newline','pc');
                  pause(1.5)
                  open flac700.exe
                  pause(1.5)
                  i = i+1;
              end
          end
      end

end

