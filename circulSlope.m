%% circulSlope:Fnction description
function [fosList] = circulSlope(F)

    global totalNum
    global dataFolder exeFolder codeFolder


    mfLocation = [codeFolder '\reliability.dat'];
    % mf stands for file MainFlac
    tempLocation = [exeFolder '\temp.txt'];
    iniLocation = [exeFolder '\flac.ini'];

    callmf = ['call '  mfLocation];
    callmf = ['call reliability.dat'];

    flacCalFile1 = [codeFolder '\FOSUnstable.f3sav'];
    flacCalFile2 = [codeFolder '\FOSInitial.f3sav'];
    flacCalFile3 = [codeFolder '\FOSStable.f3sav'];

    temp = 0;
    fosList = [];

   i = 1;
    while i <= totalNum
      temp = temp+1
      para=[F(i,:)];
      dlmwrite(tempLocation,para,'delimiter','\t','newline','pc');
      cd(exeFolder);
      

      % system('flac700.exe');
      !flac700.exe
      % dos('flac700.exe')

      % ---TO execute in now window---
      % open flac700.exe

      tempFos = load('result.txt');
      fosList = [fosList;tempFos];

      rstTempIO=fopen('result.txt','r');
      tempResult=fgets(rstTempIO)
      fclose(rstTempIO);
      fosListFile = fopen('fosList.dat','a')
      fprintf(fosListFile,tempResult);
      fclose(fosListFile);

      %!!!!!a space must be added after  .exe otherwise cannot run!!!!! 

      % system([exeLocation callmf]);
      % the command system is meant to call system application but not any application
      % thus cannot be used easily

      % !flac3d500_gui_64.exe call E:\work\matlab\projects\SLOPENO3\exe64\partflac\flacMain.dat 
      % delete(flacCalFile1);
      % delete(flacCalFile2);
      % delete(flacCalFile3);
      temp = temp - 1
      i = i+1
      cd(codeFolder);
    end

