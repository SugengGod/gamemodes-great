/* 
	CTime Library Plugin For Pawn
    Copyright © 2011 RyDeR`
	Modified by AndreT (27/12/2011) to remove the Time prefixes
*/

#if defined _CTime_Included
	#endinput
#endif

#define _Ctime_Included

#pragma library "CTime"

enum e_tm {
	tm_sec,
	tm_min,
	tm_hour,
	tm_mday,
	tm_mon,
	tm_year,
	tm_wday,
	tm_yday,
	tm_isdst
};

#define tm<%0> \
	tm: %0[e_tm]
	
#define CLOCKS_PER_SEC (1000)

native clock();
native difftime(tTime1, tTime2);
native mktime(tm <tmPtr>);
native asctime(tm <tmPtr>, szBuf[], const iSize = sizeof(szBuf));
native ctime(tTime, szBuf[], const iSize = sizeof(szBuf));
native gmtime(tTime, tm <tmPtr>);
native localtime(tTime, tm <tmPtr>);
native strftime(szBuf[], const iSize, const szFormat[], tm <tmPtr>);