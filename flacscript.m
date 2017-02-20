% for a given parameter set, this script does the calculation and save results in folder
% input parameters:
% circlePara
% output results:
% fosList.dat in exefolder/data/rstidstr

sstv_id
cd(exeFolder);
if ~exist('data')
  mkdir('data')
else
  disp('data folder exists');
end

if ~exist('fosList.dat')
  tempfile = fopen(TEMPRSTNAME,'a');
  fclose(tempfile);
else
  disp('fosList.dat exists, how could this happen');
end


[cirM,cirN] = size(circlePara);
rainfall_amt_cvt = sstv(sstv_id,1);
rainfall_hour = sstv(sstv_id,2);
ini_suction_kpa = sstv(sstv_id,3);
rainfall_amt = rainfall_amt_cvt*(1e-7);
rainfall_time = rainfall_hour*3600;
ini_suction = ini_suction_kpa*1000;
this_set = [rainfall_amt rainfall_time ini_suction]
rstidfstr = strcat(num2str(rainfall_amt),'_',num2str(rainfall_hour),'_',num2str(ini_suction));

this_set_p = repmat(this_set,cirM,1); 
circlePara = [circlePara this_set_p];


i = 1;
while i <cirM
  flagcount = 0;
  delete('*.fsv');
  while flagcount<FLAG

      flagcount=flagcount+1;
      if (i<=cirM)
        para=[circlePara(i,:)];
      else
        break;
      end
      dlmwrite(TEMPLOC,para,'delimiter','\t','newline','pc');
      fosListFile = fopen(INILOC,'w');
      try
          fprintf(fosListFile,[FLACCMD FLACF_NAME(flagcount,:)]);
      catch
          disp('fuck!!!!!!!!!!!!!!!!');
      end
      fclose(fosListFile);
      pause(PAUSE_FLAC)
      open flac700.exe
      pause(PAUSE_FLAC)
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
              rst = load(RSTF_NAME(flagcount,:));
              rstList = [rstList;rst];
          end
          dlmwrite(TEMPRSTNAME,rstList,'-append','delimiter','\t','newline','pc');
          break;
      end

  end

end

% fosList.dat is complete now

rstfolder = strcat('data/',rstidfstr);

if ~exist(rstfolder)
  mkdir(rstfolder);
else
  disp('result folder exists, results corrupted');
end

movefile(TEMPRSTNAME,rstfolder);

cd(rstfolder)

  copyfile(TEMPRSTNAME,rstidfstr);

cd(codeFolder);

