#define MAX_GATES 500

enum E_GATE
{
	gModel,
	gPass[36],
	gAdmin,
	gVip,
	gFaction,
	gFamily,
	Float:gSpeed,
	Float:gCX,
	Float:gCY,
	Float:gCZ,
	Float:gCRX,
	Float:gCRY,
	Float:gCRZ,
	Float:gOX,
	Float:gOY,
	Float:gOZ,
	Float:gORX,
	Float:gORY,
	Float:gORZ,
	gStatus,
	gObjID,
	Text3D:gText
}
new gData[MAX_GATES][E_GATE],
	Iterator: Gates<MAX_GATES>;
	
new Float:gPosX[MAX_PLAYERS],
	Float:gPosY[MAX_PLAYERS],
	Float:gPosZ[MAX_PLAYERS],
	Float:gRotX[MAX_PLAYERS],
	Float:gRotY[MAX_PLAYERS],
	Float:gRotZ[MAX_PLAYERS];

Gate_Save(id)
{
	new dquery[2048];
	mysql_format(g_SQL, dquery, sizeof(dquery), "UPDATE gates SET model='%d', password='%s', admin='%d', vip='%d', faction='%d', family='%d', speed='%f', cX='%f', cY='%f', cZ='%f', cRX='%f', cRY='%f', cRZ='%f', oX='%f', oY='%f', oZ='%f', oRX='%f', oRY='%f', oRZ='%f' WHERE ID='%d'",
	gData[id][gModel], gData[id][gPass], gData[id][gAdmin], gData[id][gVip], gData[id][gFaction], gData[id][gFamily], gData[id][gSpeed], gData[id][gCX], gData[id][gCY], gData[id][gCZ], gData[id][gCRX], gData[id][gCRY], gData[id][gCRZ], gData[id][gOX], gData[id][gOY], gData[id][gOZ], gData[id][gORX], gData[id][gORY], gData[id][gORZ], id);
	mysql_tquery(g_SQL, dquery);
	return 1;
}

function LoadGates()
{
    new rows = cache_num_rows();
 	if(rows)
  	{
   		new id, password[36];
		for(new i; i < rows; i++)
		{
  			cache_get_value_name_int(i, "ID", id);
	    	cache_get_value_name_int(i, "model", gData[id][gModel]);
		    cache_get_value_name(i, "password", password);
			format(gData[id][gPass], 36, password);
		    cache_get_value_name_int(i, "admin", gData[id][gAdmin]);
		    cache_get_value_name_int(i, "vip", gData[id][gVip]);
		    cache_get_value_name_int(i, "faction", gData[id][gFaction]);
		    cache_get_value_name_int(i, "family", gData[id][gFamily]);
		    cache_get_value_name_float(i, "speed", gData[id][gSpeed]);
		    cache_get_value_name_float(i, "cX", gData[id][gCX]);
			cache_get_value_name_float(i, "cY", gData[id][gCY]);
			cache_get_value_name_float(i, "cZ", gData[id][gCZ]);
			cache_get_value_name_float(i, "cRX", gData[id][gCRX]);
			cache_get_value_name_float(i, "cRY", gData[id][gCRY]);
			cache_get_value_name_float(i, "cRZ", gData[id][gCRZ]);
			cache_get_value_name_float(i, "oX", gData[id][gOX]);
			cache_get_value_name_float(i, "oY", gData[id][gOY]);
			cache_get_value_name_float(i, "oZ", gData[id][gOZ]);
			cache_get_value_name_float(i, "oRX", gData[id][gORX]);
			cache_get_value_name_float(i, "oRY", gData[id][gORY]);
			cache_get_value_name_float(i, "oRZ", gData[id][gORZ]);
			
			Iter_Add(Gates, id);
			new str[128];
			format(str, sizeof(str), "Gate ID: %d", id);
			gData[id][gObjID] = CreateDynamicObject(gData[id][gModel], gData[id][gCX], gData[id][gCY], gData[id][gCZ], gData[id][gCRX], gData[id][gCRY], gData[id][gCRZ], -1, -1, -1, 50.0, 50.0);
			
			gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
			gData[id][gStatus] = 0;
	    }
	    printf("[Gate]: %d Loaded.", rows);
	}
}


//Gates - Commands
CMD:creategate(playerid, params[])
{
	new object;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
	
	new id = Iter_Free(Gates), str[128], query[248];
	if(id == -1) return Error(playerid, "You cant create more gate!");
	if(sscanf(params, "i", object)) return Usage(playerid, "/creategate [objectid]");
	
	GetPlayerPos(playerid, gData[id][gCX], gData[id][gCY], gData[id][gCZ]);
	gData[id][gModel] = object;
	gData[id][gCX] = gData[id][gCX] + 2;
	gData[id][gCY] = gData[id][gCY] + 2;
	gData[id][gCRX] = 0;
	gData[id][gCRY] = 0;
	gData[id][gCRZ] = 0;
	GetPlayerPos(playerid, gData[id][gOX], gData[id][gOY], gData[id][gOZ]);
	gData[id][gOX] = gData[id][gOX] + 2;
	gData[id][gOY] = gData[id][gOY] + 2;
	gData[id][gORX] = 0;
	gData[id][gORY] = 0;
	gData[id][gORZ] = 0;
	gData[id][gStatus] = 0;
	gData[id][gFamily] = -1;
	gData[id][gFaction] = 0;
	gData[id][gAdmin] = 0;
	gData[id][gVip] = 0;
	format(gData[id][gPass], 36, "");
	gData[id][gSpeed] = 2.0;
	// Creating
	gData[id][gObjID] = CreateDynamicObject(gData[id][gModel], gData[id][gCX], gData[id][gCY], gData[id][gCZ], gData[id][gCRX], gData[id][gCRY], gData[id][gCRZ], -1, -1, -1, 50.0, 50.0);
	
	format(str, sizeof(str), "Gate ID: %d", id);
	gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
	gData[id][gStatus] = 0;
	Iter_Add(Gates, id);
	// Text
	Servers(playerid, "You has create gate id %d", id);
	new str1[150];
	format(str1,sizeof(str1),"[Gate]: %s membuat gate id %d!", GetRPName(playerid), id);
	LogServer("Admin", str1);	
	
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO gates SET ID='%d', model='%d', cX='%f', cY='%f', cZ='%f', cRX='%f', cRY='%f', cRZ='%f', oX='%f', oY='%f', oZ='%f', oRX='%f', oRY='%f', oRZ='%f'",
	id, gData[id][gModel], gData[id][gCX], gData[id][gCY], gData[id][gCZ], gData[id][gCRX], gData[id][gCRY], gData[id][gCRZ], gData[id][gOX], gData[id][gOY], gData[id][gOZ], gData[id][gORX], gData[id][gORY], gData[id][gORZ]);
	mysql_tquery(g_SQL, query, "OnGateCreated", "i", id);
	return 1;
}

function OnGateCreated(id)
{
	Gate_Save(id);
	return 1;
}

CMD:gedit(playerid, params[])
{
    static
        id,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", id, type, string))
    {
        Usage(playerid, "/gedit [id] [name]");
        Info(playerid, "object | admin | vip | faction | family | close | open | speed | password");
        return 1;
    }
    if((id < 0 || id >= MAX_GATES))
        return Error(playerid, "You have specified an invalid gate ID.");
	if(!Iter_Contains(Gates, id)) return Error(playerid, "The gate you specified ID of doesn't exist.");
	
	if(!strcmp(type, "object", true))
    {
		new object;

        if(sscanf(string, "d", object))
            return Usage(playerid, "/gedit [id] [Object] [objectid]");

        gData[id][gModel] = object;
		DestroyDynamicObject(gData[id][gObjID]);
		//gData[id][gObjID] = CreateDynamicObject(gData[id][gModel], gData[id][gCX], gData[id][gCY], gData[id][gCZ], gData[id][gCRX], gData[id][gCRY], gData[id][gCRZ]);
		gData[id][gObjID] = CreateDynamicObject(gData[id][gModel], gData[id][gCX], gData[id][gCY], gData[id][gCZ], gData[id][gCRX], gData[id][gCRY], gData[id][gCRZ], -1, -1, -1, 50.0, 50.0);
	    Servers(playerid, "You have set gate ID %d's object ID to %d.", id, object);
	    Gate_Save(id);
	}
	else if(!strcmp(type, "admin", true))
    {
		new admin;

        if(sscanf(string, "d", admin))
            return Usage(playerid, "/gedit [id] [Admin] [level]");
		
		if(admin < 0 || admin > 6)
			return Error(playerid, "invalid vip id 0 - 6.");
			
		gData[id][gAdmin] = admin;
	    Servers(playerid, "You have set gate ID %d's to admin level %d.", id, admin);
	    Gate_Save(id);
	}
	else if(!strcmp(type, "vip", true))
    {
		new vip;

        if(sscanf(string, "d", vip))
            return Usage(playerid, "/gedit [id] [VIP] [level]");

        if(vip < 0 || vip > 3)
            return Error(playerid, "Invalid value. Use 0 - 3 for level.");
		
		gData[id][gVip] = vip;
	    Servers(playerid, "You have set gate ID %d's to VIP level %d.", id, vip);
	    Gate_Save(id);
	}
	else if(!strcmp(type, "faction", true))
    {
		new fid;

        if(sscanf(string, "d", fid))
            return Usage(playerid, "/gedit [id] [faction] [faction id]");

        if(fid < 0 || fid > 4)
            return Error(playerid, "Invalid value. Use 0 - 4 for type.");
		
		gData[id][gFaction] = fid;
	    Servers(playerid, "You have set gate ID %d's to faction id %d.", id, fid);
	    Gate_Save(id);
	}
	else if(!strcmp(type, "family", true))
    {
		new fid;

        if(sscanf(string, "d", fid))
            return Usage(playerid, "/gedit [id] [family] [family id]");

        if(fid < -1 || fid > 9)
            return Error(playerid, "Invalid value. Use -1 - 9 for family id.");
			
		gData[id][gFamily] = fid;
	    Servers(playerid, "You have set gate ID %d's to family id %d.", id, fid);
	    Gate_Save(id);
	}
	else if(!strcmp(type, "speed", true))
    {
		new Float:speed;

        if(sscanf(string, "f", speed))
            return Usage(playerid, "/gedit [id] [Speed] [level]");
		
		gData[id][gSpeed] = speed;
	    Servers(playerid, " You have set gate ID %d's moving speed to %f.", id, speed);
	    Gate_Save(id);
	}
	else if(!strcmp(type, "close", true))
    {	
		pData[playerid][gEdit] = 1;
		pData[playerid][gEditID] = id;
		GetDynamicObjectPos(gData[id][gObjID], gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
		GetDynamicObjectRot(gData[id][gObjID], gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
		EditDynamicObject(playerid, gData[id][gObjID]);
	    Servers(playerid, " You are now editing gate ID %d's closing position.", id);
	    Gate_Save(id);
	}
	else if(!strcmp(type, "open", true))
    {
		pData[playerid][gEdit] = 2;
		pData[playerid][gEditID] = id;
		GetDynamicObjectPos(gData[id][gObjID], gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
		GetDynamicObjectRot(gData[id][gObjID], gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
		EditDynamicObject(playerid, gData[id][gObjID]);
	    Servers(playerid, " You are now editing gate ID %d's opening position.", id);
	}
	else if(!strcmp(type, "password", true))
    {
		new password[36];

        if(sscanf(string, "s[36]", password))
            return Usage(playerid, "/gedit [id] [password] [gate pass] (use 'none' to disable)");

        if(!strcmp(password, "none", true)) {
            format(gData[id][gPass], 36, "");
        }
        else {
            format(gData[id][gPass], 36, password);
        }
        Gate_Save(id);
        Servers(playerid, "You has adjusted the password of gate ID: %d to %s", id, password);
	}
	else if(!strcmp(type, "delete", true))
    {
		gData[id][gModel] = 0;
		gData[id][gCX] = 0;
		gData[id][gCY] = 0;
		gData[id][gCZ] = 0;
		gData[id][gCRX] = 0;
		gData[id][gCRY] = 0;
		gData[id][gCRZ] = 0;
		gData[id][gOX] = 0;
		gData[id][gOY] = 0;
		gData[id][gOZ] = 0;
		gData[id][gORX] = 0;
		gData[id][gORY] = 0;
		gData[id][gORZ] = 0;
		gData[id][gStatus] = 0;
		format(gData[id][gPass], 36, "");
		gData[id][gSpeed] = 0;
		
		DestroyDynamicObject(gData[id][gObjID]);
		DestroyDynamic3DTextLabel(gData[id][gText]);
		
		Iter_Remove(Gates, id);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM gates WHERE ID=%d", id);
		mysql_tquery(g_SQL, query);
		Servers(playerid, "You has deleted gate id %d.", id);
		new str[150];
		format(str,sizeof(str),"[Gate]: %s menghapus gate id %d!", GetRPName(playerid), id);
		LogServer("Admin", str);		
	}
	return 1;
}
/*
CMD:gedit(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
 	if(sscanf(params, "s[128]", params))
	{
		Usage(playerid, "USAGE: /gedit [option] [gateid]");
		Info(playerid, "object | close | open | speed | password");
		return 1;
	}
	
	if((id < 0 || id >= MAX_GATES))
        return Error(playerid, "You have specified an invalid gate ID.");
		
	if(!Iter_Contains(Gates, id)) return Error(playerid, "The gates you specified ID of doesn't exist.");
	
	if(!strcmp(params, "object", true))
	{
	    new object;
	    if(sscanf(params, "s[128]ii", params, id, object)) return Usage(playerid, "/gedit object [gateid] [objectid]");

		gData[id][gModel] = object;
		DestroyDynamicObject(gData[id][gObjID]);
		gData[id][gObjID] = CreateDynamicObject(gData[id][gModel], gData[id][gCX], gData[id][gCY], gData[id][gCZ], gData[id][gCRX], gData[id][gCRY], gData[id][gCRZ]);
	    Servers(playerid, "You have set gate ID %d's object ID to %d.", id, object);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "admin", true))
	{
	    new admin;
	    if(sscanf(params, "s[128]ii", params, id, admin)) return Usage(playerid, "/gedit object [gateid] [adminid]");
		
		if(admin < 0 || admin > 6)
			return Error(playerid, "invalid vip id 0 - 6.");
			
		gData[id][gAdmin] = admin;
	    Servers(playerid, "You have set gate ID %d's to admin level %d.", id, admin);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "vip", true))
	{
	    new vip;
	    if(sscanf(params, "s[128]ii", params, id, vip)) return Usage(playerid, "/gedit object [gateid] [vipid]");
		
		if(vip < 0 || vip > 3)
			return Error(playerid, "invalid vip id 0 - 3.");
		
		gData[id][gVip] = vip;
	    Servers(playerid, "You have set gate ID %d's to VIP level %d.", id, vip);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "faction", true))
	{
	    new faction;
	    if(sscanf(params, "s[128]ii", params, id, faction)) return Usage(playerid, "/gedit object [gateid] [factionid]");

		if(faction < 0 || faction > 4)
			return Error(playerid, "invalid faction id 0 - 4.");
			
		gData[id][gFaction] = faction;
	    Servers(playerid, "You have set gate ID %d's to faction id %d.", id, faction);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "family", true))
	{
	    new family;
	    if(sscanf(params, "s[128]ii", params, id, family)) return Usage(playerid, "/gedit object [gateid] [familyid]");
		
		if(family < -1 || family > MAX_FAMILY)
			return Error(playerid, "invalid family id.");
			
		gData[id][gFamily] = family;
	    Servers(playerid, "You have set gate ID %d's to family id %d.", id, family);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "close", true))
	{
	    if(sscanf(params, "s[128]i", params, id)) return Usage(playerid, "/gedit close [gateid]");
		
		pData[playerid][gEdit] = 1;
		pData[playerid][gEditID] = id;
		GetDynamicObjectPos(gData[id][gObjID], gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
		GetDynamicObjectRot(gData[id][gObjID], gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
		EditDynamicObject(playerid, gData[id][gObjID]);
	    Servers(playerid, " You are now editing gate ID %d's closing position.", id);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "open", true))
	{
	    if(sscanf(params, "s[128]i", params, id)) return Usage(playerid, "/gedit open [gateid]");
		
		pData[playerid][gEdit] = 2;
		pData[playerid][gEditID] = id;
		GetDynamicObjectPos(gData[id][gObjID], gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
		GetDynamicObjectRot(gData[id][gObjID], gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
		EditDynamicObject(playerid, gData[id][gObjID]);
	    Servers(playerid, " You are now editing gate ID %d's opening position.", id);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "speed", true))
	{
	    new Float:speed;
	    if(sscanf(params, "s[128]if", params, id, speed)) return Usage(playerid, "/gedit speed [gateid] [speed]");

		gData[id][gSpeed] = speed;
	    Servers(playerid, " You have set gate ID %d's moving speed to %f.", id, speed);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "password", true))
	{
	    new password[256];
	    if(sscanf(params, "s[128]is[256]", params, id, password)) return Usage(playerid, "/gedit password [gateid] [password]");

		format(gData[id][gPass], 36, "%s", password);
	    Servers(playerid, "You have set gate ID %d's password to {FF6347}%s", id, password);
	    Gate_Save(id);
	}
	else if(!strcmp(params, "delete", true))
	{
		
		gData[id][gModel] = 0;
		gData[id][gCX] = 0;
		gData[id][gCY] = 0;
		gData[id][gCZ] = 0;
		gData[id][gCRX] = 0;
		gData[id][gCRY] = 0;
		gData[id][gCRZ] = 0;
		gData[id][gOX] = 0;
		gData[id][gOY] = 0;
		gData[id][gOZ] = 0;
		gData[id][gORX] = 0;
		gData[id][gORY] = 0;
		gData[id][gORZ] = 0;
		gData[id][gStatus] = 0;
		format(gData[id][gPass], 36, "");
		gData[id][gSpeed] = 0;
		
		DestroyDynamicObject(gData[id][gObjID]);
		DestroyDynamic3DTextLabel(gData[id][gText]);
		
		Iter_Remove(Gates, id);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM gates WHERE ID=%d", id);
		mysql_tquery(g_SQL, query);
		Servers(playerid, "You has deleted gate id %d.", id);
	}
	return 1;
}*/

CMD:gotogate(playerid, params[])
{
    new id;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
		
	if(sscanf(params, "i", id)) return Usage(playerid, "/gotogate [gateid]");
	if(!Iter_Contains(Gates, id)) return Error(playerid, "The gate you specified ID of doesn't exist.");

	SetPlayerPosition(playerid, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 5.0);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;
	Servers(playerid, "You has teleport to gate id %d", id);
	return 1;
}

CMD:gate(playerid, params[])
{
    // Dynamic Gates
    foreach(new idx : Gates)
	{
	    if(gData[idx][gModel] && IsPlayerInRangeOfPoint(playerid, 8.0, gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ]))
	    {
			if(gData[idx][gFaction] > 0)
			{
				if(gData[idx][gFaction] != pData[playerid][pFaction])
					return Error(playerid, "This gate only for faction.");
			}
			if(gData[idx][gFamily] > -1)
			{
				if(gData[idx][gFamily] != pData[playerid][pFamily])
					return Error(playerid, "This gate only for family.");
			}
			
			if(gData[idx][gVip] > pData[playerid][pVip])
				return Error(playerid, "Your VIP level not enough to enter this gate.");
			
			if(gData[idx][gAdmin] > pData[playerid][pAdmin])
				return Error(playerid, "Your admin level not enough to enter this gate.");
			
	        if(strlen(gData[idx][gPass]))
	        {
	            if(sscanf(params, "s[36]", params)) return Usage(playerid, "/gate [password]");
	            if(strcmp(params, gData[idx][gPass])) return Error(playerid, "Invalid gate password.");
	            if(!gData[idx][gStatus])
		        {
		            gData[idx][gStatus] = 1;
		            MoveDynamicObject(gData[idx][gObjID], gData[idx][gOX], gData[idx][gOY], gData[idx][gOZ], gData[idx][gSpeed]);
		            SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gORX], gData[idx][gORY], gData[idx][gORZ]);
		        }
		        else
		        {
		            gData[idx][gStatus] = 0;
		            MoveDynamicObject(gData[idx][gObjID], gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ], gData[idx][gSpeed]);
		            SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gCRX], gData[idx][gCRY], gData[idx][gCRZ]);
		        }
	        }
	        else
	        {
		        if(!gData[idx][gStatus])
		        {
		            gData[idx][gStatus] = 1;
		            MoveDynamicObject(gData[idx][gObjID], gData[idx][gOX], gData[idx][gOY], gData[idx][gOZ], gData[idx][gSpeed]);
		            SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gORX], gData[idx][gORY], gData[idx][gORZ]);
		        }
		        else
		        {
		            gData[idx][gStatus] = 0;
		            MoveDynamicObject(gData[idx][gObjID], gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ], gData[idx][gSpeed]);
		            SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gCRX], gData[idx][gCRY], gData[idx][gCRZ]);
		        }
	        }
	        return 1;
	    }
	}
	return 1;
}