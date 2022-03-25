#define MAX_WORKSHOP 100
#define MAX_WORKSHOP_EMPLOYEE 3
#define MAX_WORKSHOP_INT 7000

enum E_WORKSHOP
{
    wID,
    wName[24],
    wOwner[MAX_PLAYER_NAME + 1],
    wOwnerID,
    wComp,
    wMat,
    wMoney,
    Text3D:wText,
    wPickup,
    Float:wX,
    Float:wY,
    Float:wZ,
    wStatus,
    wPrice
};
new wsData[MAX_WORKSHOP][E_WORKSHOP],
    wsEmploy[MAX_WORKSHOP][3][MAX_PLAYER_NAME + 1],
    Iterator:Workshop<MAX_WORKSHOP>;

Workshop_Refresh(id)
{
    if(id != -1)
    {
        if(IsValidDynamic3DTextLabel(wsData[id][wText]))
            DestroyDynamic3DTextLabel(wsData[id][wText]);

        if(IsValidDynamicPickup(wsData[id][wPickup]))
            DestroyDynamicPickup(wsData[id][wPickup]);

        new str[316], stats[64];
        if(wsData[id][wStatus] == 1)
        {
            stats = "{7fff00}OPEN{ffffff}";
        }
        else
        {
            stats = "{ff0000}CLOSED{ffffff}";
        }

        format(str, sizeof str,"[Workshop ID:%d]\n{ffffff}Workshop Price: {7fff00}%s{ffffff}\n{ffffff}Type '/buy' to buy this Workshop", id, FormatMoney(wsData[id][wPrice]));

        if(wsData[id][wOwnerID] != 0 || strcmp(wsData[id][wOwner], "-", true))
            format(str, sizeof str,"[Workshop ID:%d]\n{ffffff}Workshop Name: %s\n{ffffff}Workshop Owner: %s\n{ffffff}STATUS: %s", id, wsData[id][wName], wsData[id][wOwner], stats);

        wsData[id][wText] = CreateDynamic3DTextLabel(str, ARWIN, wsData[id][wX], wsData[id][wY], wsData[id][wZ]+0.5, 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 8.0);
        wsData[id][wPickup] = CreateDynamicPickup(1239, 23, wsData[id][wX], wsData[id][wY], wsData[id][wZ]+0.2, 0, 0, _, 50.0);
    }
}

Workshop_Save(id)
{
    new query[2248];
    format(query, sizeof query,"UPDATE workshop SET owner='%s', ownerid='%d', name='%s', component=%d, material=%d, money=%d, posx='%f', posy='%f', posz='%f', status=%d, price=%d",
        wsData[id][wOwner],
        wsData[id][wOwnerID],
        wsData[id][wName],
        wsData[id][wComp],
        wsData[id][wMat],
        wsData[id][wMoney],
        wsData[id][wX],
        wsData[id][wY],
        wsData[id][wZ],
        wsData[id][wStatus],
        wsData[id][wPrice]);
    for(new z = 0; z < MAX_WORKSHOP_EMPLOYEE; z++)
    {
        format(query, sizeof query,"%s, employe%d='%s'", query, z, wsEmploy[id][z]);
    }
    format(query, sizeof query,"%s WHERE id = %d", query, id);
    return mysql_tquery(g_SQL, query);
}

Workshop_Reset(id)
{
    format(wsData[id][wOwner], MAX_PLAYER_NAME, "-");
    format(wsEmploy[id][0], MAX_PLAYER_NAME, "-");
    format(wsEmploy[id][1], MAX_PLAYER_NAME, "-");
    format(wsEmploy[id][2], MAX_PLAYER_NAME, "-");
    wsData[id][wOwnerID] = 0;
    wsData[id][wComp] = 0;
    wsData[id][wMat] = 0;
    wsData[id][wMoney] = 0;
    for(new z = 0; z < MAX_WORKSHOP_EMPLOYEE; z++)
    {
        format(wsEmploy[id][z], MAX_PLAYER_NAME, "-");
    }
    Workshop_Refresh(id);
}

IsWorkshopEmploye(playerid, id)
{
    if(!strcmp(wsEmploy[id][0], pData[playerid][pName], true)) return 1;
    if(!strcmp(wsEmploy[id][1], pData[playerid][pName], true)) return 1;
    if(!strcmp(wsEmploy[id][2], pData[playerid][pName], true)) return 1;
    return 0;
}

IsWorkshopOwner(playerid, id)
{
    return (wsData[id][wOwnerID] == pData[playerid][pID]) || (!strcmp(wsData[id][wOwner], pData[playerid][pName], true));
}

function LoadWorkshop()
{
    static wid;
	
	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", wid);
			cache_get_value_name(i, "owner", owner);
			format(wsData[wid][wOwner], 128, owner);            
			cache_get_value_name_int(i, "ownerid", wsData[wid][wOwnerID]);
			cache_get_value_name(i, "name", name);
			format(wsData[wid][wName], 128, name);
			cache_get_value_name_int(i, "price", wsData[wid][wPrice]);
			cache_get_value_name_float(i, "posx", wsData[wid][wX]);
			cache_get_value_name_float(i, "posy", wsData[wid][wY]);
			cache_get_value_name_float(i, "posz", wsData[wid][wZ]);
			cache_get_value_name_int(i, "component", wsData[wid][wComp]);
			cache_get_value_name_int(i, "material", wsData[wid][wMat]);
            cache_get_value_name_int(i, "money", wsData[wid][wMoney]);
            for(new z = 0; z < MAX_WORKSHOP_EMPLOYEE; z++)
            {
                new str[64];
                format(str, sizeof str,"employe%d", z);
                cache_get_value_name(i, str, wsEmploy[wid][z]);
            }
			Workshop_Refresh(wid);
			Iter_Add(Workshop, wid);
		}
		printf("[Workshops] %d Loaded.", rows);
	}
}

GetOwnedWorkshop(playerid)
{
	new tmpcount;
	foreach(new wid : Workshop)
	{
	    if(!strcmp(wsData[wid][wOwner], pData[playerid][pName], true) || (wsData[wid][wOwnerID] == pData[playerid][pID]))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerWorkshopID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new wid : Workshop)
	{
	    if(!strcmp(pData[playerid][pName], wsData[wid][wOwner], true) || (wsData[wid][wOwnerID] == pData[playerid][pID]))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return wid;
  			}
	    }
	}
	return -1;
}

GetAnyWorkshop()
{
	new tmpcount;
	foreach(new id : Workshop)
	{
     	tmpcount++;
	}
	return tmpcount;
}

ReturnWorkshopID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_WORKSHOP) return -1;
	foreach(new id : Workshop)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}

Player_WorkshopCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Workshop)
	{
		if(IsWorkshopOwner(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

CMD:wsmenu(playerid, params[])
{
    foreach(new id : Workshop)
	{
        if(IsPlayerInRangeOfPoint(playerid, 4.0, wsData[id][wX], wsData[id][wY], wsData[id][wZ]))
        {
            if(!IsWorkshopOwner(playerid, id) && !IsWorkshopEmploye(playerid, id))
                return Error(playerid, "You're not the Owner or Employee of this Workshop");
            
            ShowWorkshopMenu(playerid, id);
        }
    }
    return 1;
}

ShowWorkshopMenu(playerid, id)
{
    pData[playerid][pMenuType] = 0;
    pData[playerid][pInWs] = id;

    new str[256], vstr[64], StatusLocked[30];
    if(wsData[id][wStatus] == 1)
    {
        StatusLocked = "{FFFF00}OPEN{FFFFFF}";
    }
    else
    {
        StatusLocked = "{FF0000}CLOSE{FFFFFF}";
    }
    format(vstr, sizeof vstr,"Workshop (%s) Menu", wsData[id][wName]);
    format(str, sizeof str,"Set Workshop Name\nStatus: %s\nEmploye Menu\nComponent\t(%d/%d)\nMaterial\t(%d/%d)\nMoney\t({7fff00}%s{ffffff})",
        StatusLocked,
        wsData[id][wComp],
        MAX_WORKSHOP_INT,
        wsData[id][wMat],
        MAX_WORKSHOP_INT,
        FormatMoney(wsData[id][wMoney]));
    ShowPlayerDialog(playerid, WS_MENU, DIALOG_STYLE_LIST, vstr, str, "Select", "Cancel");
    return 1;
}
alias:createworkshop("createws")
CMD:createworkshop(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
	
	new query[512];
	new wid = Iter_Free(Workshop);
	if(wid == -1) return Error(playerid, "You cant create more workshop!");
	new price;
	if(sscanf(params, "d", price)) return Usage(playerid, "/createworkshop [price]");
	new totalcash[25];
	format(totalcash, sizeof totalcash,"%d00",price);
	price = strval(totalcash);
	format(wsData[wid][wOwner], MAX_PLAYER_NAME, "-");
    format(wsEmploy[wid][0], MAX_PLAYER_NAME, "-");
    format(wsEmploy[wid][1], MAX_PLAYER_NAME, "-");
    format(wsEmploy[wid][2], MAX_PLAYER_NAME, "-");
    format(wsData[wid][wName], 24, "-");
	GetPlayerPos(playerid, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]);
	wsData[wid][wPrice] = price;
	wsData[wid][wStatus] = 0;
    wsData[wid][wOwnerID] = 0;

    Workshop_Refresh(wid);
	Iter_Add(Workshop, wid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO workshop SET id=%d, owner='%s', ownerid='%d', price=%d, posx='%f', posy='%f', posz='%f', name='%s'", wid, wsData[wid][wOwner], wsData[wid][wOwnerID], wsData[wid][wPrice], wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ], wsData[wid][wName]);
	mysql_tquery(g_SQL, query, "OnWorkshopCreated", "i", wid);
    Info(playerid, "Created Workshop ID:%d", wid);
    new str[150];
	format(str,sizeof(str),"[Workshop] %s membuat workshop id %d!", GetRPName(playerid), wid);
	LogServer("Admin", str);
	return 1;
}

function OnWorkshopCreated(wid)
{
	Workshop_Save(wid);
    Workshop_Refresh(wid);
	return 1;
}
alias:gotoworkshop("gotows")
CMD:gotoworkshop(playerid, params[])
{
	new wid;
	if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
		
	if(sscanf(params, "d", wid))
		return Usage(playerid, "/gotoworkshop [id]");
	if(!Iter_Contains(Workshop, wid)) return Error(playerid, "The Workshop you specified ID of doesn't exist.");
	SetPlayerPos(playerid, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;	
	Info(playerid, "You has teleport to Workshop id %d", wid);
	return 1;
}
alias:editworkshop("editws")
CMD:editworkshop(playerid, params[])
{
    static
        wid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", wid, type, string))
    {
        Usage(playerid, "/editworkshop [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, status, owner, price, money, comp, mat");
        return 1;
    }
    if((wid < 0 || wid >= MAX_WORKSHOP))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Workshop, wid)) return Error(playerid, "The Workshop you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]);
        Workshop_Save(wid);
		Workshop_Refresh(wid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of Workshop ID: %d.", pData[playerid][pAdminname], wid);
    }
    else if(!strcmp(type, "status", true))
    {
        new locked;

        if(sscanf(string, "d", locked))
            return Usage(playerid, "/editws [id] [locked] [0/1]");

        if(locked < 0 || locked > 1)
            return Error(playerid, "You must specify at least 0 or 1.");

        wsData[wid][wStatus] = locked;
        Workshop_Save(wid);
		Workshop_Refresh(wid);

        if(locked) {
            SendAdminMessage(COLOR_RED, "%s has Opened Workshop ID: %d.", pData[playerid][pAdminname], wid);
        }
        else {
            SendAdminMessage(COLOR_RED, "%s has Closed Workshop ID: %d.", pData[playerid][pAdminname], wid);
        }
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editws [id] [Price] [Amount]");

        wsData[wid][wPrice] = price;

        Workshop_Save(wid);
		Workshop_Refresh(wid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the price of Workshop ID: %d to %d.", pData[playerid][pAdminname], wid, price);
    }
	else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return Usage(playerid, "/editws [id] [money] [Ammount]");

        wsData[wid][wMoney] = money;
        Workshop_Save(wid);
		Workshop_Refresh(wid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the money of Workshop ID: %d to %s.", pData[playerid][pAdminname], wid, FormatMoney(money));
    }
	else if(!strcmp(type, "comp", true))
    {
        new amount;

        if(sscanf(string, "d", amount))
            return Usage(playerid, "/editws [id] [Comp] [Ammount]");

        wsData[wid][wComp] = amount;
        Workshop_Save(wid);
		Workshop_Refresh(wid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the component of Workshop ID: %d to %d.", pData[playerid][pAdminname], wid, amount);
    }
    else if(!strcmp(type, "mat", true))
    {
        new amount;

        if(sscanf(string, "d", amount))
            return Usage(playerid, "/editws [id] [mat] [Ammount]");

        wsData[wid][wMat] = amount;
        Workshop_Save(wid);
		Workshop_Refresh(wid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the material of Workshop ID: %d to %d.", pData[playerid][pAdminname], wid, amount);
    }
    else if(!strcmp(type, "owner", true))
    {
		new otherid;
        if(sscanf(string, "d", otherid))
            return Usage(playerid, "/editws [id] [owner] [playerid] (use '-1' to no owner/ reset)");
		if(otherid == -1)
			return format(wsData[wid][wOwner], MAX_PLAYER_NAME, "-");

        format(wsData[wid][wOwner], MAX_PLAYER_NAME, pData[otherid][pName]);
        wsData[wid][wOwnerID] = pData[otherid][pID];
  
        Workshop_Save(wid);
		Workshop_Refresh(wid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of Workshop ID: %d to %s", pData[playerid][pAdminname], wid, pData[otherid][pName]);
    }
    else if(!strcmp(type, "reset", true))
    {
        Workshop_Reset(wid);
		Workshop_Save(wid);
		Workshop_Refresh(wid);
        SendAdminMessage(COLOR_RED, "%s has reset Workshop ID: %d.", pData[playerid][pAdminname], wid);
    }
	else if(!strcmp(type, "delete", true))
    {
		Workshop_Reset(wid);
		
		DestroyDynamic3DTextLabel(wsData[wid][wText]);
        DestroyDynamicPickup(wsData[wid][wPickup]);
		
		wsData[wid][wX] = 0;
		wsData[wid][wY] = 0;
		wsData[wid][wZ] = 0;
		wsData[wid][wPrice] = 0;
		wsData[wid][wText] = Text3D: INVALID_3DTEXT_ID;
		wsData[wid][wPickup] = -1;
		
		Iter_Remove(Workshop, wid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM Workshop WHERE ID=%d", wid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete Workshop ID: %d.", pData[playerid][pAdminname], wid);
        new str[150];
        format(str,sizeof(str),"[Workshop] %s menghapus workshop id %d!", GetRPName(playerid), wid);
        LogServer("Admin", str);
	}
    return 1;
}

/*CMD:lockworkshop(playerid, params[])
{
	foreach(new wid : Workshop)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]))
		{
			if(!IsWorkshopOwner(playerid, wid) && !IsWorkshopEmploye(playerid, wid)) return Error(playerid, "Kamu bukan pengurus Workshop ini.");
			if(!wsData[wid][wStatus])
			{
				wsData[wid][wStatus] = 1;
				Workshop_Save(wid);

				InfoTD_MSG(playerid, 4000, "Workshop anda berhasil ~g~Dibuka!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				wsData[wid][wStatus] = 0;
				Workshop_Save(wid);

				InfoTD_MSG(playerid, 4000,"Workshop anda berhasil ~r~Ditutup");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
            Workshop_Refresh(wid);
		}
	}
	return 1;
}*/
alias:myworkshop("myws")
CMD:myworkshop(playerid)
{
	if(!GetOwnedWorkshop(playerid)) return Error(playerid, "You don't have any Workshop.");
	new wid, _tmpstring[128], count = GetOwnedWorkshop(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	strcat(CMDSString,"No\tName(Status)\tLocation\n",sizeof(CMDSString));
	Loop(itt, (count + 1), 1)
	{
	    wid = ReturnPlayerWorkshopID(playerid, itt);
		if(wsData[wid][wStatus] == 1)
		{
			lock = "{7FFF00}Open{ffffff}";
		}
		else
		{
			lock = "{FF0000}Closed{ffffff}";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), "%d\t%s{ffffff}(%s)\t%s{ffffff}\n", itt, wsData[wid][wName], lock, GetLocation(wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]));
		}
		else format(_tmpstring, sizeof(_tmpstring), "%d\t%s{ffffff}(%s)\t%s{ffffff}\n", itt, wsData[wid][wName], lock, GetLocation(wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]));
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_WS, DIALOG_STYLE_TABLIST_HEADERS, "My Workshop", CMDSString, "Track", "Cancel");
	return 1;
}