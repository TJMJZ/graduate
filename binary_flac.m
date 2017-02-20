%% binary_flac: function description
function [reviseddp] = binary_flac(dp)

	global xsd xr xmean

	[m,n] = size(dp);
	dpy0 = zeros(1,n);
	dpy1 = gety(dp);
	tempp = dpy1;

	fail = 0;
	while (~fail)
		tempp = tempp*2;
		[tempresult,fail] = flacstate(getx(tempp));
	end

	lastsafe = dpy0;
	lastfail = tempp;

	errLimit = 0.01;
	errCurr = objFORM(tempp);

	while errCurr>errLimit
		midtemp = (lastfail+lastsafe)/2;
		[midresult,midstat] = flacstate(getx(midtemp));
		if midstat
			lastfail = midtemp;
		else
			lastsafe = midtemp;
		end
		errCurr = abs(objFORM(lastfail)-objFORM(lastsafe));
	end

	reviseddp = lastfail;

end

