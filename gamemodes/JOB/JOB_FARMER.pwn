//kentang 760
//gandum 804
//jeruk 949
//ganja 19473
//-383.67, -1438.90, 26.32
//Drug 874.52, -15.98, 63.19

CreateJoinFarmerPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, -383.67, -1438.90, 26.32, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[FARMER JOBS]\n{ffffff}Jadilah Pekerja Petani disini\n{7fffd4}/getjob /accept job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -383.67, -1438.90, 26.32, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
}

#define MAX_PLANT 1000

enum E_PLANT
{
	// loaded from db
	PlantType,
	PlantTime,
	Float:PlantX,
	Float:PlantY,
	Float:PlantZ,
	//temp
	bool:PlantHarvest,
	PlantTimer,
	PlantObjID,
	PlantCP,
	Text3D:PlantLabel
}

new PlantData[MAX_PLANT][E_PLANT],
	Iterator:Plants<MAX_PLANT>;
	
GetClosestPlant(playerid, Float: range = 2.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : Plants)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, PlantData[i][PlantX], PlantData[i][PlantY], PlantData[i][PlantZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}

GetNearPlant(playerid, Float: range = 3.5)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : Plants)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, PlantData[i][PlantX], PlantData[i][PlantY], PlantData[i][PlantZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}

Plant_Refresh(id)
{
	if(id != -1)
    {
		if(IsValidDynamicObject(PlantData[id][PlantObjID]))
			DestroyDynamicObject(PlantData[id][PlantObjID]);
		
		if(IsValidDynamicCP(PlantData[id][PlantCP]))
			DestroyDynamicCP(PlantData[id][PlantCP]);
		
		if(PlantData[id][PlantType] == 1)
		{
			if(PlantData[id][PlantTime] > 2400)
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(760, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-1.5, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
			else if(PlantData[id][PlantTime] < 2400 && PlantData[id][PlantTime] > 10)
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(760, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-1.3, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
			else
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(760, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-1.0, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
		}
		else if(PlantData[id][PlantType] == 2)
		{
			if(PlantData[id][PlantTime] > 2400)
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(804, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-1.0, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
			else if(PlantData[id][PlantTime] < 2400 && PlantData[id][PlantTime] > 10)
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(804, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-0.5, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
			else
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(804, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
		}
		else if(PlantData[id][PlantType] == 3)
		{
			if(PlantData[id][PlantTime] > 2400)
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(949, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-1.0, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
			else if(PlantData[id][PlantTime] < 2400 && PlantData[id][PlantTime] > 10)
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(949, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-0.7, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
			else
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(949, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-0.4, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
		}
		else if(PlantData[id][PlantType] == 4)
		{
			if(PlantData[id][PlantTime] > 2400)
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(19473, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-2.0, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
			else if(PlantData[id][PlantTime] < 2400 && PlantData[id][PlantTime] > 10)
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(19473, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-1.5, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
			else
			{
				PlantData[id][PlantObjID] = CreateDynamicObject(19473, PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ]-1.0, 0.0, 0.0, 0.0, -1, -1, -1, 8.0, 8.0, -1, 0);
				PlantData[id][PlantCP] = CreateDynamicCP(PlantData[id][PlantX], PlantData[id][PlantY], PlantData[id][PlantZ], 2.0, 0, 0, -1, 2.0);
			}
		}
	}
}

function PlantGrowup(id)
{
	if(id != -1)
	{
		if(PlantData[id][PlantTime] > 0)
		{
			PlantData[id][PlantTime]--;
		}
		if(PlantData[id][PlantTime] < 2300 && PlantData[id][PlantTime] > 2298)
		{
			Plant_Refresh(id);
		}
		if(PlantData[id][PlantTime] < 5 && PlantData[id][PlantTime] > 1)
		{
			Plant_Refresh(id);
		}
	}
	return 1;
}

function LoadPlants()
{
    new id;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", id);
			cache_get_value_name_int(i, "type", PlantData[id][PlantType]);
			cache_get_value_name_int(i, "time", PlantData[id][PlantTime]);
			cache_get_value_name_float(i, "posx", PlantData[id][PlantX]);
			cache_get_value_name_float(i, "posy", PlantData[id][PlantY]);
			cache_get_value_name_float(i, "posz", PlantData[id][PlantZ]);
			Iter_Add(Plants, id);
			
			PlantData[id][PlantHarvest] = false;
			Plant_Refresh(id);
			PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
		}
		printf("[Farmer Plants]: %d Loaded.", rows);
	}
}

Plant_Save(id)
{
	new cQuery[512];
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE plants SET type='%d', time='%d', posx='%f', posy='%f', posz='%f' WHERE id='%d'",
	PlantData[id][PlantType],
	PlantData[id][PlantTime],
	PlantData[id][PlantX],
	PlantData[id][PlantY],
	PlantData[id][PlantZ],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

function OnPlantCreated(playerid, id)
{
	Plant_Refresh(id);
	Plant_Save(id);
	return 1;
}

function HarvestPlant(playerid)
{
	if(pData[playerid][pHarvestID] != -1)
	{
		new id = pData[playerid][pHarvestID];
		new kg = RandomEx(1, 5);
		
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(PlantData[id][PlantType] == 1)
			{
				pData[playerid][pPotato] += kg;
				Info(playerid, "Anda mendapatkan hasil panen potato/kentang seberat "GREEN_E"%d kg.", kg);
			}
			else if(PlantData[id][PlantType] == 2)
			{
				pData[playerid][pWheat] += kg;
				Info(playerid, "Anda mendapatkan hasil panen wheat/gandum seberat "GREEN_E"%d kg.", kg);
			}
			else if(PlantData[id][PlantType] == 3)
			{
				pData[playerid][pOrange] += kg;
				Info(playerid, "Anda mendapatkan hasil panen orange/jeruk seberat "GREEN_E"%d kg.", kg);
			}
			else if(PlantData[id][PlantType] == 4)
			{
				pData[playerid][pMarijuana] += kg;
				Info(playerid, "Anda mendapatkan hasil panen marijuana/ganja seberat "GREEN_E"%d kg.", kg);
			}
			
			InfoTD_MSG(playerid, 8000, "Harvesting done!");
			KillTimer(pData[playerid][pHarvest]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pHarvestID] = -1;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pEnergy] -= 1;
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			SetPlayerSpecialAction(playerid, 0);
			
			new query[128];
			PlantData[id][PlantType] = 0;
			PlantData[id][PlantTime] = 0;
			PlantData[id][PlantX] = 0.0;
			PlantData[id][PlantY] = 0.0;
			PlantData[id][PlantZ] = 0.0;
			PlantData[id][PlantHarvest] = false;
			KillTimer(PlantData[id][PlantTimer]);
			PlantData[id][PlantTimer] = -1;
			DestroyDynamicObject(PlantData[id][PlantObjID]);
			DestroyDynamicCP(PlantData[id][PlantCP]);
			DestroyDynamic3DTextLabel(PlantData[id][PlantLabel]);
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM plants WHERE id='%d'", id);
			mysql_query(g_SQL, query);
			Iter_SafeRemove(Plants, id, id);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 10;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	return 1;
}

Player_ResetHarvest(playerid)
{
	if(!IsPlayerConnected(playerid) || pData[playerid][pHarvestID] == -1) return 0;
	
	new id = pData[playerid][pHarvestID];
	PlantData[id][PlantHarvest] = false;
	return 1;
}

//------------[ Farmer Commands ]------------

CMD:plant(playerid, params[])
{
	if(isnull(params)) return Usage(playerid, "/plant [plant/harvest/destroy/sell]");
	
	if(!strcmp(params, "plant", true))
	{
		if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
		{
			if(GetPlayerInterior(playerid) > 0) return Error(playerid, "You cant plant at here!");
			if(GetPlayerVirtualWorld(playerid) > 0) return Error(playerid, "You cant plant at here!");
			
			new mstr[512], tstr[64];
			format(tstr, sizeof(tstr), ""WHITE_E"My Seed: "GREEN_E"%d", pData[playerid][pSeed]);
			format(mstr, sizeof(mstr), "Plant\tSeed\n\
			"WHITE_E"Potato\t"GREEN_E"5 Seed\n\
			"WHITE_E"Wheat\t"GREEN_E"18 Seed\n\
			"WHITE_E"Orange\t"GREEN_E"11 Seed\n\
			"RED_E"[ILEGAL]Marijuana\t"GREEN_E"50 Seed");
			ShowPlayerDialog(playerid, DIALOG_PLANT, DIALOG_STYLE_TABLIST_HEADERS, tstr, mstr, "Plant", "Close");
		}
		else return Error(playerid, "You are not farmer!");
	}
	else if(!strcmp(params, "harvest", true))
	{
		if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
		{
			new id = GetClosestPlant(playerid);
			if(id == -1) return Error(playerid, "You must closes on the plant!");
			if(PlantData[id][PlantTime] > 1) return Error(playerid, "This plant is not ready!");
			if(PlantData[id][PlantHarvest] == true) return Error(playerid, "This plant already harvesting by someone!");
			if(GetPlayerWeapon(playerid) != WEAPON_KNIFE) return Error(playerid, "You need holding a knife(pisau)!");
			
			pData[playerid][pHarvestID] = id;
			pData[playerid][pHarvest] = SetTimerEx("HarvestPlant", 1000, true, "i", playerid);
			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Harvesting...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			SetPlayerArmedWeapon(playerid, WEAPON_KNIFE);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);

			PlantData[id][PlantHarvest] = true;
		}
		else return Error(playerid, "You are not farmer!");
	}
	else if(!strcmp(params, "destroy", true))
	{
		if(pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2)
		{
			new id = GetClosestPlant(playerid);
			if(id == -1) return Error(playerid, "You must closes on the plant!");
			if(PlantData[id][PlantHarvest] == true) return Error(playerid, "This plant already harvesting by someone!");
			
			new query[128];
			PlantData[id][PlantType] = 0;
			PlantData[id][PlantTime] = 0;
			PlantData[id][PlantX] = 0.0;
			PlantData[id][PlantY] = 0.0;
			PlantData[id][PlantZ] = 0.0;
			PlantData[id][PlantHarvest] = false;
			KillTimer(PlantData[id][PlantTimer]);
			PlantData[id][PlantTimer] = -1;
			DestroyDynamicObject(PlantData[id][PlantObjID]);
			DestroyDynamicCP(PlantData[id][PlantCP]);
			DestroyDynamic3DTextLabel(PlantData[id][PlantLabel]);
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM plants WHERE id='%d'", id);
			mysql_query(g_SQL, query);
			Iter_SafeRemove(Plants, id, id);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
			Info(playerid, "You has destroyed this plant!");
		}
		else return Error(playerid, "You cant destroy a plant!");
	}
	else if(!strcmp(params, "sell", true))
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.5, -381.44, -1426.13, 25.93))
			return Error(playerid, "You must near in food/farmer warehouse!");
			
		new potato = pData[playerid][pPotato] * PotatoPrice,
		wheat = pData[playerid][pWheat] * WheatPrice,
		orange = pData[playerid][pOrange] * OrangePrice;
		
		new total = pData[playerid][pPotato] + pData[playerid][pWheat] + pData[playerid][pOrange];
		new pay = potato + wheat + orange;
		
		if(total < 1) return Error(playerid, "You dont have plant!");
		GivePlayerMoneyEx(playerid, pay);
		Food += total;
		Server_MinMoney(pay);
		
		pData[playerid][pPotato] = 0;
		pData[playerid][pWheat] = 0;
		pData[playerid][pOrange] = 0;
		Info(playerid, "You selling "RED_E"%d kg "WHITE_E"all plant to "GREEN_E"%s", total, FormatMoney(pay));
	}
	return 1;
}

CMD:sellmarijuana(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, 874.52, -15.98, 63.19))
		return Error(playerid, "You must near in back market!");
	
	if(pData[playerid][pMarijuana] < 1) return Error(playerid, "You dont have marijuana!");
	new pay = pData[playerid][pMarijuana] * MarijuanaPrice;
	new total = pData[playerid][pMarijuana];
	GivePlayerMoneyEx(playerid, pay);
	Marijuana += total;
	Server_MinMoney(pay);
	
	Info(playerid, "You selling "RED_E"%d kg "WHITE_E"marijuana to "GREEN_E"%s", total, FormatMoney(pay));
	pData[playerid][pMarijuana] = 0;
	return 1;
}


CMD:price(playerid, params[])
{
	if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
	{
		new mstr[512], tstr[64];
		format(tstr, sizeof(tstr), ""WHITE_E"My Food: "GREEN_E"%d", pData[playerid][pFood]);
		format(mstr, sizeof(mstr), "Name\tPrice\n\
		"WHITE_E"Sprunk\t"GREEN_E"%s\n\
		"WHITE_E"Snack\t"GREEN_E"%s\n\
		"WHITE_E"Ice Cream Orange\t"GREEN_E"%s\n\
		"WHITE_E"Hotdog\t"GREEN_E"%s", FormatMoney(pData[playerid][pPrice1]), FormatMoney(pData[playerid][pPrice2]), FormatMoney(pData[playerid][pPrice3]), FormatMoney(pData[playerid][pPrice4]));
		ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE, DIALOG_STYLE_TABLIST_HEADERS, tstr, mstr, "Edit", "Close");
	}
	else return Error(playerid, "You are not farmer job!");
	return 1;
}

CMD:offer(playerid, params[])
{
	if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return Error(playerid, "You must in Mr.Whoopee or Hotdog vehicle!");
		
		new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
		if(modelid != 423 && modelid != 588)
			return Error(playerid, "You must in Mr.Whoopee or Hotdog vehicle!");
		
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/offer [playerid/PartOfName]");
		
		if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
			return Error(playerid, "The specified player is disconnected or not near you.");
		
		pData[otherid][pOffer] = playerid;
		new mstr[512], tstr[64];
		format(tstr, sizeof(tstr), ""WHITE_E"Food Stock: "GREEN_E"%d", pData[playerid][pFood]);
		format(mstr, sizeof(mstr), "Name\tPrice\n\
		"WHITE_E"Sprunk\t"GREEN_E"%s\n\
		"WHITE_E"Snack\t"GREEN_E"%s\n\
		"WHITE_E"Ice Cream Orange\t"GREEN_E"%s\n\
		"WHITE_E"Hotdog\t"GREEN_E"%s", FormatMoney(pData[playerid][pPrice1]), FormatMoney(pData[playerid][pPrice2]), FormatMoney(pData[playerid][pPrice3]), FormatMoney(pData[playerid][pPrice4]));
		ShowPlayerDialog(otherid, DIALOG_OFFER, DIALOG_STYLE_TABLIST_HEADERS, tstr, mstr, "Buy", "Close");
	}
	else return Error(playerid, "You are not farmer job!");
	return 1;
}

CMD:cook(playerid, params[])
{
	if(pData[playerid][pInHouse] == -1)
		return Error(playerid, "You must inside a house!");
		
	if(isnull(params)) return Usage(playerid, "/cook [snack/sprunk/burger]");
	
	if(!strcmp(params, "snack", true))
	{
		if(pData[playerid][pFood] < 5)
			return Error(playerid, "Bahan makanan tidak cukup!");
		
		pData[playerid][pFood] -= 5;
				
		TogglePlayerControllable(playerid, 0);
		Info(playerid, "Anda sedang memasak makanan dengan 5 food!");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pCookingStatus] = 1;
		pData[playerid][pCooking] = SetTimerEx("CookingFood", 1000, true, "id", playerid, 1);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cooking...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	}
	else if(!strcmp(params, "sprunk", true))
	{
		if(pData[playerid][pFood] < 5)
			return Error(playerid, "Bahan makanan tidak cukup!");
			
		pData[playerid][pFood] -= 5;
				
		TogglePlayerControllable(playerid, 0);
		Info(playerid, "Anda sedang memasak makanan dengan 5 food!");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pCookingStatus] = 1;
		pData[playerid][pCooking] = SetTimerEx("CookingFood", 1000, true, "id", playerid, 2);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cooking...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		
	}
	else if(!strcmp(params, "burger", true))
	{
		if(pData[playerid][pFood] < 10)
			return Error(playerid, "Bahan makanan tidak cukup!");
			
		pData[playerid][pFood] -= 10;
				
		TogglePlayerControllable(playerid, 0);
		Info(playerid, "Anda sedang memasak makanan dengan 5 food!");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pCookingStatus] = 1;
		pData[playerid][pCooking] = SetTimerEx("CookingFood", 1000, true, "id", playerid, 3);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cooking...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	}
	return 1;
}

function CookingFood(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pCookingStatus] != 1) return 0;
	if(pData[playerid][pInHouse] != -1)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(type == 1)
			{
				pData[playerid][pSnack] += 1;
				
				Info(playerid, "Anda telah berhasil membuat bahan makanan.");
				TogglePlayerControllable(playerid, 1);
				InfoTD_MSG(playerid, 8000, "Cooking done!");
				KillTimer(pData[playerid][pCooking]);
				pData[playerid][pCookingStatus] = 0;
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pEnergy] -= 2;
				ClearAnimations(playerid);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}
			else if(type == 2)
			{
				pData[playerid][pSprunk] += 1;
				
				Info(playerid, "Anda telah berhasil membuat bahan makanan.");
				TogglePlayerControllable(playerid, 1);
				InfoTD_MSG(playerid, 8000, "Cooking done!");
				KillTimer(pData[playerid][pCooking]);
				pData[playerid][pCookingStatus] = 0;
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pEnergy] -= 2;
				ClearAnimations(playerid);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}
			else if(type == 3)
			{
				pData[playerid][pHunger] += 50;
				
				Info(playerid, "Anda telah berhasil membuat bahan makanan.");
				TogglePlayerControllable(playerid, 1);
				InfoTD_MSG(playerid, 8000, "Cooking done!");
				KillTimer(pData[playerid][pCooking]);
				pData[playerid][pCookingStatus] = 0;
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pEnergy] -= 2;
				ClearAnimations(playerid);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}
			else
			{
				KillTimer(pData[playerid][pCooking]);
				pData[playerid][pCookingStatus] = 0;
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	return 1;
}
