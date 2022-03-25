/* TimerCheck SAMP

  Credits: Pateeer */

/* FUNCTION

[+] IsValidTimer(timerid)
[+] KillTimerEx(id, timerid[id])

*/

#if !defined _samp_included
	#error Please include a_samp before TimerCheck.
#endif

#if !defined IsValidTimer
	forward IsValidTimer(timerid);
#endif


#if defined KillTimer
	forward KillTimerEx(id, timerid[]);
#endif

public KillTimerEx(id, timerid[])
{
	KillTimer(timerid[id]);
	timerid[id] = 0;
}

public IsValidTimer(timerid)
{	
	return (timerid);
}