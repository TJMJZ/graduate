%% callflac_mjz_ratio: function description
function [ratioResult,fail] = callflac_mjz_ratio(flac_cal_para)
	
	global codeFolder reviseFolder


ratiolimit = 1e-3;
tempLocation = [reviseFolder '\temp.txt'];


[para_m,para_n] = size(flac_cal_para)
flac_cal_para(:,3) = 1-flac_cal_para(:,3);

circlePara = addNum(flac_cal_para);

cd(reviseFolder);

        para=circlePara(1,:);
        dlmwrite(tempLocation,para,'delimiter','\t','newline','pc');
        !flac700.exe
        clc
        ratioResult = load('result1.txt');

cd(codeFolder);

dlmwrite('ratioList.dat',ratioResult,'-append','delimiter','\t','newline','pc');

fail = (ratioResult(1,(para_n+2))>ratiolimit);
