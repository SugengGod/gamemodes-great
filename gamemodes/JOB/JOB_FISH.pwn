//Fishing System

IsPlayerInWater(playerid)
{
	new Float:x,Float:y,Float:pz;
	GetPlayerPos(playerid,x,y,pz);
	if (
 	(IsPlayerInArea(playerid, 2032.1371, 1841.2656, 1703.1653, 1467.1099) && pz <= 9.0484) //lv piratenschiff
  	|| (IsPlayerInArea(playerid, 2109.0725, 2065.8232, 1962.5355, 10.8547) && pz <= 10.0792) //lv visage
  	|| (IsPlayerInArea(playerid, -492.5810, -1424.7122, 2836.8284, 2001.8235) && pz <= 41.06) //lv staucamm
  	|| (IsPlayerInArea(playerid, -2675.1492, -2762.1792, -413.3973, -514.3894) && pz <= 4.24) //sf südwesten kleiner teich
  	|| (IsPlayerInArea(playerid, -453.9256, -825.7167, -1869.9600, -2072.8215) && pz <= 5.72) //sf gammel teich
  	|| (IsPlayerInArea(playerid, 1281.0251, 1202.2368, -2346.7451, -2414.4492) && pz <= 9.3145) //ls neben dem airport
  	|| (IsPlayerInArea(playerid, 2012.6154, 1928.9028, -1178.6207, -1221.4043) && pz <= 18.45) //ls mitte teich
  	|| (IsPlayerInArea(playerid, 2326.4858, 2295.7471, -1400.2797, -1431.1266) && pz <= 22.615) //ls weiter südöstlich
  	|| (IsPlayerInArea(playerid, 2550.0454, 2513.7588, 1583.3751, 1553.0753) && pz <= 9.4171) //lv pool östlich
  	|| (IsPlayerInArea(playerid, 1102.3634, 1087.3705, -663.1653, -682.5446) && pz <= 112.45) //ls pool nordwestlich
  	|| (IsPlayerInArea(playerid, 1287.7906, 1270.4369, -801.3882, -810.0527) && pz <= 87.123) //pool bei maddog's haus oben
  	|| (pz < 1.5)
	)
	{
		return 1;
	}
	return 0;
}

IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if (x > minx && x < maxx && y > miny && y < maxy) return 1;
	return 0;
}

IsAtFishPlace(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerInRangeOfPoint(playerid,1.0,403.8266,-2088.7598,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,398.7553,-2088.7490,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,396.2197,-2088.6692,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,391.1094,-2088.7976,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,383.4157,-2088.7849,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,374.9598,-2088.7979,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,369.8107,-2088.7927,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,367.3637,-2088.7925,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,362.2244,-2088.7981,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,354.5382,-2088.7979,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInWater(playerid))
		{
			return 1;
		}
	}
	return 0;
}

function FishTime(playerid)
{
	if(IsPlayerConnected(playerid) && pData[playerid][pInFish] == 1)
	{
	    new rand = RandomEx(1,12);
	    new weight = RandomEx(1,4);
	    if(rand == 1)
	    {
	        Info(playerid, "Anda mendapatkan sebuah sampah dan langsung membuangannya.");
	        pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 2)
		{
		    Info(playerid, "Anda mendapatkan ikan tuna seberat %d kg!", weight);
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFish] += weight;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 3)
		{
		    Info(playerid, "Anda mendapatkan ikan tongkol seberat %d kg!", weight);
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFish] += weight;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 4)
		{
		    Info(playerid, "Anda mendapatkan ikan kakap seberat %d kg!", weight);
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFish] += weight;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 5)
		{
		    Info(playerid, "Anda mendapatkan ikan kembung seberat %d kg!", weight);
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFish] += weight;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 6)
		{
		    Info(playerid, "Anda mendapatkan ikan makarel seberat %d kg!", weight);
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFish] += weight;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 7)
		{
		    Info(playerid, "Anda mendapatkan ikan tenggiri seberat %d kg!", weight);
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFish] += weight;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 8)
		{
		    Info(playerid, "Anda mendapatkan ikan blue marlin seberat %d kg!", weight);
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFish] += weight;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 9)
		{
		    Info(playerid, "Anda mendapatkan ikan sail fish seberat %d kg!", weight);
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFish] += weight;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 10)
		{
		    Info(playerid, "Anda tidak mendapatkan apapun.");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
		    return 1;
		}
		else if(rand == 11)
		{
		    Info(playerid, "Ikan yang sangat besar! tetapi pancingan anda terputus dan rusak.");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFishTool]--;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
		    return 1;
		}
		else
		{
		    Info(playerid, "Anda tidak mendapatkan apapun.");
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
		    return 1;
		}
	}
	return 0;
}

CMD:fish(playerid,params[])
{
	if(pData[playerid][pFishTool] > 0)
	{
	    if(pData[playerid][pWorm] > 0)
	    {
	        if(IsAtFishPlace(playerid))
	        {
				if(pData[playerid][pInFish] == 0)
				{
					if(pData[playerid][pFish] >= 20)
					{
					    /*SendClientMessage(playerid,COLOR_YELLOW,"*[JOB] You have enough fishes and you are tiered of fishing.");
					    SendClientMessage(playerid,COLOR_YELLOW,"*[JOB] You can sell your fishes at lighthouse");
						AlreadyFished[playerid] = 1;
						//SetPlayerCheckpoint(playerid, 2766.6602,-2575.1614,3.0000,3.0);
						SetTimerEx("StopFish", 1000*60*10, 0, "i",playerid);*/
						Error(playerid, "Inventory ikan anda sudah penuh, anda dapat menjualnya terlebih dahulu.");
					}
					else
					{
						new random2 = RandomEx(30000, 60000);
						pData[playerid][pInFish] = 1;
						SetTimerEx("FishTime", random2, 0, "i",playerid);
						SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "** %s swings fishing rod and starts to wait for fish", ReturnName(playerid));
						TogglePlayerControllable(playerid, 0);
						ApplyAnimation(playerid,"SWORD","sword_block",50.0 ,0,1,0,1,1);
	    				SetPlayerAttachedObject(playerid, 9,18632,6,0.079376,0.037070,0.007706,181.482910,0.000000,0.000000,1.000000,1.000000,1.000000);
						InfoTD_MSG(playerid, 10000, "Fishing...");
					}
				}
				else
				{
				    Error(playerid, "Tunggu beberapa saat lagi.");
				    return 1;
				}
			}
			else
			{
			    Error(playerid, "Anda harus berada di laut.");
			    return 1;
			}
		}
		else
		{
			Error(playerid, "Anda tidak mempunyai umpan.");
		}
	}
	else
	{
		Error(playerid, "Anda tidak mempunyai fishing tool/pancingan.");
	}
	return 1;
}

CMD:sellfish(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -381.44, -1426.13, 25.93)) return Error(playerid, "You're not near a food & farmer warehouse.");
	if(pData[playerid][pFish] < 1)
		return Error(playerid, "You dont have fish.");
		
	new fish = pData[playerid][pFish];
	new pay = fish * FishPrice;
	GivePlayerMoneyEx(playerid, pay);
	Info(playerid, "Anda menjual semua ikan dengan total uang "GREEN_E"%s", FormatMoney(pay));
	Food += fish;
	Server_MinMoney(pay);
	pData[playerid][pFish] = 0;
	return 1;
}









