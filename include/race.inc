 
/*
	Racing System 1.0 by Raf.
	
	Changelog:
		Version 1.0 (17/07/2017 - 21:00)
			- Initial Release
*/

#include <a_samp>
#include <sscanf2>
#include <foreach>
#include <zcmd>

#define MAX_RACES 			1
#define MAX_CHECKS 			40

#define DIALOG_UNUSED 		0
#define DIALOG_RACE 		1

#define RACE_VIRTUALWORLD 	1

enum RACE_playerInfo
{
	RACE_playerUsername[MAX_PLAYER_NAME],
	
	RACE_playerVehicle,
	
	RACE_playerPosition,
	RACE_playerCheckpointsPassed,
	RACE_playerTimeTookToFinish,

    Text:RACE_textdrawBar,
	Text:RACE_textdrawBox,
	Text:RACE_textdrawTitle,
	Text:RACE_textdrawName,
	Text:RACE_textdrawPosition,
	Text:RACE_textdrawCheckpoint,
	Text:RACE_textdrawTimeLeft,
	Text:RACE_textdrawSpeed,

    bool:RACE_isPlayerInRace,
	
	Text:RACE_textdrawTip,
	Text:RACE_textdrawTip2
};

enum RACE_raceInfo
{
	raceName[24],

	raceVehicleID,
	raceMaxCheckpoints,
	raceInterior,
	raceDistance,
	raceRecord,
	raceRecordPlaced,
	raceRecordHolder[24],
	
	Float:raceSpawnPositionX,
	Float:raceSpawnPositionY,
	Float:raceSpawnPositionZ,
	Float:raceSpawnPositionA,

	Float:raceCheckpointPositionX,
	Float:raceCheckpointPositionY,
	Float:raceCheckpointPositionZ
};

new	
	RACE_pInfo[MAX_PLAYERS][RACE_playerInfo],
	
	RACE_rInfo[MAX_RACES][MAX_CHECKS][RACE_raceInfo],

    RACE_loadedRaces = 0,
	RACE_runningID,

	RACE_playersInEvent = 0,
	RACE_playersLeft = 0,
	RACE_playersSpawned = 0,

	RACE_timeLeft,
	RACE_timerCounter,

	RACE_countdownTimer,
	RACE_checkRaceTimer,

	RACE_checkpoints[MAX_CHECKS],
	
	RACE_spawnSlots[16] = {-1, ...},

 	bool:RACE_isRaceStarted = false,
	bool:RACE_isRaceInLobby = false,
	
	RACE_globalString[144]
;

RACE_loadTextdraws()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		RACE_pInfo[i][RACE_textdrawBox] = TextDrawCreate(534.708190, 433.166961, "usebox");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawBox], 0.000000, -8.563220);
		TextDrawTextSize(RACE_pInfo[i][RACE_textdrawBox], 635.188659, 0.000000);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawBox], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawBox], 0);
		TextDrawUseBox(RACE_pInfo[i][RACE_textdrawBox], true);
		TextDrawBoxColor(RACE_pInfo[i][RACE_textdrawBox], 102);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawBox], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawBox], 0);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawBox], 0);

		RACE_pInfo[i][RACE_textdrawTitle] = TextDrawCreate(534.114196, 349.999572, "Race");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawTitle], 0.449999, 1.600000);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawTitle], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawTitle], -1);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawTitle], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawTitle], 1);
		TextDrawBackgroundColor(RACE_pInfo[i][RACE_textdrawTitle], 51);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawTitle], 0);
		TextDrawSetProportional(RACE_pInfo[i][RACE_textdrawTitle], 1);

		RACE_pInfo[i][RACE_textdrawName] = TextDrawCreate(535.988464, 365.166381, "~g~Name:~w~");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawName], 0.234476, 1.483335);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawName], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawName], -1);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawName], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawName], 1);
		TextDrawBackgroundColor(RACE_pInfo[i][RACE_textdrawName], 51);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawName], 1);
		TextDrawSetProportional(RACE_pInfo[i][RACE_textdrawName], 1);

		RACE_pInfo[i][RACE_textdrawPosition] = TextDrawCreate(535.988464, 377.416473, "~g~Position:~w~");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawPosition], 0.234476, 1.483335);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawPosition], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawPosition], -1);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawPosition], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawPosition], 1);
		TextDrawBackgroundColor(RACE_pInfo[i][RACE_textdrawPosition], 51);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawPosition], 1);
		TextDrawSetProportional(RACE_pInfo[i][RACE_textdrawPosition], 1);

		RACE_pInfo[i][RACE_textdrawCheckpoint] = TextDrawCreate(535.988464, 389.666564, "~g~Checkpoint:~w~");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawCheckpoint], 0.234476, 1.483335);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawCheckpoint], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawCheckpoint], -1);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawCheckpoint], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawCheckpoint], 1);
		TextDrawBackgroundColor(RACE_pInfo[i][RACE_textdrawCheckpoint], 51);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawCheckpoint], 1);
		TextDrawSetProportional(RACE_pInfo[i][RACE_textdrawCheckpoint], 1);

		RACE_pInfo[i][RACE_textdrawTimeLeft] = TextDrawCreate(535.988464, 401.916656, "~g~Time Left:~w~ 5:00");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawTimeLeft], 0.234476, 1.483335);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawTimeLeft], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawTimeLeft], -1);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawTimeLeft], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawTimeLeft], 1);
		TextDrawBackgroundColor(RACE_pInfo[i][RACE_textdrawTimeLeft], 51);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawTimeLeft], 1);
		TextDrawSetProportional(RACE_pInfo[i][RACE_textdrawTimeLeft], 1);

		RACE_pInfo[i][RACE_textdrawSpeed] = TextDrawCreate(535.988464, 414.750091, "~g~Speed:~w~ 0 KM/H");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawSpeed], 0.234476, 1.483335);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawSpeed], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawSpeed], -1);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawSpeed], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawSpeed], 1);
		TextDrawBackgroundColor(RACE_pInfo[i][RACE_textdrawSpeed], 51);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawSpeed], 1);
		TextDrawSetProportional(RACE_pInfo[i][RACE_textdrawSpeed], 1);
		
		RACE_pInfo[i][RACE_textdrawTip] = TextDrawCreate(143.367523, 359.916778, "Test message");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawTip], 0.283672, 1.570829);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawTip], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawTip], -1);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawTip], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawTip], 1);
		TextDrawBackgroundColor(RACE_pInfo[i][RACE_textdrawTip], 51);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawTip], 1);
		TextDrawSetProportional(RACE_pInfo[i][RACE_textdrawTip], 1);

		RACE_pInfo[i][RACE_textdrawTip2] = TextDrawCreate(143.367523, 359.916778, "Test message");
		TextDrawLetterSize(RACE_pInfo[i][RACE_textdrawTip2], 0.283672, 1.570829);
		TextDrawAlignment(RACE_pInfo[i][RACE_textdrawTip2], 1);
		TextDrawColor(RACE_pInfo[i][RACE_textdrawTip2], -1);
		TextDrawSetShadow(RACE_pInfo[i][RACE_textdrawTip2], 0);
		TextDrawSetOutline(RACE_pInfo[i][RACE_textdrawTip2], 1);
		TextDrawBackgroundColor(RACE_pInfo[i][RACE_textdrawTip2], 51);
		TextDrawFont(RACE_pInfo[i][RACE_textdrawTip2], 1);
	}
}

RACE_resetPlayerVariables(playerid)
{
	RACE_pInfo[playerid][RACE_playerPosition] = 0,
	RACE_pInfo[playerid][RACE_playerCheckpointsPassed] = 0,
	RACE_pInfo[playerid][RACE_playerTimeTookToFinish] = 0,

	RACE_pInfo[playerid][RACE_isPlayerInRace] = false;
}

RACE_showPlayerRaceTextdraws(playerid)
{
    TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawBox]);
	TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTitle]);
	TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawName]);
	TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawPosition]);
	TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawCheckpoint]);
	TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTimeLeft]);
	TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawSpeed]);
}

RACE_hidePlayerRaceTextdraws(playerid)
{
    TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawBox]);
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTitle]);
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawName]);
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawPosition]);
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawCheckpoint]);
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTimeLeft]);
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawSpeed]);
}

RACE_getPlayerSpeed(playerid)
{
    new
		Float:X,
		Float:Y,
		Float:Z
	;

    if(IsPlayerInAnyVehicle(playerid))
    {
		GetVehicleVelocity(GetPlayerVehicleID(playerid), X, Y, Z);
	}
    else
    {
		GetPlayerVelocity(playerid, X, Y, Z);
	}
	return floatround(floatsqroot((X * X) + (Y * Y) + (Z * Z)) * 195.12);
}

RACE_replaceline(filename[], find[], replace[])
{
	if(!fexist(filename)) return 0;

	new
		File:handle = fopen(filename, io_read)
	;

	if(!handle) return 0;

	new
		File:tmp = ftemp()
	;

	if(!tmp)
	{
		fclose(handle);
		return 0;
	}

	new
		line[256]
	;

	while(fread(handle, line))
	{
		if(strfind(line, find) == -1)
		{
			fwrite(tmp, line);
		}
		else
		{
			fwrite(tmp, replace);
		}
	}

	fclose(handle);

	fseek(tmp, 0);
	handle = fopen(filename, io_write);

	if(!handle)
	{
		fclose(tmp);
		return 0;
	}

	while(fread(tmp, line))
	{
		fwrite(handle, line);
	}

	fclose(handle);
	fclose(tmp);
	return 1;
}

RACE_convertTime(timestamp, bool:withtime = true)
{
    new
		monthDays[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
		years = 1970,
		days = 0,
		months = 0,
		hours = 0,
		minutes = 0,
		seconds = 0,
		string[50]
	;

    while(timestamp > 31622400)
	{
        timestamp -= 31536000;
        
        if(((years % 4 == 0) && (years % 100 != 0)) || (years % 400 == 0))
		{
			timestamp -= 86400;
		}
		
        years++;
    }

    if (((years % 4 == 0) && (years % 100 != 0)) || (years % 400 == 0))
    {
        monthDays[1] = 29;
	}
    else
    {
        monthDays[1] = 28;
	}

    while(timestamp > 86400)
	{
        timestamp -= 86400;
		days++;
		
        if(days == monthDays[months])
		{
			days = 0;
			months++;
		}
    }

    while(timestamp > 60)
	{
        timestamp -= 60;
		minutes++;
		
        if(minutes == 60)
		{
			minutes = 0;
			hours++;
		}
    }

    seconds = timestamp;

	if(withtime)
	{
		format(string, sizeof(string), "%02d/%02d/%d - %02d:%02d:%02d", days + 1, months + 1, years, hours, minutes, seconds);
	}
	else
	{
	    format(string, sizeof(string), "%02d/%02d/%d", days + 1, months + 1, years);
	}
    return string;
}

RACE_loadRaceFromFile(race)
{
    new
	    fileName[15]
	;

	format(fileName, sizeof(fileName), "Races/%d.txt", race);

    new
		File:file = fopen(fileName, io_read)
	;

    if(!file)
    {
        printf("[RACE] %s failed to load.", fileName);
        return 0;
    }
    else
    {
        new
			line[200],

			rName[24],
			rVehicleID,
			rMaxCheckpoints,
			rInterior,
			rDistance,
			rRecord,
			rRecordPlaced,
			rRecordHolder[24],
			Float:rSpawnPositionX,
			Float:rSpawnPositionY,
			Float:rSpawnPositionA,
			Float:rSpawnPositionZ,

			Float:rCheckpointPositionX,
			Float:rCheckpointPositionY,
			Float:rCheckpointPositionZ,

			checkpointCount = 0,

			bool:firstline = false
		;

        while (fread(file, line))
        {
            if(!firstline)
			{
			    firstline = true;

	            if(!sscanf(line, "p<|>s[24]iiiiiis[24]ffff", rName, rVehicleID, rMaxCheckpoints, rInterior, rDistance, rRecord, rRecordPlaced, rRecordHolder, rSpawnPositionX, rSpawnPositionY, rSpawnPositionZ, rSpawnPositionA))
	            {
					format(RACE_rInfo[race][0][raceName], 24, "%s", rName);
					RACE_rInfo[race][0][raceVehicleID] = rVehicleID;
					RACE_rInfo[race][0][raceMaxCheckpoints] = rMaxCheckpoints;
					RACE_rInfo[race][0][raceInterior] = rInterior;
					RACE_rInfo[race][0][raceDistance] = rDistance;
					RACE_rInfo[race][0][raceRecord] = rRecord;
					RACE_rInfo[race][0][raceRecordPlaced] = rRecordPlaced;
					format(RACE_rInfo[race][0][raceRecordHolder], 24, "%s", rRecordHolder);
					RACE_rInfo[race][0][raceSpawnPositionX] = rSpawnPositionX;
					RACE_rInfo[race][0][raceSpawnPositionY] = rSpawnPositionY;
					RACE_rInfo[race][0][raceSpawnPositionZ] = rSpawnPositionZ;
					RACE_rInfo[race][0][raceSpawnPositionA] = rSpawnPositionA;
				}
			}
			else
			{
			    if(!sscanf(line, "p<|>fff", rCheckpointPositionX, rCheckpointPositionY, rCheckpointPositionZ))
	            {
					RACE_rInfo[race][checkpointCount][raceCheckpointPositionX] = rCheckpointPositionX;
					RACE_rInfo[race][checkpointCount][raceCheckpointPositionY] = rCheckpointPositionY;
					RACE_rInfo[race][checkpointCount][raceCheckpointPositionZ] = rCheckpointPositionZ;

					checkpointCount++;
	            }
			}
		}
		RACE_loadedRaces++;
		
        fclose(file);
    }
    return 1;
}

RACE_updateRace(race)
{
	new
	    fileName[15]
	;

	format(fileName, sizeof(fileName), "Races/%d.txt", race);

	new
		File:file = fopen(fileName, io_append)
	;

    if(!file)
    {
        printf("[RACE] %s failed to open.", fileName);
        return 0;
    }
    else
    {
        new
            string[200]
		;

		format(string, sizeof(string), "%s|%i|%i|%i|%i|%i|%i|%s|%f|%f|%f|%f\r\n",
		RACE_rInfo[race][0][raceName],
		RACE_rInfo[race][0][raceVehicleID],
		RACE_rInfo[race][0][raceMaxCheckpoints],
		RACE_rInfo[race][0][raceInterior],
		RACE_rInfo[race][0][raceDistance],
		RACE_rInfo[race][0][raceRecord],
		RACE_rInfo[race][0][raceRecordPlaced],
		RACE_rInfo[race][0][raceRecordHolder],
		RACE_rInfo[race][0][raceSpawnPositionX],
		RACE_rInfo[race][0][raceSpawnPositionY],
		RACE_rInfo[race][0][raceSpawnPositionZ],
		RACE_rInfo[race][0][raceSpawnPositionA]);

    	RACE_replaceline(fileName, RACE_rInfo[race][0][raceName], string);

    	fclose(file);
    }
    return 1;
}

forward RACE_showPlayerTip(playerid, text[], time);
public RACE_showPlayerTip(playerid, text[], time)
{
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTip]);
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTip2]);
	
	TextDrawSetString(RACE_pInfo[playerid][RACE_textdrawTip], text);
	TextDrawSetString(RACE_pInfo[playerid][RACE_textdrawTip2], text);
	TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTip]);
	TextDrawShowForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTip2]);

	SetTimerEx("RACE_hidePlayerTip", time, false, "d", playerid);
	return 1;
}

forward RACE_hidePlayerTip(playerid, text[]);
public RACE_hidePlayerTip(playerid, text[])
{
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTip]);
	TextDrawHideForPlayer(playerid, RACE_pInfo[playerid][RACE_textdrawTip2]);
	return 1;
}

forward RACE_createVehicle(playerid, vehicleid, Float:X, Float:Y, Float:Z, Float:A, pInterior, pVirtualWorld);
public RACE_createVehicle(playerid, vehicleid, Float:X, Float:Y, Float:Z, Float:A, pInterior, pVirtualWorld)
{
    RemovePlayerFromVehicle(playerid);
	
	if(RACE_pInfo[playerid][RACE_playerVehicle] != -1)
	{
		DestroyVehicle(RACE_pInfo[playerid][RACE_playerVehicle]);
	}

	new
		Veh = CreateVehicle(vehicleid, X, Y, Z + 2.0, A, random(200), random(200), -1)
	;
	
	SetPlayerInterior(playerid, pInterior);
	SetPlayerVirtualWorld(playerid, pVirtualWorld);
	
	LinkVehicleToInterior(Veh, pInterior);
	SetVehicleVirtualWorld(Veh, pVirtualWorld);
	
	PutPlayerInVehicle(playerid, Veh, 0);
	
	SetPlayerArmedWeapon(playerid, 0);

	RACE_pInfo[playerid][RACE_playerVehicle] = GetPlayerVehicleID(playerid);
	return 1;
}

forward RACE_prepareEvent(RaceID);
public RACE_prepareEvent(RaceID)
{
	KillTimer(RACE_countdownTimer);
	KillTimer(RACE_checkRaceTimer);

	new
		randomNumber = random(RACE_loadedRaces)
	;
	
	if(RaceID == -1)
	{
		RACE_runningID = randomNumber;
	}
	else
	{
	    RACE_runningID = RaceID;
	}

	RACE_isRaceStarted = false;
	RACE_isRaceInLobby = true;

	RACE_timeLeft = 300;
	RACE_timerCounter = 30;

	RACE_playersInEvent = 0;
	RACE_playersSpawned = 0;
	RACE_playersLeft = 0;

	for(new i = 0; i < MAX_CHECKS; i++)
	{
		RACE_checkpoints[i] = 0;
	}
	
	for(new i = 0; i < sizeof(RACE_spawnSlots); i++)
	{
	    RACE_spawnSlots[i] = -1;
	}
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(RACE_pInfo[i][RACE_playerVehicle] != -1)
		{
			DestroyVehicle(RACE_pInfo[i][RACE_playerVehicle]);
			RACE_pInfo[i][RACE_playerVehicle] = -1;
		}
	}

	RACE_countDown();
	
	RACE_globalString[0] = '\0';
	format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race is about to Start in 30 seconds. Use {00ff80}/race{FFFFFF} to join!", RACE_rInfo[RACE_runningID][0][raceName]);
	SendClientMessageToAll(0x00ff8000, RACE_globalString);
	
	GameTextForAll("~w~A Race ~g~Started!", 3000, 3);

	format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} Record holder is {00ff80}%s{FFFFFF} with '{00ff80}%i:%02i.%03i{FFFFFF}' seconds made on '{00ff80}%s{FFFFFF}'.", RACE_rInfo[RACE_runningID][0][raceRecordHolder], RACE_rInfo[RACE_runningID][0][raceRecord] / 60000, ((RACE_rInfo[RACE_runningID][0][raceRecord] / 1000) % 60), RACE_rInfo[RACE_runningID][0][raceRecord] % 1000, RACE_convertTime(RACE_rInfo[RACE_runningID][0][raceRecordPlaced], false));
	SendClientMessageToAll(0x00ff8000, RACE_globalString);
	return 1;
}

forward RACE_checkRace();
public RACE_checkRace()
{
	if(RACE_playersLeft == 0)
	{
		RACE_finishEvent(2);
	}

	if(RACE_timeLeft == 0)
	{
		RACE_finishEvent(3);
	}
	else
	{
		RACE_timeLeft--;

        RACE_globalString[0] = '\0';
		format(RACE_globalString, sizeof(RACE_globalString), "~g~Time Left:~w~ %d:%02d", (RACE_timeLeft / 60) % 60, RACE_timeLeft % 60);

		foreach (new i : Player)
		{
			if(RACE_pInfo[i][RACE_isPlayerInRace])
			{
				TextDrawSetString(RACE_pInfo[i][RACE_textdrawTimeLeft], RACE_globalString);
				SetVehicleHealth(RACE_pInfo[i][RACE_playerVehicle], 1000);
			}
		}
	}
	return 1;
}

forward RACE_finishEvent(reason);
public RACE_finishEvent(reason)
{
	KillTimer(RACE_countdownTimer);
	KillTimer(RACE_checkRaceTimer);

	RACE_isRaceStarted = false;
	RACE_isRaceInLobby = false;

	foreach(new i : Player)
	{
	    if(RACE_pInfo[i][RACE_isPlayerInRace])
	    {
		    TogglePlayerControllable(i, true);
			
			DisableRemoteVehicleCollisions(i, false);
			
			DisablePlayerCheckpoint(i);
			DisablePlayerRaceCheckpoint(i);

			RACE_hidePlayerRaceTextdraws(i);
	
			RemovePlayerFromVehicle(i);
			
			DestroyVehicle(RACE_pInfo[i][RACE_playerVehicle]);
			RACE_pInfo[i][RACE_playerVehicle] = -1;
			
			SpawnPlayer(i);
			
			RACE_pInfo[i][RACE_isPlayerInRace] = false;
		}
	}
	
	RACE_globalString[0] = '\0';

	switch(reason)
	{
	    case 0: format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race ended.", RACE_rInfo[RACE_runningID][0][raceName]);
		case 1: format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race ended. (Terminated by Admin)", RACE_rInfo[RACE_runningID][0][raceName]);
		case 2: format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race ended. (All player left)", RACE_rInfo[RACE_runningID][0][raceName]);
		case 3: format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race ended. (Time over)", RACE_rInfo[RACE_runningID][0][raceName]);
	}

	SendClientMessageToAll(0x00ff8000, RACE_globalString);
	return 1;
}

forward RACE_countDown();
public RACE_countDown()
{
    KillTimer(RACE_countdownTimer);

	switch(RACE_timerCounter)
	{
	    case 0:
	    {
	        if(RACE_playersInEvent == 0)
	        {
	            KillTimer(RACE_checkRaceTimer);
				KillTimer(RACE_countdownTimer);

			    RACE_isRaceStarted = false;
				RACE_isRaceInLobby = false;

				RACE_timerCounter = 15;

				RACE_playersSpawned = 0;
				RACE_playersInEvent = 0;
				RACE_playersLeft = 0;
				
				RACE_globalString[0] = '\0';
				format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race ended. (Due to lack of participation)", RACE_rInfo[RACE_runningID][0][raceName]);
				SendClientMessageToAll(0x00ff8000, RACE_globalString);
				return 1;
	        }
	        else
	        {
		        foreach (new i : Player)
				{
				    if(RACE_pInfo[i][RACE_isPlayerInRace])
					{
					    new
							runID = RACE_runningID
						;

						RACE_showPlayerRaceTextdraws(i);

                        RACE_globalString[0] = '\0';
				        format(RACE_globalString, sizeof(RACE_globalString), "~g~Name:~w~ %s", RACE_rInfo[RACE_runningID][0][raceName]);
						TextDrawSetString(RACE_pInfo[i][RACE_textdrawName], RACE_globalString);

						format(RACE_globalString, sizeof(RACE_globalString), "~g~Position:~w~ %d/%d", RACE_pInfo[i][RACE_playerPosition], RACE_playersInEvent);
						TextDrawSetString(RACE_pInfo[i][RACE_textdrawPosition], RACE_globalString);

						format(RACE_globalString, sizeof(RACE_globalString), "~g~Checkpoint:~w~ %d/%d", RACE_pInfo[i][RACE_playerCheckpointsPassed], RACE_rInfo[RACE_runningID][0][raceMaxCheckpoints]);
						TextDrawSetString(RACE_pInfo[i][RACE_textdrawCheckpoint], RACE_globalString);

						TextDrawSetString(RACE_pInfo[i][RACE_textdrawTimeLeft], "~g~Time Left:~w~ 5:00");

						SetPlayerRaceCheckpoint(i, 0, RACE_rInfo[runID][0][raceCheckpointPositionX], RACE_rInfo[runID][0][raceCheckpointPositionY], RACE_rInfo[runID][0][raceCheckpointPositionZ], RACE_rInfo[runID][1][raceCheckpointPositionX], RACE_rInfo[runID][1][raceCheckpointPositionY], RACE_rInfo[runID][1][raceCheckpointPositionZ], 7.0);

						DisablePlayerCheckpoint(i);
						SetPlayerCheckpoint(i, RACE_rInfo[runID][1][raceCheckpointPositionX], RACE_rInfo[runID][1][raceCheckpointPositionY], RACE_rInfo[runID][1][raceCheckpointPositionZ], 0.0);

						GameTextForPlayer(i, "~n~~g~Go!", 2000, 3);
			            PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);

						TogglePlayerControllable(i, true);

						DisableRemoteVehicleCollisions(i, true);

			            RACE_pInfo[i][RACE_playerTimeTookToFinish] = GetTickCount();

			            format(RACE_globalString, sizeof(RACE_globalString), "Race started with ~g~%d~w~ players.~n~Use ~r~/exitrace~w~ if you want to leave.~n~Good luck!", RACE_playersSpawned);
						RACE_showPlayerTip(i, RACE_globalString, 10000);

						SetCameraBehindPlayer(i);
					}
				}
				
				RACE_globalString[0] = '\0';
				format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race started!", RACE_rInfo[RACE_runningID][0][raceName]);
				SendClientMessageToAll(0x00ff8000, RACE_globalString);

				RACE_checkRaceTimer = SetTimer("RACE_checkRace", 1000, true);

		        RACE_playersLeft = RACE_playersInEvent;

		        RACE_isRaceStarted = true;
		        RACE_isRaceInLobby = false;
		        
		        return 1;
			}
		}
		case 1:
		{
		    RACE_globalString[0] = '\0';
		    format(RACE_globalString, sizeof(RACE_globalString), "~w~Race Event~n~starts in~g~~n~- %d -~w~~n~Second", RACE_timerCounter);

			foreach(new i : Player)
	        {
	            if(RACE_pInfo[i][RACE_isPlayerInRace])
	            {
	            	PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
	            	GameTextForPlayer(i, RACE_globalString, 800, 3);

					TogglePlayerControllable(i, false);
	            }
	        }
		}
		case 2,3:
		{
		    RACE_globalString[0] = '\0';
	        format(RACE_globalString, sizeof(RACE_globalString), "~w~Race Event~n~starts in~g~~n~- %d -~w~~n~Seconds", RACE_timerCounter);

			foreach(new i : Player)
	        {
	            if(RACE_pInfo[i][RACE_isPlayerInRace])
	            {
	            	PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
	            	GameTextForPlayer(i, RACE_globalString, 800, 3);

	            	SetCameraBehindPlayer(i);

					TogglePlayerControllable(i, false);
	            }
	        }
		}
		default:
		{
		    RACE_globalString[0] = '\0';
			format(RACE_globalString, sizeof(RACE_globalString), "~w~Race Event~n~starts in~r~~n~- %d -~w~~n~Seconds", RACE_timerCounter);

			foreach(new i : Player)
	        {
	            if(RACE_pInfo[i][RACE_isPlayerInRace])
	            {
	            	GameTextForPlayer(i, RACE_globalString, 800, 3);

					TogglePlayerControllable(i, false);
	            }
	        }

	        if(RACE_timerCounter == 15)
	        {
				format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race is about to Start in 15 seconds. Use {00ff80}/race{FFFFFF} to join!", RACE_rInfo[RACE_runningID][0][raceName]);
				SendClientMessageToAll(0x00ff8000, RACE_globalString);
			}

			if(RACE_timerCounter == 5)
	        {
				format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s race is about to Start in 5 seconds. Use {00ff80}/race{FFFFFF} to join!", RACE_rInfo[RACE_runningID][0][raceName]);
				SendClientMessageToAll(0x00ff8000, RACE_globalString);
			}
		}
	}
	
	RACE_countdownTimer = SetTimerEx("RACE_countDown", 1000, false, "d", --RACE_timerCounter);
	return 1;
}

forward RACE_playerFinishedTheRace(playerid);
public RACE_playerFinishedTheRace(playerid)
{
	if(!RACE_pInfo[playerid][RACE_isPlayerInRace]) return 0;
	
    switch(RACE_pInfo[playerid][RACE_playerPosition])
    {
		case 1:
		{
			RACE_pInfo[playerid][RACE_playerTimeTookToFinish] = GetTickCount() - RACE_pInfo[playerid][RACE_playerTimeTookToFinish];

			if(RACE_rInfo[RACE_runningID][0][raceRecord] == 0)
			{
			    strcat((RACE_rInfo[RACE_runningID][0][raceRecordHolder][0] = EOS, RACE_rInfo[RACE_runningID][0][raceRecordHolder]), RACE_pInfo[playerid][RACE_playerUsername], MAX_PLAYER_NAME);

				RACE_rInfo[RACE_runningID][0][raceRecord] = RACE_pInfo[playerid][RACE_playerTimeTookToFinish];
				RACE_rInfo[RACE_runningID][0][raceRecordPlaced] = gettime();

			    RACE_updateRace(RACE_runningID);
			    
			    RACE_globalString[0] = '\0';
                format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s has finished 1st and broke the current record to '{00ff80}%i:%02i.%03i{FFFFFF}'.", RACE_pInfo[playerid][RACE_playerUsername], RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 60000, ((RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 1000) % 60), RACE_pInfo[playerid][RACE_playerTimeTookToFinish] % 1000);
				SendClientMessageToAll(0x00ff8000, RACE_globalString);
				
				/* NOTICE: Give Awards */
			}
			else if(RACE_rInfo[RACE_runningID][0][raceRecord] > RACE_pInfo[playerid][RACE_playerTimeTookToFinish])
			{
			    strcat((RACE_rInfo[RACE_runningID][0][raceRecordHolder][0] = EOS, RACE_rInfo[RACE_runningID][0][raceRecordHolder]), RACE_pInfo[playerid][RACE_playerUsername], MAX_PLAYER_NAME);

				RACE_rInfo[RACE_runningID][0][raceRecord] = RACE_pInfo[playerid][RACE_playerTimeTookToFinish];
				RACE_rInfo[RACE_runningID][0][raceRecordPlaced] = gettime();

			    RACE_updateRace(RACE_runningID);

                RACE_globalString[0] = '\0';
				format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s has finished 1st and broke the current record to '{00ff80}%i:%02i.%03i{FFFFFF}'.", RACE_pInfo[playerid][RACE_playerUsername], RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 60000, ((RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 1000) % 60), RACE_pInfo[playerid][RACE_playerTimeTookToFinish] % 1000);
				SendClientMessageToAll(0x00ff8000, RACE_globalString);
				
				/* NOTICE: Give Awards */
			}
			else
			{
			    RACE_globalString[0] = '\0';
				format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s has finished 1st in '{00ff80}%i:%02i.%03i{FFFFFF}' seconds.", RACE_pInfo[playerid][RACE_playerUsername], RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 60000, ((RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 1000) % 60), RACE_pInfo[playerid][RACE_playerTimeTookToFinish] % 1000);
				SendClientMessageToAll(0x00ff8000, RACE_globalString);
				
				/* NOTICE: Give Awards */
			}
		}
		case 2:
		{
		    RACE_pInfo[playerid][RACE_playerTimeTookToFinish] = GetTickCount() - RACE_pInfo[playerid][RACE_playerTimeTookToFinish];

            RACE_globalString[0] = '\0';
			format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s has finished 2nd in '{00ff80}%i:%02i.%03i{FFFFFF}' seconds.", RACE_pInfo[playerid][RACE_playerUsername], RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 60000, ((RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 1000) % 60), RACE_pInfo[playerid][RACE_playerTimeTookToFinish] % 1000);
			SendClientMessageToAll(0x00ff8000, RACE_globalString);

			/* NOTICE: Give Awards */
		}
		case 3:
		{
		    RACE_pInfo[playerid][RACE_playerTimeTookToFinish] = GetTickCount() - RACE_pInfo[playerid][RACE_playerTimeTookToFinish];

            RACE_globalString[0] = '\0';
			format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s has finished 3rd in '{00ff80}%i:%02i.%03i{FFFFFF}' seconds.", RACE_pInfo[playerid][RACE_playerUsername], RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 60000, ((RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 1000) % 60), RACE_pInfo[playerid][RACE_playerTimeTookToFinish] % 1000);
			SendClientMessageToAll(0x00ff8000, RACE_globalString);

			/* NOTICE: Give Awards */
		}
		default:
		{
		    RACE_pInfo[playerid][RACE_playerTimeTookToFinish] = GetTickCount() - RACE_pInfo[playerid][RACE_playerTimeTookToFinish];

            RACE_globalString[0] = '\0';
			format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} You have finished %dth in '{00ff80}%i:%02i.%03i{FFFFFF}' seconds.", RACE_pInfo[playerid][RACE_playerPosition], RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 60000, ((RACE_pInfo[playerid][RACE_playerTimeTookToFinish] / 1000) % 60), RACE_pInfo[playerid][RACE_playerTimeTookToFinish] % 1000);
			SendClientMessage(playerid, 0x00ff8000, RACE_globalString);
		}
	}

	TogglePlayerControllable(playerid, true);
	DisableRemoteVehicleCollisions(playerid, false);
	
	RACE_hidePlayerRaceTextdraws(playerid);
	
	RemovePlayerFromVehicle(playerid);
	
	DestroyVehicle(RACE_pInfo[playerid][RACE_playerVehicle]);
	RACE_pInfo[playerid][RACE_playerVehicle] = -1;
	
	SpawnPlayer(playerid);
	
	RACE_pInfo[playerid][RACE_isPlayerInRace] = false;
	return 1;
}

forward RACE_playerJoinEvent(playerid);
public RACE_playerJoinEvent(playerid)
{
	new
		distance = RACE_rInfo[RACE_runningID][0][raceDistance],
		rID = RACE_runningID,
		Float:X,
		Float:Y,
		Float:Z = RACE_rInfo[rID][0][raceSpawnPositionZ],
		Float:angle = RACE_rInfo[rID][0][raceSpawnPositionA],
		slot
	;

	for(new i = 0, j = sizeof(RACE_spawnSlots); i < j; i++)
	{
	    if(RACE_spawnSlots[i] == -1)
	    {
	        slot = i;
	        break;
	    }
	    else
		{
		    continue;
		}
	}
	
	RACE_spawnSlots[slot] = playerid;

	switch(slot)
	{
		case 0:
		{
			X = RACE_rInfo[rID][0][raceSpawnPositionX], Y = RACE_rInfo[rID][0][raceSpawnPositionY];
		}
		case 1:
		{
			X = RACE_rInfo[rID][0][raceSpawnPositionX] + (distance * floatcos(angle, degrees));
			Y = RACE_rInfo[rID][0][raceSpawnPositionY] + (distance * floatsin(angle, degrees));
		}
		case 2:
		{
			X = RACE_rInfo[rID][0][raceSpawnPositionX] + ((distance * 2) * floatcos(angle, degrees));
			Y = RACE_rInfo[rID][0][raceSpawnPositionY] + ((distance * 2) * floatsin(angle, degrees));
		}
		case 3:
		{
			X = RACE_rInfo[rID][0][raceSpawnPositionX] + ((distance * 3) * floatcos(angle, degrees));
			Y = RACE_rInfo[rID][0][raceSpawnPositionY] + ((distance * 3) * floatsin(angle, degrees));
		}
		case 4:
		{
			X = RACE_rInfo[rID][0][raceSpawnPositionX] - (6 * floatsin(- angle, degrees));
			Y = RACE_rInfo[rID][0][raceSpawnPositionY] - (6 * floatcos(- angle, degrees));
		}
		case 5:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + (distance * floatcos(angle, degrees)) - (6 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + (distance * floatsin(angle, degrees)) - (6 * floatcos(- angle, degrees)));
		}
		case 6:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + ((distance * 2) * floatcos(angle, degrees)) - (6 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + ((distance * 2) * floatsin(angle, degrees)) - (6 * floatcos(- angle, degrees)));
		}
		case 7:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + ((distance * 3) * floatcos(angle, degrees)) - (6 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + ((distance * 3) * floatsin(angle, degrees)) - (6 * floatcos(- angle, degrees)));
		}
		case 8:
		{
			X = RACE_rInfo[rID][0][raceSpawnPositionX] - (12 * floatsin(- angle, degrees));
			Y = RACE_rInfo[rID][0][raceSpawnPositionY] - (12 * floatcos(- angle, degrees));
		}
		case 9:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + (distance  * floatcos(angle, degrees)) - (12 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + (distance  * floatsin(angle, degrees)) - (12 * floatcos(- angle, degrees)));
		}
		case 10:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + ((distance * 2) * floatcos(angle, degrees)) - (12 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + ((distance * 2) * floatsin(angle, degrees)) - (12 * floatcos(- angle, degrees)));
		}
		case 11:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + ((distance * 3) * floatcos(angle, degrees)) - (12 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + ((distance * 3) * floatsin(angle, degrees)) - (12 * floatcos(- angle, degrees)));
		}
		case 12:
		{
			X = RACE_rInfo[rID][0][raceSpawnPositionX] - (18 * floatsin(- angle, degrees));
			Y = RACE_rInfo[rID][0][raceSpawnPositionY] - (18 * floatcos(- angle, degrees));
		}
		case 13:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + (distance * floatcos(angle, degrees)) - (18 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + (distance * floatsin(angle, degrees)) - (18 * floatcos(- angle, degrees)));
		}
		case 14:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + ((distance * 2) * floatcos(angle, degrees)) - (18 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + ((distance * 2) * floatsin(angle, degrees)) - (18 * floatcos(- angle, degrees)));
		}
		case 15:
		{
			X = (RACE_rInfo[rID][0][raceSpawnPositionX] + ((distance * 3) * floatcos(angle, degrees)) - (18 * floatsin(- angle, degrees)));
			Y = (RACE_rInfo[rID][0][raceSpawnPositionY] + ((distance * 3) * floatsin(angle, degrees)) - (18 * floatcos(- angle, degrees)));
		}
	}
	
	SetPlayerInterior(playerid, RACE_rInfo[RACE_runningID][0][raceInterior]);
	SetPlayerVirtualWorld(playerid, RACE_VIRTUALWORLD);

	RACE_createVehicle(playerid, RACE_rInfo[RACE_runningID][0][raceVehicleID], X, Y, Z, angle, RACE_rInfo[RACE_runningID][0][raceInterior], RACE_VIRTUALWORLD);

	X = RACE_rInfo[RACE_runningID][0][raceSpawnPositionX] + (distance * 1.5) * floatcos(angle, degrees);
	Y = RACE_rInfo[RACE_runningID][0][raceSpawnPositionY] + (distance * 1.5) * floatsin(angle, degrees);
	SetPlayerCameraLookAt(playerid, X, Y, Z);

	X = (RACE_rInfo[RACE_runningID][0][raceSpawnPositionX] + ((distance * 1.5) * floatcos(angle, degrees)) + (12 * floatsin(- angle, degrees)));
	Y = (RACE_rInfo[RACE_runningID][0][raceSpawnPositionY] + ((distance * 1.5) * floatsin(angle, degrees)) + (12 * floatcos(- angle, degrees)));
	SetPlayerCameraPos(playerid, X, Y, Z + 6);
	
	TogglePlayerControllable(playerid, false);

	RACE_playersInEvent++;
	RACE_playersSpawned++;

	RACE_pInfo[playerid][RACE_playerCheckpointsPassed] = 0;
	RACE_pInfo[playerid][RACE_playerPosition] = slot + 1;
	
	RACE_pInfo[playerid][RACE_isPlayerInRace] = true;
	return 1;
}

forward RACE_playerExitEvent(playerid);
public RACE_playerExitEvent(playerid)
{
	TogglePlayerControllable(playerid, true);
	DisableRemoteVehicleCollisions(playerid, false);
	
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);

    RACE_playersInEvent--;
    RACE_playersLeft--;
    
	if(RACE_isRaceInLobby)
	{
	    for(new i = 0; i < sizeof(RACE_spawnSlots); i++)
	    {
	    	if(RACE_spawnSlots[i] == playerid)
	    	{
                RACE_spawnSlots[i] = -1;
                break;
	    	}
		}
	}

	RACE_hidePlayerRaceTextdraws(playerid);
	
	RemovePlayerFromVehicle(playerid);
	
	DestroyVehicle(RACE_pInfo[playerid][RACE_playerVehicle]);
	RACE_pInfo[playerid][RACE_playerVehicle] = -1;
	
	SpawnPlayer(playerid);
	
	RACE_pInfo[playerid][RACE_isPlayerInRace] = false;
	return 1;
}


public OnGameModeInit()
{
	for(new i = 0; i < MAX_RACES; i++)
	{
		RACE_loadRaceFromFile(i);
	}
	
	printf(" ___________________________________________________________\n");
	printf("  » Raf Racing System loaded. (Loaded %d Races)", RACE_loadedRaces);
	printf(" ___________________________________________________________\n\n\n");
	
	RACE_loadTextdraws();
	
	#if defined RACE_OnGameModeInit
        RACE_OnGameModeInit();
    #endif
	return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit RACE_OnGameModeInit

#if defined RACE_OnGameModeInit
    forward RACE_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, RACE_pInfo[playerid][RACE_playerUsername], MAX_PLAYER_NAME);
	
	RACE_resetPlayerVariables(playerid);
	
	#if defined RACE_OnPlayerConnect
        RACE_OnPlayerConnect(playerid);
    #endif
	return 1;
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect RACE_OnPlayerConnect

#if defined RACE_OnPlayerConnect
    forward RACE_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	if(RACE_pInfo[playerid][RACE_isPlayerInRace])
	{
		RACE_playerExitEvent(playerid);
	}
	
	#if defined RACE_OnPlayerDisconnect
        RACE_OnPlayerDisconnect(playerid, reason);
    #endif
	return 1;
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect RACE_OnPlayerDisconnect

#if defined RACE_OnPlayerDisconnect
    forward RACE_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
	if(RACE_pInfo[playerid][RACE_isPlayerInRace])
	{
		RACE_playerExitEvent(playerid);
	}
	
	#if defined RACE_OnPlayerDeath
        RACE_OnPlayerDeath(playerid, killerid, reason);
    #endif
	return 1;
}

#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif

#define OnPlayerDeath RACE_OnPlayerDeath

#if defined RACE_OnPlayerDeath
    forward RACE_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(RACE_pInfo[playerid][RACE_isPlayerInRace])
	{
		if(oldstate == PLAYER_STATE_DRIVER)
		{
            PutPlayerInVehicle(playerid, RACE_pInfo[playerid][RACE_playerVehicle], 0);
		}
	}
	
	#if defined RACE_OnPlayerStateChange
        RACE_OnPlayerStateChange(playerid, newstate, oldstate);
    #endif
    return 1;
}

#if defined _ALS_OnPlayerStateChange
    #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif

#define OnPlayerStateChange RACE_OnPlayerStateChange

#if defined RACE_OnPlayerStateChange
    forward RACE_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

public OnPlayerUpdate(playerid)
{
	if(RACE_isRaceStarted)
	{
		if(RACE_pInfo[playerid][RACE_isPlayerInRace])
		{
			new
				speed = RACE_getPlayerSpeed(playerid),
				string[32]
			;

			format(string, sizeof(string), "~g~Speed:~w~ %d KM/H", speed);
			TextDrawSetString(RACE_pInfo[playerid][RACE_textdrawSpeed], string);
		}
	}
	
	#if defined RACE_OnPlayerUpdate
        RACE_OnPlayerUpdate(playerid);
    #endif
    return 1;
}

#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif

#define OnPlayerUpdate RACE_OnPlayerUpdate

#if defined RACE_OnPlayerUpdate
    forward RACE_OnPlayerUpdate(playerid);
#endif

public OnPlayerEnterRaceCheckpoint(playerid)
{
    if(RACE_pInfo[playerid][RACE_isPlayerInRace])
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {			
			RACE_pInfo[playerid][RACE_playerCheckpointsPassed]++;
		    RACE_checkpoints[RACE_pInfo[playerid][RACE_playerCheckpointsPassed]]++;
			RACE_pInfo[playerid][RACE_playerPosition] = RACE_checkpoints[RACE_pInfo[playerid][RACE_playerCheckpointsPassed]];

			if(RACE_pInfo[playerid][RACE_playerCheckpointsPassed] == RACE_rInfo[RACE_runningID][0][raceMaxCheckpoints])
			{
				RACE_playersLeft--;

				DisablePlayerRaceCheckpoint(playerid);
				DisablePlayerCheckpoint(playerid);

				RACE_playerFinishedTheRace(playerid);

				PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			}
			else
			{
				new
					i = RACE_pInfo[playerid][RACE_playerCheckpointsPassed],
					runID = RACE_runningID
				;

                DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);

				if(RACE_rInfo[runID][0][raceMaxCheckpoints] - 1 == i)
				{
					SetPlayerRaceCheckpoint(playerid, 1, RACE_rInfo[runID][i][raceCheckpointPositionX], RACE_rInfo[runID][i][raceCheckpointPositionY], RACE_rInfo[runID][i][raceCheckpointPositionZ], RACE_rInfo[runID][i + 1][raceCheckpointPositionX], RACE_rInfo[runID][i + 1][raceCheckpointPositionY], RACE_rInfo[runID][i + 1][raceCheckpointPositionZ], 7.0);
				}
				else
				{
					SetPlayerRaceCheckpoint(playerid, 0, RACE_rInfo[runID][i][raceCheckpointPositionX], RACE_rInfo[runID][i][raceCheckpointPositionY], RACE_rInfo[runID][i][raceCheckpointPositionZ], RACE_rInfo[runID][i + 1][raceCheckpointPositionX], RACE_rInfo[runID][i + 1][raceCheckpointPositionY], RACE_rInfo[runID][i + 1][raceCheckpointPositionZ], 7.0);

					SetPlayerCheckpoint(playerid, RACE_rInfo[runID][i + 1][raceCheckpointPositionX], RACE_rInfo[runID][i + 1][raceCheckpointPositionY], RACE_rInfo[runID][i + 1][raceCheckpointPositionZ], 0.0);
				}

                RACE_globalString[0] = '\0';
				format(RACE_globalString, sizeof(RACE_globalString), "~g~Position:~w~ %d/%d", RACE_pInfo[playerid][RACE_playerPosition], RACE_playersInEvent);
				TextDrawSetString(RACE_pInfo[playerid][RACE_textdrawPosition], RACE_globalString);

				format(RACE_globalString, sizeof(RACE_globalString), "~g~Checkpoint:~w~ %d/%d", i, RACE_rInfo[runID][0][raceMaxCheckpoints]);
				TextDrawSetString(RACE_pInfo[playerid][RACE_textdrawCheckpoint], RACE_globalString);

				PlayerPlaySound(playerid, 1138,0.0,0.0,0.0);
			}

	  		if(RACE_playersLeft == 0)
			{
				RACE_finishEvent(0);
			}
		}
	}
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{	
	if(dialogid == DIALOG_RACE)
    {
        if(response)
        {
			RACE_prepareEvent(listitem);
		}
    }
		
	#if defined RACE_OnDialogResponse
        RACE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #endif
    return 1;
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif

#define OnDialogResponse RACE_OnDialogResponse

#if defined RACE_OnDialogResponse
    forward RACE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(RACE_pInfo[playerid][RACE_isPlayerInRace])
	{
	    return 0;
	}
	
	#if defined RACE_OnPlayerExitVehicle
        RACE_OnPlayerExitVehicle(playerid, vehicleid);
    #endif
    return 1;
}

#if defined _ALS_OnPlayerExitVehicle
    #undef OnPlayerExitVehicle
#else
    #define _ALS_OnPlayerExitVehicle
#endif

#define OnPlayerExitVehicle RACE_OnPlayerExitVehicle

#if defined RACE_OnPlayerExitVehicle
    forward RACE_OnPlayerExitVehicle(playerid, vehicleid);
#endif

CMD:race(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(RACE_isRaceStarted) return SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} The race has already started.");
	if(!RACE_isRaceInLobby) return SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} There is no running race at the moment.");
	if(RACE_playersSpawned > 15) return SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} The race can't add more players. Try the next one.");

	RACE_globalString[0] = '\0';
	format(RACE_globalString, sizeof(RACE_globalString), "[RACE]{FFFFFF} %s(%d) has joined the race. (%d/16) (/race)", RACE_pInfo[playerid][RACE_playerUsername], playerid, RACE_playersInEvent + 1);
	SendClientMessageToAll(0x00ff8000, RACE_globalString);
	
	RACE_pInfo[playerid][RACE_isPlayerInRace] = true;

	RACE_playerJoinEvent(playerid);
	return 1;
}

CMD:exitrace(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
    if(!RACE_pInfo[playerid][RACE_isPlayerInRace]) return SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} You are not in any Race");

	RACE_playerExitEvent(playerid);

    RACE_globalString[0] = '\0';
	format(RACE_globalString, sizeof(RACE_globalString), "You have left the {00ff80}%s{FFFFFF} race.", RACE_rInfo[RACE_runningID][0][raceName]);
	SendClientMessage(playerid, -1, RACE_globalString);
	return 1;
}

CMD:startrace(playerid, params[])
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(RACE_loadedRaces == 0) return SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} No races found.");
	
	if(RACE_isRaceStarted) return SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} Race has already started.");
	if(RACE_isRaceInLobby) return SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} Race is about to start.");

	new
		string[MAX_RACES * 16]
	;

	for(new i = 0; i < RACE_loadedRaces; i++)
	{
		format(string, sizeof(string), "%s%s\n", string, RACE_rInfo[i][0][raceName]);
	}
		
	ShowPlayerDialog(playerid, DIALOG_RACE, DIALOG_STYLE_LIST, "Race » Select", string, "Select", "Close");
	return 1;
}

CMD:endrace(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(!RACE_isRaceStarted) return SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} There is no running race.");

	RACE_finishEvent(1);
	return 1;
}

CMD:records(playerid, params[])
{
    new
		string[128]
	;
	
	for(new i = 0; i < RACE_loadedRaces; i++)
	{
		format(string, sizeof(string), "%s{009900}%s:{FFFFFF} %s (%i:%02i.%03i)\n\n", string, RACE_rInfo[i][0][raceName], RACE_rInfo[i][0][raceRecordHolder], RACE_rInfo[i][0][raceRecord] / 60000, ((RACE_rInfo[i][0][raceRecord] / 1000) % 60), RACE_rInfo[i][0][raceRecord] % 1000);
	}

	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Race Record Holders", string, "Close", "");
	return 1;
}

CMD:resetrecord(playerid, params[])
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	new
		rName[24]
	;
		
	if(sscanf(params, "s[24]", rName)) return SendClientMessage(playerid, -1, "{FF9900}Usage:{FFFFFF} /resetrecord [Name]");
		
	for(new i = 0; i < RACE_loadedRaces; i++)
	{
		if(!strcmp(rName, RACE_rInfo[i][0][raceName], false))
		{
			strcat((RACE_rInfo[i][0][raceRecordHolder][0] = EOS, RACE_rInfo[i][0][raceRecordHolder]), "None", MAX_PLAYER_NAME);
			RACE_rInfo[i][0][raceRecord] = 0;
			RACE_rInfo[i][0][raceRecordPlaced] = 0;
				
			RACE_updateRace(i);
				
			RACE_globalString[0] = '\0';
			format(RACE_globalString, sizeof(RACE_globalString), "%s record has been reset.", rName);
			SendClientMessage(playerid, -1, RACE_globalString);
			
			return 1;
		}
	}

	SendClientMessage(playerid, 0xFF0000FF, "ERROR {B0B0B0}»{FFFFFF} This Race does not exist.");
	return 1;
}
© 2020 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About
