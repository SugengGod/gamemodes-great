#define MAX_VENDING 50
#define Vend(%1,%2) SendClientMessageEx(%1, ARWIN, "[VENDING]: "WHITE_E""%2)

enum Vending
{
	vendingOwner[MAX_PLAYER_NAME],
	vendingOwnerID,
	vendingName[128],
	vendingPrice,
	vendingStock,
	vendingRestock,
	vendingLock,
	vendingMoney,
	vendingItemPrice[5],
	Float:vendingX,
	Float:vendingY,
	Float:vendingZ,
	Float:vendingA,
	Float:vendingRX,
	Float:vendingRY,
	Float:vendingRZ,
	vendingInterior,
	vendingWorld,
	vendingObject,
	Text3D:vendingText
};

new VendingData[MAX_VENDING][Vending],
	Iterator:Vendings<MAX_VENDING>;

function LoadVending()
{
    static vid;
	
	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", vid);
			cache_get_value_name(i, "owner", owner);
			format(VendingData[vid][vendingOwner], 128, owner);
			cache_get_value_name_int(i, "ownerid", VendingData[vid][vendingOwnerID]);
			cache_get_value_name(i, "name", name);
			format(VendingData[vid][vendingName], 128, name);
			cache_get_value_name_int(i, "price", VendingData[vid][vendingPrice]);
			cache_get_value_name_int(i, "money", VendingData[vid][vendingMoney]);
			cache_get_value_name_int(i, "stock", VendingData[vid][vendingStock]);
			cache_get_value_name_int(i, "vprice0", VendingData[vid][vendingItemPrice][0]);
			cache_get_value_name_int(i, "vprice1", VendingData[vid][vendingItemPrice][1]);
			cache_get_value_name_int(i, "vprice2", VendingData[vid][vendingItemPrice][2]);
			cache_get_value_name_int(i, "vprice3", VendingData[vid][vendingItemPrice][3]);
			cache_get_value_name_int(i, "restock", VendingData[vid][vendingRestock]);
			cache_get_value_name_float(i, "posx", VendingData[vid][vendingX]);
			cache_get_value_name_float(i, "posy", VendingData[vid][vendingY]);
			cache_get_value_name_float(i, "posz", VendingData[vid][vendingZ]);
			cache_get_value_name_float(i, "posa", VendingData[vid][vendingA]);
			cache_get_value_name_float(i, "posrx", VendingData[vid][vendingRX]);
			cache_get_value_name_float(i, "posry", VendingData[vid][vendingRY]);
			cache_get_value_name_float(i, "posrz", VendingData[vid][vendingRZ]);
            
			Vending_RefreshObject(vid);
			Vending_RefreshText(vid);	

			Iter_Add(Vendings, vid);	
		}
		printf("[Vending] %d Loaded.", rows);
	}
}

Vending_Save(vid)
{
    new cQuery[2248];
    format(cQuery, sizeof(cQuery), "UPDATE vending SET owner = '%s', ownerid='%d', name = '%s', price = '%d', money = '%d', stock = '%d', vprice0 = '%d', vprice1 = '%d', vprice2 = '%d', vprice3 = '%d', posx = '%f', posy = '%f', posz = '%f', posa = '%f', posrx = '%f', posry = '%f', posrz = '%f', restock = '%d' WHERE ID = '%d'",
    VendingData[vid][vendingOwner],
	VendingData[vid][vendingOwnerID],
    VendingData[vid][vendingName],
    VendingData[vid][vendingPrice],
    VendingData[vid][vendingMoney],
    VendingData[vid][vendingStock],
    VendingData[vid][vendingItemPrice][0],
	VendingData[vid][vendingItemPrice][1],
	VendingData[vid][vendingItemPrice][2],
	VendingData[vid][vendingItemPrice][3],
    VendingData[vid][vendingX],
    VendingData[vid][vendingY],
    VendingData[vid][vendingZ],
    VendingData[vid][vendingA],
    VendingData[vid][vendingRX],
    VendingData[vid][vendingRY],
    VendingData[vid][vendingRZ],
    VendingData[vid][vendingRestock],
    vid
    );
    return mysql_tquery(g_SQL, cQuery);
}

Vending_RefreshText(vid)
{
	if(vid != -1)
	{		
		if(IsValidDynamic3DTextLabel(VendingData[vid][vendingText]))
            DestroyDynamic3DTextLabel(VendingData[vid][vendingText]);
		
		new tstr[218];
		if(VendingData[vid][vendingX] != 0 && VendingData[vid][vendingY] != 0 && VendingData[vid][vendingZ] != 0 && strcmp(VendingData[vid][vendingOwner], "-") || VendingData[vid][vendingOwnerID] != 0)
		{
			format(tstr, sizeof(tstr), "[ID: %d]\n"YELLOW_E"%s\n"WHITE_E"Owned by %s\nStock: "YELLOW_E"%d\n"WHITE_E"Type "RED_E"ENTER "WHITE_E"to buy from vending.", vid, VendingData[vid][vendingName], VendingData[vid][vendingOwner], VendingData[vid][vendingStock]);
			VendingData[vid][vendingText] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]+1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingData[vid][vendingWorld], VendingData[vid][vendingInterior], -1, 10.0);
		}
		else if(VendingData[vid][vendingX] != 0 && VendingData[vid][vendingY] != 0 && VendingData[vid][vendingZ] != 0)
		{
			format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"This Vending Machine is for sell\nPrice: "GREEN_E"%s\n"WHITE_E"Type /buy to purchase", vid, FormatMoney(VendingData[vid][vendingPrice]));
			VendingData[vid][vendingText] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]+1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingData[vid][vendingWorld], VendingData[vid][vendingInterior], -1, 10.0);
        }
	}
}

Vending_RefreshObject(vid)
{
	if(vid != -1)
	{		
		if(IsValidDynamicObject(VendingData[vid][vendingObject]))
			DestroyDynamicObject(VendingData[vid][vendingObject]);

		VendingData[vid][vendingObject] = CreateDynamicObject(1776, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ], VendingData[vid][vendingRX], VendingData[vid][vendingRY], VendingData[vid][vendingRZ], VendingData[vid][vendingWorld], VendingData[vid][vendingInterior]);
	}
}

Vending_Nearest(playerid)
{
	for (new i = 0; i < MAX_VENDING; i ++) if (IsPlayerInRangeOfPoint(playerid, 5.0, VendingData[i][vendingX], VendingData[i][vendingY], VendingData[i][vendingZ]))
	    return i;

	return -1;
}

function OnVendingCreated(playerid, vid)
{
	Vending_Save(vid);
	Servers(playerid, "Vending [%d] berhasil di buat!", vid);
	new str[150];
	format(str,sizeof(str),"[Vending] %s membuat vending id %d!", GetRPName(playerid), vid);
	LogServer("Admin", str);
}

PlayerOwnVending(playerid, vid)
{
	return (VendingData[vid][vendingOwnerID] == pData[playerid][pID]) || (!strcmp(VendingData[vid][vendingOwner], pData[playerid][pName], true));
}

GetOwnedVending(playerid)
{
	new tmpcount;
	foreach(new i : Vendings)
	{
	    if(!strcmp(VendingData[i][vendingOwner], pData[playerid][pName], true) || VendingData[i][vendingOwnerID] == pData[playerid][pID])
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerVendingID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new i : Vendings)
	{
	    if(!strcmp(pData[playerid][pName], VendingData[i][vendingOwner], true) || VendingData[i][vendingOwnerID] == pData[playerid][pID])
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return i;
  			}
	    }
	}
	return -1;
}

Player_VendingCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Vendings)
	{
		if(PlayerOwnVending(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

VendingProductMenu(playerid, vid)
{
	if(vid <= -1)
		return 0;

	new
		string[300];

	format(string, sizeof(string), "PotaBee\t%s\nCheetos\t%s\nSprunk\t%s\nCofee\t%s\n",
	FormatMoney(VendingData[vid][vendingItemPrice][0]),
	FormatMoney(VendingData[vid][vendingItemPrice][1]),
	FormatMoney(VendingData[vid][vendingItemPrice][2]),
    FormatMoney(VendingData[vid][vendingItemPrice][3]));

	ShowPlayerDialog(playerid, DIALOG_VENDING_EDITPROD, DIALOG_STYLE_LIST, VendingData[vid][vendingName], string, "Buy", "Cancel");
	return 1;
}

VendingBuyMenu(playerid, vid)
{
	if(vid <= -1)
		return 0;

	new
		string[300];

	format(string, sizeof(string), "PotaBee\t%s\nCheetos\t%s\nSprunk\t%s\nCofee\t%s\n",
	FormatMoney(VendingData[vid][vendingItemPrice][0]),
	FormatMoney(VendingData[vid][vendingItemPrice][1]),
	FormatMoney(VendingData[vid][vendingItemPrice][2]),
    FormatMoney(VendingData[vid][vendingItemPrice][3]));
	
	ShowPlayerDialog(playerid, DIALOG_VENDING_BUYPROD, DIALOG_STYLE_LIST, VendingData[vid][vendingName], string, "Buy", "Cancel");
	
    return 1;
}

function VendingNgentot(playerid)
{
	new vid = pData[playerid][pInVending];

	VendingBuyMenu(playerid, vid);
}

ptask PlayerVendingUpdate[1000](playerid)
{
	foreach(new vid : Vendings)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]))
		{
			pData[playerid][pInVending] = vid;
			//Info(playerid, "DEBUG MESSAGE: Kamu berada di dekat Vending ID %d", vid);
		}
	}
	return 1;
}

GetAnyVendings()
{
	new tmpcount;
	foreach(new id : Vendings)
	{
     	tmpcount++;
	}
	return tmpcount;
}

ReturnVendingsID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_VENDING) return -1;
	foreach(new id : Vendings)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}

//=============== [ COMMAND VENDING ] ===============//
alias:createvending("createven")
CMD:createvending(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new query[512];
	new vendingid = Iter_Free(Vendings);

	new price;
	if(sscanf(params, "d", price))
		return Usage(playerid, "/createven [price]");

	if(vendingid == -1) 
		return Error(playerid, "You cant create more Vending");

	if((vendingid < 0 || vendingid >= MAX_VENDING))
        return Error(playerid, "You have already input %i Vending in this server.", MAX_VENDING);

	format(VendingData[vendingid][vendingOwner], 128, "-");
	VendingData[vendingid][vendingOwnerID] = 0;
	GetPlayerPos(playerid, VendingData[vendingid][vendingX], VendingData[vendingid][vendingY], VendingData[vendingid][vendingZ]);
	GetPlayerFacingAngle(playerid, VendingData[vendingid][vendingA]);

	VendingData[vendingid][vendingPrice] = price;
	VendingData[vendingid][vendingLock] = 1;
	VendingData[vendingid][vendingMoney] = 0;
	VendingData[vendingid][vendingStock] = 50;
	VendingData[vendingid][vendingRestock] = 0;

	Vending_RefreshObject(vendingid);
	Vending_RefreshText(vendingid);

	Iter_Add(Vendings, vendingid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO vending SET ID = '%d', owner = '%s', ownerid='%d', price = '%d', posx = '%f', posy = '%f', posz = '%f', posa = '%f', name = '%s'", vendingid, VendingData[vendingid][vendingOwner], VendingData[vendingid][vendingOwnerID], VendingData[vendingid][vendingPrice], VendingData[vendingid][vendingX], VendingData[vendingid][vendingY], VendingData[vendingid][vendingZ], VendingData[vendingid][vendingA], VendingData[vendingid][vendingName]);
	mysql_tquery(g_SQL, query, "OnVendingCreated", "di", playerid, vendingid);
	return 1;
}
alias:deletevending("deleteven")
CMD:deletevending(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/deleteven [id]");
	if(!Iter_Contains(Vendings, id)) return Error(playerid, "Invalid Vending ID.");
	
	DestroyDynamicObject(VendingData[id][vendingObject]);
	DestroyDynamic3DTextLabel(VendingData[id][vendingText]);
	
	VendingData[id][vendingX] = VendingData[id][vendingY] = VendingData[id][vendingZ] = VendingData[id][vendingRX] = VendingData[id][vendingRY] = VendingData[id][vendingRZ] = 0.0;
	VendingData[id][vendingInterior] = VendingData[id][vendingWorld] = 0;
	VendingData[id][vendingObject] = -1;
	VendingData[id][vendingText] = Text3D: -1;
	format(VendingData[id][vendingOwner], MAX_PLAYER_NAME, "-");
	VendingData[id][vendingLock] = 1;
    VendingData[id][vendingMoney] = 0;
	VendingData[id][vendingStock] = 0;
	VendingData[id][vendingRestock] = 0;

	Iter_Remove(Vendings, id);
	
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vending WHERE id = %d", id);
	mysql_tquery(g_SQL, query);
	SM(COLOR_RED, "Admin %s has deleted Vending ID %d", pData[playerid][pAdminname], id);
	new str[150];
	format(str,sizeof(str),"[Vending] %s membuat vending id %d!", GetRPName(playerid), id);
	LogServer("Admin", str);
	return 1;
}
alias:gotovending("gotovend")
CMD:gotovending(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotovend [id]");
	if(!Iter_Contains(Vendings, id)) return Error(playerid, "That Vending ID is not exists");
	
	SetPlayerPos(playerid, VendingData[id][vendingX] + 5, VendingData[id][vendingY], VendingData[id][vendingZ]);
	SetPlayerFacingAngle(playerid, VendingData[id][vendingA]);
    SetPlayerInterior(playerid, VendingData[id][vendingInterior]);
    SetPlayerVirtualWorld(playerid, VendingData[id][vendingWorld]);
	SendClientMessageEx(playerid, COLOR_LBLUE, "{FFFF00}You has teleport to Vending ID %d", id);
	return 1;
}
alias:editvending("editven")
CMD:editvending(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new id, name[24], param[50], ammount, text[24];
	if(sscanf(params, "is[24]S()[32]", id, name, param)) 
	{
		Usage(playerid, "/editven [id] [name]");
		Info(playerid, "Names: Name, Owner, Price, Pos, Stock, Restock");
		return 1;
	}	

	if(!Iter_Contains(Vendings, id)) return Error(playerid, "Invalid ID.");

	if(!strcmp(name, "name", true)) 
	{			
		if(sscanf(param, "s[24]", text))
			return Usage(playerid, "/editven [id] [name] [name]");

        format(VendingData[id][vendingName], 24, "%s", text);

		Vending_Save(id);
		Vending_RefreshText(id);
    }
	else if(!strcmp(name, "owner", true))
    {
		new otherid;
        if(sscanf(param, "d", otherid))
            return Usage(playerid, "/editven [id] [owner] [playerid] (use '-1' to no owner/ reset)");
		if(otherid == -1)
			return format(VendingData[id][vendingOwner], MAX_PLAYER_NAME, "-");

        format(VendingData[id][vendingOwner], MAX_PLAYER_NAME, pData[otherid][pName]);
		VendingData[id][vendingOwnerID] = pData[otherid][pID];
  
        Vending_Save(id);
        Vending_RefreshObject(id);
		Vending_RefreshText(id);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of Vending ID: %d to %s", pData[playerid][pAdminname], id, pData[otherid][pName]);
    }
	else if(!strcmp(name, "price", true)) 
	{			
		if(sscanf(param, "i", ammount))
			return Usage(playerid, "/editven [id] [price] [ammount]");

		VendingData[id][vendingPrice] = ammount;

		Vending_Save(id);
		Vending_RefreshText(id);
    } 
	else if(!strcmp(name, "pos", true)) 
	{			
		if(pData[playerid][EditingVending] != -1) return Error(playerid, "You're already editing.");
		if(!IsPlayerInRangeOfPoint(playerid, 30.0, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]))
			return Error(playerid, "You're not near the Vending you want to edit.");
		
		pData[playerid][EditingVending] = id;
		EditDynamicObject(playerid, VendingData[id][vendingObject]);
    } 
	else if(!strcmp(name, "stock", true)) 
	{			
		if(sscanf(param, "i", ammount))
			return Usage(playerid, "/editven [id] [stock] [ammount]");

		VendingData[id][vendingStock] = ammount;

		Vending_Save(id);
		Vending_RefreshText(id);
    } 
	else if(!strcmp(name, "restock", true)) 
	{			
		if(sscanf(param, "i", ammount))
			return Usage(playerid, "/editven [id] [stock] [0/1]");

		if(ammount < 0 || ammount > 1)
            return Error(playerid, "You must specify at least 0 or 1.");

		VendingData[id][vendingStock] = ammount;

		Vending_Save(id);
		Vending_RefreshText(id);
    } 
	return 1;
}

CMD:vendingmanage(playerid, params[])
{
	new vid = Vending_Nearest(playerid);
	if(vid == -1)
	{
		Vend(playerid, "Kamu tidak berada di dekat mesin Vending manapun");
	}
	else
	{
		if(!PlayerOwnVending(playerid, vid)) return Error(playerid, "Vending ini bukan milik anda!");
		ShowPlayerDialog(playerid, DIALOG_VENDING_MANAGE, DIALOG_STYLE_LIST, "Vending Manage", "Vending Information\nVending Change Name\nVending Vault\nVending Modify\nRequest Stock", "Select", "Cancel");
	}
	
	return 1;
}
alias:myvending("myven")
CMD:myvending(playerid)
{
	if(GetOwnedVending(playerid) == -1) return Error(playerid, "You don't have a vending machine.");
	new ved, _tmpstring[128], count = GetOwnedVending(playerid), CMDSString[1024];
	CMDSString = "";
	Loop(itt, (count + 1), 1)
	{
	    ved = ReturnPlayerVendingID(playerid, itt);
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s\n", itt, VendingData[ved][vendingName]);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s\n", itt, VendingData[ved][vendingName]);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_VENDING, DIALOG_STYLE_LIST, "{0000FF}My Vending", CMDSString, "Select", "Cancel");
	return 1;
}