//----------[ Dynamic Locker System ]-----------

#define MAX_LOCKERS	10

enum lockerinfo
{
	lType,
	Float:lPosX,
	Float:lPosY,
	Float:lPosZ,
	lInt,
	Text3D:lLabel,
	lPickup
};

new lData[MAX_LOCKERS][lockerinfo],
	Iterator: Lockers<MAX_LOCKERS>;
	
Locker_Refresh(lid)
{
    if(lid != -1)
    {
        if(IsValidDynamic3DTextLabel(lData[lid][lLabel]))
            DestroyDynamic3DTextLabel(lData[lid][lLabel]);

        if(IsValidDynamicPickup(lData[lid][lPickup]))
            DestroyDynamicPickup(lData[lid][lPickup]);

        static
        string[255];
		
		new type[128];
		if(lData[lid][lType] == 1)
		{
			type= "Police Departement";
		}
		else if(lData[lid][lType] == 2)
		{
			type= "Medical Departement";
		}
		else if(lData[lid][lType] == 3)
		{
			type= "Goverment Service";
		}
		else if(lData[lid][lType] == 4)
		{
			type= "News Agency";
		}
		else if(lData[lid][lType] == 5)
		{
			type= "VIP";
		}
		else
		{
			type= "Unknown";
		}

		format(string, sizeof(string), "[ID: %d]\n"WHITE_E"Type: "YELLOW_E"%s\n"WHITE_E"Type '"RED_E"/locker"WHITE_E"' to open", lid, type);
		lData[lid][lPickup] = CreateDynamicPickup(1239, 23, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]+0.2, 0, lData[lid][lInt], -1, 50);
		lData[lid][lLabel] = CreateDynamic3DTextLabel(string, COLOR_BLUE, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]+0.5, 5.0);
	}
    return 1;
}

function LoadLockers()
{
    static lid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", lid);
			cache_get_value_name_int(i, "type", lData[lid][lType]);
			cache_get_value_name_float(i, "posx", lData[lid][lPosX]);
			cache_get_value_name_float(i, "posy", lData[lid][lPosY]);
			cache_get_value_name_float(i, "posz", lData[lid][lPosZ]);
			cache_get_value_name_int(i, "interior", lData[lid][lInt]);
			Locker_Refresh(lid);
			Iter_Add(Lockers, lid);
		}
		printf("[Lockers]: %d Loaded.", rows);
	}
}
	
Locker_Save(lid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE lockers SET type='%d', posx='%f', posy='%f', posz='%f', interior='%d' WHERE id='%d'",
	lData[lid][lType],
	lData[lid][lPosX],
	lData[lid][lPosY],
	lData[lid][lPosZ],
	lData[lid][lInt],
	lid
	);
	return mysql_tquery(g_SQL, cQuery);
}


//Dynamic Locker System
CMD:createlocker(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	
	new lid = Iter_Free(Lockers), query[128];
	if(lid == -1) return Error(playerid, "You cant create more locker!");
	new type;
	if(sscanf(params, "d", type)) return SendClientMessageEx(playerid, COLOR_WHITE, "[USAGE]: /createlocker [type, 1.PD 2.MD 3.GS 4.NA]");
	
	if(type < 1 || type > 4) return Error(playerid, "Invalid type.");
	
	GetPlayerPos(playerid, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]);
	lData[lid][lInt] = GetPlayerInterior(playerid);
	lData[lid][lType] = type;
    Locker_Refresh(lid);
	Iter_Add(Lockers, lid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO lockers SET id='%d', type='%d', posx='%f', posy='%f', posz='%f'", lid, lData[lid][lType], lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]);
	mysql_tquery(g_SQL, query, "OnLockerCreated", "ii", playerid, lid);
	return 1;
}

function OnLockerCreated(playerid, lid)
{
	Locker_Save(lid);
	Servers(playerid, "Locker [%d] berhasil di buat!", lid);
	return 1;
}

CMD:gotolocker(playerid, params[])
{
	new lid;
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	if(sscanf(params, "d", lid))
		return SendClientMessageEx(playerid, COLOR_WHITE, "[USAGE]: /gotolocker [id]");
	if(!Iter_Contains(Lockers, lid)) return Error(playerid, "The locker you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ], 2.0);
    SetPlayerInterior(playerid, lData[lid][lInt]);
    SetPlayerVirtualWorld(playerid, 0);
	Servers(playerid, "You has teleport to locker id %d", lid);
	return 1;
}

CMD:editlocker(playerid, params[])
{
    static
        lid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", lid, type, string))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[USAGE]: /editlocker [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, type, delete");
        return 1;
    }
    if((lid < 0 || lid >= MAX_LOCKERS))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Lockers, lid)) return Error(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]);
		lData[lid][lInt] = GetPlayerInterior(playerid);
        Locker_Save(lid);
		Locker_Refresh(lid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of locker ID: %d.", pData[playerid][pAdminname], lid);
    }
    else if(!strcmp(type, "type", true))
    {
        new tipe;

        if(sscanf(string, "d", tipe))
            return SendClientMessageEx(playerid, COLOR_WHITE, "[USAGE]: /editlocker [id] [type] [type, 1.PD 2.MD 3.GS 4.NA]");

        if(tipe < 1 || tipe > 4)
            return Error(playerid, "You must specify at least 1 - 4.");

        lData[lid][lType] = tipe;
        Locker_Save(lid);
		Locker_Refresh(lid);

        SendAdminMessage(COLOR_RED, "%s has set locker ID: %d to type id faction %d.", pData[playerid][pAdminname], lid, tipe);
    }
    else if(!strcmp(type, "delete", true))
    {
		new query[128];
		DestroyDynamic3DTextLabel(lData[lid][lLabel]);
		DestroyDynamicPickup(lData[lid][lPickup]);
		lData[lid][lPosX] = 0;
		lData[lid][lPosY] = 0;
		lData[lid][lPosZ] = 0;
		lData[lid][lInt] = 0;
		lData[lid][lLabel] = Text3D: INVALID_3DTEXT_ID;
		lData[lid][lPickup] = -1;
		Iter_Remove(Lockers, lid);
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM lockers WHERE id=%d", lid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete locker ID: %d.", pData[playerid][pAdminname], lid);
    }
    return 1;
}