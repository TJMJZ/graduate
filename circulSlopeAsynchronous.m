%% circulSlope:Fnction description
function [fosList] = circulSlope(F)

    global totalNum
    global dataFolder exeFolder codeFolder


    mfLocation = [codeFolder '\reliability.dat'];
    % mf stands for file MainFlac
    tempLocation = [exeFolder '\temp.txt'];
    iniLocation = [exeFolder '\flac.ini'];

    temp = 0;
    fosList = [];
    FLAG = 12;
    i = 1;

cd(exeFolder);

while i <= totalNum



  flagcount = 0;
  while flagcount<FLAG
      flagcount=flagcount+1
      para=[F(i,:)];
      i = i+1
      dlmwrite(tempLocation,para,'delimiter','\t','newline','pc');
      open flac700.exe
      pause(5)
  end

  rstcount = 0;
  rstFileInfo = dir('result.txt');
  rstFileChangeTime = rstFileInfo.date;
  rstFileChangeTimeLast = rstFileChangeTime;

  while rstcount<FLAG
      rstFileInfo = dir('result.txt');
      rstFileChangeTime = rstFileInfo.date;
  
      if(~strcmp(rstFileChangeTime,rstFileChangeTimeLast))

          rstFileChangeTimeLast = rstFileChangeTime;

          tempFos = load('result.txt');
          fosList = [fosList;tempFos];

          rstTempIO=fopen('result.txt','r');
          tempResult=fgets(rstTempIO)
          fclose(rstTempIO);

          fosListFile = fopen('fosList.dat','a')
          fprintf(fosListFile,tempResult);
          fclose(fosListFile);
          rstcount = rstcount+1;
      end
  end



end
cd(codeFolder);
