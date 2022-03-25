
//----------[ Native Login Register]----------
/*AssignPlayerData(playerid)
{
	new aname[128], email[128], age[128], ip[128], regdate[50], lastlogin[50];
	
	cache_get_value_int(0, "id", pData[playerid][pID]);
	cache_get_value(0, "adminname", aname);
	format(pData[playerid][pAdminname], 128, "%s", aname);
	cache_get_value(0, "ip", ip);
	format(pData[playerid][pIP], 128, "%s", ip);
	cache_get_value(0, "email", email);
	format(pData[playerid][pEmail], 128, "%s", email);
	cache_get_value_int(0, "admin", pData[playerid][pAdmin]);
	cache_get_value_int(0, "helper", pData[playerid][pHelper]);
	cache_get_value_int(0, "level", pData[playerid][pLevel]);
	cache_get_value_int(0, "levelup", pData[playerid][pLevelUp]);
	cache_get_value_int(0, "vip", pData[playerid][pVip]);
	cache_get_value_int(0, "vip_time", pData[playerid][pVipTime]);
	cache_get_value_int(0, "gold", pData[playerid][pGold]);
	cache_get_value(0, "reg_date", regdate);
	format(pData[playerid][pRegDate], 128, "%s", regdate);
	cache_get_value(0, "last_login", lastlogin);
	format(pData[playerid][pLastLogin], 128, "%s", lastlogin);
	cache_get_value_int(0, "money", pData[playerid][pMoney]);
	cache_get_value_int(0, "bmoney", pData[playerid][pBankMoney]);
	cache_get_value_int(0, "brek", pData[playerid][pBankRek]);
	cache_get_value_int(0, "phone", pData[playerid][pPhone]);
	cache_get_value_int(0, "phonecredit", pData[playerid][pPhoneCredit]);
	cache_get_value_int(0, "phonebook", pData[playerid][pPhoneBook]);
	cache_get_value_int(0, "hours", pData[playerid][pHours]);
	cache_get_value_int(0, "minutes", pData[playerid][pMinutes]);
	cache_get_value_int(0, "seconds", pData[playerid][pSeconds]);
	cache_get_value_int(0, "paycheck", pData[playerid][pPaycheck]);
	cache_get_value_int(0, "skin", pData[playerid][pSkin]);
	cache_get_value_int(0, "facskin", pData[playerid][pFacSkin]);
	cache_get_value_int(0, "gender", pData[playerid][pGender]);
	cache_get_value(0, "age", age);
	format(pData[playerid][pAge], 128, "%s", age);
	cache_get_value_int(0, "indoor", pData[playerid][pInDoor]);
	cache_get_value_int(0, "inhouse", pData[playerid][pInHouse]);
	cache_get_value_int(0, "inbiz", pData[playerid][pInBiz]);
	cache_get_value_float(0, "posx", pData[playerid][pPosX]);
	cache_get_value_float(0, "posy", pData[playerid][pPosY]);
	cache_get_value_float(0, "posz", pData[playerid][pPosZ]);
	cache_get_value_float(0, "posa", pData[playerid][pPosA]);
	cache_get_value_int(0, "interior", pData[playerid][pInt]);
	cache_get_value_int(0, "world", pData[playerid][pWorld]);
	cache_get_value_float(0, "health", pData[playerid][pHealth]);
	cache_get_value_float(0, "armour", pData[playerid][pArmour]);
	cache_get_value_int(0, "hunger", pData[playerid][pHunger]);
	cache_get_value_int(0, "energy", pData[playerid][pEnergy]);
	cache_get_value_int(0, "sick", pData[playerid][pSick]);
	cache_get_value_int(0, "hospital", pData[playerid][pHospital]);
	cache_get_value_int(0, "injured", pData[playerid][pInjured]);
	cache_get_value_int(0, "duty", pData[playerid][pOnDuty]);
	cache_get_value_int(0, "dutytime", pData[playerid][pOnDutyTime]);
	cache_get_value_int(0, "faction", pData[playerid][pFaction]);
	cache_get_value_int(0, "factionrank", pData[playerid][pFactionRank]);
	cache_get_value_int(0, "factionlead", pData[playerid][pFactionLead]);
	cache_get_value_int(0, "family", pData[playerid][pFamily]);
	cache_get_value_int(0, "familyrank", pData[playerid][pFamilyRank]);
	cache_get_value_int(0, "jail", pData[playerid][pJail]);
	cache_get_value_int(0, "arrest", pData[playerid][pArrest]);
	cache_get_value_int(0, "arrest_time", pData[playerid][pArrestTime]);
	cache_get_value_int(0, "warn", pData[playerid][pWarn]);
	cache_get_value_int(0, "job", pData[playerid][pJob]);
	cache_get_value_int(0, "job2", pData[playerid][pJob2]);
	cache_get_value_int(0, "jobtime", pData[playerid][pJobTime]);
	cache_get_value_int(0, "exitjob", pData[playerid][pExitJob]);
	cache_get_value_int(0, "taxitime", pData[playerid][pTaxiTime]);
	cache_get_value_int(0, "medicine", pData[playerid][pMedicine]);
	cache_get_value_int(0, "medkit", pData[playerid][pMedkit]);
	cache_get_value_int(0, "mask", pData[playerid][pMask]);
	cache_get_value_int(0, "helmet", pData[playerid][pHelmet]);
	cache_get_value_int(0, "snack", pData[playerid][pSnack]);
	cache_get_value_int(0, "sprunk", pData[playerid][pSprunk]);
	cache_get_value_int(0, "gas", pData[playerid][pGas]);
	cache_get_value_int(0, "bandage", pData[playerid][pBandage]);
	cache_get_value_int(0, "gps", pData[playerid][pGPS]);
	cache_get_value_int(0, "material", pData[playerid][pMaterial]);
	cache_get_value_int(0, "component", pData[playerid][pComponent]);
	cache_get_value_int(0, "fishtool", pData[playerid][pFishTool]);
	cache_get_value_int(0, "fish", pData[playerid][pFish]);
	cache_get_value_int(0, "worm", pData[playerid][pWorm]);
	cache_get_value_int(0, "idcard", pData[playerid][pIDCard]);
	cache_get_value_int(0, "idcard_time", pData[playerid][pIDCardTime]);
	cache_get_value_int(0, "drivelic", pData[playerid][pDriveLic]);
	cache_get_value_int(0, "drivelic_time", pData[playerid][pDriveLicTime]);
	
	cache_get_value_int(0, "Gun1", pData[playerid][pGuns][0]);
	cache_get_value_int(0, "Gun2", pData[playerid][pGuns][1]);
	cache_get_value_int(0, "Gun3", pData[playerid][pGuns][2]);
	cache_get_value_int(0, "Gun4", pData[playerid][pGuns][3]);
	cache_get_value_int(0, "Gun5", pData[playerid][pGuns][4]);
	cache_get_value_int(0, "Gun6", pData[playerid][pGuns][5]);
	cache_get_value_int(0, "Gun7", pData[playerid][pGuns][6]);
	cache_get_value_int(0, "Gun8", pData[playerid][pGuns][7]);
	cache_get_value_int(0, "Gun9", pData[playerid][pGuns][8]);
	cache_get_value_int(0, "Gun10", pData[playerid][pGuns][9]);
	cache_get_value_int(0, "Gun11", pData[playerid][pGuns][10]);
	cache_get_value_int(0, "Gun12", pData[playerid][pGuns][11]);
	cache_get_value_int(0, "Gun13", pData[playerid][pGuns][12]);
	
	cache_get_value_int(0, "Ammo1", pData[playerid][pAmmo][0]);
	cache_get_value_int(0, "Ammo2", pData[playerid][pAmmo][1]);
	cache_get_value_int(0, "Ammo3", pData[playerid][pAmmo][2]);
	cache_get_value_int(0, "Ammo4", pData[playerid][pAmmo][3]);
	cache_get_value_int(0, "Ammo5", pData[playerid][pAmmo][4]);
	cache_get_value_int(0, "Ammo6", pData[playerid][pAmmo][5]);
	cache_get_value_int(0, "Ammo7", pData[playerid][pAmmo][6]);
	cache_get_value_int(0, "Ammo8", pData[playerid][pAmmo][7]);
	cache_get_value_int(0, "Ammo9", pData[playerid][pAmmo][8]);
	cache_get_value_int(0, "Ammo10", pData[playerid][pAmmo][9]);
	cache_get_value_int(0, "Ammo11", pData[playerid][pAmmo][10]);
	cache_get_value_int(0, "Ammo12", pData[playerid][pAmmo][11]);
	cache_get_value_int(0, "Ammo13", pData[playerid][pAmmo][12]);
	
	for (new i; i < 17; i++)
	{
		WeaponSettings[playerid][i][Position][0] = -0.116;
		WeaponSettings[playerid][i][Position][1] = 0.189;
		WeaponSettings[playerid][i][Position][2] = 0.088;
		WeaponSettings[playerid][i][Position][3] = 0.0;
		WeaponSettings[playerid][i][Position][4] = 44.5;
		WeaponSettings[playerid][i][Position][5] = 0.0;
		WeaponSettings[playerid][i][Bone] = 1;
		WeaponSettings[playerid][i][Hidden] = false;
	}
	WeaponTick[playerid] = 0;
	EditingWeapon[playerid] = 0;
	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "SELECT * FROM weaponsettings WHERE Owner = '%d'", pData[playerid][pID]);
	mysql_tquery(g_SQL, string, "OnWeaponsLoaded", "d", playerid);
	
	MySQL_LoadPlayerToys(playerid);
	LoadPlayerVehicle(playerid);
	return 1;
}*/

UpdatePlayerData(playerid)
{
	if(pData[playerid][IsLoggedIn] == false) return 0;
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(IsATruck(GetPlayerVehicleID(playerid)))
		{
			RemovePlayerFromVehicle(playerid);
			GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
			pData[playerid][pPosZ] = pData[playerid][pPosZ]+0.4;
		}
		else
		{
			GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
		}
    }
	else
	{
		GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	}
	GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
	GetPlayerHealth(playerid, pData[playerid][pHealth]);
	GetPlayerArmour(playerid, pData[playerid][pArmour]);
	//UpdateWeapons(playerid);

	new cQuery[4028], PlayerIP[16];

	GetPlayerIp(playerid, PlayerIP, sizeof (PlayerIP));
	
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE `players` SET ");
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun1` = '%d', ", cQuery, pData[playerid][pGuns][0]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun2` = '%d', ", cQuery, pData[playerid][pGuns][1]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun3` = '%d', ", cQuery, pData[playerid][pGuns][2]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun4` = '%d', ", cQuery, pData[playerid][pGuns][3]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun5` = '%d', ", cQuery, pData[playerid][pGuns][4]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun6` = '%d', ", cQuery, pData[playerid][pGuns][5]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun7` = '%d', ", cQuery, pData[playerid][pGuns][6]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun8` = '%d', ", cQuery, pData[playerid][pGuns][7]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun9` = '%d', ", cQuery, pData[playerid][pGuns][8]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun10` = '%d', ", cQuery, pData[playerid][pGuns][9]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun11` = '%d', ", cQuery, pData[playerid][pGuns][10]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun12` = '%d', ", cQuery, pData[playerid][pGuns][11]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Gun13` = '%d', ", cQuery, pData[playerid][pGuns][12]);
	
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo1` = '%d', ", cQuery, pData[playerid][pAmmo][0]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo2` = '%d', ", cQuery, pData[playerid][pAmmo][1]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo3` = '%d', ", cQuery, pData[playerid][pAmmo][2]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo4` = '%d', ", cQuery, pData[playerid][pAmmo][3]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo5` = '%d', ", cQuery, pData[playerid][pAmmo][4]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo6` = '%d', ", cQuery, pData[playerid][pAmmo][5]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo7` = '%d', ", cQuery, pData[playerid][pAmmo][6]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo8` = '%d', ", cQuery, pData[playerid][pAmmo][7]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo9` = '%d', ", cQuery, pData[playerid][pAmmo][8]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo10` = '%d', ", cQuery, pData[playerid][pAmmo][9]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo11` = '%d', ", cQuery, pData[playerid][pAmmo][10]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo12` = '%d', ", cQuery, pData[playerid][pAmmo][11]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`Ammo13` = '%d', ", cQuery, pData[playerid][pAmmo][12]);
	
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`username` = '%e', ", cQuery, pData[playerid][pName]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`adminname` = '%e', ", cQuery, pData[playerid][pAdminname]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`twittername` = '%e', ", cQuery, pData[playerid][pTwittername]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`ip` = '%s', ", cQuery, PlayerIP);
	//mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`email` = '%s', ", cQuery, pData[playerid][pEmail]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`admin` = '%d', ", cQuery, pData[playerid][pAdmin]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`servermod` = '%d', ", cQuery, pData[playerid][pServerModerator]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`eventmod` = '%d', ", cQuery, pData[playerid][pEventModerator]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`factionmod` = '%d', ", cQuery, pData[playerid][pFactionModerator]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`familymod` = '%d', ", cQuery, pData[playerid][pFamilyModerator]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`helper` = '%d', ", cQuery, pData[playerid][pHelper]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`level` = '%d', ", cQuery, pData[playerid][pLevel]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`levelup` = '%d', ", cQuery, pData[playerid][pLevelUp]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`vip` = '%d', ", cQuery, pData[playerid][pVip]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`vip_time` = '%d', ", cQuery, pData[playerid][pVipTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`gold` = '%d', ", cQuery, pData[playerid][pGold]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`money` = '%d', ", cQuery, pData[playerid][pMoney]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`redmoney` = '%d', ", cQuery, pData[playerid][pRedMoney]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`bmoney` = '%d', ", cQuery, pData[playerid][pBankMoney]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`brek` = '%d', ", cQuery, pData[playerid][pBankRek]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`starterpack` = '%d', ", cQuery, pData[playerid][pStarterpack]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`phone` = '%d', ", cQuery, pData[playerid][pPhone]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`phonestatus` = '%d', ", cQuery, pData[playerid][pPhoneStatus]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`phonekuota` = '%d', ", cQuery, pData[playerid][pKuota]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`phonecredit` = '%d', ", cQuery, pData[playerid][pPhoneCredit]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`phonebook` = '%d', ", cQuery, pData[playerid][pPhoneBook]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`twitter` = '%d', ", cQuery, pData[playerid][pTwitter]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`twitterstatus` = '%d', ", cQuery, pData[playerid][pTwitterStatus]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`wt` = '%d', ", cQuery, pData[playerid][pWT]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`hours` = '%d', ", cQuery, pData[playerid][pHours]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`minutes` = '%d', ", cQuery, pData[playerid][pMinutes]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`seconds` = '%d', ", cQuery, pData[playerid][pSeconds]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`paycheck` = '%d', ", cQuery, pData[playerid][pPaycheck]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`skin` = '%d', ", cQuery, pData[playerid][pSkin]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`facskin` = '%d', ", cQuery, pData[playerid][pFacSkin]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`gender` = '%d', ", cQuery, pData[playerid][pGender]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`age` = '%s', ", cQuery, pData[playerid][pAge]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`indoor` = '%d', ", cQuery, pData[playerid][pInDoor]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`inhouse` = '%d', ", cQuery, pData[playerid][pInHouse]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`inbiz` = '%d', ", cQuery, pData[playerid][pInBiz]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`infamily` = '%d', ", cQuery, pData[playerid][pInFamily]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`posx` = '%f', ", cQuery, pData[playerid][pPosX]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`posy` = '%f', ", cQuery, pData[playerid][pPosY]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`posz` = '%f', ", cQuery, pData[playerid][pPosZ]+0.3);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`posa` = '%f', ", cQuery, pData[playerid][pPosA]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`interior` = '%d', ", cQuery, GetPlayerInterior(playerid));
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`world` = '%d', ", cQuery, GetPlayerVirtualWorld(playerid));
	
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`health` = '%f', ", cQuery, pData[playerid][pHealth]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`armour` = '%f', ", cQuery, pData[playerid][pArmour]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`hunger` = '%d', ", cQuery, pData[playerid][pHunger]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`energy` = '%d', ", cQuery, pData[playerid][pEnergy]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sick` = '%d', ", cQuery, pData[playerid][pSick]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`hospital` = '%d', ", cQuery, pData[playerid][pHospital]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`injured` = '%d', ", cQuery, pData[playerid][pInjured]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`duty` = '%d', ", cQuery, pData[playerid][pOnDuty]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`dutytime` = '%d', ", cQuery, pData[playerid][pOnDutyTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`faction` = '%d', ", cQuery, pData[playerid][pFaction]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`factionrank` = '%d', ", cQuery, pData[playerid][pFactionRank]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`factionlead` = '%d', ", cQuery, pData[playerid][pFactionLead]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`family` = '%d', ", cQuery, pData[playerid][pFamily]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`familyrank` = '%d', ", cQuery, pData[playerid][pFamilyRank]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`jail` = '%d', ", cQuery, pData[playerid][pJail]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`jail_time` = '%d', ", cQuery, pData[playerid][pJailTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`arrest` = '%d', ", cQuery, pData[playerid][pArrest]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`arrest_time` = '%d', ", cQuery, pData[playerid][pArrestTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`suspect` = '%d', ", cQuery, pData[playerid][pSuspect]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`suspect_time` = '%d', ", cQuery, pData[playerid][pSuspectTimer]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`ask_time` = '%d', ", cQuery, pData[playerid][pAskTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`warn` = '%d', ", cQuery, pData[playerid][pWarn]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`job` = '%d', ", cQuery, pData[playerid][pJob]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`job2` = '%d', ", cQuery, pData[playerid][pJob2]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`jobtime` = '%d', ", cQuery, pData[playerid][pJobTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sidejobtime` = '%d', ", cQuery, pData[playerid][pSideJobTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sidejob_bustime` = '%d', ", cQuery, pData[playerid][pBusTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sidejob_forkliftertime` = '%d', ", cQuery, pData[playerid][pForklifterTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sidejob_mowertime` = '%d', ", cQuery, pData[playerid][pMowerTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sidejob_sweepertime` = '%d', ", cQuery, pData[playerid][pSweeperTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`exitjob` = '%d', ", cQuery, pData[playerid][pExitJob]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`taxitime` = '%d', ", cQuery, pData[playerid][pTaxiTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`robtime` = '%d', ", cQuery, pData[playerid][pRobTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`myricous` = '%d', ", cQuery, pData[playerid][pObat]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`medicine` = '%d', ", cQuery, pData[playerid][pMedicine]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`medkit` = '%d', ", cQuery, pData[playerid][pMedkit]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`mask` = '%d', ", cQuery, pData[playerid][pMask]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`helmet` = '%d', ", cQuery, pData[playerid][pHelmet]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`snack` = '%d', ", cQuery, pData[playerid][pSnack]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sprunk` = '%d', ", cQuery, pData[playerid][pSprunk]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`gas` = '%d', ", cQuery, pData[playerid][pGas]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`bandage` = '%d', ", cQuery, pData[playerid][pBandage]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`gps` = '%d', ", cQuery, pData[playerid][pGPS]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`material` = '%d', ", cQuery, pData[playerid][pMaterial]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`component` = '%d', ", cQuery, pData[playerid][pComponent]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`food` = '%d', ", cQuery, pData[playerid][pFood]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`seed` = '%d', ", cQuery, pData[playerid][pSeed]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`potato` = '%d', ", cQuery, pData[playerid][pPotato]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`wheat` = '%d', ", cQuery, pData[playerid][pWheat]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`orange` = '%d', ", cQuery, pData[playerid][pOrange]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`price1` = '%d', ", cQuery, pData[playerid][pPrice1]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`price2` = '%d', ", cQuery, pData[playerid][pPrice2]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`price3` = '%d', ", cQuery, pData[playerid][pPrice3]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`price4` = '%d', ", cQuery, pData[playerid][pPrice4]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`marijuana` = '%d', ", cQuery, pData[playerid][pMarijuana]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`plant` = '%d', ", cQuery, pData[playerid][pPlant]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`plant_time` = '%d', ", cQuery, pData[playerid][pPlantTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`fishtool` = '%d', ", cQuery, pData[playerid][pFishTool]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`fish` = '%d', ", cQuery, pData[playerid][pFish]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`worm` = '%d', ", cQuery, pData[playerid][pWorm]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`idcard` = '%d', ", cQuery, pData[playerid][pIDCard]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`idcard_time` = '%d', ", cQuery, pData[playerid][pIDCardTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`drivelic` = '%d', ", cQuery, pData[playerid][pDriveLic]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`drivelic_time` = '%d', ", cQuery, pData[playerid][pDriveLicTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weaponlic` = '%d', ", cQuery, pData[playerid][pWeaponLic]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weaponlic_time` = '%d', ", cQuery, pData[playerid][pWeaponLicTime]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`hbemode` = '%d', ", cQuery, pData[playerid][pHBEMode]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`togpm` = '%d', ", cQuery, pData[playerid][pTogPM]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`toglog` = '%d', ", cQuery, pData[playerid][pTogLog]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`togads` = '%d', ", cQuery, pData[playerid][pTogAds]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`togwt` = '%d', ", cQuery, pData[playerid][pTogWT]);
	
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`kepala` = '%d', ", cQuery, pData[playerid][pHead]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`perut` = '%d', ", cQuery, pData[playerid][pPerut]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`lengankiri` = '%d', ", cQuery, pData[playerid][pLHand]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`lengankanan` = '%d', ", cQuery, pData[playerid][pRHand]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`kakikiri` = '%d', ", cQuery, pData[playerid][pLFoot]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`kakikanan` = '%d', ", cQuery, pData[playerid][pRFoot]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`kurir` = '%d', ", cQuery, pData[playerid][pKurirEnd]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sparepart` = '%d', ", cQuery, pData[playerid][pSparepart]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`senter` = '%d', ", cQuery, pData[playerid][pFlashlight]);

	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`last_login` = CURRENT_TIMESTAMP() WHERE `reg_id` = '%d'", cQuery, pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	
	MySQL_SavePlayerToys(playerid);
	return 1;
}

/*UpdatePlayerData(playerid)
{
	if (pData[playerid][IsLoggedIn] == false) return 0;

	GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
	//UpdateWeapons(playerid);

	new query[2048], PlayerIP[16];
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	
	mysql_format(g_SQL, query, sizeof query, "UPDATE players SET username='%s',adminname='%s',ip='%s',email='%s',admin=%d,helper=%d,level=%d,levelup=%d,vip=%d,vip_time=%d,coin=%d,money=%d,bmoney=%d,brek=%d,phone=%d,phonecredit=%d,hours=%d,minutes=%d,seconds=%d,paycheck='%d',skin=%d,facskin=%d,gender=%d,age='%s',indoor=%d,inhouse=%d,inbiz=%d,posx=%f,posy=%f,posz=%f,posa=%f,interior=%d,world=%d",
	pData[playerid][pName],
	pData[playerid][pAdminname],
	PlayerIP,
	pData[playerid][pEmail],
	pData[playerid][pAdmin],
	pData[playerid][pHelper],
	pData[playerid][pLevel],
	pData[playerid][pLevelUp],
	pData[playerid][pVip],
	pData[playerid][pVipTime],
	pData[playerid][pGold],
	pData[playerid][pMoney],
	pData[playerid][pBankMoney],
	pData[playerid][pBankRek],
	pData[playerid][pPhone],
	pData[playerid][pPhoneCredit],
	pData[playerid][pHours],
	pData[playerid][pMinutes],
	pData[playerid][pSeconds],
	pData[playerid][pPaycheck],
	pData[playerid][pSkin],
	pData[playerid][pFacSkin],
	pData[playerid][pGender],
	pData[playerid][pAge],
	pData[playerid][pInDoor],
	pData[playerid][pInHouse],
	pData[playerid][pInBiz],
	pData[playerid][pPosX],
	pData[playerid][pPosY],
	pData[playerid][pPosZ],
	pData[playerid][pPosA],
	GetPlayerInterior(playerid),
	GetPlayerVirtualWorld(playerid));
	
	for (new i = 0; i < 13; i ++) 
	{
        format(query, sizeof(query), "%s, Gun%d=%d, Ammo%d=%d", query, i + 1, pData[playerid][pGuns][i], i + 1, pData[playerid][pAmmo][i]);
    }
	format(query, sizeof(query), "%s, health=%f,armour=%f,hunger=%d,bladder=%d,energy=%d,sick=%d,hospital=%d,injured=%d,duty=%d,dutytime=%d,faction=%d,factionrank=%d,family=%d,familyrank=%d,jail=%d,arrest=%d,arrest_time=%d,warn=%d,job=%d,job2=%d,jobtime=%d,taxitime=%d,medicine=%d,medkit=%d,mask=%d,helmet=%d,snack=%d,sprunk=%d,gas=%d,bandage=%d,gps=%d,material=%d,component=%d,idcard=%d,idcard_time=%d,drivelic=%d,drivelic_time=%d,last_login=CURRENT_TIMESTAMP() WHERE ID=%d LIMIT 1",
	query,
	pData[playerid][pHealth],
	pData[playerid][pArmour],
	pData[playerid][pHunger],
	pData[playerid][pEnergy],
	pData[playerid][pSick],
	pData[playerid][pHospital],
	pData[playerid][pInjured],
	pData[playerid][pOnDuty],
	pData[playerid][pOnDutyTime],
	pData[playerid][pFaction],
	pData[playerid][pFactionRank],
	pData[playerid][pFamily],
	pData[playerid][pFamilyRank],
	pData[playerid][pJail],
	pData[playerid][pArrest],
	pData[playerid][pArrestTime],
	pData[playerid][pWarn],
	pData[playerid][pJob],
	pData[playerid][pJob2],
	pData[playerid][pJobTime],
	pData[playerid][pTaxiTime],
	pData[playerid][pMedicine],
	pData[playerid][pMedkit],
	pData[playerid][pMask],
	pData[playerid][pHelmet],
	pData[playerid][pSnack],
	pData[playerid][pSprunk],
	pData[playerid][pGas],
	pData[playerid][pBandage],
	pData[playerid][pGPS],
	pData[playerid][pMaterial],
	pData[playerid][pComponent],
	pData[playerid][pIDCard],
	pData[playerid][pIDCardTime],
	pData[playerid][pDriveLic],
	pData[playerid][pDriveLicTime],
	pData[playerid][pID]);
	mysql_tquery(g_SQL, query);
	
	//MySQL_SavePlayerToys(playerid);
	return 1;
}*/

ResetVariables(playerid)
{
	/*for(new i; E_PLAYERS:i < E_PLAYERS; i++)
	{
    	pData[playerid][E_PLAYERS:i] = 0;
	}*/
	
	static const empty_player[E_PLAYERS];
	pData[playerid] = empty_player;
	
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;
	pData[playerid][pFamily] = -1;
	pData[playerid][IsLoggedIn] = false;
	pData[playerid][PurchasedToy] = false;
	pData[playerid][pHealth] = 100.0;
	pData[playerid][pArmour] = 0.0;
	pData[playerid][pMaskID] = random(90000) + 10000;
	pData[playerid][pSpec] = -1;
	pData[playerid][spfuelbar] = INVALID_PLAYER_BAR_ID;
	pData[playerid][spdamagebar] = INVALID_PLAYER_BAR_ID;
	pData[playerid][sphungrybar] = INVALID_PLAYER_BAR_ID;
	pData[playerid][spenergybar] = INVALID_PLAYER_BAR_ID;
	pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
	
//	pData[playerid][pTransferName] = "None";
	pData[playerid][pFlareActive] = false;
	pData[playerid][pAdoActive] = false;
	pData[playerid][CuttingTreeID] = -1;
	pData[playerid][CarryingLumber] = false;
	pData[playerid][CarryingBox] = false;
	pData[playerid][EditingTreeID] = -1;
	pData[playerid][pNewsGuest] = INVALID_PLAYER_ID;
	pData[playerid][pFindEms] = INVALID_PLAYER_ID;
	pData[playerid][pCall] = INVALID_PLAYER_ID;
	
	pData[playerid][MiningOreID] = -1;
	pData[playerid][CarryingLog] = -1;
	pData[playerid][EditingOreID] = -1;
	
	pData[playerid][EditingATMID] = -1;
	pData[playerid][EditingVending] = -1;
	pData[playerid][gEditID] = -1;
	
	pData[playerid][pHarvestID] = -1;
	pData[playerid][pOffer] = -1;
	
	pData[playerid][pFill] = -1;
	
	pData[playerid][pMission] = -1;
	pData[playerid][pHauling] = -1;
	
	pData[playerid][pFacInvite] = -1;
	pData[playerid][pFacOffer] = -1;
	pData[playerid][pFamInvite] = -1;
	pData[playerid][pFamOffer] = -1;
	
	pData[playerid][pHBEMode] = 1;
	
	gPlayerUsingLoopingAnim[playerid] = 0;
	gPlayerAnimLibsPreloaded[playerid] = 0;
	
	pData[playerid][pLoc] = -1;
	SetPVarInt(playerid, "GiveUptime", 0);
	
	ResetVariableTazer(playerid);
	
	//Toys
    pData[playerid][PurchasedToy] = false;
	pData[playerid][toySelected] = 0;
	for(new i = 0; i < 6; i++)
	{
		pToys[playerid][i][toy_model] = 0;
		pToys[playerid][i][toy_bone] = 0;
		pToys[playerid][i][toy_x] = 0.0;
		pToys[playerid][i][toy_y] = 0.0;
		pToys[playerid][i][toy_z] = 0.0;
		pToys[playerid][i][toy_rx] = 0.0;
		pToys[playerid][i][toy_ry] = 0.0;
		pToys[playerid][i][toy_rz] = 0.0;
		pToys[playerid][i][toy_sx] = 0.0;
		pToys[playerid][i][toy_sy] = 0.0;
		pToys[playerid][i][toy_sz] = 0.0;
	}
}

KickEx(playerid, time = 500)
{
	SetTimerEx("_KickPlayerDelayed", time, false, "i", playerid);
	return 1;
}

IsValidRoleplayName(const name[]) {
    if(!name[0] || strfind(name, "_") == -1)
        return 0;

    else for (new i = 0, len = strlen(name); i != len; i ++) {
    if((i == 0) && (name[i] < 'A' || name[i] > 'Z'))
            return 0;

        else if((i != 0 && i < len  && name[i] == '_') && (name[i + 1] < 'A' || name[i + 1] > 'Z'))
            return 0;

        else if((name[i] < 'A' || name[i] > 'Z') && (name[i] < 'a' || name[i] > 'z') && name[i] != '_' && name[i] != '.')
            return 0;
    }
    return 1;
}

IsValidName(const name[])
{
	new len = strlen(name);

	for(new ch = 0; ch != len; ch++)
	{
		switch(name[ch])
		{
			case 'A' .. 'Z', 'a' .. 'z', '0' .. '9', ']', '[', '(', ')', '_', '.': continue;
			default: return false;
		}
	}
	return true;
}

IsValidPassword(const name[])
{
	new len = strlen(name);

	for(new ch = 0; ch != len; ch++)
	{
		switch(name[ch])
		{
			case 'A' .. 'Z', 'a' .. 'z', '0' .. '9', ']', '[', '(', ')', '_', '.', '@', '#': continue;
			default: return false;
		}
	}
	return true;
}

IsValidNameUCP(const name[])
{
	new len = strlen(name);

	for(new ch = 0; ch != len; ch++)
	{
		switch(name[ch])
		{
			case 'A' .. 'Z', 'a' .. 'z', '0' .. '9': continue;
			default: return false;
		}
	}
	return true;
}

/*SetupPlayerTable()
{
	mysql_tquery(g_SQL, "CREATE TABLE IF NOT EXISTS `players` (`id` int(11) NOT NULL AUTO_INCREMENT,`username` varchar(24) NOT NULL,`password` char(64) NOT NULL,`salt` char(16) NOT NULL,`kills` mediumint(8) NOT NULL DEFAULT '0',`deaths` mediumint(8) NOT NULL DEFAULT '0',`x` float NOT NULL DEFAULT '0',`y` float NOT NULL DEFAULT '0',`z` float NOT NULL DEFAULT '0',`angle` float NOT NULL DEFAULT '0',`interior` tinyint(3) NOT NULL DEFAULT '0', PRIMARY KEY (`id`), UNIQUE KEY `username` (`username`))");
	return 1;
}*/

//----------[ Anti-Cheat Native ]------
//Anti Money Hack
GivePlayerMoneyEx(playerid, cashgiven)
{
	pData[playerid][pMoney] += cashgiven;
	GivePlayerMoney(playerid, cashgiven);
}
ResetPlayerMoneyEx(playerid)
{
	pData[playerid][pMoney] = 0;
	ResetPlayerMoney(playerid);
}

//Anti Health and Armour Hack
SetPlayerHealthEx(playerid, Float:heal)
{
	pData[playerid][pHealth] = heal;
	SetPlayerHealth(playerid, heal);
}

SetPlayerArmourEx(playerid, Float:armor)
{
	pData[playerid][pACTime] = gettime() + 5;
	pData[playerid][pArmorTime] = gettime() + 5;
	pData[playerid][pArmour] = armor;
	SetPlayerArmour(playerid, armor);
}

//Anti Weapon Hack
new const g_aWeaponSlots[] = {
    0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 8, 8, 8, 0, 0, 0, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 4, 6, 6, 7, 7, 7, 7, 8, 12, 9, 9, 9, 11, 11, 11
};

ResetPlayerWeaponsEx(playerid)
{
    ResetPlayerWeapons(playerid);

    for (new i = 0; i < 13; i ++) {
        pData[playerid][pGuns][i] = 0;
        pData[playerid][pAmmo][i] = 0;
    }
    return 1;
}

ResetWeapon(playerid, weaponid)
{
	ResetPlayerWeapons(playerid);
	
    for (new i = 0; i < 13; i ++) {
        if(pData[playerid][pGuns][i] != weaponid) 
		{
            GivePlayerWeapon(playerid, pData[playerid][pGuns][i], pData[playerid][pAmmo][i]);
        }
        else 
		{
            pData[playerid][pGuns][i] = 0;
            pData[playerid][pAmmo][i] = 0;
        }
    }
    return 1;
}

UpdateWeapons(playerid)
{
    for(new i = 0; i < 13; i ++)
	{
		if(pData[playerid][pGuns][i])
		{
			GetPlayerWeaponData(playerid, i, pData[playerid][pGuns][i], pData[playerid][pAmmo][i]);

			if(pData[playerid][pGuns][i] != 0 && !pData[playerid][pAmmo][i]) 
			{
					pData[playerid][pGuns][i] = 0;
			}
		}
	}
    return 1;
}

IsWeaponModel(model) {
    new const g_aWeaponModels[] = {
        0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324,
        325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352,
        353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366,
        367, 368, 368, 371
    };
    for (new i = 0; i < sizeof(g_aWeaponModels); i ++) if(g_aWeaponModels[i] == model) {
        return 1;
    }
    return 0;
}

SetWeapons(playerid)
{
    ResetPlayerWeapons(playerid);

    for (new i = 0; i < 13; i ++) if(pData[playerid][pGuns][i] > 0 && pData[playerid][pAmmo][i] > 0) {
        GivePlayerWeapon(playerid, pData[playerid][pGuns][i], pData[playerid][pAmmo][i]);
    }
    return 1;
}

GetPlayerWeaponEx(playerid)
{
    new weaponid = GetPlayerWeapon(playerid);

    if(1 <= weaponid <= 46 && pData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
        return weaponid;

    return 0;
}

GetPlayerAmmoEx(playerid)
{
	new weaponid = GetPlayerWeapon(playerid);
	new ammo = pData[playerid][pAmmo][g_aWeaponSlots[weaponid]];
	if(1 <= weaponid <= 46 && pData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
	{
		if(pData[playerid][pGuns][g_aWeaponSlots[weaponid]] != 0 && pData[playerid][pAmmo][g_aWeaponSlots[weaponid]] > 0)
		{
			return ammo;
		}
	}
	return 0;
}

IsAHaulTruck(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
	    case 515, 514, 403: return 1;
	    default: return 0;
	}

	return 0;
}

GivePlayerWeaponEx(playerid, weaponid, ammo)
{
    if(weaponid < 0 || weaponid > 46)
        return 0;

    pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = weaponid;
    pData[playerid][pAmmo][g_aWeaponSlots[weaponid]] += ammo;

    return GivePlayerWeapon(playerid, weaponid, ammo);
}

ReturnWeaponName(weaponid)
{
    new weapon[22];
    switch(weaponid)
    {
        case 0: weapon = "Tinju";
        case 18: weapon = "Molotov Cocktail";
        case 44: weapon = "Night Vision Goggles";
        case 45: weapon = "Thermal Goggles";
        case 54: weapon = "Fall";
        default: GetWeaponName(weaponid, weapon, sizeof(weapon));
    }
    return weapon;
}

//----------[ Admin Native ]----------
GetStaffRank(playerid)
{
	new name[40];
	if(pData[playerid][pAdmin] == 1)
	{
		name = ""RED_E"Volunteer";
	}
	else if(pData[playerid][pAdmin] == 2)
	{
		name = ""RED_E"Helper";
	}
	else if(pData[playerid][pAdmin] == 3)
	{
		name = ""RED_E"Staff";
	}
	else if(pData[playerid][pAdmin] == 4)
	{
		name = ""RED_E"Administrator";
	}
	else if(pData[playerid][pAdmin] == 5)
	{
		name = ""RED_E"Management";
	}
	else if(pData[playerid][pAdmin] == 6)
	{
		name = ""RED_E"Developer";
	}
	else if(pData[playerid][pHelper] == 1 && pData[playerid][pAdmin] == 0)
	{
		name = ""GREEN_E"Junior Helper";
	}
	else if(pData[playerid][pHelper] == 2 && pData[playerid][pAdmin] == 0)
	{
		name = ""GREEN_E"Senior Helper";
	}
	else if(pData[playerid][pHelper] == 3 && pData[playerid][pAdmin] == 0)
	{
		name = ""GREEN_E"Head Helper";
	}
	else
	{
		name = "None";
	}
	return name;
}

SendStaffMessage(color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[144]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if(args > 8)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 8); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 144
        #emit PUSH.C string

        #emit LOAD.S.pri 8
        #emit ADD.C 4
        #emit PUSH.pri

        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        foreach (new i : Player)
        {
            if(pData[i][pAdmin] >= 1 || pData[i][pHelper] >= 1) {
                SendClientMessageEx(i, color, "[STAFF MSG] "YELLOW_E"%s", string);
            }
        }
        return 1;
    }
    foreach (new i : Player)
    {
        if(pData[i][pAdmin] >= 1 || pData[i][pHelper] >= 1) {
            SendClientMessageEx(i, color, "[STAFF MSG] "YELLOW_E"%s", string);
        }
    }
    return 1;
}

SendAdminMessage(color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[144]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if(args > 8)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 8); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 144
        #emit PUSH.C string

        #emit LOAD.S.pri 8
        #emit ADD.C 4
        #emit PUSH.pri

        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        foreach (new i : Player)
        {
            if(pData[i][pAdmin] >= 1 /*&& !pData[i][pDisableAdmin]*/) {
				SendClientMessageEx(i, color, "[ADMIN MSG] "YELLOW_E"%s", string);
            }
        }
        return 1;
    }
    foreach (new i : Player)
    {
        if(pData[i][pAdmin] >= 1 /*&& !pData[i][pDisableAdmin]*/) {
			SendClientMessageEx(i, color, "[ADMIN MSG] "YELLOW_E"%s", string);
        }
    }
    return 1;
}

SendAnticheat(color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[144]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if(args > 8)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 8); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 144
        #emit PUSH.C string

        #emit LOAD.S.pri 8
        #emit ADD.C 4
        #emit PUSH.pri

        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        foreach (new i : Player)
        {
            if(pData[i][pAdmin] >= 1 || pData[i][pHelper] >= 1) {
                SendClientMessageEx(i, color, "[ANTICHEAT] "YELLOW_E"%s", string);
            }
        }
        return 1;
    }
    foreach (new i : Player)
    {
        if(pData[i][pAdmin] >= 1 || pData[i][pHelper] >= 1) {
            SendClientMessageEx(i, color, "[ANTICHEAT] "YELLOW_E"%s", string);
        }
    }
    return 1;
}

StaffCommandLog(const command[], adminid, player = INVALID_PLAYER_ID, logstr[] = '*')
{
	// Set the logging message to be correct
	new logStrEscaped[128], query[512];
	if(logstr[0] == '*')
		logStrEscaped = "*", printf("AdminCommandLog: logstr detected as unnecessary, logStrEscaped = '%s' (must be '*')", logStrEscaped);
	else
		mysql_escape_string(logstr, logStrEscaped), printf("AdminCommandLog: logstr detected necessary, escaped from '%s' to '%s'", logstr, logStrEscaped);

	if(player != INVALID_PLAYER_ID)
	{
		// The action involves a player, get their name
		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logstaff (command,admin,adminid,player,playerid,str,time) VALUES('%s','%s(%s)',%d,'%s',%d,'%s',UNIX_TIMESTAMP())", command, pData[adminid][pName], pData[adminid][pAdminname], pData[adminid][pID], pData[player][pName], pData[player][pID], logStrEscaped);
	}
	else
	{
		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logstaff (command,admin,adminid,str,time) VALUES('%s','%s(%s)',%d,'%s',UNIX_TIMESTAMP())", command, pData[adminid][pName], pData[adminid][pAdminname], pData[adminid][pID], logStrEscaped);
	}

	// Send the query!
	mysql_tquery(g_SQL, query);
	return 1;
}

//----------[ VIP Native ]----------
GetVipRank(playerid)
{
	new name[40];
	if(pData[playerid][pVip] == 1)
	{
		name = ""LG_E"Bronze";
	}
	else if(pData[playerid][pVip] == 2)
	{
		name = ""YELLOW_E"Silver";
	}
	else if(pData[playerid][pVip] == 3)
	{
		name = ""PURPLE_E"Diamond";
	}
	else
	{
		name = "None";
	}
	return name;
}

//----------[ Faction Native ]----------
SetFactionColor(playerid)
{
    new factionid = pData[playerid][pFaction];

    if(factionid == 1)
	{
		SetPlayerColor(playerid, COLOR_BLUE);
	}
	else if(factionid == 2)
	{
		SetPlayerColor(playerid, COLOR_LBLUE);
	}
	else if(factionid == 3)
	{
		SetPlayerColor(playerid, COLOR_PINK2);
	}
	else if(factionid == 4)
	{
		SetPlayerColor(playerid, COLOR_ORANGE2);
	}
	else
	{
		SetPlayerColor(playerid, COLOR_WHITE);
	}
	return 1;
}

GetFactionRank(playerid)
{
	new rank[40];
	if(pData[playerid][pFaction] == 1)
	{
        if(pData[playerid][pFactionRank] == 1)
        {
            rank = "PO I";
        }
        else if(pData[playerid][pFactionRank] == 2)
        {
            rank = "PO II";
        }
        else if(pData[playerid][pFactionRank] == 3)
        {
            rank = "PO III";
        }
        else if(pData[playerid][pFactionRank] == 4)
        {
            rank = "Prob. Sergeant";
        }
        else if(pData[playerid][pFactionRank] == 5)
        {
            rank = "Sergeant I";
        }
        else if(pData[playerid][pFactionRank] == 6)
        {
            rank = "Sergeant II";
        }
        else if(pData[playerid][pFactionRank] == 7)
        {
            rank = "Lieutenant";
        }
        else if(pData[playerid][pFactionRank] == 8)
        {
            rank = "Captain";
        }
        else if(pData[playerid][pFactionRank] == 9)
        {
            rank = "Commander";
        }
        else if(pData[playerid][pFactionRank] == 10)
        {
            rank = "Deputy Chief";
        }
        else if(pData[playerid][pFactionRank] == 11)
        {
            rank = "Assistant CoP";
        }
        else if(pData[playerid][pFactionRank] == 12)
        {
            rank = "Chief of Police";
        }
        else if(pData[playerid][pFactionRank] == 13)
        {
            rank = "Commissioner";
        }
        else
        {
            rank = "None";
		}
	}
  	if(pData[playerid][pFaction] == 2)
	{
		if(pData[playerid][pFactionRank] == 1)
        {
            rank = "Driver";
        }
        else if(pData[playerid][pFactionRank] == 2)
        {
            rank = "Bodyguard";
        }
        else if(pData[playerid][pFactionRank] == 3)
        {
            rank = "Secretary";
        }
        else if(pData[playerid][pFactionRank] == 4)
        {
            rank = "Licensor";
        }
        else if(pData[playerid][pFactionRank] == 5)
        {
            rank = "Treasurer";
        }
        else if(pData[playerid][pFactionRank] == 6)
        {
            rank = "Lawyer";
        }
        else if(pData[playerid][pFactionRank] == 7)
        {
            rank = "Minister of Law";
        }
        else if(pData[playerid][pFactionRank] == 8)
        {
            rank = "Minister of Religion";
        }
        else if(pData[playerid][pFactionRank] == 9)
        {
            rank = "Governor's Staff";
        }
        else if(pData[playerid][pFactionRank] == 10)
        {
            rank = "Secretary Regional";
        }
        else if(pData[playerid][pFactionRank] == 11)
        {
            rank = "Regional People's Representative";
        }
        else if(pData[playerid][pFactionRank] == 12)
        {
            rank = "Deputy Governor";
        }
        else if(pData[playerid][pFactionRank] == 13)
        {
            rank = "Governor";
        }
		else
		{
			rank = "None";
		}
	}
	if(pData[playerid][pFaction] == 3)
	{
		if(pData[playerid][pFactionRank] == 1)
        {
            rank = "Resident";
        }
        else if(pData[playerid][pFactionRank] == 2)
        {
            rank = "Senior Resident";
        }
        else if(pData[playerid][pFactionRank] == 3)
        {
            rank = "Fellow";
        }
        else if(pData[playerid][pFactionRank] == 4)
        {
            rank = "Attending Physician";
        }
        else if(pData[playerid][pFactionRank] == 5)
        {
            rank = "Doctor";
        }
        else if(pData[playerid][pFactionRank] == 6)
        {
            rank = "Medical Director";
        }
        else if(pData[playerid][pFactionRank] == 7)
        {
            rank = "Executive Assistant";
        }
        else if(pData[playerid][pFactionRank] == 8)
        {
            rank = "Hospital Executive";
        }
        else if(pData[playerid][pFactionRank] == 9)
        {
            rank = "Division Chief";
        }
        else if(pData[playerid][pFactionRank] == 10)
        {
            rank = "Assistant Chief of Medical";
        }
        else if(pData[playerid][pFactionRank] == 11)
        {
            rank = "Deputy Chief of Medical";
        }
        else if(pData[playerid][pFactionRank] == 12)
        {
            rank = "Chief of Medical";
        }
        else if(pData[playerid][pFactionRank] == 13)
        {
            rank = "Commissioner";
        }
        else
        {
            rank = "None";
		}
	}
  	if(pData[playerid][pFaction] == 4)
	{
		if(pData[playerid][pFactionRank] == 1)
        {
            rank = "Intership";
        }
        else if(pData[playerid][pFactionRank] == 2)
        {
            rank = "Staff";
        }
        else if(pData[playerid][pFactionRank] == 3)
        {
            rank = "Senior Staff";
        }
        else if(pData[playerid][pFactionRank] == 4)
        {
            rank = "Supervisor I";
        }
        else if(pData[playerid][pFactionRank] == 5)
        {
            rank = "Supervisor II";
        }
        else if(pData[playerid][pFactionRank] == 6)
        {
            rank = "Head of Radio";
        }
        else if(pData[playerid][pFactionRank] == 7)
        {
            rank = "Head of OS";
        }
        else if(pData[playerid][pFactionRank] == 8)
        {
            rank = "Manager";
        }
        else if(pData[playerid][pFactionRank] == 9)
        {
            rank = "Chief of SAN";
        }
        else if(pData[playerid][pFactionRank] == 10)
        {
            rank = "Vice CEO";
        }
        else if(pData[playerid][pFactionRank] == 11)
        {
            rank = "Chief Executive Officer";
        }
        else if(pData[playerid][pFactionRank] == 12)
        {
            rank = "Vice Commissioner";
        }
        else if(pData[playerid][pFactionRank] == 13)
        {
            rank = "Commissioner";
        }
        else
        {
            rank = "None";
		}
	}
	return rank;
}

SetPlayerArrest(playerid, cellid)
{
	if(cellid == 1)
	{
		SetPlayerPositionEx(playerid, 227.49, 109.84, 999.01, 3.70, 2000);
	}
	else if(cellid == 2)
	{
		SetPlayerPositionEx(playerid, 223.51, 109.61, 999.01, 0.25, 2000);
	}
	else if(cellid == 3)
	{
		SetPlayerPositionEx(playerid, 219.52, 109.52, 999.01, 150, 2000);
	}
	else if(cellid == 4)
	{
		SetPlayerPositionEx(playerid, 215.33, 109.62, 999.01, 357.05, 2000);
	}
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 10);
	ShowPlayerDialog(playerid, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
	SetPlayerWantedLevel(playerid, 0);
	PlayerPlaySound(playerid, 1186, 0, 0, 0);
    ResetPlayerWeaponsEx(playerid);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	pData[playerid][pCuffed] = 0;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInFamily] = -1;
}

SendFactionMessage(factionid, color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[144]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if(args > 12)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 12); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 144
        #emit PUSH.C string
        #emit PUSH.C args

        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        foreach (new i : Player) if(pData[i][pFaction] == factionid /*&& !pData[i][pDisableFaction]*/) {
                SendClientMessage(i, color, string);
        }
        return 1;
    }
    foreach (new i : Player) if(pData[i][pFaction] == factionid /*&& !pData[i][pDisableFaction]*/) {
        SendClientMessage(i, color, str);
    }
    return 1;
}

//----------[ Family Native]----------
GetFamilyRank(playerid)
{
	new rank[24];
	if(pData[playerid][pFamily] != -1)
	{
		if(pData[playerid][pFamilyRank] == 1) 
		{
			rank = "Outsider(1)";
		}
		else if(pData[playerid][pFamilyRank] == 2) 
		{
			rank = "Associate(2)";
		}
		else if(pData[playerid][pFamilyRank] == 3) 
		{
			rank = "Soldier(3)";
		}
		else if(pData[playerid][pFamilyRank] == 4) 
		{
			rank = "Advisor(4)";
		}
		else if(pData[playerid][pFamilyRank] == 5) 
		{
			rank = "UnderBoss(5)";
		}
		else if(pData[playerid][pFamilyRank] == 6) 
		{
			rank = "GodFather(6)";
		}
		else
		{
			rank = "None";
		}
	}
	else
	{
		rank = "None";
	}
	return rank;
}

SendFamilyMessage(familyid, color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[144]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if(args > 12)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 12); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 144
        #emit PUSH.C string
        #emit PUSH.C args

        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        foreach (new i : Player) if(pData[i][pFamily] == familyid /*&& !pData[i][pDisableFaction]*/) {
                SendClientMessage(i, color, string);
        }
        return 1;
    }
    foreach (new i : Player) if(pData[i][pFamily] == familyid /*&& !pData[i][pDisableFaction]*/) {
        SendClientMessage(i, color, str);
    }
    return 1;
}

//----------[ Job Native ]----------
GetJobName(type)
{
    static
        str[24];

    switch (type)
    {
        case 1: str = "Taxi Driver";
        case 2: str = "Mechanic";
		case 3: str = "Lumber Jack";
		case 4: str = "Trucker";
		case 5: str = "Miner";
		case 6: str = "Production";
		case 7: str = "Farmer";
		case 8: str = "Courier";
		case 9: str = "Smuggler";
		case 10: str = "Baggage Airport";
        default: str = "None";
    }
    return str;
}

IsAtJob(playerid)
{
	if(pData[playerid][pCP] == 1 || pData[playerid][pCP] == 3 || pData[playerid][pCP] == 4 || pData[playerid][pCP] == 5 || pData[playerid][pCP] == 10 || pData[playerid][pCP] == 12
		|| pData[playerid][pCP] == 6 || pData[playerid][pCP] == 7 || pData[playerid][pCP] == 8 || pData[playerid][pSideJob] > 0)
		return 1;
				
	return 0;
}

//-----------[ Player Native ]----------
GetID(const name[])
{
	foreach(new i : Player)
	{
		if(!strcmp(name, pData[i][pName]))
			return i;
	}
	return -1;
}

DisplayStats(playerid, p2)
{
	new gstr[1024], header[512], scoremath = ((pData[p2][pLevel])*8), fac[24], fid = pData[p2][pFamily];
	header = "";
	gstr = "";
	
	if(pData[p2][pFaction] == 1)
	{
		fac = "San Andreas Police";
	}
	else if(pData[p2][pFaction] == 2)
	{
		fac = "San Andreas Goverment";
	}
	else if(pData[p2][pFaction] == 3)
	{
		fac = "San Andreas Medic";
	}
	else if(pData[p2][pFaction] == 4)
	{
		fac = "San Andreas News";
	}
	else
	{
		fac = "None";
	}
	
	new pstatus[36];
	if(pData[p2][pPhoneStatus] == 1)
	{
		format(pstatus, 36, "{7fff00}Online{ffffff}");
	}
	else
	{
		format(pstatus, 36, "{ff0000}Offline{ffffff}");
	}

	new fname[128];
	if(fid != -1)
	{
		format(fname, 128, fData[fid][fName]);
	}
	else
	{
		format(fname, 128, "None");
	}
	
	format(header,sizeof(header),"Statistics");
    format(gstr,sizeof(gstr),""RED_E"In Character"WHITE_E"\n");
    format(gstr,sizeof(gstr),"%sGender: [%s] | Money: ["LG_E"%s"WHITE_E"] | Bank: ["LG_E"%s"WHITE_E"] | Rekening Bank: [%d]\n", gstr,(pData[p2][pGender] == 2) ? ("Female") : ("Male") , FormatMoney(pData[p2][pMoney]), FormatMoney(pData[p2][pBankMoney]), pData[p2][pBankRek]);
    format(gstr,sizeof(gstr),"%sPhone Number: [%d] | Birdthdate: [%s] | Job: [%s] | Job2: [%s]\n", gstr, pData[p2][pPhone], pData[p2][pAge], GetJobName(pData[p2][pJob]), GetJobName(pData[p2][pJob2]));
    format(gstr,sizeof(gstr),"%sFaction: [%s] | Family: [%s] | Phone Status : [%s] | Twitter : [{0099ff}%s{ffffff}]\n\n", gstr, fac, fname, pstatus, pData[p2][pTwittername]);
	format(gstr,sizeof(gstr),"%s"RED_E"Out of Character"WHITE_E"\n", gstr);
    format(gstr,sizeof(gstr),"%sUCP: [{15D4ED}%s{ffffff}] | Name: [{15D4ED}%s{ffffff}] | UID: [%d] | Level score: [%d/%d]\n", gstr, pData[p2][pUCP], pData[p2][pName], pData[p2][pID], pData[p2][pLevelUp], scoremath);
    format(gstr,sizeof(gstr),"%sEmail: [%s] | Warning:[%d/20] | Last Login: [%s]\n", gstr, pData[p2][pEmail], pData[p2][pWarn], pData[p2][pLastLogin]);
	format(gstr,sizeof(gstr),"%sStaff: [%s{FFFFFF}] | Time Played: [%d hour(s) %d minute(s) %02d second(s)] | Gold Coin: [%d]\n", gstr, GetStaffRank(p2), pData[p2][pHours], pData[p2][pMinutes], pData[p2][pSeconds], pData[p2][pGold]);
	if(pData[p2][pVipTime] != 0)
	{
		format(gstr,sizeof(gstr),"%sVIP Level: [%s{FFFFFF}] | VIP Time: [%s]\n", gstr, GetVipRank(p2), pData[p2][pVipTime]);
	}
	else
	{
		format(gstr,sizeof(gstr),"%sVIP Level: [%s{FFFFFF}] | VIP Time: [None]\n", gstr, GetVipRank(p2));
	}
	format(gstr,sizeof(gstr),"%sInterior: [%d] | Virtual World: [%d] | Register Date: [%s]", gstr, GetPlayerInterior(p2), GetPlayerVirtualWorld(p2), pData[p2][pRegDate]);
	ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, header, gstr, "Settings", "Close");
	return 1;
}

DisplayItems(playerid, p2)
{
	new weaponid, ammo, mstr[512], lstr[1024];
	format(mstr, sizeof(mstr), "Items (%s)", pData[p2][pName]);
    format(lstr, sizeof(lstr), "Name\tAmmount\n{00FF00}Money\t{00FF00}%s\n", FormatMoney(pData[p2][pMoney]));
	if(pData[p2][pRedMoney] > 0)
	{
		format(lstr, sizeof(lstr), "%s{FF0000}Red Money\t{FF0000}%s\n", lstr, FormatMoney(pData[p2][pRedMoney]));
	}
	if(pData[p2][pIDCardTime] > 0)
	{
		format(lstr, sizeof(lstr), "%sID-Card\t%s", lstr, ReturnTimelapse(gettime(), pData[p2][pIDCardTime]));
	}
	if(pData[p2][pDriveLicTime] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nDrive-Lic\t%s", lstr, ReturnTimelapse(gettime(), pData[p2][pDriveLicTime]));
	}
	if(pData[p2][pWeaponLic] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nWeapon-Lic\t%s", lstr, ReturnTimelapse(gettime(), pData[p2][pWeaponLicTime]));
	}
	if(pData[p2][pSparepart] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nSparepart\t%d", lstr, pData[p2][pSparepart]);
	}
	if(pData[p2][pFlashlight] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nFlashlight\t%d", lstr, pData[p2][pFlashlight]);
	}
	if(pData[p2][pBandage] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nBandage\t%d", lstr, pData[p2][pBandage]);
	}
	if(pData[p2][pSnack] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nSnack\t%d", lstr, pData[p2][pSnack]);
	}
	if(pData[p2][pSprunk] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nSprunk\t%d", lstr, pData[p2][pSprunk]);
	}
	if(pData[p2][pMedicine] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nMedicine\t%d", lstr, pData[p2][pMedicine]);
	}
	if(pData[p2][pMedkit] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nMedkit\t%d", lstr, pData[p2][pMedkit]);
	}
	if(pData[p2][pGas] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nGas Fuel\t%d", lstr, pData[p2][pGas]);
	}
	if(pData[p2][pMaterial] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nMaterial\t%d", lstr, pData[p2][pMaterial]);
	}
	if(pData[p2][pComponent] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nComponent\t%d", lstr, pData[p2][pComponent]);
	}
	if(pData[p2][pFood] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nFood\t%d", lstr, pData[p2][pFood]);
	}
	if(pData[p2][pPhone] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nHandphone\t1", lstr);
	}
	if(pData[p2][pObat] > 0)
	{
		format(lstr, sizeof(lstr), "%s\n[Obat]Myricous\t%d", lstr, pData[p2][pObat]);
	}
	if(pData[p2][pSeed] > 0)
	{
		format(lstr, sizeof(lstr), "%s\n[Farmer]Seed\t%d", lstr, pData[p2][pSeed]);
	}
	if(pData[p2][pPotato] > 0)
	{
		format(lstr, sizeof(lstr), "%s\n[Farmer]Potato\t%d kg", lstr, pData[p2][pPotato]);
	}
	if(pData[p2][pWheat] > 0)
	{
		format(lstr, sizeof(lstr), "%s\n[Farmer]Wheat\t%d kg", lstr, pData[p2][pWheat]);
	}
	if(pData[p2][pOrange] > 0)
	{
		format(lstr, sizeof(lstr), "%s\n[Farmer]Orange\t%d kg", lstr, pData[p2][pOrange]);
	}
	if(pData[p2][pFish] > 0)
	{
		format(lstr, sizeof(lstr), "%s\nFish\t%d kg", lstr, pData[p2][pFish]);
	}
	if(pData[p2][pMarijuana] > 0)
	{
		format(lstr, sizeof(lstr), "%s\n"RED_E"Marijuana\t"RED_E"%d kg", lstr, pData[p2][pMarijuana]);
	}
	for(new i = 0; i < 13; i ++)
    {
        GetPlayerWeaponData(p2, i, weaponid, ammo);

        if(weaponid > 0)
			format(lstr, sizeof(lstr), "%s\n"RED_E"%s\t"RED_E"%d", lstr, ReturnWeaponName(weaponid), ammo);
    }
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, mstr, lstr,"Close","");
	return 1;
}

IsKeyJustDown(key, newkeys, oldkeys)
{
	if((newkeys & key) && !(oldkeys & key)) return 1;
	return 0;
}

//----------[ Banneds Native ]---------
Ban_GetLongIP(const ip[])
{
  	new len = strlen(ip);
	if (!(len > 0 && len < 17))
	{
    	return 0;
	}

	new count;
	new pos;
	new dest[3];
	new val[4];
	for (new i; i < len; i++)
	{
		if (ip[i] == '.' || i == len)
		{
			strmid(dest, ip, pos, i);
			pos = (i + 1);

		    val[count] = strval(dest);
		    if (!(0 <= val[count] <= 255))
		    {
		        return 0;
			}

			count++;
			if (count > 3)
			{
				return 0;
			}
		}
	}

	if (count != 3)
	{
	    return 0;
	}
	return ((val[0] * 16777216) + (val[1] * 65536) + (val[2] * 256) + (val[3]));
}

ReturnDate(timestamp)
{
	new year, month, day, hour, minute, second;
	TimestampToDate(timestamp, year, month, day, hour, minute, second, 7);

	static monthname[15];
	switch (month)
	{
	    case 1: monthname = "January";
	    case 2: monthname = "February";
	    case 3: monthname = "March";
	    case 4: monthname = "April";
	    case 5: monthname = "May";
	    case 6: monthname = "June";
	    case 7: monthname = "July";
	    case 8: monthname = "August";
	    case 9: monthname = "September";
	    case 10: monthname = "October";
	    case 11: monthname = "November";
	    case 12: monthname = "December";
	}

	new date[30];
	format(date, sizeof (date), "%d %s, %d - %d:%d:%d", day, monthname, year, hour, minute, second);
	return date;
}

ReturnTimelapse(start, till)
{
    new ret[32];
	new second = till - start;

	const
		MINUTE = 60,
		HOUR = 60 * MINUTE,
		DAY = 24 * HOUR,
		MONTH = 30 * DAY;

	if (second == 1)
		format(ret, sizeof(ret), "a second");
	if (second < (1 * MINUTE))
		format(ret, sizeof(ret), "%i seconds", second);
	else if (second < (2 * MINUTE))
		format(ret, sizeof(ret), "a minute");
	else if (second < (45 * MINUTE))
		format(ret, sizeof(ret), "%i minutes", (second / MINUTE));
	else if (second < (90 * MINUTE))
		format(ret, sizeof(ret), "an hour");
	else if (second < (24 * HOUR))
		format(ret, sizeof(ret), "%i hours", (second / HOUR));
	else if (second < (48 * HOUR))
		format(ret, sizeof(ret), "a day");
	else if (second < (30 * DAY))
		format(ret, sizeof(ret), "%i days", (second / DAY));
	else if (second < (12 * MONTH))
    {
		new month = floatround(second / DAY / 30);
      	if (month <= 1)
			format(ret, sizeof(ret), "a month");
      	else
			format(ret, sizeof(ret), "%i months", month);
	}
    else
    {
      	new year = floatround(second / DAY / 365);
      	if (year <= 1)
			format(ret, sizeof(ret), "a year");
      	else
			format(ret, sizeof(ret), "%i years", year);
	}
	return ret;
}

/*GetElapsedTime(time, &jam, &menit, &detik)
{
    jam = 0;
    menit = 0;
    detik = 0;

    if(time >= 3600) //jika lebih dari 1 jam (3600 = 1 jam)
    {
        jam = (time / 3600); //pembagian waktu per jam di bagi time/3600
        time -= (jam * 3600); //pengurangan di time , ex 2 jam terpakai maka di kalikan 2 * 3600 = time-7200
    }
    while (time >= 60) //hitungan menit.
    {
        menit++; //hitungan menit bertambah selama time masih bervalue 60.
        time -= 60; // waktu berkurang per menit hitungan 60 sec dari time.
    }
    return (detik = time);
}*/

BanPlayerMSG(playerid, adminid, reason[], bool:serverBan = false)
{
	new mstr[248], lstr[512], hours, minutes, seconds, years, months, days;
	mstr = "";
    for(new i = 0; i < 7; i++) SendClientMessage(playerid, -1, " ");
    gettime(hours, minutes, seconds);
	getdate(years, months, days);
	SendClientMessage(playerid, COLOR_RED, "YOU HAVE BEEN BANNED!");
	if(serverBan == false)
 	{
		format(mstr, sizeof(mstr), ""RED_E"Server: "GREY_E"Admin: %s(%i)", pData[adminid][pAdminname], adminid);
	}
	else SendClientMessage(playerid, COLOR_GREY, ""RED_E"Server: "GREY_E"Admin: Server Ban");
	SendClientMessage(playerid, COLOR_GREY, mstr);
	format(mstr, sizeof(mstr), ""RED_E"Server: "GREY_E"Reason: %s", reason);
	SendClientMessage(playerid, COLOR_GREY, mstr);
	format(mstr, sizeof(mstr), ""RED_E"Server: "GREY_E"The time is %02d:%02d (%02d/%02d/%d)", hours, minutes, months, days, years);
	SendClientMessage(playerid, COLOR_GREY, mstr);
	SendClientMessage(playerid, COLOR_GREY, ""RED_E"Server: "GREY_E"Go to nfs-server.pe.hu/forums to appeal your ban. Include a screenshot of your ban.");
	GameTextForPlayer(playerid, "~r~~h~Banned!", 4000, 5);

	format(lstr, sizeof(lstr), ""RED_E"You have been banned!\n\n"LB2_E"Ban Info:\n"RED_E"Name: "GREY2_E"%s\n"RED_E"IP: "GREY2_E"%s\n"RED_E"Admin: "GREY2_E"%s\n"RED_E"Ban Reason: "GREY2_E"%s\n"RED_E"Ban Date: "GREY2_E"%02d:%02d (%02d/%02d/%d)\n\n"WHITE_E"Feel that you were wrongfully banned? Appeal at nfs-server.pe.hu/forums", pData[playerid][pName], pData[playerid][pIP], pData[adminid][pAdminname], reason, hours, minutes, months, days, years);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"BANNED", lstr, "Exit", "");
}

//----------[ Vehicle Native ]---------
IsVehicleEmpty(vehicleid)
{
        for(new i=0; i<MAX_PLAYERS; i++)
        {
                if(IsPlayerInVehicle(i, vehicleid)) return 0;
        }
        return 1;
}

IsACruiser(vehicleid)
{
	switch (GetVehicleModel(vehicleid))
	{
	    case 523, 427, 490, 528, 596..599, 601: return 1;
	}
	return 0;
}

IsABoat(vehicleid)
{
    switch (GetVehicleModel(vehicleid)) {
        case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: return 1;
    }
    return 0;
}

IsABike(vehicleid)
{
    switch (GetVehicleModel(vehicleid)) {
        case 448, 461..463, 468, 521..523, 581, 586, 481, 509, 510: return 1;
    }
    return 0;
}

IsAPlane(vehicleid)
{
    switch (GetVehicleModel(vehicleid)) {
        case 460, 464, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: return 1;
    }
    return 0;
}

IsAVehicleStorage(vehicleid)
{
    switch (GetVehicleModel(vehicleid)) {
    case 400, 401, 402, 403, 404, 405, 406, 407, 409, 410, 411, 412, 413, 414, 415, 416,
		417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432,
		433, 434, 436, 437, 438, 439, 440, 442, 443, 444, 445, 446, 447, 448, 451, 452, 453,
		454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 466, 467, 468, 469, 470, 472,
		474, 475, 476, 477, 478, 479, 480, 482, 483, 484, 487, 488, 489, 490, 491, 492, 493,
		494, 495, 496, 497, 498, 499, 500, 502, 503, 504, 505, 506, 507, 508, 511, 512, 513,
		514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 533,
		534, 535, 536, 537, 538, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551,
		552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 565, 566, 567, 570, 573,
		574, 575, 576, 577, 579, 580, 581, 582, 583, 585, 586, 587, 589, 588, 592, 593, 595,
		596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 609: return 1;
	}	
    return 0;
}

IsAHelicopter(vehicleid)
{
    switch (GetVehicleModel(vehicleid)) {
        case 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563: return 1;
    }
    return 0;
}

IsATowTruck(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 485 || GetVehicleModel(vehicleid) == 525 || GetVehicleModel(vehicleid) == 583 || GetVehicleModel(vehicleid) == 574)
	{
		return 1;
	}
	return 0;
}

IsATruck(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
	    case 414, 455, 456, 498, 499, 609: return 1;
	    default: return 0;
	}

	return 0;
}

IsAPickup(vehicleid)
{
    switch (GetVehicleModel(vehicleid)) {
        case 478, 422, 543, 554: return 1;
    }
    return 0;
}

IsEngineVehicle(vehicleid)
{
    static const g_aEngineStatus[] = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
        1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
    };
    new modelid = GetVehicleModel(vehicleid);

    if(modelid < 400 || modelid > 611)
        return 0;

    return (g_aEngineStatus[modelid - 400]);
}

GetVehicleMaxSeats(vehicleid)
{
    static const g_arrMaxSeats[] = {
        4, 2, 2, 2, 4, 4, 1, 2, 2, 4, 2, 2, 2, 4, 2, 2, 4, 2, 4, 2, 4, 4, 2, 2, 2, 1, 4, 4, 4, 2,
        1, 7, 1, 2, 2, 0, 2, 7, 4, 2, 4, 1, 2, 2, 2, 4, 1, 2, 1, 0, 0, 2, 1, 1, 1, 2, 2, 2, 4, 4,
        2, 2, 2, 2, 1, 1, 4, 4, 2, 2, 4, 2, 1, 1, 2, 2, 1, 2, 2, 4, 2, 1, 4, 3, 1, 1, 1, 4, 2, 2,
        4, 2, 4, 1, 2, 2, 2, 4, 4, 2, 2, 1, 2, 2, 2, 2, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 4, 2, 2, 1,
        1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 1, 1, 1, 2, 2, 2, 2, 7, 7, 1, 4, 2, 2, 2, 2, 2, 4, 4, 2, 2,
        4, 4, 2, 1, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 1, 2, 4, 4, 1, 0, 0, 1, 1, 2, 1, 2, 2, 1, 2, 4,
        4, 2, 4, 1, 0, 4, 2, 2, 2, 2, 0, 0, 7, 2, 2, 1, 4, 4, 4, 2, 2, 2, 2, 2, 4, 2, 0, 0, 0, 4,
        0, 0
    };
    new
        model = GetVehicleModel(vehicleid);

    if(400 <= model <= 611)
        return g_arrMaxSeats[model - 400];

    return 0;
}

RemoveFromVehicle(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        static
        Float:fX,
        Float:fY,
        Float:fZ;

        GetPlayerPos(playerid, fX, fY, fZ);
        SetPlayerPos(playerid, fX, fY, fZ + 1.5);
    }
    return 1;
}

GetAvailableSeat(vehicleid, start = 1)
{
    new seats = GetVehicleMaxSeats(vehicleid);

    for (new i = start; i < seats; i ++) if(!IsVehicleSeatUsed(vehicleid, i)) {
        return i;
    }
    return -1;
}

IsVehicleSeatUsed(vehicleid, seat)
{
    foreach (new i : Player) if(IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seat) {
        return 1;
    }
    return 0;
}

//----------[ Other Native]----------

Uptime()
{
	new uptime[40];
	switch(up_days)
	{
	    case 0:
	    {
			if(up_hours)
			{
				if(up_minutes)
					format(uptime, sizeof(uptime), "%d hour%s and %d minute%s", up_hours, (up_hours != 1 ?("s") : ("")), up_minutes, (up_minutes != 1 ? ("s") : ("")));
				else
					format(uptime, sizeof(uptime), "%d hour%s", up_hours, (up_hours != 1 ? ("s") : ("")));
			}
			else
			{
				if(up_minutes)
					format(uptime, sizeof(uptime), "%d minute%s and %d second%s", up_minutes, (up_minutes != 1 ? ("s") : ("")), up_seconds, (up_seconds != 1 ? ("s") : ("")));
				else
					format(uptime, sizeof(uptime), "%d seconds", up_seconds);
			}
		}
		case 1:
		{
			switch(up_hours)
			{
				case 0: uptime = "24 hours";
				case 1: uptime = "one day and 1 hour";
				default: format(uptime, sizeof(uptime), "one day and %d hours", up_hours);
			}
		}
		default:
		{
			switch(up_hours)
			{
				case 0: format(uptime, sizeof(uptime), "%d days", up_days);
				case 1: format(uptime, sizeof(uptime), "%d days and 1 hour", up_days);
				default: format(uptime, sizeof(uptime), "%d days and %d hours", up_days, up_hours);
			}
		}
	}
	return uptime;
}

ConvertHBEColor(value) {
    new color;
    if(value >= 90 && value <= 100)
        color = 0x15a014FF;
    else if(value >= 80 && value < 90)
        color = 0x1b9913FF;
    else if(value >= 70 && value < 80)
        color = 0x1a7f08FF;
    else if(value >= 60 && value < 70)
        color = 0x326305FF;
    else if(value >= 50 && value < 60)
        color = 0x375d04FF;
    else if(value >= 40 && value < 50)
        color = 0x603304FF;
    else if(value >= 30 && value < 40)
        color = 0xd72800FF;
    else if(value >= 10 && value < 30)
        color = 0xfb3508FF;
    else if(value >= 0 && value < 10)
        color = 0xFF0000FF;
    else 
        color = COLOR_WHITE;

    return color;
}
/*
IsSRV(carid)
{
	for(new v = 0; v < sizeof(SRV); v++) {
	    if(carid == SRV[v]) return 1;
	}
	return 0;
}

IsVSRV(carid)
{
	for(new v = 0; v < sizeof(VSRV); v++) {
	    if(carid == VSRV[v]) return 1;
	}
	return 0;
}*/

/*GetVipVehicleCost(carid)
{
	if(carid == 522) return 30; //NRG
	if(carid == 411) return 45; //Infernus
	if(carid == 451) return 35; //Turismo
	if(carid == 415) return 30; //Cheetah
	if(carid == 402) return 30; //Buffalo
	if(carid == 541) return 30; //Bullet
	if(carid == 429) return 30; //Benshe
	if(carid == 506) return 35; //SuperGT
	if(carid == 494) return 35; //nascar
	if(carid == 502) return 35; //nascar
	if(carid == 503) return 35; //nascar
	if(carid == 409) return 30; //Stretch
	if(carid == 477) return 30; //ZR-350
	
	return -1;
}

GetVehicleCost(carid)
{
    if(carid == 481) return 80;  //bmx
	if(carid == 509) return 50; //bike
	if(carid == 510) return 100; //mt bike
	if(carid == 463) return 9000; //freeway harley
	if(carid == 521) return 10500; //fcr 900
	if(carid == 461) return 8000; //pcj 600
	if(carid == 581) return 5000; //bf
	if(carid == 468) return 6800; //sancehz
	if(carid == 586) return 8500; //wayfare
	if(carid == 462) return 3000; //faggio
	
	if(carid == 400) return 20500; //Landstalker
	if(carid == 412) return 22300; //Voodoo
	if(carid == 419) return 13500; //Esperanto
	if(carid == 426) return 17500; //Premier
	if(carid == 436) return 18000; //Stallion
	if(carid == 466) return 18000; //Glendale
	if(carid == 467) return 17500; //Oceanic
	if(carid == 474) return 25000; //Hermes
	if(carid == 475) return 55000; //Sabre
	if(carid == 480) return 32000; //Comet
	if(carid == 603) return 58000; //Phoenix
	if(carid == 421) return 11500; //Wasington
	if(carid == 602) return 32000; //Alpha
	if(carid == 424) return 15000; //Bf Injection
	if(carid == 492) return 12000; //Greenwood
	if(carid == 545) return 50000; //huster
	if(carid == 470) return 12000; //Patriot
	if(carid == 489) return 12000; //Rancher
	if(carid == 405) return 16200; //Sentinel
	if(carid == 445) return 10000; //Admiral
	if(carid == 579) return 28000; //Huntley
	if(carid == 507) return 18000; //Elegant
	
	if(carid == 483) return 35000; //Camper
	if(carid == 534) return 30000; //Remington
	if(carid == 535) return 38000; //Slamvan
	if(carid == 536) return 20000; //Blade
	if(carid == 567) return 27000; //Savanna
	if(carid == 562) return 72000; //Elegy
	if(carid == 559) return 65000; //Jester
	if(carid == 558) return 65000; //Uranus
	if(carid == 560) return 78000; //Sultan
	if(carid == 561) return 58800; //Stratum
	if(carid == 565) return 37000; //Flash
	if(carid == 575) return 17500; //Broadway
	if(carid == 576) return 26500; //Tornado
	
	if(carid == 522) return 10000; //NRG
	if(carid == 411) return 80000; //Infernus
	if(carid == 451) return 75000; //Turismo
	if(carid == 415) return 50000; //Cheetah
	if(carid == 402) return 36500; //Buffalo
	if(carid == 541) return 75000; //Bullet
	if(carid == 429) return 40000; //Benshe
	if(carid == 506) return 75000; //SuperGT
	if(carid == 494) return 75000; //nascar
	if(carid == 502) return 75000; //nascar
	if(carid == 503) return 75000; //nascar
	if(carid == 409) return 50000; //Stretch
	if(carid == 477) return 70000; //ZR-350
	
	if(carid == 420) return 7000; //Taxi
	if(carid == 438) return 6000; //Cabbie
	if(carid == 403) return 9000; //Linerunner
	if(carid == 413) return 8000; //Phony
	if(carid == 414) return 8000; //Mule
	if(carid == 422) return 10000; //Bobcat
	if(carid == 440) return 8000; //Rumpo
	if(carid == 455) return 8000; //Flatbead
	if(carid == 456) return 9000; //Yankee
	if(carid == 478) return 7000; //Walton
	if(carid == 482) return 6850; //Burrito
	if(carid == 498) return 8000; //Boxville
	if(carid == 499) return 8000; //Benson
	if(carid == 514) return 19000; //Tanker
	if(carid == 515) return 19000; //Roadtrain
	if(carid == 524) return 19000; //Cement Truck
	if(carid == 525) return 9000; //Towtruck
	if(carid == 543) return 7500; //Sadler
	if(carid == 552) return 8000; //Utility Van
	if(carid == 554) return 18800; //Yosemite
	if(carid == 578) return 19000; //DFT-30
	if(carid == 609) return 8000; //Boxville
	if(carid == 423) return 5000; //Mr Whoopee/Ice cream
	if(carid == 588) return 5000; //Hotdog
 	return -1;
}*/

GetVipVehicleCost(carid)
{
	//Ini Kendaraan saat beli pakai GOLD

	//Category Kendaraan Dealer
	if(carid == 445) return 1000; //Admiral
	if(carid == 496) return 1000; //Blista compact
	if(carid == 401) return 1000; //Bravura
	if(carid == 518) return 1000; //Buccaneer
	if(carid == 527) return 1000; //Cadrona
	if(carid == 483) return 1000; //Camper
	if(carid == 542) return 1000; //Clover
	if(carid == 589) return 1000; //Club
	if(carid == 507) return 1000; //Elegant
	if(carid == 540) return 1000; //Vincent
	if(carid == 585) return 1000; //Emperor
	if(carid == 419) return 1000; //Esperanto
	if(carid == 526) return 1000; //Fortune
	if(carid == 466) return 1000; //Glendale
	if(carid == 492) return 1000; //Greenwood
	if(carid == 474) return 1000; //Hermes
	if(carid == 546) return 1000; //Intruder
	if(carid == 517) return 1000; //Majestic
	if(carid == 410) return 1000; //Manana
	if(carid == 551) return 1000; //Merit
	if(carid == 516) return 1000; //Nebula
	if(carid == 467) return 1000; //Oceanic
	if(carid == 404) return 1000; //Perenniel
	if(carid == 600) return 1000; //Picador
	if(carid == 426) return 1000; //Premier
	if(carid == 436) return 1000; //Previon
	if(carid == 547) return 1000; //Primo
	if(carid == 405) return 1000; //Sentinel
	if(carid == 458) return 1000; //Solair
	if(carid == 439) return 1000; //Stallion
	if(carid == 550) return 1000; //Sunrise
	if(carid == 549) return 1000; //Tampa
	if(carid == 491) return 1000; //Virgo
	if(carid == 421) return 1000; //Washington
	if(carid == 529) return 1000; //Williard
	
	//Category Kendaraan Limitid 
	if(carid == 602) return 1400; //Alpha
	if(carid == 429) return 1400; //Banshee
	if(carid == 562) return 1400; //Elegy
	if(carid == 587) return 1400; //Euros
	if(carid == 565) return 1400; //Flash
	if(carid == 559) return 1400; //Jester
	if(carid == 534) return 1400; //Remington
	if(carid == 535) return 1400; //Slamvan
	if(carid == 561) return 1400; //Stratum
	if(carid == 506) return 1400; //Super GT
	if(carid == 560) return 1400; //Sultan
	if(carid == 558) return 1400; //Uranus
	if(carid == 555) return 1400; //Windsor
	if(carid == 477) return 1400; //Zr-350
	if(carid == 545) return 1400; //HUstler
	if(carid == 475) return 1400; //Sabre
	if(carid == 480) return 1400; //Comet
	if(carid == 580) return 1400; //Staffrod
	
	//Category Kendaraan Non Dealer
	if(carid == 434) return 1800; //Hotknife
	if(carid == 502) return 1800; //Hotring Racer
	if(carid == 495) return 1800; //Sandking
	if(carid == 451) return 1800; //Turismo
	if(carid == 470) return 1800; //Patriot
	if(carid == 424) return 1800; //BF Injection
	if(carid == 522) return 1800; //Nrg
	if(carid == 411) return 1800; //Infernus
	if(carid == 541) return 1800; //Bullet
	if(carid == 504) return 1800; //Bloodring Banger
	if(carid == 603) return 1800; //Phoenix
	if(carid == 415) return 1800; //Cheetah
	if(carid == 402) return 1800; //Buffalo
	if(carid == 508) return 1800; //Journey
	if(carid == 457) return 1800; //Caddy
	if(carid == 471) return 1800; //Quad
	
	return -1;
}

GetVehicleCost(carid)
{
	//Ini Kendaraan saat beli pakai uang IC
	
	//Category Kendaraan Bike
	if(carid == 481) return 100; //Bmx
	if(carid == 509) return 50; //Bike
	if(carid == 510) return 150; //Mt bike
	if(carid == 463) return 4500; //Freeway harley
	if(carid == 521) return 5500; //Fcr 900
	if(carid == 461) return 4750; //Pcj 600
	if(carid == 581) return 2500; //Bf
	if(carid == 468) return 3500; //Sancehz
	if(carid == 586) return 4250; //Wayfare
	if(carid == 462) return 1500; //Faggio

	//Category Kendaraan Cars
	if(carid == 445) return 3500; //Admiral
	if(carid == 496) return 2000; //Blista Compact
	if(carid == 401) return 1500; //Bravura
	if(carid == 518) return 1500; //Buccaneer
	if(carid == 527) return 2000; //Cadrona
	if(carid == 483) return 2000; //Camper
	if(carid == 542) return 3000; //Clover
	if(carid == 589) return 2500; //Club
	if(carid == 507) return 5000; //Elegant
	if(carid == 540) return 2000; //Vincent
	if(carid == 585) return 2000; //Emperor
	if(carid == 419) return 3500; //Esperanto
	if(carid == 526) return 3000; //Fortune
	if(carid == 466) return 4000; //Glendale
	if(carid == 492) return 5000; //Greenwood
	if(carid == 474) return 4500; //Hermes
	if(carid == 546) return 4000; //Intruder
	if(carid == 517) return 4000; //Majestic
	if(carid == 410) return 3500; //Manana
	if(carid == 551) return 4000; //Merit
	if(carid == 516) return 4500; //Nebula
	if(carid == 467) return 4500; //Oceanic
	if(carid == 404) return 3000; //Perenniel
	if(carid == 600) return 8000; //Picador
	if(carid == 426) return 3500; //Premier
	if(carid == 436) return 3000; //Previon
	if(carid == 547) return 4000; //Primo
	if(carid == 405) return 3000; //Sentinel
	if(carid == 458) return 3500; //Solair
	if(carid == 439) return 3000; //Stallion
	if(carid == 550) return 2500; //Sunrise
	if(carid == 566) return 3000; //Tahoma
	if(carid == 549) return 3500; //Tampa
	if(carid == 491) return 4000; //Virgo
	if(carid == 412) return 4000; //Voodoo
	if(carid == 421) return 3000; //Washington
	if(carid == 529) return 4000; //Willard
	if(carid == 555) return 4000; //Windsor
	if(carid == 580) return 7000; //Stafford
	if(carid == 475) return 5000; //Sabre
	if(carid == 545) return 2500; //Hustler
	
	//Category Kendaraan Lowriders
	if(carid == 536) return 4000; //Blade
	if(carid == 575) return 4000; //Broadway
	if(carid == 533) return 2500; //Feltzer
	if(carid == 534) return 3500; //Remington
	if(carid == 567) return 5000; //Savanna
	if(carid == 535) return 4000; //Slamvan
	if(carid == 576) return 4000; //Tornado
	if(carid == 566) return 3000; //Tahoma
	if(carid == 412) return 4000; //Voodoo
	
	//Category Kendaraan SUVS Cars
	if(carid == 579) return 7000; //Huntley
	if(carid == 400) return 5500; //Landstalker
	if(carid == 500) return 10000; //Mesa
	if(carid == 489) return 5500; //Rancher
	if(carid == 479) return 2000; //Regina
	if(carid == 482) return 4000; //Burrito
	if(carid == 418) return 4500; //Moonbeam
	if(carid == 413) return 5000; //Pony
	//if(carid == 554) return 3000; //Yosemite
	
	//Category Kendaraan Sports
	if(carid == 602) return 8000; //Alpha
	if(carid == 429) return 12500; //Banshee
	if(carid == 562) return 15000; //Elegy
	if(carid == 587) return 7000; //Euros
	if(carid == 565) return 9000; //Flash
	if(carid == 559) return 12000; //Jester
	if(carid == 561) return 11000; //Stratum
	if(carid == 560) return 14000; //Sultan
	if(carid == 506) return 20000; //Super GT
	if(carid == 558) return 13000; //Uranus
	if(carid == 477) return 13500; //Zr-350
	if(carid == 480) return 9000; //Comet
	
	//Category Kendaraan Non Dealer
	if(carid == 434) return 50000; //Hotknife
	if(carid == 502) return 50000; //Hotring Racer
	if(carid == 495) return 50000; //Sandking
	if(carid == 451) return 50000; //Turismo
	if(carid == 470) return 50000; //Patriot
	if(carid == 424) return 50000; //BF Injection
	if(carid == 522) return 50000; //Nrg
	if(carid == 411) return 50000; //Infernus
	if(carid == 541) return 50000; //Bullet
	if(carid == 504) return 50000; //Bloodring Banger
	if(carid == 603) return 50000; //Phoenix
	if(carid == 415) return 50000; //Cheetah
	if(carid == 402) return 50000; //Buffalo
	if(carid == 508) return 50000; //Journey
	if(carid == 457) return 50000; //Caddy
	if(carid == 471) return 50000; //Quad

	//Category Kendaraan Job
	if(carid == 420) return 2000; //Taxi
	if(carid == 438) return 2500; //Cabbie
	if(carid == 403) return 3500; //Linerunner
	if(carid == 414) return 3500; //Mule
	if(carid == 422) return 3000; //Bobcat
	if(carid == 440) return 3500; //Rumpo
	if(carid == 455) return 4000; //Flatbead
	if(carid == 456) return 3500; //Yankee
	if(carid == 478) return 2500; //Walton
	if(carid == 498) return 3000; //Boxville
	if(carid == 499) return 3000; //Benson
	if(carid == 514) return 3500; //Tanker
	if(carid == 515) return 4000; //Roadtrain
	if(carid == 524) return 3000; //Cement Truck
	if(carid == 525) return 4000; //Towtruck
	if(carid == 543) return 3000; //Sadler
	if(carid == 552) return 2500; //Utility Van
	if(carid == 554) return 3000; //Yosemite
	if(carid == 578) return 3500; //DFT-30
	if(carid == 609) return 3500; //Boxville
	if(carid == 423) return 2500; //Mr Whoopee/Ice cream
	if(carid == 588) return 2500; //Hotdog
 	return -1;
}

GetVehicleRentalCost(carid)
{
	//Kapal/ Perahu
	if(carid == 452) return 1500; //Speeder
	if(carid == 473) return 750; //Dinghy
	if(carid == 453) return 1250; //Reefer

	if(carid == 481) return 50; //BMX
	if(carid == 462) return 200; //Vespa
	return -1;
}

//Text and Chat
ColouredText(text[])
{
    new
        pos = -1,
        string[144]
    ;
    strmid(string, text, 0, 128, (sizeof(string) - 16));

    while((pos = strfind(string, "#", true, (pos + 1))) != -1)
    {
        new
            i = (pos + 1),
            hexCount
        ;
        for( ; ((string[i] != 0) && (hexCount < 6)); ++i, ++hexCount)
        {
            if(!(('a' <= string[i] <= 'f') || ('A' <= string[i] <= 'F') || ('0' <= string[i] <= '9')))
            {
                    break;
            }
        }
        if((hexCount == 6) && !(hexCount < 6))
        {
            string[pos] = '{';
            strins(string, "}", i);
        }
    }
    return string;
}

FixText(text[])
{
    new len = strlen(text);
    if(len > 1)
    {
        for (new i = 0; i < len; i++)
        {
            if(text[i] == 92)
            {
                if(text[i+1] == 'n')
                {
                    text[i] = '\n';
                    for (new j = i+1; j < len; j++) text[j] = text[j+1], text[j+1] = 0;
                    continue;
                }
                if(text[i+1] == 't')
                {
                    text[i] = '\t';
                    for (new j = i+1; j < len-1; j++) text[j] = text[j+1], text[j+1] = 0;
                    continue;
                }
                if(text[i+1] == 92)
                {
                    text[i] = 92;
                    for (new j = i+1; j < len-1; j++) text[j] = text[j+1], text[j+1] = 0;
                }
            }
        }
    }
    return 1;
}

SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
    static
        args,
            str[144];

    if((args = numargs()) == 3)
    {
            SendClientMessage(playerid, color, text);
    }
    else
    {
        while (--args >= 3)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit PUSH.S 8
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}

SendClientMessageToAllEx(color, const text[], {Float, _}:...)
{
    static
        args,
            str[144];

    if((args = numargs()) == 2)
    {
            SendClientMessageToAll(color, text);
    }
    else
    {
        while (--args >= 2)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit LOAD.S.pri 8
        #emit ADD.C 4
        #emit PUSH.pri
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessageToAll(color, str);

        #emit RETN
    }
    return 1;
}

SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[144]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if(args > 16)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 16); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 144
        #emit PUSH.C string

        #emit LOAD.S.pri 8
        #emit CONST.alt 4
        #emit SUB
        #emit PUSH.pri

        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        foreach (new i : Player)
        {
            if(NearPlayer(i, playerid, radius)) {
                SendClientMessage(i, color, string);
            }
        }
        return 1;
    }
    foreach (new i : Player)
    {
        if(NearPlayer(i, playerid, radius)) {
            SendClientMessage(i, color, str);
        }
    }
    return 1;
}

SetPlayerPosition(playerid, Float:X, Float:Y, Float:Z, Float:a, inter = 0)
{
    SetPlayerInterior(playerid, inter);
    SetPlayerPos(playerid, X, Y, Z);
	SetPlayerFacingAngle(playerid, a);
	SetCameraBehindPlayer(playerid);
	//SetPlayerWorldBounds(playerid, 20000, -20000, 20000, -20000);
}

SetVehiclePosition(playerid, vehicleid, Float:X, Float:Y, Float:Z, Float:a, inter = 0)
{
    LinkVehicleToInterior(vehicleid, inter);
    SetVehiclePos(vehicleid, X, Y, Z);
	SetVehicleZAngle(playerid, a);
	SetCameraBehindPlayer(playerid);
	//SetPlayerWorldBounds(playerid, 20000, -20000, 20000, -20000);
}

SetPlayerPositionEx(playerid, Float:x, Float:y, Float:z, Float:a, time = 2000)
{
    if(pData[playerid][pFreeze])
    {
        KillTimer(pData[playerid][pFreezeTimer]);
        pData[playerid][pFreeze] = 0;
        TogglePlayerControllable(playerid, 1);
    }
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 0);
    pData[playerid][pFreeze] = 1;
    SetPlayerPos(playerid, x, y, z + 0.5);
	SetPlayerFacingAngle(playerid, a);
	pData[playerid][pFreezeTimer] = SetTimerEx("SetPlayerToUnfreeze", time, false, "iffff", playerid, x, y, z, a);
}

SetVehiclePositionEx(playerid, vehicleid, Float:x, Float:y, Float:z, Float:a, time = 2000)
{
    if(pData[playerid][pFreeze])
    {
        KillTimer(pData[playerid][pFreezeTimer]);
        pData[playerid][pFreeze] = 0;
        TogglePlayerControllable(playerid, 1);
    }
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 0);
    pData[playerid][pFreeze] = 1;
    SetVehiclePos(vehicleid, x, y, z + 0.4);
	SetVehicleZAngle(vehicleid, a);
	pData[playerid][pFreezeTimer] = SetTimerEx("SetVehicleToUnfreeze", time, false, "iiffff", playerid, vehicleid, x, y, z, a);
}

SendPlayerToPlayer(playerid, targetid)
{
    new
        Float:x,
        Float:y,
        Float:z;
		
	if(pData[targetid][pSpawned] == 0 || pData[playerid][pSpawned] == 0)
	{
		Error(playerid, "Player/Target sedang tidak spawn!");
		return 1;
	}
	if(pData[playerid][pJail] > 0 || pData[targetid][pJail] > 0)
		return Error(playerid, "Player/Target sedang di jail");
		
	if(pData[playerid][pArrest] > 0 || pData[targetid][pArrest] > 0)
		return Error(playerid, "Player/Target sedang di arrest");
		
    GetPlayerPos(targetid, x, y, z);

    if(IsPlayerInAnyVehicle(playerid))
    {
        SetVehiclePos(GetPlayerVehicleID(playerid), x, y + 2, z);
        LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(targetid));
    }
    else
    {
        SetPlayerPosition(playerid, x + 1, y, z, 750);
    }
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

    pData[playerid][pInHouse] = pData[targetid][pInHouse];
    pData[playerid][pInBiz] = pData[targetid][pInBiz];
    pData[playerid][pInDoor] = pData[targetid][pInDoor];
	pData[playerid][pInFamily] = pData[targetid][pInFamily];
    return 1;
}

ProxDetector(Float: f_Radius, playerid, string[],col1,col2,col3,col4,col5) 
{
		new
			Float: f_playerPos[3];

		GetPlayerPos(playerid, f_playerPos[0], f_playerPos[1], f_playerPos[2]);
		foreach(new i : Player) 
		{
			if(!pData[i][pSPY]) 
			{
				if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)) 
				{
					if(IsPlayerInRangeOfPoint(i, f_Radius / 16, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
						SendClientMessage(i, col1, string);
					}
					else if(IsPlayerInRangeOfPoint(i, f_Radius / 8, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
						SendClientMessage(i, col2, string);
					}
					else if(IsPlayerInRangeOfPoint(i, f_Radius / 4, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
						SendClientMessage(i, col3, string);
					}
					else if(IsPlayerInRangeOfPoint(i, f_Radius / 2, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
						SendClientMessage(i, col4, string);
					}
					else if(IsPlayerInRangeOfPoint(i, f_Radius, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
						SendClientMessage(i, col5, string);
					}
				}
			}
			else SendClientMessage(i, col1, string);
		}
		return 1;
}

NearPlayer(playerid, targetid, Float:radius)
{
    static
        Float:fX,
        Float:fY,
        Float:fZ;

    GetPlayerPos(targetid, fX, fY, fZ);

    return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

GetLocation(Float:fX, Float:fY, Float:fZ)
{
    enum e_ZoneData
    {
            e_ZoneName[32 char],
        Float:e_ZoneArea[6]
    };
    static const g_arrZoneData[][e_ZoneData] =
    {
        {!"The Big Ear",                {-410.00, 1403.30, -3.00, -137.90, 1681.20, 200.00}},
        {!"Aldea Malvada",                {-1372.10, 2498.50, 0.00, -1277.50, 2615.30, 200.00}},
        {!"Angel Pine",                   {-2324.90, -2584.20, -6.10, -1964.20, -2212.10, 200.00}},
        {!"Arco del Oeste",               {-901.10, 2221.80, 0.00, -592.00, 2571.90, 200.00}},
        {!"Avispa Country Club",          {-2646.40, -355.40, 0.00, -2270.00, -222.50, 200.00}},
        {!"Avispa Country Club",          {-2831.80, -430.20, -6.10, -2646.40, -222.50, 200.00}},
        {!"Avispa Country Club",          {-2361.50, -417.10, 0.00, -2270.00, -355.40, 200.00}},
        {!"Avispa Country Club",          {-2667.80, -302.10, -28.80, -2646.40, -262.30, 71.10}},
        {!"Avispa Country Club",          {-2470.00, -355.40, 0.00, -2270.00, -318.40, 46.10}},
        {!"Avispa Country Club",          {-2550.00, -355.40, 0.00, -2470.00, -318.40, 39.70}},
        {!"Back o Beyond",                {-1166.90, -2641.10, 0.00, -321.70, -1856.00, 200.00}},
        {!"Battery Point",                {-2741.00, 1268.40, -4.50, -2533.00, 1490.40, 200.00}},
        {!"Bayside",                      {-2741.00, 2175.10, 0.00, -2353.10, 2722.70, 200.00}},
        {!"Bayside Marina",               {-2353.10, 2275.70, 0.00, -2153.10, 2475.70, 200.00}},
        {!"Beacon Hill",                  {-399.60, -1075.50, -1.40, -319.00, -977.50, 198.50}},
        {!"Blackfield",                   {964.30, 1203.20, -89.00, 1197.30, 1403.20, 110.90}},
        {!"Blackfield",                   {964.30, 1403.20, -89.00, 1197.30, 1726.20, 110.90}},
        {!"Blackfield Chapel",            {1375.60, 596.30, -89.00, 1558.00, 823.20, 110.90}},
        {!"Blackfield Chapel",            {1325.60, 596.30, -89.00, 1375.60, 795.00, 110.90}},
        {!"Blackfield Intersection",      {1197.30, 1044.60, -89.00, 1277.00, 1163.30, 110.90}},
        {!"Blackfield Intersection",      {1166.50, 795.00, -89.00, 1375.60, 1044.60, 110.90}},
        {!"Blackfield Intersection",      {1277.00, 1044.60, -89.00, 1315.30, 1087.60, 110.90}},
        {!"Blackfield Intersection",      {1375.60, 823.20, -89.00, 1457.30, 919.40, 110.90}},
        {!"Blueberry",                    {104.50, -220.10, 2.30, 349.60, 152.20, 200.00}},
        {!"Blueberry",                    {19.60, -404.10, 3.80, 349.60, -220.10, 200.00}},
        {!"Blueberry Acres",              {-319.60, -220.10, 0.00, 104.50, 293.30, 200.00}},
        {!"Caligula's Palace",            {2087.30, 1543.20, -89.00, 2437.30, 1703.20, 110.90}},
        {!"Caligula's Palace",            {2137.40, 1703.20, -89.00, 2437.30, 1783.20, 110.90}},
        {!"Calton Heights",               {-2274.10, 744.10, -6.10, -1982.30, 1358.90, 200.00}},
        {!"Chinatown",                    {-2274.10, 578.30, -7.60, -2078.60, 744.10, 200.00}},
        {!"City Hall",                    {-2867.80, 277.40, -9.10, -2593.40, 458.40, 200.00}},
        {!"Come-A-Lot",                   {2087.30, 943.20, -89.00, 2623.10, 1203.20, 110.90}},
        {!"Commerce",                     {1323.90, -1842.20, -89.00, 1701.90, -1722.20, 110.90}},
        {!"Commerce",                     {1323.90, -1722.20, -89.00, 1440.90, -1577.50, 110.90}},
        {!"Commerce",                     {1370.80, -1577.50, -89.00, 1463.90, -1384.90, 110.90}},
        {!"Commerce",                     {1463.90, -1577.50, -89.00, 1667.90, -1430.80, 110.90}},
        {!"Commerce",                     {1583.50, -1722.20, -89.00, 1758.90, -1577.50, 110.90}},
        {!"Commerce",                     {1667.90, -1577.50, -89.00, 1812.60, -1430.80, 110.90}},
        {!"Conference Center",            {1046.10, -1804.20, -89.00, 1323.90, -1722.20, 110.90}},
        {!"Conference Center",            {1073.20, -1842.20, -89.00, 1323.90, -1804.20, 110.90}},
        {!"Cranberry Station",            {-2007.80, 56.30, 0.00, -1922.00, 224.70, 100.00}},
        {!"Creek",                        {2749.90, 1937.20, -89.00, 2921.60, 2669.70, 110.90}},
        {!"Dillimore",                    {580.70, -674.80, -9.50, 861.00, -404.70, 200.00}},
        {!"Doherty",                      {-2270.00, -324.10, -0.00, -1794.90, -222.50, 200.00}},
        {!"Doherty",                      {-2173.00, -222.50, -0.00, -1794.90, 265.20, 200.00}},
        {!"Downtown",                     {-1982.30, 744.10, -6.10, -1871.70, 1274.20, 200.00}},
        {!"Downtown",                     {-1871.70, 1176.40, -4.50, -1620.30, 1274.20, 200.00}},
        {!"Downtown",                     {-1700.00, 744.20, -6.10, -1580.00, 1176.50, 200.00}},
        {!"Downtown",                     {-1580.00, 744.20, -6.10, -1499.80, 1025.90, 200.00}},
        {!"Downtown",                     {-2078.60, 578.30, -7.60, -1499.80, 744.20, 200.00}},
        {!"Downtown",                     {-1993.20, 265.20, -9.10, -1794.90, 578.30, 200.00}},
        {!"Downtown Los Santos",          {1463.90, -1430.80, -89.00, 1724.70, -1290.80, 110.90}},
        {!"Downtown Los Santos",          {1724.70, -1430.80, -89.00, 1812.60, -1250.90, 110.90}},
        {!"Downtown Los Santos",          {1463.90, -1290.80, -89.00, 1724.70, -1150.80, 110.90}},
        {!"Downtown Los Santos",          {1370.80, -1384.90, -89.00, 1463.90, -1170.80, 110.90}},
        {!"Downtown Los Santos",          {1724.70, -1250.90, -89.00, 1812.60, -1150.80, 110.90}},
        {!"Downtown Los Santos",          {1370.80, -1170.80, -89.00, 1463.90, -1130.80, 110.90}},
        {!"Downtown Los Santos",          {1378.30, -1130.80, -89.00, 1463.90, -1026.30, 110.90}},
        {!"Downtown Los Santos",          {1391.00, -1026.30, -89.00, 1463.90, -926.90, 110.90}},
        {!"Downtown Los Santos",          {1507.50, -1385.20, 110.90, 1582.50, -1325.30, 335.90}},
        {!"East Beach",                   {2632.80, -1852.80, -89.00, 2959.30, -1668.10, 110.90}},
        {!"East Beach",                   {2632.80, -1668.10, -89.00, 2747.70, -1393.40, 110.90}},
        {!"East Beach",                   {2747.70, -1668.10, -89.00, 2959.30, -1498.60, 110.90}},
        {!"East Beach",                   {2747.70, -1498.60, -89.00, 2959.30, -1120.00, 110.90}},
        {!"East Los Santos",              {2421.00, -1628.50, -89.00, 2632.80, -1454.30, 110.90}},
        {!"East Los Santos",              {2222.50, -1628.50, -89.00, 2421.00, -1494.00, 110.90}},
        {!"East Los Santos",              {2266.20, -1494.00, -89.00, 2381.60, -1372.00, 110.90}},
        {!"East Los Santos",              {2381.60, -1494.00, -89.00, 2421.00, -1454.30, 110.90}},
        {!"East Los Santos",              {2281.40, -1372.00, -89.00, 2381.60, -1135.00, 110.90}},
        {!"East Los Santos",              {2381.60, -1454.30, -89.00, 2462.10, -1135.00, 110.90}},
        {!"East Los Santos",              {2462.10, -1454.30, -89.00, 2581.70, -1135.00, 110.90}},
        {!"Easter Basin",                 {-1794.90, 249.90, -9.10, -1242.90, 578.30, 200.00}},
        {!"Easter Basin",                 {-1794.90, -50.00, -0.00, -1499.80, 249.90, 200.00}},
        {!"Easter Bay Airport",           {-1499.80, -50.00, -0.00, -1242.90, 249.90, 200.00}},
        {!"Easter Bay Airport",           {-1794.90, -730.10, -3.00, -1213.90, -50.00, 200.00}},
        {!"Easter Bay Airport",           {-1213.90, -730.10, 0.00, -1132.80, -50.00, 200.00}},
        {!"Easter Bay Airport",           {-1242.90, -50.00, 0.00, -1213.90, 578.30, 200.00}},
        {!"Easter Bay Airport",           {-1213.90, -50.00, -4.50, -947.90, 578.30, 200.00}},
        {!"Easter Bay Airport",           {-1315.40, -405.30, 15.40, -1264.40, -209.50, 25.40}},
        {!"Easter Bay Airport",           {-1354.30, -287.30, 15.40, -1315.40, -209.50, 25.40}},
        {!"Easter Bay Airport",           {-1490.30, -209.50, 15.40, -1264.40, -148.30, 25.40}},
        {!"Easter Bay Chemicals",         {-1132.80, -768.00, 0.00, -956.40, -578.10, 200.00}},
        {!"Easter Bay Chemicals",         {-1132.80, -787.30, 0.00, -956.40, -768.00, 200.00}},
        {!"El Castillo del Diablo",       {-464.50, 2217.60, 0.00, -208.50, 2580.30, 200.00}},
        {!"El Castillo del Diablo",       {-208.50, 2123.00, -7.60, 114.00, 2337.10, 200.00}},
        {!"El Castillo del Diablo",       {-208.50, 2337.10, 0.00, 8.40, 2487.10, 200.00}},
        {!"El Corona",                    {1812.60, -2179.20, -89.00, 1970.60, -1852.80, 110.90}},
        {!"El Corona",                    {1692.60, -2179.20, -89.00, 1812.60, -1842.20, 110.90}},
        {!"El Quebrados",                 {-1645.20, 2498.50, 0.00, -1372.10, 2777.80, 200.00}},
        {!"Esplanade East",               {-1620.30, 1176.50, -4.50, -1580.00, 1274.20, 200.00}},
        {!"Esplanade East",               {-1580.00, 1025.90, -6.10, -1499.80, 1274.20, 200.00}},
        {!"Esplanade East",               {-1499.80, 578.30, -79.60, -1339.80, 1274.20, 20.30}},
        {!"Esplanade North",              {-2533.00, 1358.90, -4.50, -1996.60, 1501.20, 200.00}},
        {!"Esplanade North",              {-1996.60, 1358.90, -4.50, -1524.20, 1592.50, 200.00}},
        {!"Esplanade North",              {-1982.30, 1274.20, -4.50, -1524.20, 1358.90, 200.00}},
        {!"Fallen Tree",                  {-792.20, -698.50, -5.30, -452.40, -380.00, 200.00}},
        {!"Fallow Bridge",                {434.30, 366.50, 0.00, 603.00, 555.60, 200.00}},
        {!"Fern Ridge",                   {508.10, -139.20, 0.00, 1306.60, 119.50, 200.00}},
        {!"Financial",                    {-1871.70, 744.10, -6.10, -1701.30, 1176.40, 300.00}},
        {!"Fisher's Lagoon",              {1916.90, -233.30, -100.00, 2131.70, 13.80, 200.00}},
        {!"Flint Intersection",           {-187.70, -1596.70, -89.00, 17.00, -1276.60, 110.90}},
        {!"Flint Range",                  {-594.10, -1648.50, 0.00, -187.70, -1276.60, 200.00}},
        {!"Fort Carson",                  {-376.20, 826.30, -3.00, 123.70, 1220.40, 200.00}},
        {!"Foster Valley",                {-2270.00, -430.20, -0.00, -2178.60, -324.10, 200.00}},
        {!"Foster Valley",                {-2178.60, -599.80, -0.00, -1794.90, -324.10, 200.00}},
        {!"Foster Valley",                {-2178.60, -1115.50, 0.00, -1794.90, -599.80, 200.00}},
        {!"Foster Valley",                {-2178.60, -1250.90, 0.00, -1794.90, -1115.50, 200.00}},
        {!"Frederick Bridge",             {2759.20, 296.50, 0.00, 2774.20, 594.70, 200.00}},
        {!"Gant Bridge",                  {-2741.40, 1659.60, -6.10, -2616.40, 2175.10, 200.00}},
        {!"Gant Bridge",                  {-2741.00, 1490.40, -6.10, -2616.40, 1659.60, 200.00}},
        {!"Ganton",                       {2222.50, -1852.80, -89.00, 2632.80, -1722.30, 110.90}},
        {!"Ganton",                       {2222.50, -1722.30, -89.00, 2632.80, -1628.50, 110.90}},
        {!"Garcia",                       {-2411.20, -222.50, -0.00, -2173.00, 265.20, 200.00}},
        {!"Garcia",                       {-2395.10, -222.50, -5.30, -2354.00, -204.70, 200.00}},
        {!"Garver Bridge",                {-1339.80, 828.10, -89.00, -1213.90, 1057.00, 110.90}},
        {!"Garver Bridge",                {-1213.90, 950.00, -89.00, -1087.90, 1178.90, 110.90}},
        {!"Garver Bridge",                {-1499.80, 696.40, -179.60, -1339.80, 925.30, 20.30}},
        {!"Glen Park",                    {1812.60, -1449.60, -89.00, 1996.90, -1350.70, 110.90}},
        {!"Glen Park",                    {1812.60, -1100.80, -89.00, 1994.30, -973.30, 110.90}},
        {!"Glen Park",                    {1812.60, -1350.70, -89.00, 2056.80, -1100.80, 110.90}},
        {!"Green Palms",                  {176.50, 1305.40, -3.00, 338.60, 1520.70, 200.00}},
        {!"Greenglass College",           {964.30, 1044.60, -89.00, 1197.30, 1203.20, 110.90}},
        {!"Greenglass College",           {964.30, 930.80, -89.00, 1166.50, 1044.60, 110.90}},
        {!"Hampton Barns",                {603.00, 264.30, 0.00, 761.90, 366.50, 200.00}},
        {!"Hankypanky Point",             {2576.90, 62.10, 0.00, 2759.20, 385.50, 200.00}},
        {!"Harry Gold Parkway",           {1777.30, 863.20, -89.00, 1817.30, 2342.80, 110.90}},
        {!"Hashbury",                     {-2593.40, -222.50, -0.00, -2411.20, 54.70, 200.00}},
        {!"Hilltop Farm",                 {967.30, -450.30, -3.00, 1176.70, -217.90, 200.00}},
        {!"Hunter Quarry",                {337.20, 710.80, -115.20, 860.50, 1031.70, 203.70}},
        {!"Idlewood",                     {1812.60, -1852.80, -89.00, 1971.60, -1742.30, 110.90}},
        {!"Idlewood",                     {1812.60, -1742.30, -89.00, 1951.60, -1602.30, 110.90}},
        {!"Idlewood",                     {1951.60, -1742.30, -89.00, 2124.60, -1602.30, 110.90}},
        {!"Idlewood",                     {1812.60, -1602.30, -89.00, 2124.60, -1449.60, 110.90}},
        {!"Idlewood",                     {2124.60, -1742.30, -89.00, 2222.50, -1494.00, 110.90}},
        {!"Idlewood",                     {1971.60, -1852.80, -89.00, 2222.50, -1742.30, 110.90}},
        {!"Jefferson",                    {1996.90, -1449.60, -89.00, 2056.80, -1350.70, 110.90}},
        {!"Jefferson",                    {2124.60, -1494.00, -89.00, 2266.20, -1449.60, 110.90}},
        {!"Jefferson",                    {2056.80, -1372.00, -89.00, 2281.40, -1210.70, 110.90}},
        {!"Jefferson",                    {2056.80, -1210.70, -89.00, 2185.30, -1126.30, 110.90}},
        {!"Jefferson",                    {2185.30, -1210.70, -89.00, 2281.40, -1154.50, 110.90}},
        {!"Jefferson",                    {2056.80, -1449.60, -89.00, 2266.20, -1372.00, 110.90}},
        {!"Julius Thruway East",          {2623.10, 943.20, -89.00, 2749.90, 1055.90, 110.90}},
        {!"Julius Thruway East",          {2685.10, 1055.90, -89.00, 2749.90, 2626.50, 110.90}},
        {!"Julius Thruway East",          {2536.40, 2442.50, -89.00, 2685.10, 2542.50, 110.90}},
        {!"Julius Thruway East",          {2625.10, 2202.70, -89.00, 2685.10, 2442.50, 110.90}},
        {!"Julius Thruway North",         {2498.20, 2542.50, -89.00, 2685.10, 2626.50, 110.90}},
        {!"Julius Thruway North",         {2237.40, 2542.50, -89.00, 2498.20, 2663.10, 110.90}},
        {!"Julius Thruway North",         {2121.40, 2508.20, -89.00, 2237.40, 2663.10, 110.90}},
        {!"Julius Thruway North",         {1938.80, 2508.20, -89.00, 2121.40, 2624.20, 110.90}},
        {!"Julius Thruway North",         {1534.50, 2433.20, -89.00, 1848.40, 2583.20, 110.90}},
        {!"Julius Thruway North",         {1848.40, 2478.40, -89.00, 1938.80, 2553.40, 110.90}},
        {!"Julius Thruway North",         {1704.50, 2342.80, -89.00, 1848.40, 2433.20, 110.90}},
        {!"Julius Thruway North",         {1377.30, 2433.20, -89.00, 1534.50, 2507.20, 110.90}},
        {!"Julius Thruway South",         {1457.30, 823.20, -89.00, 2377.30, 863.20, 110.90}},
        {!"Julius Thruway South",         {2377.30, 788.80, -89.00, 2537.30, 897.90, 110.90}},
        {!"Julius Thruway West",          {1197.30, 1163.30, -89.00, 1236.60, 2243.20, 110.90}},
        {!"Julius Thruway West",          {1236.60, 2142.80, -89.00, 1297.40, 2243.20, 110.90}},
        {!"Juniper Hill",                 {-2533.00, 578.30, -7.60, -2274.10, 968.30, 200.00}},
        {!"Juniper Hollow",               {-2533.00, 968.30, -6.10, -2274.10, 1358.90, 200.00}},
        {!"K.A.C.C. Military Fuels",      {2498.20, 2626.50, -89.00, 2749.90, 2861.50, 110.90}},
        {!"Kincaid Bridge",               {-1339.80, 599.20, -89.00, -1213.90, 828.10, 110.90}},
        {!"Kincaid Bridge",               {-1213.90, 721.10, -89.00, -1087.90, 950.00, 110.90}},
        {!"Kincaid Bridge",               {-1087.90, 855.30, -89.00, -961.90, 986.20, 110.90}},
        {!"King's",                       {-2329.30, 458.40, -7.60, -1993.20, 578.30, 200.00}},
        {!"King's",                       {-2411.20, 265.20, -9.10, -1993.20, 373.50, 200.00}},
        {!"King's",                       {-2253.50, 373.50, -9.10, -1993.20, 458.40, 200.00}},
        {!"LVA Freight Depot",            {1457.30, 863.20, -89.00, 1777.40, 1143.20, 110.90}},
        {!"LVA Freight Depot",            {1375.60, 919.40, -89.00, 1457.30, 1203.20, 110.90}},
        {!"LVA Freight Depot",            {1277.00, 1087.60, -89.00, 1375.60, 1203.20, 110.90}},
        {!"LVA Freight Depot",            {1315.30, 1044.60, -89.00, 1375.60, 1087.60, 110.90}},
        {!"LVA Freight Depot",            {1236.60, 1163.40, -89.00, 1277.00, 1203.20, 110.90}},
        {!"Las Barrancas",                {-926.10, 1398.70, -3.00, -719.20, 1634.60, 200.00}},
        {!"Las Brujas",                   {-365.10, 2123.00, -3.00, -208.50, 2217.60, 200.00}},
        {!"Las Colinas",                  {1994.30, -1100.80, -89.00, 2056.80, -920.80, 110.90}},
        {!"Las Colinas",                  {2056.80, -1126.30, -89.00, 2126.80, -920.80, 110.90}},
        {!"Las Colinas",                  {2185.30, -1154.50, -89.00, 2281.40, -934.40, 110.90}},
        {!"Las Colinas",                  {2126.80, -1126.30, -89.00, 2185.30, -934.40, 110.90}},
        {!"Las Colinas",                  {2747.70, -1120.00, -89.00, 2959.30, -945.00, 110.90}},
        {!"Las Colinas",                  {2632.70, -1135.00, -89.00, 2747.70, -945.00, 110.90}},
        {!"Las Colinas",                  {2281.40, -1135.00, -89.00, 2632.70, -945.00, 110.90}},
        {!"Las Payasadas",                {-354.30, 2580.30, 2.00, -133.60, 2816.80, 200.00}},
        {!"Las Venturas Airport",         {1236.60, 1203.20, -89.00, 1457.30, 1883.10, 110.90}},
        {!"Las Venturas Airport",         {1457.30, 1203.20, -89.00, 1777.30, 1883.10, 110.90}},
        {!"Las Venturas Airport",         {1457.30, 1143.20, -89.00, 1777.40, 1203.20, 110.90}},
        {!"Las Venturas Airport",         {1515.80, 1586.40, -12.50, 1729.90, 1714.50, 87.50}},
        {!"Last Dime Motel",              {1823.00, 596.30, -89.00, 1997.20, 823.20, 110.90}},
        {!"Leafy Hollow",                 {-1166.90, -1856.00, 0.00, -815.60, -1602.00, 200.00}},
        {!"Liberty City",                 {-1000.00, 400.00, 1300.00, -700.00, 600.00, 1400.00}},
        {!"Lil' Probe Inn",               {-90.20, 1286.80, -3.00, 153.80, 1554.10, 200.00}},
        {!"Linden Side",                  {2749.90, 943.20, -89.00, 2923.30, 1198.90, 110.90}},
        {!"Linden Station",               {2749.90, 1198.90, -89.00, 2923.30, 1548.90, 110.90}},
        {!"Linden Station",               {2811.20, 1229.50, -39.50, 2861.20, 1407.50, 60.40}},
        {!"Little Mexico",                {1701.90, -1842.20, -89.00, 1812.60, -1722.20, 110.90}},
        {!"Little Mexico",                {1758.90, -1722.20, -89.00, 1812.60, -1577.50, 110.90}},
        {!"Los Flores",                   {2581.70, -1454.30, -89.00, 2632.80, -1393.40, 110.90}},
        {!"Los Flores",                   {2581.70, -1393.40, -89.00, 2747.70, -1135.00, 110.90}},
        {!"Los Santos International",     {1249.60, -2394.30, -89.00, 1852.00, -2179.20, 110.90}},
        {!"Los Santos International",     {1852.00, -2394.30, -89.00, 2089.00, -2179.20, 110.90}},
        {!"Los Santos International",     {1382.70, -2730.80, -89.00, 2201.80, -2394.30, 110.90}},
        {!"Los Santos International",     {1974.60, -2394.30, -39.00, 2089.00, -2256.50, 60.90}},
        {!"Los Santos International",     {1400.90, -2669.20, -39.00, 2189.80, -2597.20, 60.90}},
        {!"Los Santos International",     {2051.60, -2597.20, -39.00, 2152.40, -2394.30, 60.90}},
        {!"Marina",                       {647.70, -1804.20, -89.00, 851.40, -1577.50, 110.90}},
        {!"Marina",                       {647.70, -1577.50, -89.00, 807.90, -1416.20, 110.90}},
        {!"Marina",                       {807.90, -1577.50, -89.00, 926.90, -1416.20, 110.90}},
        {!"Market",                       {787.40, -1416.20, -89.00, 1072.60, -1310.20, 110.90}},
        {!"Market",                       {952.60, -1310.20, -89.00, 1072.60, -1130.80, 110.90}},
        {!"Market",                       {1072.60, -1416.20, -89.00, 1370.80, -1130.80, 110.90}},
        {!"Market",                       {926.90, -1577.50, -89.00, 1370.80, -1416.20, 110.90}},
        {!"Market Station",               {787.40, -1410.90, -34.10, 866.00, -1310.20, 65.80}},
        {!"Martin Bridge",                {-222.10, 293.30, 0.00, -122.10, 476.40, 200.00}},
        {!"Missionary Hill",              {-2994.40, -811.20, 0.00, -2178.60, -430.20, 200.00}},
        {!"Montgomery",                   {1119.50, 119.50, -3.00, 1451.40, 493.30, 200.00}},
        {!"Montgomery",                   {1451.40, 347.40, -6.10, 1582.40, 420.80, 200.00}},
        {!"Montgomery Intersection",      {1546.60, 208.10, 0.00, 1745.80, 347.40, 200.00}},
        {!"Montgomery Intersection",      {1582.40, 347.40, 0.00, 1664.60, 401.70, 200.00}},
        {!"Mulholland",                   {1414.00, -768.00, -89.00, 1667.60, -452.40, 110.90}},
        {!"Mulholland",                   {1281.10, -452.40, -89.00, 1641.10, -290.90, 110.90}},
        {!"Mulholland",                   {1269.10, -768.00, -89.00, 1414.00, -452.40, 110.90}},
        {!"Mulholland",                   {1357.00, -926.90, -89.00, 1463.90, -768.00, 110.90}},
        {!"Mulholland",                   {1318.10, -910.10, -89.00, 1357.00, -768.00, 110.90}},
        {!"Mulholland",                   {1169.10, -910.10, -89.00, 1318.10, -768.00, 110.90}},
        {!"Mulholland",                   {768.60, -954.60, -89.00, 952.60, -860.60, 110.90}},
        {!"Mulholland",                   {687.80, -860.60, -89.00, 911.80, -768.00, 110.90}},
        {!"Mulholland",                   {737.50, -768.00, -89.00, 1142.20, -674.80, 110.90}},
        {!"Mulholland",                   {1096.40, -910.10, -89.00, 1169.10, -768.00, 110.90}},
        {!"Mulholland",                   {952.60, -937.10, -89.00, 1096.40, -860.60, 110.90}},
        {!"Mulholland",                   {911.80, -860.60, -89.00, 1096.40, -768.00, 110.90}},
        {!"Mulholland",                   {861.00, -674.80, -89.00, 1156.50, -600.80, 110.90}},
        {!"Mulholland Intersection",      {1463.90, -1150.80, -89.00, 1812.60, -768.00, 110.90}},
        {!"North Rock",                   {2285.30, -768.00, 0.00, 2770.50, -269.70, 200.00}},
        {!"Ocean Docks",                  {2373.70, -2697.00, -89.00, 2809.20, -2330.40, 110.90}},
        {!"Ocean Docks",                  {2201.80, -2418.30, -89.00, 2324.00, -2095.00, 110.90}},
        {!"Ocean Docks",                  {2324.00, -2302.30, -89.00, 2703.50, -2145.10, 110.90}},
        {!"Ocean Docks",                  {2089.00, -2394.30, -89.00, 2201.80, -2235.80, 110.90}},
        {!"Ocean Docks",                  {2201.80, -2730.80, -89.00, 2324.00, -2418.30, 110.90}},
        {!"Ocean Docks",                  {2703.50, -2302.30, -89.00, 2959.30, -2126.90, 110.90}},
        {!"Ocean Docks",                  {2324.00, -2145.10, -89.00, 2703.50, -2059.20, 110.90}},
        {!"Ocean Flats",                  {-2994.40, 277.40, -9.10, -2867.80, 458.40, 200.00}},
        {!"Ocean Flats",                  {-2994.40, -222.50, -0.00, -2593.40, 277.40, 200.00}},
        {!"Ocean Flats",                  {-2994.40, -430.20, -0.00, -2831.80, -222.50, 200.00}},
        {!"Octane Springs",               {338.60, 1228.50, 0.00, 664.30, 1655.00, 200.00}},
        {!"Old Venturas Strip",           {2162.30, 2012.10, -89.00, 2685.10, 2202.70, 110.90}},
        {!"Palisades",                    {-2994.40, 458.40, -6.10, -2741.00, 1339.60, 200.00}},
        {!"Palomino Creek",               {2160.20, -149.00, 0.00, 2576.90, 228.30, 200.00}},
        {!"Paradiso",                     {-2741.00, 793.40, -6.10, -2533.00, 1268.40, 200.00}},
        {!"Pershing Square",              {1440.90, -1722.20, -89.00, 1583.50, -1577.50, 110.90}},
        {!"Pilgrim",                      {2437.30, 1383.20, -89.00, 2624.40, 1783.20, 110.90}},
        {!"Pilgrim",                      {2624.40, 1383.20, -89.00, 2685.10, 1783.20, 110.90}},
        {!"Pilson Intersection",          {1098.30, 2243.20, -89.00, 1377.30, 2507.20, 110.90}},
        {!"Pirates in Men's Pants",       {1817.30, 1469.20, -89.00, 2027.40, 1703.20, 110.90}},
        {!"Playa del Seville",            {2703.50, -2126.90, -89.00, 2959.30, -1852.80, 110.90}},
        {!"Prickle Pine",                 {1534.50, 2583.20, -89.00, 1848.40, 2863.20, 110.90}},
        {!"Prickle Pine",                 {1117.40, 2507.20, -89.00, 1534.50, 2723.20, 110.90}},
        {!"Prickle Pine",                 {1848.40, 2553.40, -89.00, 1938.80, 2863.20, 110.90}},
        {!"Prickle Pine",                 {1938.80, 2624.20, -89.00, 2121.40, 2861.50, 110.90}},
        {!"Queens",                       {-2533.00, 458.40, 0.00, -2329.30, 578.30, 200.00}},
        {!"Queens",                       {-2593.40, 54.70, 0.00, -2411.20, 458.40, 200.00}},
        {!"Queens",                       {-2411.20, 373.50, 0.00, -2253.50, 458.40, 200.00}},
        {!"Randolph Industrial Estate",   {1558.00, 596.30, -89.00, 1823.00, 823.20, 110.90}},
        {!"Redsands East",                {1817.30, 2011.80, -89.00, 2106.70, 2202.70, 110.90}},
        {!"Redsands East",                {1817.30, 2202.70, -89.00, 2011.90, 2342.80, 110.90}},
        {!"Redsands East",                {1848.40, 2342.80, -89.00, 2011.90, 2478.40, 110.90}},
        {!"Redsands West",                {1236.60, 1883.10, -89.00, 1777.30, 2142.80, 110.90}},
        {!"Redsands West",                {1297.40, 2142.80, -89.00, 1777.30, 2243.20, 110.90}},
        {!"Redsands West",                {1377.30, 2243.20, -89.00, 1704.50, 2433.20, 110.90}},
        {!"Redsands West",                {1704.50, 2243.20, -89.00, 1777.30, 2342.80, 110.90}},
        {!"Regular Tom",                  {-405.70, 1712.80, -3.00, -276.70, 1892.70, 200.00}},
        {!"Richman",                      {647.50, -1118.20, -89.00, 787.40, -954.60, 110.90}},
        {!"Richman",                      {647.50, -954.60, -89.00, 768.60, -860.60, 110.90}},
        {!"Richman",                      {225.10, -1369.60, -89.00, 334.50, -1292.00, 110.90}},
        {!"Richman",                      {225.10, -1292.00, -89.00, 466.20, -1235.00, 110.90}},
        {!"Richman",                      {72.60, -1404.90, -89.00, 225.10, -1235.00, 110.90}},
        {!"Richman",                      {72.60, -1235.00, -89.00, 321.30, -1008.10, 110.90}},
        {!"Richman",                      {321.30, -1235.00, -89.00, 647.50, -1044.00, 110.90}},
        {!"Richman",                      {321.30, -1044.00, -89.00, 647.50, -860.60, 110.90}},
        {!"Richman",                      {321.30, -860.60, -89.00, 687.80, -768.00, 110.90}},
        {!"Richman",                      {321.30, -768.00, -89.00, 700.70, -674.80, 110.90}},
        {!"Robada Intersection",          {-1119.00, 1178.90, -89.00, -862.00, 1351.40, 110.90}},
        {!"Roca Escalante",               {2237.40, 2202.70, -89.00, 2536.40, 2542.50, 110.90}},
        {!"Roca Escalante",               {2536.40, 2202.70, -89.00, 2625.10, 2442.50, 110.90}},
        {!"Rockshore East",               {2537.30, 676.50, -89.00, 2902.30, 943.20, 110.90}},
        {!"Rockshore West",               {1997.20, 596.30, -89.00, 2377.30, 823.20, 110.90}},
        {!"Rockshore West",               {2377.30, 596.30, -89.00, 2537.30, 788.80, 110.90}},
        {!"Rodeo",                        {72.60, -1684.60, -89.00, 225.10, -1544.10, 110.90}},
        {!"Rodeo",                        {72.60, -1544.10, -89.00, 225.10, -1404.90, 110.90}},
        {!"Rodeo",                        {225.10, -1684.60, -89.00, 312.80, -1501.90, 110.90}},
        {!"Rodeo",                        {225.10, -1501.90, -89.00, 334.50, -1369.60, 110.90}},
        {!"Rodeo",                        {334.50, -1501.90, -89.00, 422.60, -1406.00, 110.90}},
        {!"Rodeo",                        {312.80, -1684.60, -89.00, 422.60, -1501.90, 110.90}},
        {!"Rodeo",                        {422.60, -1684.60, -89.00, 558.00, -1570.20, 110.90}},
        {!"Rodeo",                        {558.00, -1684.60, -89.00, 647.50, -1384.90, 110.90}},
        {!"Rodeo",                        {466.20, -1570.20, -89.00, 558.00, -1385.00, 110.90}},
        {!"Rodeo",                        {422.60, -1570.20, -89.00, 466.20, -1406.00, 110.90}},
        {!"Rodeo",                        {466.20, -1385.00, -89.00, 647.50, -1235.00, 110.90}},
        {!"Rodeo",                        {334.50, -1406.00, -89.00, 466.20, -1292.00, 110.90}},
        {!"Royal Casino",                 {2087.30, 1383.20, -89.00, 2437.30, 1543.20, 110.90}},
        {!"San Andreas Sound",            {2450.30, 385.50, -100.00, 2759.20, 562.30, 200.00}},
        {!"Santa Flora",                  {-2741.00, 458.40, -7.60, -2533.00, 793.40, 200.00}},
        {!"Santa Maria Beach",            {342.60, -2173.20, -89.00, 647.70, -1684.60, 110.90}},
        {!"Santa Maria Beach",            {72.60, -2173.20, -89.00, 342.60, -1684.60, 110.90}},
        {!"Shady Cabin",                  {-1632.80, -2263.40, -3.00, -1601.30, -2231.70, 200.00}},
        {!"Shady Creeks",                 {-1820.60, -2643.60, -8.00, -1226.70, -1771.60, 200.00}},
        {!"Shady Creeks",                 {-2030.10, -2174.80, -6.10, -1820.60, -1771.60, 200.00}},
        {!"Sobell Rail Yards",            {2749.90, 1548.90, -89.00, 2923.30, 1937.20, 110.90}},
        {!"Spinybed",                     {2121.40, 2663.10, -89.00, 2498.20, 2861.50, 110.90}},
        {!"Starfish Casino",              {2437.30, 1783.20, -89.00, 2685.10, 2012.10, 110.90}},
        {!"Starfish Casino",              {2437.30, 1858.10, -39.00, 2495.00, 1970.80, 60.90}},
        {!"Starfish Casino",              {2162.30, 1883.20, -89.00, 2437.30, 2012.10, 110.90}},
        {!"Temple",                       {1252.30, -1130.80, -89.00, 1378.30, -1026.30, 110.90}},
        {!"Temple",                       {1252.30, -1026.30, -89.00, 1391.00, -926.90, 110.90}},
        {!"Temple",                       {1252.30, -926.90, -89.00, 1357.00, -910.10, 110.90}},
        {!"Temple",                       {952.60, -1130.80, -89.00, 1096.40, -937.10, 110.90}},
        {!"Temple",                       {1096.40, -1130.80, -89.00, 1252.30, -1026.30, 110.90}},
        {!"Temple",                       {1096.40, -1026.30, -89.00, 1252.30, -910.10, 110.90}},
        {!"The Camel's Toe",              {2087.30, 1203.20, -89.00, 2640.40, 1383.20, 110.90}},
        {!"The Clown's Pocket",           {2162.30, 1783.20, -89.00, 2437.30, 1883.20, 110.90}},
        {!"The Emerald Isle",             {2011.90, 2202.70, -89.00, 2237.40, 2508.20, 110.90}},
        {!"The Farm",                     {-1209.60, -1317.10, 114.90, -908.10, -787.30, 251.90}},
        {!"The Four Dragons Casino",      {1817.30, 863.20, -89.00, 2027.30, 1083.20, 110.90}},
        {!"The High Roller",              {1817.30, 1283.20, -89.00, 2027.30, 1469.20, 110.90}},
        {!"The Mako Span",                {1664.60, 401.70, 0.00, 1785.10, 567.20, 200.00}},
        {!"The Panopticon",               {-947.90, -304.30, -1.10, -319.60, 327.00, 200.00}},
        {!"The Pink Swan",                {1817.30, 1083.20, -89.00, 2027.30, 1283.20, 110.90}},
        {!"The Sherman Dam",              {-968.70, 1929.40, -3.00, -481.10, 2155.20, 200.00}},
        {!"The Strip",                    {2027.40, 863.20, -89.00, 2087.30, 1703.20, 110.90}},
        {!"The Strip",                    {2106.70, 1863.20, -89.00, 2162.30, 2202.70, 110.90}},
        {!"The Strip",                    {2027.40, 1783.20, -89.00, 2162.30, 1863.20, 110.90}},
        {!"The Strip",                    {2027.40, 1703.20, -89.00, 2137.40, 1783.20, 110.90}},
        {!"The Visage",                   {1817.30, 1863.20, -89.00, 2106.70, 2011.80, 110.90}},
        {!"The Visage",                   {1817.30, 1703.20, -89.00, 2027.40, 1863.20, 110.90}},
        {!"Unity Station",                {1692.60, -1971.80, -20.40, 1812.60, -1932.80, 79.50}},
        {!"Valle Ocultado",               {-936.60, 2611.40, 2.00, -715.90, 2847.90, 200.00}},
        {!"Verdant Bluffs",               {930.20, -2488.40, -89.00, 1249.60, -2006.70, 110.90}},
        {!"Verdant Bluffs",               {1073.20, -2006.70, -89.00, 1249.60, -1842.20, 110.90}},
        {!"Verdant Bluffs",               {1249.60, -2179.20, -89.00, 1692.60, -1842.20, 110.90}},
        {!"Verdant Meadows",              {37.00, 2337.10, -3.00, 435.90, 2677.90, 200.00}},
        {!"Verona Beach",                 {647.70, -2173.20, -89.00, 930.20, -1804.20, 110.90}},
        {!"Verona Beach",                 {930.20, -2006.70, -89.00, 1073.20, -1804.20, 110.90}},
        {!"Verona Beach",                 {851.40, -1804.20, -89.00, 1046.10, -1577.50, 110.90}},
        {!"Verona Beach",                 {1161.50, -1722.20, -89.00, 1323.90, -1577.50, 110.90}},
        {!"Verona Beach",                 {1046.10, -1722.20, -89.00, 1161.50, -1577.50, 110.90}},
        {!"Vinewood",                     {787.40, -1310.20, -89.00, 952.60, -1130.80, 110.90}},
        {!"Vinewood",                     {787.40, -1130.80, -89.00, 952.60, -954.60, 110.90}},
        {!"Vinewood",                     {647.50, -1227.20, -89.00, 787.40, -1118.20, 110.90}},
        {!"Vinewood",                     {647.70, -1416.20, -89.00, 787.40, -1227.20, 110.90}},
        {!"Whitewood Estates",            {883.30, 1726.20, -89.00, 1098.30, 2507.20, 110.90}},
        {!"Whitewood Estates",            {1098.30, 1726.20, -89.00, 1197.30, 2243.20, 110.90}},
        {!"Willowfield",                  {1970.60, -2179.20, -89.00, 2089.00, -1852.80, 110.90}},
        {!"Willowfield",                  {2089.00, -2235.80, -89.00, 2201.80, -1989.90, 110.90}},
        {!"Willowfield",                  {2089.00, -1989.90, -89.00, 2324.00, -1852.80, 110.90}},
        {!"Willowfield",                  {2201.80, -2095.00, -89.00, 2324.00, -1989.90, 110.90}},
        {!"Willowfield",                  {2541.70, -1941.40, -89.00, 2703.50, -1852.80, 110.90}},
        {!"Willowfield",                  {2324.00, -2059.20, -89.00, 2541.70, -1852.80, 110.90}},
        {!"Willowfield",                  {2541.70, -2059.20, -89.00, 2703.50, -1941.40, 110.90}},
        {!"Yellow Bell Station",          {1377.40, 2600.40, -21.90, 1492.40, 2687.30, 78.00}},
        {!"Los Santos",                   {44.60, -2892.90, -242.90, 2997.00, -768.00, 900.00}},
        {!"Las Venturas",                 {869.40, 596.30, -242.90, 2997.00, 2993.80, 900.00}},
        {!"Bone County",                  {-480.50, 596.30, -242.90, 869.40, 2993.80, 900.00}},
        {!"Tierra Robada",                {-2997.40, 1659.60, -242.90, -480.50, 2993.80, 900.00}},
        {!"Tierra Robada",                {-1213.90, 596.30, -242.90, -480.50, 1659.60, 900.00}},
        {!"San Fierro",                   {-2997.40, -1115.50, -242.90, -1213.90, 1659.60, 900.00}},
        {!"Red County",                   {-1213.90, -768.00, -242.90, 2997.00, 596.30, 900.00}},
        {!"Flint County",                 {-1213.90, -2892.90, -242.90, 44.60, -768.00, 900.00}},
        {!"Whetstone",                    {-2997.40, -2892.90, -242.90, -1213.90, -1115.50, 900.00}}
    };
    new
        name[32] = "San Andreas";

    for (new i = 0; i != sizeof(g_arrZoneData); i ++) if((fX >= g_arrZoneData[i][e_ZoneArea][0] && fX <= g_arrZoneData[i][e_ZoneArea][3]) && (fY >= g_arrZoneData[i][e_ZoneArea][1] && fY <= g_arrZoneData[i][e_ZoneArea][4]) && (fZ >= g_arrZoneData[i][e_ZoneArea][2] && fZ <= g_arrZoneData[i][e_ZoneArea][5])) {
        strunpack(name, g_arrZoneData[i][e_ZoneName]);

        break;
    }
    return name;
}

ReturnName(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));

	if(pData[playerid][pMaskOn] == 1 && pData[playerid][pAdminDuty] == 0)
        format(name, sizeof(name), "Mask_#%d", pData[playerid][pMaskID]);

	for(new i = 0, l = strlen(name); i < l; i ++)
	{
	    if(name[i] == '_')
	    {
	        name[i] = ' ';
		}
	}

	return name;
}

//Format Money
FormatMoney(cCash)
{
    new szStr[18], dollar[40];
    format(szStr, sizeof(szStr), "%i", cCash);

    for(new iLen = strlen(szStr) - 3; iLen > 0; iLen -= 3)
    {
        strins(szStr, ",", iLen);
    }
	format(dollar, sizeof(dollar), "$%s", szStr);
    return dollar;
}

RandomEx(min, max)
{
    return random(max - min) + min;
}

IsNumeric(const str[])
{
    for (new i = 0, l = strlen(str); i != l; i ++)
    {
        if(i == 0 && str[0] == '-')
            continue;

        else if(str[i] < '0' || str[i] > '9')
            return 0;
    }
    return 1;
}

//Date and Time
GetMonth(bulan)
{
    static
        month[12];

    switch (bulan) {
        case 1: month = "January";
        case 2: month = "February";
        case 3: month = "March";
        case 4: month = "April";
        case 5: month = "May";
        case 6: month = "June";
        case 7: month = "July";
        case 8: month = "August";
        case 9: month = "September";
        case 10: month = "October";
        case 11: month = "November";
        case 12: month = "December";
    }
    return month;
}

ReturnTime()
{
    static
        date[6],
        string[72];

    getdate(date[2], date[1], date[0]);
    gettime(date[3], date[4], date[5]);

    format(string, sizeof(string), "%02d %s %d, %02d:%02d:%02d", date[0],GetMonth(date[1]), date[2], date[3], date[4], date[5]);
    return string;
}

ClearChat(playerid)
{
	for(new i = 0; i < 29; i ++)
	{
	    SendClientMessage(playerid, -1, " ");
	}
}

ClearAllChat(playerid)
{
	for(new i = 0; i < 65; i ++)
	{
	    SendClientMessage(playerid, -1, " ");
	}
}

GetRPName(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));

	for(new i = 0, l = strlen(name); i < l; i ++)
	{
	    if(name[i] == '_')
	    {
	        name[i] = ' ';
		}
	}

	return name;
}

//Log Server YSI
function LogServer(type[], const text[], {Float,_}:...)
{
	new entry[256],days, months, years, hours, minutes, seconds;

	getdate(years, months, days);
	gettime(hours, minutes, seconds);

	format(entry, sizeof(entry), "[%02d/%02d/%02d - %02d:%02d:%02d] - %s\r\n",
	days, months, years, hours, minutes, seconds, text);

	new File:hFile, tipe[50];
	format(tipe, sizeof(tipe), "Logs/%s.txt", type);
	hFile = fopen((tipe), io_append);
	fwrite(hFile, entry);
	fclose(hFile);
	return 0;
}