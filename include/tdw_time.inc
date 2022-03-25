/** ======================================================================== **\
	Time
| Description:
	This library adds the useful functions from C/C++ languages, because
	PAWN has very few functions to manipulate with time. The functions
	that are added from C/C++ languages are provide a huge functionality.
	Functions:
	- gmtime
		Converts time_t to Time structure.
	- mktime
		Converts Time structure to time_t.
| Version:
	1.0.0
| Dependencies:
	-
| Compatible with the JIT plugin:
	Yes
| License:
	Copyright (c) 2017 Double V
	This software is provided 'as-is', without any express or implied
	warranty. In no event will the authors be held liable for any damages
	arising from the use of this software.
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:
	1.	The origin of this software must not be misrepresented; you must not
		claim that you wrote the original software. If you use this software
		in a product, an acknowledgement in the product documentation would be
		appreciated but is not required.
	2.	Altered source versions must be plainly marked as such, and must not be
		misrepresented as being the original software.
	3.	This notice may not be removed or altered from any source distribution.
\** ======================================================================== **/

#if defined _inc_tdw_time
	#undef _inc_tdw_time
#endif

#if defined _TDW_TIME_INC
	#define _TDW_TIME_INC
#endif

#define _TDW_TIME_INC

#if !defined _inc_time && !defined _time_included
	#include <time>
#endif

#if !defined _IS_LEAP_YEAR
	#define _IS_LEAP_YEAR(%0) (!((%0) % 4)&&(((%0) % 100)||!((%0) % 400)))
#endif

#if !defined _YEAR_SIZE
	#define _YEAR_SIZE(%0) (_IS_LEAP_YEAR(%0)?366:365)
#endif

#define FIRSTSUNDAY(%0)       ((%0[TIME_YDAY] - %0[TIME_WDAY] + 420) % 7)
#define FIRSTDAYOF(%0)        ((%0[TIME_WDAY] - %0[TIME_YDAY] + 420) % 7)

enum Time
{
	TIME_SEC,   // seconds       [0,60]
	TIME_MIN,   // minutes       [0,59]
	TIME_HOUR,  // hours         [0,59]
	TIME_MDAY,  // day of month  [0,31]
	TIME_YDAY,  // day of year   [0,365]
	TIME_WDAY,  // day of week   [0,7]
	TIME_MON,   // month         [0,12]
	TIME_YEAR   // year
};

// Time constants
const
	TDW_SECONDS_IN_MINUTE = 60,
	TDW_MINUTES_IN_HOUR   = 60,
	TDW_SECONDS_IN_HOUR   = TDW_SECONDS_IN_MINUTE * TDW_MINUTES_IN_HOUR,
	TDW_HOURS_IN_DAY      = 24,
	TDW_SECONDS_IN_DAY    = TDW_SECONDS_IN_HOUR * TDW_HOURS_IN_DAY,
	TDW_MINUTES_IN_DAY    = TDW_MINUTES_IN_HOUR * TDW_HOURS_IN_DAY,
	TDW_DAYS_IN_WEEK      = 7,
	TDW_HOURS_IN_WEEK     = TDW_HOURS_IN_DAY * TDW_DAYS_IN_WEEK,
	TDW_MINUTES_IN_WEEK   = TDW_MINUTES_IN_DAY * TDW_DAYS_IN_WEEK,
	TDW_SECONDS_IN_WEEK   = TDW_SECONDS_IN_DAY * TDW_DAYS_IN_WEEK,
	TDW_MONTHS_IN_YEAR    = 12;

// Unix-time constants
const
	TDW_EPOCH_YEAR = 1970,
	TDW_ZERO_YEAR  = 1900;

// Other constants
const
	TDW_ABBR_LEN = 3;

// Day of the week
enum { DAY_SUN, DAY_MON, DAY_TUE, DAY_WED, DAY_THU, DAY_FRI, DAY_SAT };

// Number of the month
enum {
	MONTH_JAN, MONTH_FEB, MONTH_MAR,
	MONTH_APR, MONTH_MAY, MONTH_JUN,
	MONTH_JUL, MONTH_AUG, MONTH_SEP,
	MONTH_OCT, MONTH_NOV, MONTH_DEC
};

static stock const
	TDW_g_sMonths[][] =
{
	"January", "February", "March",
	"April",   "May",      "June",
	"July",    "August",   "September",
	"October", "November", "December"
};

static stock const
	TDW_g_sDays[][] =
{
	"Sunday",    "Monday",   "Tuesday",
	"Wednesday", "Thursday", "Friday",
	"Saturday"
};

static stock const
	TDW_g_sDaysInMonths[2][TDW_MONTHS_IN_YEAR] =
{
//	JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC
	{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
	{31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}  // leap year
};

// A wrapper for gettime
stock time_t:time()
{
	return time_t:gettime();
}

// Converts time_t to Time structure.
stock gmtime(const time_t:time, tm[Time])
{
	new
		dayclock, dayno,
		year = TDW_EPOCH_YEAR,
		ysize, isleap,
		monthdays, month_index;

	// dayclock = _:time % TDW_SECONDS_IN_DAY;
	// dayno = _:time / TDW_SECONDS_IN_DAY;
	#emit load.s.pri time
	#emit const.alt  TDW_SECONDS_IN_DAY
	#emit sdiv
	#emit stor.s.alt dayclock
	#emit stor.s.pri dayno

	tm[TIME_SEC] = dayclock % TDW_SECONDS_IN_MINUTE;
	tm[TIME_MIN] = (dayclock % TDW_SECONDS_IN_HOUR) / TDW_MINUTES_IN_HOUR;
	tm[TIME_HOUR] = dayclock / TDW_SECONDS_IN_HOUR;

	tm[TIME_WDAY] = (dayno + 4) % TDW_DAYS_IN_WEEK;

	while (dayno >= (ysize = _YEAR_SIZE(year))) {
		dayno -= ysize;
		year++;
	}

	tm[TIME_YEAR] = year - TDW_ZERO_YEAR;
	tm[TIME_YDAY] = dayno;

	isleap = _IS_LEAP_YEAR(year);
	while (dayno >= (monthdays = TDW_g_sDaysInMonths[isleap][month_index])) {
		dayno -= monthdays;
		month_index++;
	}

	tm[TIME_MON] = month_index;
	tm[TIME_MDAY] = dayno + 1;

	return 1;
}

// Converts Time structure to time_t.
stock time_t:mktime(tm[Time])
{
	new
		day,
		year,
		yday,
		month,
		seconds,
		overflow,
		tmp_year;

	tm[TIME_MIN] += tm[TIME_SEC] / TDW_SECONDS_IN_MINUTE;
	tm[TIME_SEC] %= TDW_SECONDS_IN_MINUTE;
	if (tm[TIME_SEC] < 0) {
		tm[TIME_SEC] += TDW_SECONDS_IN_MINUTE;
		--tm[TIME_MIN];
	}

	tm[TIME_HOUR] += tm[TIME_MIN] / TDW_MINUTES_IN_HOUR;
	tm[TIME_MIN] %= TDW_MINUTES_IN_HOUR;
	if (tm[TIME_MIN] < 0) {
		tm[TIME_MIN] += TDW_MINUTES_IN_HOUR;
		--tm[TIME_HOUR];
	}

	day = tm[TIME_HOUR] / TDW_HOURS_IN_DAY;
	tm[TIME_HOUR] %= TDW_HOURS_IN_DAY;
	if (tm[TIME_HOUR] < 0) {
		tm[TIME_HOUR] += TDW_HOURS_IN_DAY;
		--day;
	}

	tm[TIME_YEAR] += tm[TIME_MON] / TDW_MONTHS_IN_YEAR;
	tm[TIME_MON] %= TDW_MONTHS_IN_YEAR;
	if (tm[TIME_MON] < 0) {
		tm[TIME_MON] += TDW_MONTHS_IN_YEAR;
		--tm[TIME_YEAR];
	}

	day += tm[TIME_MDAY] - 1;
	while (day < 0) {
		if (--tm[TIME_MON] < 0) {
			tm[TIME_YEAR]--;
			tm[TIME_MON] = 11;
		}
		day += TDW_g_sDaysInMonths[_IS_LEAP_YEAR(TDW_ZERO_YEAR + tm[TIME_YEAR])][tm[TIME_MON]];
	}
	while (day >= TDW_g_sDaysInMonths[_IS_LEAP_YEAR(TDW_ZERO_YEAR + tm[TIME_YEAR])][tm[TIME_MON]]) {
		day -= TDW_g_sDaysInMonths[_IS_LEAP_YEAR(TDW_ZERO_YEAR + tm[TIME_YEAR])][tm[TIME_MON]];
		if (++tm[TIME_MON] == 12) {
			tm[TIME_MON] = 0;
			tm[TIME_YEAR]++;
		}
	}

	tm[TIME_MDAY] = day + 1;

	year = TDW_EPOCH_YEAR;
	seconds = day = overflow = 0;

	tmp_year = tm[TIME_YEAR] + TDW_ZERO_YEAR;

	if (cellmax / 365 < tmp_year - TDW_EPOCH_YEAR)
		overflow++;

	day = (tmp_year - year) * 365;
	if (cellmax - day < (tmp_year - TDW_EPOCH_YEAR) / 4 + 1)
		overflow++;

	day += (tmp_year - TDW_EPOCH_YEAR) / 4   + _:((tmp_year % 4)
		&& tmp_year % 4 < TDW_EPOCH_YEAR % 4);
	day -= (tmp_year - TDW_EPOCH_YEAR) / 100 + _:((tmp_year % 100)
		&& tmp_year % 100 < TDW_EPOCH_YEAR % 100);
	day += (tmp_year - TDW_EPOCH_YEAR) / 400 + _:((tmp_year % 400)
		&& tmp_year % 400 < TDW_EPOCH_YEAR % 400);

	yday = month = 0;

	while (month < tm[TIME_MON]) {
		yday +=  TDW_g_sDaysInMonths[_IS_LEAP_YEAR(tmp_year)][month];
		month++;
	}

	yday += tm[TIME_MDAY] - 1;
	if (day + yday < 0)
		overflow++;
	day += yday;

	tm[TIME_YDAY] = yday;
	tm[TIME_WDAY] = (day + 4) % 7;

	seconds = ((tm[TIME_HOUR] * 60) + tm[TIME_MIN]) * 60 + tm[TIME_SEC];

	if ((cellmax - seconds) / TDW_SECONDS_IN_DAY < day)
		overflow++;

	seconds += day * TDW_SECONDS_IN_DAY;

	if (overflow) {
		return time_t:-1;
	}

	return time_t:seconds;
}

// Extra functions

stock getyearweek(const tm[Time])
{
	return ((tm[TIME_YDAY] - (tm[TIME_WDAY] ? (tm[TIME_WDAY] - 1) : 6)) / TDW_DAYS_IN_WEEK) + 1;
}

stock getmonthweek(const tm[Time])
{
	return 1 + ((tm[TIME_MDAY] + tm[TIME_WDAY] - 1) / 7);
}

stock getmonthend(year, month)
{
	return (0 <= month <= 11) ? TDW_g_sDaysInMonths[_IS_LEAP_YEAR(year)][month] : -1;
}