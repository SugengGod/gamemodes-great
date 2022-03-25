//Job Taxi


CreateJoinTaxiPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, -2159.04, 640.36, 1052.38, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[TAXI JOBS]\n{ffffff}Jadilah Pekerja Taxi disini\n{7fff00}/getjob /accept job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -2159.04, 640.36, 1052.38, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Taxi
}

//Taxi
CMD:taxiduty(playerid, params[])
{
	if(pData[playerid][pJob] == 1 || pData[playerid][pJob2] == 1)
	{
		new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
		
		if(modelid != 438 && modelid != 420)
			return Error(playerid, "Kamu harus berada didalam Taxi.");
			
		if(pData[playerid][pTaxiDuty] == 0)
		{
			pData[playerid][pTaxiDuty] = 1;
			SetPlayerColor(playerid, COLOR_YELLOW);
			SendClientMessageToAllEx(COLOR_YELLOW, "[TAXI]"WHITE_E"[ %s sedang On duty ] {ffffff}Gunakan {7fffd4}[ /call 933 ] {ffffff}untuk memanggil taksi", ReturnName(playerid));
		}
		else
		{
			pData[playerid][pTaxiDuty] = 0;
			SetPlayerColor(playerid, COLOR_WHITE);
			Servers(playerid, "Anda off duty!");
		}
	}
	else return Error(playerid, "Anda bukan pekerja taxi driver.");
	return 1;
}

CheckPassengers(vehicleid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInAnyVehicle(i))
		{
			if(GetPlayerVehicleID(i) == vehicleid && i != GetVehicleDriver(vehicleid))
			{

				return 1;

			}
		}
	}
	return 0;
}

CMD:fare(playerid, params[])
{
	if(pData[playerid][pTaxiDuty] == 0)
		return Error(playerid, "Anda harus On duty taxi.");
		
	new vehicleid = GetPlayerVehicleID(playerid);
	new modelid = GetVehicleModel(vehicleid);
		
	if(modelid != 438 && modelid != 420)
		return Error(playerid, "Anda harus mengendarai taxi.");
		
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return Error(playerid, "Anda bukan driver.");
	
	
	if(pData[playerid][pFare] == 0)
	{
		if(CheckPassengers(vehicleid) != 1) return Error(playerid,"Tidak ada penumpang!");
		GetPlayerPos(playerid, Float:pData[playerid][pFareOldX], Float:pData[playerid][pFareOldY], Float:pData[playerid][pFareOldZ]);
		pData[playerid][pFareTimer] = SetTimerEx("FareUpdate", 1000, true, "ii", playerid, GetVehiclePassenger(vehicleid));
		pData[playerid][pFare] = 1;
		pData[playerid][pTotalFare] = 5;
		new formatted[128];
		format(formatted,128,"%s", FormatMoney(pData[playerid][pTotalFare]));
		//TextDrawShowForPlayer(playerid, TDEditor_TD[11]);
		TextDrawShowForPlayer(playerid, DPvehfare[playerid]);
		TextDrawSetString(DPvehfare[playerid], formatted);
		Info(playerid, "Anda telah mengaktifkan taxi fare, silahkan menuju ke tempat tujuan!");
		//passanger
		//TextDrawShowForPlayer(GetVehiclePassenger(vehicleid), TDEditor_TD[11]);
		TextDrawShowForPlayer(GetVehiclePassenger(vehicleid), DPvehfare[GetVehiclePassenger(vehicleid)]);
		TextDrawSetString(DPvehfare[GetVehiclePassenger(vehicleid)], formatted);
		Info(GetVehiclePassenger(vehicleid), "Taxi fare telah aktif!");
	}
	else
	{
		//TextDrawHideForPlayer(playerid, TDEditor_TD[11]);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
		KillTimer(pData[playerid][pFareTimer]);
		Info(playerid, "Anda telah menonaktifkan taxi fare pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
		//passanger
		Info(GetVehiclePassenger(vehicleid), "Taxi fare telah di non aktifkan pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
		//TextDrawHideForPlayer(GetVehiclePassenger(vehicleid), TDEditor_TD[11]);
		TextDrawHideForPlayer(GetVehiclePassenger(vehicleid), DPvehfare[GetVehiclePassenger(vehicleid)]);
		pData[playerid][pFare] = 0;
		pData[playerid][pTotalFare] = 0;
	}
	return 1;
}

function FareUpdate(playerid, passanger)
{	
	new formatted[128];
	GetPlayerPos(playerid,pData[playerid][pFareNewX],pData[playerid][pFareNewY],pData[playerid][pFareNewZ]);
	new Float:totdistance = GetDistanceBetweenPoints(pData[playerid][pFareOldX],pData[playerid][pFareOldY],pData[playerid][pFareOldZ], pData[playerid][pFareNewX],pData[playerid][pFareNewY],pData[playerid][pFareNewZ]);
    if(totdistance > 300.0)
    {
		new argo = RandomEx(4, 10);
	    pData[playerid][pTotalFare] = pData[playerid][pTotalFare]+argo;
		format(formatted,128,"%s", FormatMoney(pData[playerid][pTotalFare]));
		TextDrawShowForPlayer(playerid, DPvehfare[playerid]);
		TextDrawSetString(DPvehfare[playerid], formatted);
		GetPlayerPos(playerid,Float:pData[playerid][pFareOldX],Float:pData[playerid][pFareOldY],Float:pData[playerid][pFareOldZ]);
		//passanger
		TextDrawShowForPlayer(passanger, DPvehfare[passanger]);
		TextDrawSetString(DPvehfare[passanger], formatted);
	}
	return 1;
}
