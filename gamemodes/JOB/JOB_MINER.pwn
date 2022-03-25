//319.94, 874.77, 20.39
//336.70, 895.54, 20.40 > gas oil
// 315.07, 926.53, 20.46 > component
//293.73, 913.17, 20.40 > sell ore
CreateJoinMinerPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, 319.94, 874.77, 20.39, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[MINER JOBS]\n{ffffff}Jadilah Pekerja Miner disini\n{7fffd4}/getjob /accept job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 319.94, 874.77, 20.39, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Miner
}

RGBAToARGB(rgba)
    return rgba >>> 8 | rgba << 24;

#define GetVehicleBoot(%0,%1,%2,%3)				GetVehicleOffset((%0),VEHICLE_OFFSET_BOOT,(%1),(%2),(%3))

enum OffsetTypes {
	VEHICLE_OFFSET_BOOT,
	VEHICLE_OFFSET_HOOD,
	VEHICLE_OFFSET_ROOF
};

enum VehicleProperties {
	e_VEHICLE_PAINTJOB,
	e_VEHICLE_INTERIOR,
	e_VEHICLE_COLOR_1,
	e_VEHICLE_COLOR_2,
	e_VEHICLE_HORN,
	e_VEHICLE_SPAWN_X,
	e_VEHICLE_SPAWN_Y,
	e_VEHICLE_SPAWN_Z,
	e_VEHICLE_SPAWN_A,
	e_VEHICLE_SPAWN_VW,
	e_VEHICLE_SPAWN_INT,
	e_VEHICLE_SPEED_CAP,
	e_VEHICLE_FUEL_USE,
	e_VEHICLE_FUEL,
	e_VEHICLE_STICKY,
	e_VEHICLE_UNO_DAMAGE,
	e_VEHICLE_CAP_DAMAGE,
	e_VEHICLE_EDITOR,
	e_VEHICLE_DAMAGE_PANELS,
	e_VEHICLE_DAMAGE_DOORS,
	e_VEHICLE_DAMAGE_LIGHTS,
	e_VEHICLE_DAMAGE_TIRES,
	e_VEHICLE_BOMB,
	e_VEHICLE_BOMB_TIMER
};

GetVehicleOffset(vehicleid, OffsetTypes:type,&Float:x,&Float:y,&Float:z)
{
	new Float:fPos[4],Float:fSize[3];

	if(!IsValidVehicle(vehicleid)){
		x = y =	z = 0.0;
		return 0;
	} else {
		GetVehiclePos(vehicleid,fPos[0],fPos[1],fPos[2]);
		GetVehicleZAngle(vehicleid,fPos[3]);
		GetVehicleModelInfo(GetVehicleModel(vehicleid),VEHICLE_MODEL_INFO_SIZE,fSize[0],fSize[1],fSize[2]);

		switch(type){
			case VEHICLE_OFFSET_BOOT: {
				x = fPos[0] - (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3],degrees));
				y = fPos[1] - (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3],degrees));
 				z = fPos[2];
			}
			case VEHICLE_OFFSET_HOOD: {
				x = fPos[0] + (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3],degrees));
				y = fPos[1] + (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3],degrees));
	 			z = fPos[2];
			}
			case VEHICLE_OFFSET_ROOF: {
				x = fPos[0];
				y = fPos[1];
				z = fPos[2] + floatsqroot(fSize[2]);
			}
		}
	}
	return 1;
}

#define MAX_ORES 100
#define ORE_RESPAWN 1200

enum    E_ORE
{
	// loaded from db
	oreType,
	Float: oreX,
	Float: oreY,
	Float: oreZ,
	Float: oreRX,
	Float: oreRY,
	Float: oreRZ,
	// temp
	oreLog,
	oreSeconds,
	bool: oreGettingMiner,
	oreObjID,
	Text3D: oreLabel,
	oreTime,
	oreTimeStatus
}

new OreData[MAX_ORES][E_ORE],
	Iterator:Ores<MAX_ORES>;
	
GetClosestOre(playerid, Float: range = 2.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : Ores)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, OreData[i][oreX], OreData[i][oreY], OreData[i][oreZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}

Player_ResetMining(playerid)
{
	if(!IsPlayerConnected(playerid) || pData[playerid][MiningOreID] == -1) return 0;
	new id = pData[playerid][MiningOreID];
	OreData[id][oreGettingMiner] = false;
	if(OreData[id][oreSeconds] < 1) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[id][oreLabel], E_STREAMER_COLOR, 0x2ECC71FF);
	Ore_Refresh(id);
	ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 1);
    pData[playerid][MiningOreID] = -1;
    
    if(pData[playerid][pActivity] != -1)
	{
	    KillTimer(pData[playerid][pActivity]);
		pData[playerid][pActivity] = -1;
		pData[playerid][pActivityTime] = 0;
	}
	PlayerTextDrawHide(playerid, ActiveTD[playerid]);
	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
	return 1;
}

Player_RemoveLog(playerid)
{
	if(!IsPlayerConnected(playerid) || pData[playerid][CarryingLog] == -1) return 0;
	RemovePlayerAttachedObject(playerid, 9);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	pData[playerid][CarryingLog] = -1;
	
	if(pData[playerid][LoadingPoint] != -1)
	{
	    DestroyDynamicCP(pData[playerid][LoadingPoint]);
	    pData[playerid][LoadingPoint] = -1;
	}
	return 1;
}

function MiningOre(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pActivityStatus] != 1) return 0;
    if(pData[playerid][MiningOreID] != -1)
	{
		new tid = pData[playerid][MiningOreID];
		
		if(pData[playerid][pActivityTime] >= 100 && pData[playerid][MiningOreID] != -1)
		{
			OreData[tid][oreLog] -= 1;
			Player_GiveLog(playerid, OreData[tid][oreType]);
			OreData[tid][oreSeconds] = ORE_RESPAWN;
			Player_ResetMining(playerid);
			Ore_Refresh(tid);
			
			InfoTD_MSG(playerid, 8000, "Mining ore done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityStatus] = 0;
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pEnergy] -= 3;
			ClearAnimations(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
			ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 1, 0, 0, 1, 0, 1);
		}
	}
	return 1;
}

GetClosestLog(playerid, Float: range = 3.0)
{
	new id = -1, Float: dist = range, Float: tempdist, Float: pos[3];
	for(new i; i < MAX_ORES; i++)
	{
	    if(!LogData[i][logExist]) continue;
	    GetDynamicObjectPos(LogData[i][logObjID], pos[0], pos[1], pos[2]);
	    tempdist = GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}

	return id;
}

Vehicle_LogCount(vehicleid)
{
	//if(!IsValidVehicle(vehicleid)) return -1;
	new count = 0;
	for(new i; i < 2; i++) count += LogStorage[vehicleid][i];
	return count;
}

Player_GiveLog(playerid, type)
{
    if(!IsPlayerConnected(playerid)) return 0;
	pData[playerid][CarryingLog] = type;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 9, 2936, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35, RGBAToARGB(0xB87333FF));
	
	SetPVarInt(playerid, "LoadingCooldown", gettime() + 0);
	
	new Float: x, Float: y, Float: z;
    GetVehicleBoot(GetPVarInt(playerid, "LastVehicleID"), x, y, z);
    //pData[playerid][LoadingPoint] = CreateDynamicCP(x, y, z, 3.0, -1, -1, playerid, 10.0);
	SetPlayerCheckpoint(playerid, x , y, z, 3.0);
	Info(playerid, "You can press "GREEN_E"N "WHITE_E"to drop your log.");
	return 1;
}

Ore_FindFreeID()
{
	new id = -1;
	for(new i; i < MAX_ORES; i++)
	{
	    if(!LogData[i][logObjID])
	    {
	        id = i;
	        break;
	    }
	}
	return id;
}

Player_DropLog(playerid, type, death_drop = 0)
{
    if(!IsPlayerConnected(playerid) || pData[playerid][CarryingLog] == -1) return 0;
	new id = Ore_FindFreeID();
    if(id != -1)
    {
        new Float: x, Float: y, Float: z, Float: a, label[128];
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        GetPlayerName(playerid, LogData[id][logDroppedBy], MAX_PLAYER_NAME);

		if(!death_drop)
		{
		    x += (1.0 * floatsin(-a, degrees));
			y += (1.0 * floatcos(-a, degrees));
			
			ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		}
		new typename[64];
		if(type == 0)
		{
			typename = "Metal";
		}
		else if(type == 1)
		{
			typename = "Coal";
		}
		else
		{
			typename = "Unknown";
		}
		LogData[id][logExist] = true;
		LogData[id][logType] = type;
		LogData[id][logSeconds] = LOG_LIFETIME;
		LogData[id][logObjID] = CreateDynamicObject(3929, x, y, z - 0.65, 0.0, 0.0, random(360));
	  	SetDynamicObjectMaterial(LogData[id][logObjID], 0, 2936, "kmb_rckx", "larock256", RGBAToARGB(0xB87333FF));
		format(label, sizeof(label), "Log (%d - %s)\n"WHITE_E"Dropped By "GREEN_E"%s\n"WHITE_E"%s\nUse /ore pickup.", id, typename, LogData[id][logDroppedBy], ConvertToMinutes(LOG_LIFETIME));
		LogData[id][logLabel] = CreateDynamic3DTextLabel(label, COLOR_GREEN, x, y, z, 5.0, .testlos = 1);
		
		LogData[id][logTimer] = SetTimerEx("RemoveLog", 1000, true, "i", id);
    }
    
    Player_RemoveLog(playerid);
	return 1;
}

function RemoveLog(tid)
{	
	if(LogData[tid][logSeconds] > 1) 
	{
		new typename[64];
		if(LogData[tid][logType] == 0)
		{
			typename = "Metal";
		}
		else if(LogData[tid][logType] == 1)
		{
			typename = "Coal";
		}
		else
		{
			typename = "Unknown";
		}
	    LogData[tid][logSeconds]--;

        new label[128];
	    format(label, sizeof(label), "Log (%d - %s)\n"WHITE_E"Dropped By "GREEN_E"%s\n"WHITE_E"%s\nUse /ore pickup.", tid, typename, LogData[tid][logDroppedBy], ConvertToMinutes(LogData[tid][logSeconds]));
		UpdateDynamic3DTextLabelText(LogData[tid][logLabel], COLOR_GREEN, label);
	}
	else if(LogData[tid][logSeconds] == 1) 
	{
	    KillTimer(LogData[tid][logTimer]);
	    DestroyDynamicObject(LogData[tid][logObjID]);
		DestroyDynamic3DTextLabel(LogData[tid][logLabel]);
		
	    LogData[tid][logTimer] = -1;
        LogData[tid][logObjID] = -1;
        LogData[tid][logLabel] = Text3D: -1;
		LogData[tid][logExist] = false;
	}
	
	return 1;
}

function RespawnOres(id)
{
	new label[96], type[64];
	if(OreData[id][oreType] == 0)
	{
		type = "Metal";
	}
	else if(OreData[id][oreType] == 1)
	{
		type = "Coal";
	}
	else
	{
		type = "Unknown";
	}
	if(OreData[id][oreSeconds] > 1) 
	{
	    OreData[id][oreSeconds]--;
	    
	    format(label, sizeof(label), "Ore (%d - %s)\n{FFFFFF}%s", id, type, ConvertToMinutes(OreData[id][oreSeconds]));
		UpdateDynamic3DTextLabelText(OreData[id][oreLabel], COLOR_GREEN, label);
	}
	else if(OreData[id][oreSeconds] <= 1) 
	{
	    KillTimer(OreData[id][oreTime]);
		OreData[id][oreTimeStatus] = 0;

	    OreData[id][oreLog] = 5;
	    OreData[id][oreSeconds] = 0;
	    OreData[id][oreTime] = -1;
	    
	    SetDynamicObjectPos(OreData[id][oreObjID], OreData[id][oreX], OreData[id][oreY], OreData[id][oreZ]);
     	SetDynamicObjectRot(OreData[id][oreObjID], OreData[id][oreRX], OreData[id][oreRY], OreData[id][oreRZ]);
     	
     	format(label, sizeof(label), "Ore (%d - %s)\n", id, type);
     	UpdateDynamic3DTextLabelText(OreData[id][oreLabel], COLOR_GREEN, label);
	}
	return 1;
}

function LoadOres()
{
    new tid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", tid);
			cache_get_value_name_int(i, "type", OreData[tid][oreType]);
			cache_get_value_name_float(i, "posx", OreData[tid][oreX]);
			cache_get_value_name_float(i, "posy", OreData[tid][oreY]);
			cache_get_value_name_float(i, "posz", OreData[tid][oreZ]);
			cache_get_value_name_float(i, "posrx", OreData[tid][oreRX]);
			cache_get_value_name_float(i, "posry", OreData[tid][oreRY]);
			cache_get_value_name_float(i, "posrz", OreData[tid][oreRZ]);
			
			new label[64], type[64];
			if(OreData[tid][oreType] == 0)
			{
				type = "Metal";
			}
			else if(OreData[tid][oreType] == 1)
			{
				type = "Coal";
			}
			else
			{
				type = "Unknown";
			}
			OreData[tid][oreGettingMiner] = false;
			OreData[tid][oreSeconds] = 0;
			OreData[tid][oreLog] = 5;
			format(label, sizeof(label), "Ore (%d - %s)\nLog: %d", tid, type, OreData[tid][oreLog]);
			OreData[tid][oreLabel] = CreateDynamic3DTextLabel(label, COLOR_GREEN, OreData[tid][oreX], OreData[tid][oreY], OreData[tid][oreZ] + 0.5, 5.0);
			OreData[tid][oreObjID] = CreateDynamicObject(867, OreData[tid][oreX], OreData[tid][oreY], OreData[tid][oreZ], OreData[tid][oreRX], OreData[tid][oreRY], OreData[tid][oreRZ]);
			SetDynamicObjectMaterial(OreData[tid][oreObjID], 0, 2936, "kmb_rckx", "larock256", RGBAToARGB(0xB87333FF));
			Iter_Add(Ores, tid);
		}
		printf("[Ore]: %d Loaded.", rows);
	}
}

Ore_Save(tid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE ores SET type='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f' WHERE id='%d'",
	OreData[tid][oreType],
	OreData[tid][oreX],
	OreData[tid][oreY],
	OreData[tid][oreZ],
	OreData[tid][oreRX],
	OreData[tid][oreRY],
	OreData[tid][oreRZ],
	tid
	);
	return mysql_tquery(g_SQL, cQuery);
}

Ore_Refresh(id)
{
    if(!Iter_Contains(Ores, id)) return 0;
	
    new label[96], type[64];
	if(OreData[id][oreType] == 0)
	{
		type = "Metal";
	}
	else if(OreData[id][oreType] == 1)
	{
		type = "Coal";
	}
	else
	{
		type = "Unknown";
	}
    
    if(OreData[id][oreLog] > 0) {
	    format(label, sizeof(label), "Ore (%d - %s)\n"WHITE_E"Ore: "GREEN_E"%d\n"WHITE_E"Use /ore mine.", id, type, OreData[id][oreLog]);
		UpdateDynamic3DTextLabelText(OreData[id][oreLabel], COLOR_GREEN, label);
	}
	else
	{
		if(OreData[id][oreTimeStatus] != 1)
		{
			OreData[id][oreTimeStatus] = 1;
			OreData[id][oreTime] = SetTimerEx("RespawnOres", 2000, true, "i", id);
	    }
	    format(label, sizeof(label), "Ore (%d - %s)\n"WHITE_E"%s", id, type, ConvertToMinutes(OreData[id][oreSeconds]));
		UpdateDynamic3DTextLabelText(OreData[id][oreLabel], COLOR_GREEN, label);
	}
	return 1;
}

Ore_BeingEdited(tid)
{
	if(!Iter_Contains(Ores, tid)) return 0;
	foreach(new i : Player) if(pData[i][EditingOreID] == tid) return 1;
	return 0;
}

CMD:createore(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	new tid = Iter_Free(Ores), query[512], type, typename[64];
	if(tid == -1) return Error(playerid, "Can't add any more ores.");
	
	if(sscanf(params, "d", type)) return Usage(playerid, "/createore [type, 0.Metal 1.Coal");
	if(type > 1 || type < 0) return Error(playerid, "ore type only id 0 and 1.");
 	new Float: x, Float: y, Float: z, Float: a;
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;
	
	if(type == 0)
	{
		typename = "Metal";
	}
	else if(type == 1)
	{
		typename = "Coal";
	}
	else
	{
		typename = "Unknown";
	}
	OreData[tid][oreType] = type;
	OreData[tid][oreLog] = 5;
	OreData[tid][oreX] = x;
	OreData[tid][oreY] = y;
	OreData[tid][oreZ] = z;
	OreData[tid][oreRX] = OreData[tid][oreRY] = OreData[tid][oreRZ] = 0.0;
	
	new label[96];
	format(label, sizeof(label), "Ore (%d - %s)\n", tid, typename);
	OreData[tid][oreLabel] = CreateDynamic3DTextLabel(label, COLOR_GREEN, OreData[tid][oreX], OreData[tid][oreY], OreData[tid][oreZ] + 0.5, 5.0);
	OreData[tid][oreObjID] = CreateDynamicObject(867, OreData[tid][oreX], OreData[tid][oreY], OreData[tid][oreZ], OreData[tid][oreRX], OreData[tid][oreRY], OreData[tid][oreRZ]);
	Iter_Add(Ores, tid);
	
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO ores SET id='%d', type='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f'", tid, type, OreData[tid][oreX], OreData[tid][oreY], OreData[tid][oreZ], OreData[tid][oreRX], OreData[tid][oreRY], OreData[tid][oreRZ]);
	mysql_tquery(g_SQL, query, "OnOreCreated", "di", playerid, tid);
	return 1;
}

function OnOreCreated(playerid, tid)
{
	Ore_Save(tid);
	
	pData[playerid][EditingOreID] = tid;
	EditDynamicObject(playerid, OreData[tid][oreObjID]);
	Servers(playerid, "Ore created.");
	Servers(playerid, "You can edit it right now, or cancel editing and edit it some other time.");
	return 1;
}

CMD:editore(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
    if(pData[playerid][EditingOreID] != -1) return Error(playerid, "You're already editing a ore.");
	new tid;
	if(sscanf(params, "i", tid)) return Usage(playerid, "/editore [id]");
	if(!Iter_Contains(Ores, tid)) return Error(playerid, "Invalid ID.");
	if(OreData[tid][oreGettingMiner]) return Error(playerid, "Can't edit specified ore because its getting miner.");
	if(!IsPlayerInRangeOfPoint(playerid, 30.0, OreData[tid][oreX], OreData[tid][oreY], OreData[tid][oreZ])) return Error(playerid, "You're not near the ore you want to edit.");
	pData[playerid][EditingOreID] = tid;
	EditDynamicObject(playerid, OreData[tid][oreObjID]);
	return 1;
}

CMD:removeore(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new tid, query[512];
	if(sscanf(params, "i", tid)) return Usage(playerid, "/removeore [id]");
	if(!Iter_Contains(Ores, tid)) return Error(playerid, "Invalid ID.");
	if(OreData[tid][oreGettingMiner]) return Error(playerid, "Can't remove specified ore because its getting cut down.");
	if(Ore_BeingEdited(tid)) return Error(playerid, "Can't remove specified ore because its being edited.");
	DestroyDynamicObject(OreData[tid][oreObjID]);
	DestroyDynamic3DTextLabel(OreData[tid][oreLabel]);
	if(OreData[tid][oreTime] != -1) KillTimer(OreData[tid][oreTime]);
	OreData[tid][oreTimeStatus] = 0;

	
	
	OreData[tid][oreLog] = OreData[tid][oreSeconds] = 0;
	OreData[tid][oreObjID] = OreData[tid][oreTime] = -1;
	OreData[tid][oreLabel] = Text3D: -1;
	Iter_Remove(Ores, tid);
	
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM ores WHERE id=%d", tid);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Ore removed.");
	return 1;
}

CMD:gotoore(playerid, params[])
{
	new tid;
	if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", tid))
		return Usage(playerid, "/gotoore [id]");
	if(!Iter_Contains(Ores, tid)) return Error(playerid, "The ore you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, OreData[tid][oreX], OreData[tid][oreY], OreData[tid][oreZ], 2.0);
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInFamily] = -1;	
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	Servers(playerid, "You has teleport to house id %d", tid);
	return 1;
}

CMD:ore(playerid, params[])
{
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
		if(isnull(params)) return Usage(playerid, "/ore [info/mine/pickup/sell]");
		
		if(!strcmp(params, "mine", true))
		{
			if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Anda harus keluar dari kendaraan.");
			new logtype = pData[playerid][CarryingLog];
			if(pData[playerid][CarryingLog] != -1) return Player_DropLog(playerid, logtype);
			
			if(GetPlayerWeapon(playerid) != WEAPON_SHOVEL) return Error(playerid, "Anda butuh skop/shovel.");
				
			if(!IsATruck(GetPVarInt(playerid, "LastVehicleID"))) return Error(playerid, "Your last vehicle isn't available for mining.");
		
			if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
				
			new tid = GetClosestOre(playerid);

			if(tid != -1)
			{
				if(!Ore_BeingEdited(tid) && !OreData[tid][oreGettingMiner])
				{
					if(OreData[tid][oreLog] < 1) return Error(playerid, "This ore log is empty.");
					new Float: x, Float: y, Float: z;
					GetVehicleBoot(GetPVarInt(playerid, "LastVehicleID"), x, y, z);
					if(GetPlayerDistanceFromPoint(playerid, x, y, z) > 60.0) return Error(playerid, "Your last vehicle is too far away.");
		
					SetPlayerLookAt(playerid, OreData[tid][oreX], OreData[tid][oreY]);

					Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[tid][oreLabel], E_STREAMER_COLOR, 0xE74C3CFF);
					pData[playerid][pActivityStatus] = 1;
					pData[playerid][pActivity] = SetTimerEx("MiningOre", 1000, true, "i", playerid);
					pData[playerid][MiningOreID] = tid;
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Mining...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					TogglePlayerControllable(playerid, 0);
					//SetPlayerAttachedObject(playerid, 9, 19631, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
					//SetPlayerArmedWeapon(playerid, 0);
					SetPlayerArmedWeapon(playerid, WEAPON_SHOVEL);
					OreData[tid][oreGettingMiner] = true;
					ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 1, 0, 0, 1, 0, 1);
				}
				else return Error(playerid, "This ore is not ready.");
			}
			else return Error(playerid, "You must near on the ore area");
		}
		else if(!strcmp(params, "pickup", true))
		{
			if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Anda harus keluar dari kendaraan.");
			// taking from ground
			if(pData[playerid][CarryingLog] != -1) return Error(playerid, "You're already carrying a log.");
			new tid = GetClosestLog(playerid);
			if(tid == -1) return Error(playerid, "You're not near a log.");
			LogData[tid][logSeconds] = 1;
			
			Player_GiveLog(playerid, LogData[tid][logType]);
			Info(playerid, "You've taken a log from ground.");
			RemoveLog(tid);
			// done
		}
		else if(!strcmp(params, "info", true))
		{
			new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
			if(!IsValidVehicle(vehicleid)) return Error(playerid, "You're not near any vehicle.");
			if(!IsATruck(vehicleid)) return Error(playerid, "Vehicle isn't a mining vehicle.");
			new string[196], title[32], type[64], harga;
			format(string, sizeof(string), "Name\tAmount\tPrice\n");
			for(new i; i < 2; i++)
			{
				if(OreData[i][oreType] == 0)
				{
					type = "Metal";
					harga = MetalPrice;
				}
				else if(OreData[i][oreType] == 1)
				{
					type = "Coal";
					harga = CoalPrice;
				}
				else
				{
					type = "Unknown";
				}
				format(string, sizeof(string), "%s%s\t%d\t{2ECC71}$%d\n", string, type, LogStorage[vehicleid][i], harga);
			}
			format(title, sizeof(title), "Loaded Ores {E74C3C}(%d/%d)", Vehicle_LogCount(vehicleid), LOG_LIMIT);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Close", "");
		}
		else if(!strcmp(params, "sell", true))
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Error(playerid, "You are not driver in ore truck.");
			new vehicleid = GetPlayerVehicleID(playerid);
			if(!IsValidVehicle(vehicleid)) return Error(playerid, "You're not in any vehicle.");
			if(!IsATruck(vehicleid)) return Error(playerid, "Vehicle isn't a mining vehicle.");
			if(!IsPlayerInRangeOfPoint(playerid, 4.0, 293.73, 913.17, 20.40)) return Error(playerid, "You're not near a miner warehouse.");
			new cash = Vehicle_GetOreValue(vehicleid), carid = -1;
			if(cash < 1) return Error(playerid, "This vehicle ore is empty!");
			Info(playerid, "Sold "BLUE_E"%d "WHITE_E"ores and earned "LG_E"%s.", Vehicle_LogCount(vehicleid), FormatMoney(cash));
			Component += LogStorage[vehicleid][0] + 150;
			GasOil += LogStorage[vehicleid][1] + 100;
			GivePlayerMoneyEx(playerid, cash);
			Server_MinMoney(cash);
			Vehicle_CleanUp(vehicleid);
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cMetal] = 0;
				pvData[carid][cCoal] = 0;
			}
			pData[playerid][pJobTime] += 150;
		}
	}
	else return Error(playerid, "You are not miner job.");
	return 1;
}

Vehicle_CleanUp(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return -1;
    for(new i; i < 2; i++) LogStorage[vehicleid][i] = 0;
	return 1;
}

Vehicle_GetOreValue(vehicleid)
{
    if(!IsValidVehicle(vehicleid)) return -1;
	new value = 0, metal = 0, coal = 0;
	metal += LogStorage[vehicleid][0] * MetalPrice;
	coal += LogStorage[vehicleid][1] * CoalPrice;
	value = metal + coal;
	return value;
}