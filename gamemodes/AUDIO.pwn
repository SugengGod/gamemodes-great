new stationNames[13][] =
{
	{ "Radio Off" },
	{ "Playback FM" },
	{ "K-Rose" },
	{ "K-DST" },
	{ "Bounce FM" },
	{ "SF-UR" },
	{ "Radio Los Santos" },
	{ "Radio X" },
	{ "CSR 103.9" },
	{ "K-Jah West" },
	{ "Master Sounds 98.3" },
	{ "WCTR" },
	{ "User Track Player" }
};

public Audio_OnClientConnect(playerid)
{
	new hostname[64], string[128];
	SendStaffMessage(COLOR_RED, "%s(%d) has connected to audio TCP server.", pData[playerid][pName], playerid);
	GetServerVarAsString("hostname", hostname, sizeof(hostname));
	format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"You has connected to audio %s TCP server.", hostname);
	Audio_SendMessage(playerid, string);
	return 1;
}

public Audio_OnClientDisconnect(playerid)
{
	new hostname[64], string[128];
	SendStaffMessage(COLOR_RED, "%s(%d) has disconnected to audio TCP server.", pData[playerid][pName], playerid);
	GetServerVarAsString("hostname", hostname, sizeof(hostname));
	format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"You has disconnected to audio %s TCP server.", hostname);
	Audio_SendMessage(playerid, string);
	return 1;
}

public Audio_OnPlay(playerid, handleid)
{
	new string[128];
	format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"playback started (Handle ID: %d).", handleid);
	SendClientMessage(playerid, 0xFFFF00FF, string);
	return 1;
}

public Audio_OnStop(playerid, handleid)
{
	new string[128];
	format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"playback stopped (Handle ID: %d).", handleid);
	SendClientMessage(playerid, 0xFFFF00FF, string);
	return 1;
}

public Audio_OnTransferFile(playerid, file[], current, total, result)
{
	new string[128];
	switch (result)
	{
		case 0: format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"Audio file %s (%d of %d) finished local download (Player ID: %d).", file, current, total, playerid);
		case 1: format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"Audio file %s (%d of %d) finished remote download (Player ID: %d).", file, current, total, playerid);
		case 2: format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"Audio file %s (%d of %d) passed check (Player ID: %d).", file, current, total, playerid);
		case 3: format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"Audio file %s (%d of %d) could not be downloaded or checked (Player ID: %d).", file, current, total, playerid);
	}
	SendClientMessage(playerid, 0xFFFF00FF, string);
	if (current == total)
	{
		SendClientMessage(playerid, 0xFFFF00FF, ""GREEN_E"[AUDIO] "WHITE_E"All files have been processed.");
	}
	return 1;
}

public Audio_OnTrackChange(playerid, handleid, track[])
{
	new string[128];
	format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"Now playing \"%s\" (Handle ID: %d) (Player ID: %d).", track, handleid, playerid);
	SendClientMessage(playerid, 0xFFFF00FF, string);
}

public Audio_OnRadioStationChange(playerid, station)
{
	new string[128];
	format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"Radio station set to %d (%s) (Player ID: %d).", station, stationNames[station], playerid);
	SendClientMessage(playerid, 0xFFFF00FF, string);
	return 1;
}

public Audio_OnGetPosition(playerid, handleid, seconds)
{
	new string[128];
	format(string, sizeof(string), ""GREEN_E"[AUDIO] "WHITE_E"Audio position currently at %d seconds (Handle ID: %d) (Player ID: %d).", seconds, handleid, playerid);
	SendClientMessage(playerid, 0xFFFF00FF, string);
	return 1;
}

CMD:tesaudio(playerid, params[])
{
	Audio_Play(playerid, 1);
	return 1;
}

CMD:stopaudio(playerid, params[])
{
	Audio_Stop(playerid, 1);
	return 1;
}