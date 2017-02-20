% 
%% flacstate: function description
function [rst,fail] = flacstate(flacpara)

  ratiolimit = 1e-3;
  flacpara(:,3) = 1-flacpara(:,3);
  flacpara = [1 flacpara 2e-7 216000 10000]
  global dataFolder exeFolder codeFolder


  cd(exeFolder);

  dlmwrite('temp.txt',flacpara,'delimiter','\t','newline','pc');

  fosListFile = fopen('flac.ini','w');
  try
      fprintf(fosListFile,['call rainfall1.dat']);
  catch
      disp('fuck!!!!!!!!!!!!!!!!');
  end
  fclose(fosListFile);
  pause(1)
  open flac700.exe
  pause(1)
  
  while 1

    pause(2);
    [sysrsp,rspstr] = system('tasklist /FO "CSV"|findstr flac');%0.25
    
    if(length(strfind(rspstr,'flac700'))<1)
      rst = load('result1.txt');
      break;
    end

  end

  cd(dataFolder);
  dlmwrite('revise.dat',rst,'-append','delimiter','\t','newline','pc');
  fail = (rst(length(rst))>ratiolimit);
  cd(codeFolder);
end

