//291.35, -106.30, 1001.51

CreateArmsPoint()
{
	
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, 291.35, -106.30, 1001.51, -1, -1, -1, 50);
	format(strings, sizeof(strings), "{7fffd4}[Black Market]\n{FFFFFF}/creategun");
	CreateDynamic3DTextLabel(strings, COLOR_GREY, 291.35, -106.30, 1001.51, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //
}

CMD:creategun(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, 291.35, -106.30, 1001.51)) return Error(playerid, "Kamu harus diblackmarket!");
	if(pData[playerid][pLevel] < 3) return Error(playerid, "Kamu tidak memiliki skill creategun.");
	if(pData[playerid][pFamily] == -1) return Error(playerid, "Kamu bukan anggota Geng/ Family.");
	
	new Dstring[512];
	format(Dstring, sizeof(Dstring), "Weapon (Ammo)\tMaterial\n\
	{ffffff}Silenced Pistol (ammo 70)\t320\n");
	format(Dstring, sizeof(Dstring), "{ffffff}%sColt45 9MM(ammo 70)\t250\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sDesert Eagle(ammo 70)\t350\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sShotgun(ammo 50)\t300\n", Dstring);
	format(Dstring, sizeof(Dstring), "{ffffff}%sAK-47(ammo 100)\t500\n", Dstring);
	ShowPlayerDialog(playerid, DIALOG_ARMS_GUN, DIALOG_STYLE_TABLIST_HEADERS, "Create Gun", Dstring, "Create", "Cancel");
	return 1;
}

function CreateGun(playerid, gunid, ammo)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pArmsDealerStatus] != 1) return 0;
	if(gunid == 0 || ammo == 0) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		GivePlayerWeaponEx(playerid, gunid, ammo);
		
		Info(playerid, "Kamu telah berhasil membuat senjata ilegal.");
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		KillTimer(pData[playerid][pArmsDealer]);
		pData[playerid][pActivityTime] = 0;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pEnergy] -= 3;
		return 1;
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
