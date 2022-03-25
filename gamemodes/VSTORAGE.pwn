enum VehicleStorageData
{
	vsMoney,
	vsWeapon[3],
	vsAmmo[3],
	vsRedMoney,
	vsSnack,
	vsSprunk,
	vsMedicine,
	vsMedkit,
	vsBandage,
	vsSeed,
	vsMaterial,
	vsMarijuana,
	vsComponent,
};
new vsData[MAX_PRIVATE_VEHICLE][VehicleStorageData];

Vehicle_WeaponStorage(playerid, vehicleid)
{
    if(vehicleid == -1)
        return 0;

    static
        string[320];

    string[0] = 0;

    for (new i = 0; i < 3; i ++)
    {
        if(!vsData[vehicleid][vsWeapon][i])
            format(string, sizeof(string), "%sEmpty Slot\n", string);

        else
            format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(vsData[vehicleid][vsWeapon][i]), vsData[vehicleid][vsAmmo][i]);
    }
    ShowPlayerDialog(playerid, VEHICLE_WEAPON, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}

Vehicle_OpenStorage(playerid, vehicleid)
{
    if(vehicleid == -1)
        return 0;
	foreach(new ii: PVehicles)
	{
		new vehid = pvData[ii][cVeh];	

		if(pvData[vehicleid][LoadedStorage] == false)
		{
			MySQL_CreateVehicleStorage(vehicleid, vehid);
		}
		else
		{
			new
				items[1],
				string[10 * 32];

			for (new i = 0; i < 3; i ++) if(vsData[vehicleid][vsWeapon][i]) 
			{
				items[0]++;
			}
			format(string, sizeof(string), "Weapon Storage (%d/3)\nMoney Safe\nDrugs\nOther", items[0]);

			ShowPlayerDialog(playerid, VEHICLE_STORAGE, DIALOG_STYLE_LIST, "Vehicle Trunk", string, "Select", "Cancel");
			return 1;
		}
		return 1;	
	}	
	return 1;
}

MySQL_LoadVehicleStorage(vehicleid)
{
	new query[1536];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `vstorage` WHERE `owner`='%d' LIMIT 1", pvData[vehicleid][cID]);
	mysql_tquery(g_SQL, query, "LoadVehicleTrunk", "i", vehicleid);
}

function LoadVehicleTrunk(vehicleid)
{
	new rows = cache_num_rows(), vehid = pvData[vehicleid][cVeh];
 	if(rows)
  	{
		for(new z = 0; z < rows; z++)
		{
			pvData[vehid][LoadedStorage] = true;
			cache_get_value_name_int(z, "money", vsData[vehid][vsMoney]);
            cache_get_value_name_int(z, "redmoney", vsData[vehid][vsRedMoney]);
            cache_get_value_name_int(z, "snack", vsData[vehid][vsSnack]);
            cache_get_value_name_int(z, "sprunk", vsData[vehid][vsSprunk]);
            cache_get_value_name_int(z, "medicine", vsData[vehid][vsMedicine]);
            cache_get_value_name_int(z, "medkit", vsData[vehid][vsMedkit]);
            cache_get_value_name_int(z, "bandage", vsData[vehid][vsBandage]);
            cache_get_value_name_int(z, "seed", vsData[vehid][vsSeed]);
			cache_get_value_name_int(z, "material", vsData[vehid][vsMaterial]);
			cache_get_value_name_int(z, "marijuana", vsData[vehid][vsMarijuana]);
			cache_get_value_name_int(z, "component", vsData[vehid][vsComponent]);
			cache_get_value_name_int(z, "weapon1", vsData[vehid][vsWeapon][0]);
			cache_get_value_name_int(z, "ammo1", vsData[vehid][vsAmmo][0]);
			cache_get_value_name_int(z, "weapon2", vsData[vehid][vsWeapon][1]);
			cache_get_value_name_int(z, "ammo2", vsData[vehid][vsAmmo][1]);
			cache_get_value_name_int(z, "weapon3", vsData[vehid][vsWeapon][2]);
			cache_get_value_name_int(z, "ammo3", vsData[vehid][vsAmmo][2]);
		}
	}
}

Vehicle_StorageSave(vehicleid)
{
	new cQuery[1536], x = pvData[vehicleid][cVeh];
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE `vstorage` SET ");
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`money`= %d,", cQuery, vsData[x][vsMoney]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`redmoney`= %d,", cQuery, vsData[x][vsRedMoney]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`snack`= %d,", cQuery, vsData[x][vsSnack]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`sprunk`= %d,", cQuery, vsData[x][vsSprunk]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`medicine`= %d,", cQuery, vsData[x][vsMedicine]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`medkit`= %d,", cQuery, vsData[x][vsMedkit]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`bandage`= %d,", cQuery, vsData[x][vsBandage]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`seed`= %d,", cQuery, vsData[x][vsSeed]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`material`= %d,", cQuery, vsData[x][vsMaterial]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`marijuana`= %d,", cQuery, vsData[x][vsMarijuana]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`component`= %d,", cQuery, vsData[x][vsComponent]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weapon1` = %d, `ammo1` = %d,", cQuery, vsData[x][vsWeapon][0], vsData[x][vsAmmo][0]);		
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weapon2` = %d, `ammo2` = %d,", cQuery, vsData[x][vsWeapon][1], vsData[x][vsAmmo][1]);		
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weapon3` = %d, `ammo3` = %d ", cQuery, vsData[x][vsWeapon][2], vsData[x][vsAmmo][2]);		
    mysql_format(g_SQL, cQuery, sizeof(cQuery), "%sWHERE `owner` = %d", cQuery, pvData[vehicleid][cID]);
	mysql_query(g_SQL, cQuery);
	return 1;
}

function MySQL_CreateVehicleStorage(vehicleid, vehid)
{
	new query[512];

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `vstorage` (`owner`) VALUES ('%d')", pvData[vehicleid][cID]);
	mysql_tquery(g_SQL, query);

	vsData[vehicleid][vsMoney] = 0;
    vsData[vehicleid][vsRedMoney] = 0;
    vsData[vehicleid][vsSnack] = 0;
    vsData[vehicleid][vsSprunk] = 0;
    vsData[vehicleid][vsMedicine] = 0;
    vsData[vehicleid][vsMedkit] = 0;
    vsData[vehicleid][vsBandage] = 0;
    vsData[vehicleid][vsSeed] = 0;
    vsData[vehicleid][vsMaterial] = 0;
	vsData[vehicleid][vsMarijuana] = 0;
	vsData[vehicleid][vsComponent] = 0;
	pvData[vehid][LoadedStorage] = true;
	for (new h4n = 0; h4n < 5; h4n ++)
    {
        vsData[vehicleid][vsWeapon][h4n] = 0;

		vsData[vehicleid][vsAmmo][h4n] = 0;
    }
}

function CheckVehicleStorageStatus(playerid, vehicleid, vid)
{
	new count = cache_num_rows();
	if(count)
	{
		Vehicle_OpenStorage(playerid, vehicleid);
	}
	else
	{
		MySQL_CreateVehicleStorage(vid, vehicleid);
	}
}