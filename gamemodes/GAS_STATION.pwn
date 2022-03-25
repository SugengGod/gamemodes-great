#define MAX_GSTATION 50

enum gsinfo
{
	gsStock,
	Float:gsPosX,
	Float:gsPosY,
	Float:gsPosZ,
	Text3D:gsLabel,
	gsPickup
};

new gsData[MAX_GSTATION][gsinfo],
	Iterator: GStation<MAX_GSTATION>;
	
GStation_Refresh(gsid)
{
	if(gsid != -1)
    {
        if(IsValidDynamic3DTextLabel(gsData[gsid][gsLabel]))
            DestroyDynamic3DTextLabel(gsData[gsid][gsLabel]);

        if(IsValidDynamicPickup(gsData[gsid][gsPickup]))
            DestroyDynamicPickup(gsData[gsid][gsPickup]);

        static
        string[255];

		format(string, sizeof(string), "[GAS STATION ID: %d]\n"WHITE_E"Gas Stock: "YELLOW_E"%d liters\n"WHITE_E"Price: "LG_E"%s /liters\n\n"WHITE_E"Type '"RED_E"/fill"WHITE_E"' to refill", gsid, gsData[gsid][gsStock], FormatMoney(GStationPrice));
		gsData[gsid][gsPickup] = CreateDynamicPickup(1650, 23, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]+0.2, -1, -1, -1, 50.0);
		gsData[gsid][gsLabel] = CreateDynamic3DTextLabel(string, COLOR_GREEN, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]+0.5, 5.5);
	}
    return 1;
}

function LoadGStations()
{
    static gsid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", gsid);
			cache_get_value_name_int(i, "stock", gsData[gsid][gsStock]);
			cache_get_value_name_float(i, "posx", gsData[gsid][gsPosX]);
			cache_get_value_name_float(i, "posy", gsData[gsid][gsPosY]);
			cache_get_value_name_float(i, "posz", gsData[gsid][gsPosZ]);
			GStation_Refresh(gsid);
			Iter_Add(GStation, gsid);
		}
		printf("[Gas Station]: %d Loaded.", rows);
	}
}

GStation_Save(gsid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE gstations SET stock='%d', posx='%f', posy='%f', posz='%f' WHERE id='%d'",
	gsData[gsid][gsStock],
	gsData[gsid][gsPosX],
	gsData[gsid][gsPosY],
	gsData[gsid][gsPosZ],
	gsid
	);
	return mysql_tquery(g_SQL, cQuery);
}

CMD:creategs(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
	
	new gsid = Iter_Free(GStation), query[128];
	if(gsid == -1) return Error(playerid, "You cant create more gs!");
	new stok;
	if(sscanf(params, "d", stok)) return Usage(playerid, "/creategs [stock - max: 10000/liters]");
	
	if(stok < 1 || stok > 10000) return Error(playerid, "Invagsid stok.");
	
	GetPlayerPos(playerid, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]);
	gsData[gsid][gsStock] = stok;
    GStation_Refresh(gsid);
	Iter_Add(GStation, gsid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO gstations SET id='%d', stock='%d', posx='%f', posy='%f', posz='%f'", gsid, gsData[gsid][gsStock], gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]);
	mysql_tquery(g_SQL, query, "OnGstationCreated", "ii", playerid, gsid);
	return 1;
}

function OnGstationCreated(playerid, gsid)
{
	GStation_Save(gsid);
	new str[150];
	format(str,sizeof(str),"[Gas]: %s membuat gas station id %d!", GetRPName(playerid), gsid);
	LogServer("Admin", str);	
	return 1;
}

CMD:gotogs(playerid, params[])
{
	new gsid;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
		
	if(sscanf(params, "d", gsid))
		return Usage(playerid, "/gotogs [id]");
		
	if(!Iter_Contains(GStation, gsid)) return Error(playerid, "The gs you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ], 2.0);
    SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInFamily] = -1;
	Servers(playerid, "You has teleport to gs id %d", gsid);
	return 1;
}

CMD:editgs(playerid, params[])
{
    static
        gsid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", gsid, type, string))
    {
        Usage(playerid, "/editgs [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, stock, delete");
        return 1;
    }
    if((gsid < 0 || gsid >= MAX_GSTATION))
        return Error(playerid, "You have specified an invagsid ID.");
	if(!Iter_Contains(GStation, gsid)) return Error(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]);
        GStation_Save(gsid);
		GStation_Refresh(gsid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of gs ID: %d.", pData[playerid][pAdminname], gsid);
    }
    else if(!strcmp(type, "stock", true))
    {
        new stok;

        if(sscanf(string, "d", stok))
            return Usage(playerid, "/editgs [id] [type] [stock - 10000]");

        if(stok < 1 || stok > 10000)
            return Error(playerid, "You must specify at least 1 - 5.");

        gsData[gsid][gsStock] = stok;
        GStation_Save(gsid);
		GStation_Refresh(gsid);

        SendAdminMessage(COLOR_RED, "%s has set gs ID: %d stock to %d.", pData[playerid][pAdminname], gsid, stok);
    }
    else if(!strcmp(type, "delete", true))
    {
		new query[128];
		DestroyDynamic3DTextLabel(gsData[gsid][gsLabel]);
		DestroyDynamicPickup(gsData[gsid][gsPickup]);
		gsData[gsid][gsPosX] = 0;
		gsData[gsid][gsPosY] = 0;
		gsData[gsid][gsPosY] = 0;
		gsData[gsid][gsStock] = 0;
		gsData[gsid][gsLabel] = Text3D: INVALID_3DTEXT_ID;
		gsData[gsid][gsPickup] = -1;
		Iter_Remove(GStation, gsid);
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM gstations WHERE id=%d", gsid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete gs ID: %d.", pData[playerid][pAdminname], gsid);
		new str[150];
		format(str,sizeof(str),"[Gas]: %s menghapus gas station id %d!", GetRPName(playerid), gsid);
		LogServer("Admin", str);		
    }
    return 1;
}

CMD:fill(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return Error(playerid, "You must driver a vehicle engine.");
	
	new vehid = GetPlayerVehicleID(playerid);
	if(!IsEngineVehicle(vehid))
            return Error(playerid, "You are not in engine vehicle.");
	
	if(GetEngineStatus(vehid))
					return Error(playerid, "Turn off vehicle engine.");
			
	if(GetVehicleFuel(vehid) >= 999.0)
		return Error(playerid, "This vehicle gas is full.");
	
	if(pData[playerid][pFill] != -1)
		return Error(playerid, "You already filling vehicle. please wait!");
		
	foreach(new gsid : GStation)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]))
		{
			if(gsData[gsid][gsStock] < 1)
				return Error(playerid, "This Gas station is out of stock!");
			
			pData[playerid][pFill] = gsid;
			pData[playerid][pFillStatus] = 1;
			pData[playerid][pFillTime] = SetTimerEx("Filling", 500, true, "i", playerid);
		}
	}
	return 1;
}

function Filling(playerid)
{
	if(pData[playerid][pFillStatus] != 1) return 0;
	foreach(new gsid : GStation)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 4.0, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]) && !IsPlayerInAnyVehicle(playerid) || GetVehicleFuel(GetPlayerVehicleID(playerid)) >= 999.0 || GetPlayerMoney(playerid) < GStationPrice)
		{
			StopFilling(playerid);
			return 1;
		}
		else
		{
			if(GetEngineStatus(GetPlayerVehicleID(playerid)))
					return StopFilling(playerid);
			new old = GetVehicleFuel(GetPlayerVehicleID(playerid));
			SetVehicleFuel(GetPlayerVehicleID(playerid), old + 200);
			pData[playerid][pFillPrice] += GStationPrice;
			gsData[pData[playerid][pFill]][gsStock] -= 10;
			if(GetVehicleFuel(GetPlayerVehicleID(playerid)) >= 999.0)
			{
				SetVehicleFuel(GetPlayerVehicleID(playerid), 1000);
			}
			return 1;
		}
	}
	return 1;
}

StopFilling(playerid)
{
	new gsid = pData[playerid][pFill];
	GivePlayerMoneyEx(playerid, -pData[playerid][pFillPrice]);
	GStation_Refresh(gsid);
	Info(playerid,"Tangki kendaraan anda sudah terisi seharga "RED_E"%s.", FormatMoney(pData[playerid][pFillPrice]));
	KillTimer(pData[playerid][pFillTime]);
	pData[playerid][pFillStatus] = 0;
	pData[playerid][pFillPrice] = 0;
	pData[playerid][pFill] = -1;
	return 1;
}