function g = callFlac(Para,FosCalibration)

    global codeFolder
    global exeFolder

	mfLocation = [codeFolder '\calFos.dat'];
    tempLocation = [exeFolder '\Temp.txt'];
    flacCalFile1 = [codeFolder '\FOSStable.f3sav'];
    flacCalFile2 = [codeFolder '\FOSInitial.f3sav'];
    flacCalFile3 = [codeFolder '\FOSUnstable.f3sav'];
    callmf = ['call '  mfLocation];

    fosResultPath = [exeFolder '\result.txt'];
	dlmwrite(tempLocation,[0   Para],'delimiter','\t','newline','pc');

	cd(exeFolder);
    system(['flac3d500_gui_64.exe ' callmf]);
    % delete(flacCalFile1);
    delete(flacCalFile2);
    delete(flacCalFile3);
    cd(codeFolder);

    FOS = dlmread(fosResultPath,'	');
    g = FOS(size(FOS,1))-1-FosCalibration;
    if (abs(g)>=0.02)
        delete(flacCalFile1);
    end
    logData = [Para g];
    logLocation = [exeFolder '\log.txt'];
    dlmwrite(logLocation,logData,'-append','delimiter','\t','newline','pc');
