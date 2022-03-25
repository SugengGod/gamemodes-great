//Family System
#define MAX_FAMILY 20

enum familyss
{
	fName[50],
	fLeader[MAX_PLAYER_NAME],
	fMotd[100],
	fColor,
	Float:fExtposX,
	Float:fExtposY,
	Float:fExtposZ,
	Float:fExtposA,
	Float:fIntposX,
	Float:fIntposY,
	Float:fIntposZ,
	Float:fIntposA,
	fInt,
	Float:fSafeposX,
	Float:fSafeposY,
	Float:fSafeposZ,
	Float:fSafeposA,
	fMoney,
	fMarijuana,
	fComponent,
	fMaterial,
	fGun[15],
	fAmmo[15],
	//Not Save
	Text3D:fLabelext,
	Text3D:fLabelint,
	Text3D:fLabelsafe,
	fPickext,
	fPickint,
	fPicksafe
};

new fData[MAX_FAMILY][familyss],
	Iterator:FAMILYS<MAX_FAMILY>;

enum famInt
{
    intName[32],
    intID,
    Float:intX,
    Float:intY,
    Float:intZ,
    Float:intA
}

new const famInteriorArray[][famInt] =
{
	{"Int Gang 1", 	1, -577.2970, 127.0044, 1501.0859, 0.0000},
	{"Int Gang 2", 	2, 1408.7548, -1646.7239, 1259.8119, 0.0000}
};

Family_Save(id)
{
	new dquery[2048];
	format(dquery, sizeof(dquery), "UPDATE familys SET name='%s', leader='%s', motd='%s', color='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', intposx='%f', intposy='%f', intposz='%f', intposa='%f', fint='%d'",
	fData[id][fName],
	fData[id][fLeader],
	fData[id][fMotd],
	fData[id][fColor],
	fData[id][fExtposX],
	fData[id][fExtposY],
	fData[id][fExtposZ],
	fData[id][fExtposA],
	fData[id][fIntposX],
	fData[id][fIntposY],
	fData[id][fIntposZ],
	fData[id][fIntposA],
	fData[id][fInt]);
	
	for (new i = 0; i < 15; i ++) 
	{
        format(dquery, sizeof(dquery), "%s, Weapon%d='%d', Ammo%d='%d'", dquery, i + 1, fData[id][fGun][i], i + 1, fData[id][fAmmo][i]);
    }
	
	format(dquery, sizeof(dquery), "%s, safex='%f', safey='%f', safez='%f', money='%d', marijuana='%d', component='%d', material='%d' WHERE ID='%d'",
	dquery,
	fData[id][fSafeposX],
	fData[id][fSafeposY],
	fData[id][fSafeposZ],
	fData[id][fMoney],
	fData[id][fMarijuana],
	fData[id][fComponent],
	fData[id][fMaterial],
	id);
	return mysql_tquery(g_SQL, dquery);
}


Family_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamic3DTextLabel(fData[id][fLabelext]))
            DestroyDynamic3DTextLabel(fData[id][fLabelext]);

        if(IsValidDynamicPickup(fData[id][fPickext]))
            DestroyDynamicPickup(fData[id][fPickext]);

        if(IsValidDynamic3DTextLabel(fData[id][fLabelint]))
            DestroyDynamic3DTextLabel(fData[id][fLabelint]);

        if(IsValidDynamicPickup(fData[id][fPickint]))
            DestroyDynamicPickup(fData[id][fPickint]);
			
		if(IsValidDynamic3DTextLabel(fData[id][fLabelsafe]))
            DestroyDynamic3DTextLabel(fData[id][fLabelsafe]);

        if(IsValidDynamicPickup(fData[id][fPicksafe]))
            DestroyDynamicPickup(fData[id][fPicksafe]);
		
		new mstr[512], tstr[128];
		format(mstr,sizeof(mstr),"[Family ID: %d]\n{FFFFFF}%s\n{FFFFFF}Press {FF0000}ENTER {FFFFFF}to enter", id, fData[id][fName]);
		fData[id][fPickext] = CreateDynamicPickup(19130, 23, fData[id][fExtposX], fData[id][fExtposY], fData[id][fExtposZ], 0, 0, -1, 50);
		fData[id][fLabelext] = CreateDynamic3DTextLabel(mstr, COLOR_YELLOW, fData[id][fExtposX], fData[id][fExtposY], fData[id][fExtposZ]+0.35, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);

        if(fData[id][fIntposX] != 0.0 && fData[id][fIntposY] != 0.0 && fData[id][fIntposZ] != 0.0)
        {
            format(mstr,sizeof(mstr),"[Family ID: %d]\n{FFFFFF}%s\n{FFFFFF}Press {FF0000}ENTER {FFFFFF}to exit", id, fData[id][fName]);

            fData[id][fLabelint] = CreateDynamic3DTextLabel(mstr, COLOR_YELLOW, fData[id][fIntposX], fData[id][fIntposY], fData[id][fIntposZ]+0.7, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, id, fData[id][fInt]);
            fData[id][fPickint] = CreateDynamicPickup(19130, 23, fData[id][fIntposX], fData[id][fIntposY], fData[id][fIntposZ], id, fData[id][fInt], -1, 50);
        }
		if(fData[id][fSafeposX] != 0.0 && fData[id][fSafeposY] != 0.0 && fData[id][fSafeposZ] != 0.0)
		{
			format(tstr, sizeof(tstr), "[Family ID: %d]\nSafe Point", id);
			fData[id][fLabelsafe] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, fData[id][fSafeposX], fData[id][fSafeposY], fData[id][fSafeposZ]+0.7, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, id, fData[id][fInt]);
            fData[id][fPicksafe] = CreateDynamicPickup(1239, 23, fData[id][fSafeposX], fData[id][fSafeposY], fData[id][fSafeposZ], id, fData[id][fInt], -1, 50);
		}
	}
}

/*LoadFamily()
{
	mysql_tquery(g_SQL, "SELECT ID,name,leader,motd,color,extposx,extposy,extposz,extposa,intposx,intposy,intposz,intposa,fint,safex,safey,safez,money,marijuana FROM familys ORDER BY ID", "LoadFamilyData");
}*/

Family_WeaponStorage(playerid, fid)
{
    if(fid == -1)
        return 0;

    static
        string[320];

    string[0] = 0;

    for (new i = 0; i < 15; i ++)
    {
        if(!fData[fid][fGun][i])
            format(string, sizeof(string), "%sSlot Kosong\n", string);

        else
            format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(fData[fid][fGun][i]), fData[fid][fAmmo][i]);
    }
    ShowPlayerDialog(playerid, FAMILY_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}

Family_OpenStorage(playerid, fid)
{
    if(fid == -1)
        return 0;

    new
        items[1],
        string[10 * 32];

    for (new i = 0; i < 15; i ++) if(fData[fid][fGun][i]) 
	{
        items[0]++;
    }
    format(string, sizeof(string), "Weapon Storage (%d/15)", items[0]);
    ShowPlayerDialog(playerid, FAMILY_STORAGE, DIALOG_STYLE_LIST, "Family Storage", string, "Select", "Cancel");
    return 1;
}

function OnFamilyCreated(id)
{
	Family_Save(id);
	Family_Refresh(id);
	return 1;
}

function LoadFamilys()
{
    new rows = cache_num_rows();
 	if(rows)
  	{
   		new fid, name[50], leader[MAX_PLAYER_NAME], motd[100];
		for(new i; i < rows; i++)
		{
  			cache_get_value_name_int(i, "ID", fid);
	    	cache_get_value_name(i, "name", name);
			format(fData[fid][fName], 50, name);
		    cache_get_value_name(i, "leader", leader);
			format(fData[fid][fLeader], MAX_PLAYER_NAME, leader);
			cache_get_value_name(i, "motd", motd);
			format(fData[fid][fMotd], 100, motd);
		    cache_get_value_name_int(i, "color", fData[fid][fColor]);
		    cache_get_value_name_float(i, "extposx", fData[fid][fExtposX]);
		    cache_get_value_name_float(i, "extposy", fData[fid][fExtposY]);
		    cache_get_value_name_float(i, "extposz", fData[fid][fExtposZ]);
		    cache_get_value_name_float(i, "extposa", fData[fid][fExtposA]);
		    cache_get_value_name_float(i, "intposx", fData[fid][fIntposX]);
		    cache_get_value_name_float(i, "intposy", fData[fid][fIntposY]);
		    cache_get_value_name_float(i, "intposz", fData[fid][fIntposZ]);
		    cache_get_value_name_float(i, "intposa", fData[fid][fIntposA]);
		    cache_get_value_name_int(i, "fint", fData[fid][fInt]);
			cache_get_value_name_float(i, "safex", fData[fid][fSafeposX]);
			cache_get_value_name_float(i, "safey", fData[fid][fSafeposY]);
			cache_get_value_name_float(i, "safez", fData[fid][fSafeposZ]);
			cache_get_value_name_int(i, "money", fData[fid][fMoney]);
			cache_get_value_name_int(i, "marijuana", fData[fid][fMarijuana]);
			cache_get_value_name_int(i, "component", fData[fid][fComponent]);
			cache_get_value_name_int(i, "material", fData[fid][fMaterial]);
			
			cache_get_value_name_int(i, "Weapon1", fData[fid][fGun][0]);
			cache_get_value_name_int(i, "Weapon2", fData[fid][fGun][1]);
			cache_get_value_name_int(i, "Weapon3", fData[fid][fGun][2]);
			cache_get_value_name_int(i, "Weapon4", fData[fid][fGun][3]);
			cache_get_value_name_int(i, "Weapon5", fData[fid][fGun][4]);
			cache_get_value_name_int(i, "Weapon6", fData[fid][fGun][5]);
			cache_get_value_name_int(i, "Weapon7", fData[fid][fGun][6]);
			cache_get_value_name_int(i, "Weapon8", fData[fid][fGun][7]);
			cache_get_value_name_int(i, "Weapon9", fData[fid][fGun][8]);
			cache_get_value_name_int(i, "Weapon10", fData[fid][fGun][9]);
			cache_get_value_name_int(i, "Weapon11", fData[fid][fGun][10]);
			cache_get_value_name_int(i, "Weapon12", fData[fid][fGun][11]);
			cache_get_value_name_int(i, "Weapon13", fData[fid][fGun][12]);
			cache_get_value_name_int(i, "Weapon14", fData[fid][fGun][13]);
			cache_get_value_name_int(i, "Weapon15", fData[fid][fGun][14]);
			
			cache_get_value_name_int(i, "Ammo1", fData[fid][fAmmo][0]);
			cache_get_value_name_int(i, "Ammo2", fData[fid][fAmmo][1]);
			cache_get_value_name_int(i, "Ammo3", fData[fid][fAmmo][2]);
			cache_get_value_name_int(i, "Ammo4", fData[fid][fAmmo][3]);
			cache_get_value_name_int(i, "Ammo5", fData[fid][fAmmo][4]);
			cache_get_value_name_int(i, "Ammo6", fData[fid][fAmmo][5]);
			cache_get_value_name_int(i, "Ammo7", fData[fid][fAmmo][6]);
			cache_get_value_name_int(i, "Ammo8", fData[fid][fAmmo][7]);
			cache_get_value_name_int(i, "Ammo9", fData[fid][fAmmo][8]);
			cache_get_value_name_int(i, "Ammo10", fData[fid][fAmmo][9]);
			cache_get_value_name_int(i, "Ammo11", fData[fid][fAmmo][10]);
			cache_get_value_name_int(i, "Ammo12", fData[fid][fAmmo][11]);
			cache_get_value_name_int(i, "Ammo13", fData[fid][fAmmo][12]);
			cache_get_value_name_int(i, "Ammo14", fData[fid][fAmmo][13]);
			cache_get_value_name_int(i, "Ammo15", fData[fid][fAmmo][14]);
			/*for (new j = 0; j < 10; j ++)
			{
				format(str, 24, "Weapon%d", j + 1);
				cache_get_value_name_int(i, str, fData[fid][fGun][j]);

				format(str, 24, "Ammo%d", j + 1);
				cache_get_value_name_int(i, str, fData[fid][fAmmo][j]);
			}*/
			
			Iter_Add(FAMILYS, fid);
			Family_Refresh(fid);
	    }
	    printf("[Familys]: %d Loaded.", rows);
	}
}

//----------[ Family Commands ]-----------


CMD:fcreate(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pFactionModerator] < 1)
			return PermissionError(playerid);
		
	new fid = Iter_Free(FAMILYS);
	if(fid == -1) return Error(playerid, "You cant create more family slot empty!");
	new name[50], otherid, query[128];
	if(sscanf(params, "s[50]u", name, otherid)) return Usage(playerid, "/fcreate [name] [playerid]");
	if(otherid == INVALID_PLAYER_ID)
		return Error(playerid, "invalid playerid.");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");
		
	if(pData[otherid][pFaction] != 0)
		return Error(playerid, "Player tersebut sudah bergabung faction");
		
	pData[otherid][pFamily] = fid;
	pData[otherid][pFamilyRank] = 6;
		
	format(fData[fid][fName], 50, name);
	format(fData[fid][fLeader], 50, pData[otherid][pName]);
	format(fData[fid][fMotd], 50, "None");
	fData[fid][fColor] = 0;
	fData[fid][fExtposX] = 0;
	fData[fid][fExtposY] = 0;
	fData[fid][fExtposZ] = 0;
	fData[fid][fExtposA] = 0;
	
	fData[fid][fIntposX] = 0;
	fData[fid][fIntposY] = 0;
	fData[fid][fIntposZ] = 0;
	fData[fid][fIntposA] = 0;
	fData[fid][fInt] = 0;
	
	fData[fid][fMoney] = 0;
	fData[fid][fMarijuana] = 0;
	fData[fid][fComponent] = 0;
	fData[fid][fMaterial] = 0;
	fData[fid][fSafeposX] = 0;
	fData[fid][fSafeposY] = 0;
	fData[fid][fSafeposZ] = 0;

	Iter_Add(FAMILYS, fid);
	Servers(playerid, "Anda telah berhasil membuat family ID: %d dengan leader: %s", fid, pData[otherid][pName]);
	Servers(otherid, "Admin %s telah menset anda sebagai leader dari family ID: %d", pData[playerid][pAdminname], fid);
	SendStaffMessage(COLOR_RED, "Admin %s telah membuat family ID: %d dengan leader: %s", pData[playerid][pAdminname], fid, pData[otherid][pName]);
	new str[150];
	format(str,sizeof(str),"[Family]: %s membuat family id %d!", GetRPName(playerid), fid);
	LogServer("Admin", str);	

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO familys SET ID=%d, name='%s', leader='%s'", fid, name, pData[otherid][pName]);
	mysql_tquery(g_SQL, query, "OnFamilyCreated", "i", fid);
	return 1;
}

CMD:fdelete(playerid, params[])
{
 	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pFactionModerator] < 1)
			return PermissionError(playerid);

    new fid, query[128];
	if(sscanf(params, "i", fid)) return Usage(playerid, "/fdelete [fid]");
	if(!Iter_Contains(FAMILYS, fid)) return Error(playerid, "The you specified ID of doesn't exist.");
	
    format(fData[fid][fName], 50, "None");
	format(fData[fid][fLeader], 50, "None");
	format(fData[fid][fMotd], 50, "None");
	fData[fid][fColor] = 0;
	fData[fid][fExtposX] = 0;
	fData[fid][fExtposY] = 0;
	fData[fid][fExtposZ] = 0;
	fData[fid][fExtposA] = 0;
	
	fData[fid][fIntposX] = 0;
	fData[fid][fIntposY] = 0;
	fData[fid][fIntposZ] = 0;
	fData[fid][fIntposA] = 0;
	fData[fid][fInt] = 0;
	
	fData[fid][fMoney] = 0;
	fData[fid][fMarijuana] = 0;
	fData[fid][fComponent] = 0;
	fData[fid][fMaterial] = 0;
	fData[fid][fSafeposX] = 0;
	fData[fid][fSafeposY] = 0;
	fData[fid][fSafeposZ] = 0;
	
	DestroyDynamic3DTextLabel(fData[fid][fLabelext]);
	DestroyDynamicPickup(fData[fid][fPickext]);
	DestroyDynamic3DTextLabel(fData[fid][fLabelint]);
	DestroyDynamicPickup(fData[fid][fPickint]);
	DestroyDynamic3DTextLabel(fData[fid][fLabelsafe]);
	DestroyDynamicPickup(fData[fid][fPicksafe]);
	Iter_Remove(FAMILYS, fid);
	
	mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET family=-1,familyrank=0 WHERE family=%d", fid);
	mysql_tquery(g_SQL, query);
	
	foreach(new ii : Player)
	{
 		if(pData[ii][pFamily] == fid)
   		{
			pData[ii][pFamily]= -1;
			pData[ii][pFamilyRank] = 0;
		}
	}

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM familys WHERE ID=%d", fid);
	mysql_tquery(g_SQL, query);
    SendStaffMessage(COLOR_RED, "Admin %s telah menghapus family ID: %d.", pData[playerid][pAdminname], fid);
	new str[150];
	format(str,sizeof(str),"[Family]: %s menghapus family id %d!", GetRPName(playerid), fid);
	LogServer("Admin", str);	
	return 1;
}

CMD:fedit(playerid, params[])
{
    static
        fid,
        type[24],
        string[128],
		otherid;

    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pFactionModerator] < 1)
			return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", fid, type, string))
    {
        Usage(playerid, "/fedit [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, name, leader, safe, money, marijuana");
        return 1;
    }
    if((fid < 0 || fid >= MAX_FAMILY))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(FAMILYS, fid)) return Error(playerid, "The you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]);
		GetPlayerFacingAngle(playerid, fData[fid][fExtposA]);

        Family_Save(fid);
		Family_Refresh(fid);

        SendStaffMessage(COLOR_RED, "%s has adjusted the location of entrance ID: %d.", pData[playerid][pAdminname], fid);
    }
    else if(!strcmp(type, "interior", true))
    {
        GetPlayerPos(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ]);
		GetPlayerFacingAngle(playerid, fData[fid][fIntposA]);

		fData[fid][fInt] = GetPlayerInterior(playerid);
        Family_Save(fid);
		Family_Refresh(fid);

        SendStaffMessage(COLOR_RED, "%s has adjusted the interior spawn of entrance ID: %d.", pData[playerid][pAdminname], fid);
    }
    else if(!strcmp(type, "name", true))
    {
        new name[50];

        if(sscanf(string, "s[50]", name))
            return Usage(playerid, "/fedit [id] [name] [fname]");

        format(fData[fid][fName], 50, name);
		Family_Save(fid);
		Family_Refresh(fid);

        SendStaffMessage(COLOR_LRED, "Admin %s has changed the family name ID: %d to: %s.", pData[playerid][pAdminname], fid, name);
    }
    else if(!strcmp(type, "leader", true))
    {
        if(sscanf(string, "d", otherid))
            return Usage(playerid, "/fedit [id] [leader] [playerid]");
		
		if(otherid == INVALID_PLAYER_ID)
			return Error(playerid, "invalid player fid");

        format(fData[fid][fLeader], 50, pData[otherid][pName]);
		Family_Save(fid);
		Family_Refresh(fid);

        SendStaffMessage(COLOR_LRED, "Admin %s has changed the family leader ID: %d to: %s.", pData[playerid][pAdminname], fid, pData[otherid][pName]);
    }
    else if(!strcmp(type, "safe", true))
    {
        GetPlayerPos(playerid, fData[fid][fSafeposX], fData[fid][fSafeposY], fData[fid][fSafeposZ]);

        Family_Save(fid);
		Family_Refresh(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the family safepos ID: %d.", pData[playerid][pAdminname], fid);
    }
    else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return Usage(playerid, "/fedit [id] [money] [ammount]");

        fData[fid][fMoney] = money;
		
        Family_Save(fid);
		Family_Refresh(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the family money ID: %d to %s.", pData[playerid][pAdminname], fid, FormatMoney(money));
    }
    else if(!strcmp(type, "marijuana", true))
    {
        new marijuana;

        if(sscanf(string, "d", marijuana))
            return Usage(playerid, "/fedit [id] [marijuana] [ammount]");

        fData[fid][fMarijuana] = marijuana;
		
        Family_Save(fid);
		Family_Refresh(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the family marijuana ID: %d to %s.", pData[playerid][pAdminname], fid, marijuana);
    }
	else if(!strcmp(type, "component", true))
    {
        new comp;

        if(sscanf(string, "d", comp))
            return Usage(playerid, "/fedit [id] [component] [ammount]");

        fData[fid][fComponent] = comp;
		
        Family_Save(fid);
		Family_Refresh(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the family component ID: %d to %s.", pData[playerid][pAdminname], fid, comp);
    }
	else if(!strcmp(type, "material", true))
    {
        new mat;

        if(sscanf(string, "d", mat))
            return Usage(playerid, "/fedit [id] [material] [ammount]");

        fData[fid][fMarijuana] = mat;
		
        Family_Save(fid);
		Family_Refresh(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the family material ID: %d to %s.", pData[playerid][pAdminname], fid, mat);
    }
    return 1;
}

CMD:fsafe(playerid)
{
	if(pData[playerid][pFamily] == -1)
		return Error(playerid, "Anda bukan anggota family");
		
	new fid = pData[playerid][pFamily];
	if(IsPlayerInRangeOfPoint(playerid, 3.0, fData[fid][fSafeposX], fData[fid][fSafeposY], fData[fid][fSafeposZ]))
    {
     	ShowPlayerDialog(playerid, FAMILY_SAFE, DIALOG_STYLE_LIST, "Family SAFE", "Storage\nMarijuana\nComponent\nMaterial\nMoney", "Select", "Cancel");
    }
 	else
   	{
     	Error(playerid, "You aren't in range in area family safe.");
    }
	return 1;
}

CMD:finvite(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)
		return Error(playerid, "You are not in family!");
		
	if(pData[playerid][pFamilyRank] < 5)
		return Error(playerid, "You must family rank 5 - 6!");
	
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/invite [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
		
	if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family!");
	
	if(pData[otherid][pFaction] != 0)
		return Error(playerid, "Player tersebut sudah bergabung faction!");
		
	pData[otherid][pFamInvite] = pData[playerid][pFamily];
	pData[otherid][pFamOffer] = playerid;
	Servers(playerid, "Anda telah menginvite %s untuk menjadi anggota family.", pData[otherid][pName]);
	Servers(otherid, "%s telah menginvite anda untuk menjadi anggota family. Type: /accept family or /deny family!", pData[playerid][pName]);
	return 1;
}

CMD:funinvite(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)
		return Error(playerid, "You are not in family!");
		
	if(pData[playerid][pFamilyRank] < 5)
		return Error(playerid, "You must family level 5 - 6!");
	
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/uninvite [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pFamilyRank] > pData[playerid][pFamilyRank])
		return Error(playerid, "You cant kick him.");
		
	pData[otherid][pFamilyRank] = 0;
	pData[otherid][pFamily] = -1;
	Servers(playerid, "Anda telah mengeluarkan %s dari anggota family.", pData[otherid][pName]);
	Servers(otherid, "%s telah mengeluarkan anda dari anggota family.", pData[playerid][pName]);
	return 1;
}

CMD:foffkick(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)
		return Error(playerid, "You are not in family!");
		
	if(pData[playerid][pFamilyRank] < 5)
		return Error(playerid, "You must family level 5 - 6!");
	
	new username[MAX_PLAYER_NAME];
    if(sscanf(params, "s[24]", username))
        return Usage(playerid, "/foffkick [PartOfName]");
		
	if(IsPlayerOnline(username))
		return Error(playerid, "Player tersebut online.");
		
	new query[200];	
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `username`='%s'", username);
	mysql_tquery(g_SQL, query, "FamKickOffline", "is", playerid, username);
	return 1;
}

CMD:fsetrank(playerid, params[])
{
	new rank, otherid;
	if(pData[playerid][pFamilyRank] < 6)
		return Error(playerid, "You must family leader!");
		
	if(sscanf(params, "ud", otherid, rank))
        return Usage(playerid, "/fsetrank [playerid/PartOfName] [rank 1-6]");
	
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pFamily] != pData[playerid][pFamily])
		return Error(playerid, "This player is not in your family!");
	
	if(rank < 1 || rank > 6)
		return Error(playerid, "rank must 1 - 6 only");
	
	pData[otherid][pFamilyRank] = rank;
	Servers(playerid, "You has set %s family rank to level %d", pData[otherid][pName], rank);
	Servers(otherid, "%s has set your family rank to level %d", pData[playerid][pName], rank);
	return 1;
}

CMD:f(playerid, params[])
{
    new text[128];
    
    if(pData[playerid][pFamily] == -1)
        return Error(playerid, "You must in family member to use this command");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/f(family) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");
	
	SendFamilyMessage(pData[playerid][pFamily], COLOR_FAMILY, ""FAMILY_E"* %s %s: %s *", GetFamilyRank(playerid), pData[playerid][pName], params);
    return 1;
}

alias:finfo("fstat", "fstats")
CMD:finfo(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)
        return Error(playerid, "You must in family member to use this command!");
	
	ShowPlayerDialog(playerid, FAMILY_INFO, DIALOG_STYLE_LIST, "Family Info", "Family Info\nFamily Online\nFamily Member", "Select", "Cancel");
	return 1;
}

CMD:flist(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

	for(new i = 0; i < MAX_FAMILY; i ++)
	{
	    {
			new queryBuffer[128];
			mysql_format(g_SQL, queryBuffer, sizeof(queryBuffer), "SELECT COUNT(*) FROM familys WHERE ID = %i", i);
		    mysql_tquery(g_SQL, queryBuffer, "ListFamilys", "ii", playerid, i);
		}
	}	
	return 1;
}

function ListFamilys(playerid, ListFamily)
{
	new rows = cache_num_rows();
 	if(rows)
  	{
		new fname[50],
 			fleader[50],
			string[512];

		cache_get_value_index(0, 0, fname);
		cache_get_value_index(0, 1, fleader);

		format(string, sizeof(string), "%d\t%s\t%s\n", ListFamily, fname, fleader);
		
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "List Famliys", string, "Okay", "");
	}
}

function ShowFamilyInfo(playerid)
{
	new rows = cache_num_rows();
 	if(rows)
  	{
 		new fname[50],
 			fleader[50],
			fmarijuana,
			fcomponent,
			fmaterial,
			fmoney,
			string[512];
			
		cache_get_value_index(0, 0, fname);
		cache_get_value_index(0, 1, fleader);
		cache_get_value_index_int(0, 2, fmarijuana);
		cache_get_value_index_int(0, 3, fcomponent);
		cache_get_value_index_int(0, 4, fmaterial);
		cache_get_value_index_int(0, 5, fmoney);

		format(string, sizeof(string), "Family ID: %d\nFamily Name: %s\nFamily Leader: %s\nFamily Marijuana: %d\nFamily Component: %d\nFamily Material: %d\nFamily Money: %s",
		pData[playerid][pFamily], fname, fleader, fmarijuana, fcomponent, fmaterial, FormatMoney(fmoney));
		
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Family Info", string, "Okay", "");
	}
}

function ShowFamilyMember(playerid)
{
	new rows = cache_num_rows(), pid, username[50], frank, query[1048];
 	if(rows)
  	{
		for(new i = 0; i != rows; i++)
		{
			cache_get_value_index(i, 0, username);
			pid = GetID(username);
			
			format(query, sizeof(query), "%s"WHITE_E"%d. %s ", query, (i+1), username);
			
			if(IsPlayerConnected(pid))
				strcat(query, ""GREEN_E"(ONLINE) ");
			else
				strcat(query, ""RED_E"(OFFLINE) ");
			
			cache_get_value_index_int(i, 1, frank);
			if(frank == 1)
			{
				strcat(query, ""FAMILY_E"Outsider(1)");
			}
			else if(frank == 2)
			{
				strcat(query, ""FAMILY_E"Associate(2)");
			}
			else if(frank == 3)
			{
				strcat(query, ""FAMILY_E"Soldier(3)");
			}
			else if(frank == 4)
			{
				strcat(query, ""FAMILY_E"Advisor(4)");
			}
			else if(frank == 5)
			{
				strcat(query, ""FAMILY_E"UnderBoss(5)");
			}
			else if(frank == 6)
			{
				strcat(query, ""FAMILY_E"GodFather(6)");
			}
			else
			{
				strcat(query, ""FAMILY_E"None(0)");
			}
			strcat(query, "\n{FFFFFF}");
		}
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Family Member", query, "Okay", "");
	}
}

CMD:famint(playerid, params[])
{
	static list[4096];

    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pFactionModerator] < 1)
			return PermissionError(playerid);

	if(isnull(list))
	{
	    for(new i = 0; i < sizeof(famInteriorArray); i ++)
	    {
	        format(list, sizeof(list), "%s\n%s", list, famInteriorArray[i][intName]);
		}
	}

	ShowPlayerDialog(playerid, DIALOG_FAMILY_INTERIOR, DIALOG_STYLE_LIST, "Pilih interior untuk teleport.", list, "Pilih", "Batal");
	return 1;
}

forward FamKickOffline(playerid, username[]);
public FamKickOffline(playerid, username[])
{
	new rows = cache_num_rows(), fam, famrank, id;
	
	cache_get_value_name_int(0, "family", fam);
	cache_get_value_name_int(0, "familyrank", famrank);
	cache_get_value_name_int(0, "reg_id", id);
	if(rows > 0)
	{
		if(fam != pData[playerid][pFamily])
		{
			return Error(playerid, "Player tersebut tidak gabung dengan family kamu!");
		}
		else if(famrank > pData[playerid][pFamilyRank])
		{
			return Error(playerid, "Player tersebut memiliki peringkat/rank lebih tinggi dari kamu!");
		}	
		else
		{
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET family=-1,familyrank=0 WHERE reg_id=%d", id);
			mysql_tquery(g_SQL, query);
		
			Info(playerid, "Kamu berhasil kick %s dari family", username);
		}
	}
	else
	{
		Error(playerid, "Nama tersebut tidak ada difamily kamu");
	}
	return 1;
}