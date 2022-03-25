/*


         TASK OPTIMIZED LUNARPRIDE

*/

task onlineTimer[1000]()
{	
	//Date and Time Textdraw
	new datestring[64];
	new hours,
	minutes,
	seconds,
	days,
	months,
	years;
	new MonthName[12][] =
	{
		"January", "February", "March", "April", "May", "June",
		"July",	"August", "September", "October", "November", "December"
	};
	getdate(years, months, days);
 	gettime(hours, minutes, seconds);
	format(datestring, sizeof datestring, "%s%d %s %s%d", ((days < 10) ? ("0") : ("")), days, MonthName[months-1], (years < 10) ? ("0") : (""), years);
	TextDrawSetString(TextDate, datestring);
	format(datestring, sizeof datestring, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
	TextDrawSetString(TextTime, datestring);
	//Phone Time
	format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
	TextDrawSetString(PhoneTD[13], datestring);
	

    /*foreach (new i : Player) 
	{
		SetPlayerTime(i, hours, minutes);
		if(pData[i][pInDoor] <= -1 || pData[i][pInHouse] <= -1 || pData[i][pInBiz] <= -1)
        {
			SetPlayerWeather(i, GetGVarInt("g_Weather"));
		}
	}*/
	// Increase server uptime
	up_seconds ++;
	if(up_seconds == 60)
	{
	    up_seconds = 0, up_minutes ++;
	    if(up_minutes == 60)
	    {
	        up_minutes = 0, up_hours ++;
	        if(up_hours == 24) up_hours = 0, up_days ++;
			new tstr[128], rand = RandomEx(0, 20);
			format(tstr, sizeof(tstr), ""BLUE_E"UPTIME: "WHITE_E"The server has been online for %s.", Uptime());
			SendClientMessageToAll(COLOR_WHITE, tstr);
			if(hours > 18)
			{
				SetWorldTime(0);
				WorldTime = 0;
			}
			else
			{
				SetWorldTime(hours);
				WorldTime = hours;
			}
			SetWeather(rand);
			WorldWeather = rand;

			// Sync Server
			mysql_tquery(g_SQL, "OPTIMIZE TABLE `bisnis`,`houses`,`toys`,`vehicle`");
			//SetTimer("changeWeather", 10000, false);
		}
	}
	return 1;
}

ptask PlayerDelay[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == false) return 0;
	NgecekCiter(playerid);
		//VIP Expired Checking
	if(pData[playerid][pVip] > 0)
	{
		if(pData[playerid][pVipTime] != 0 && pData[playerid][pVipTime] <= gettime())
		{
			Info(playerid, "Maaf, Level VIP player anda sudah habis! sekarang anda adalah player biasa!");
			pData[playerid][pVip] = 0;
			pData[playerid][pVipTime] = 0;
		}
	}
		//ID Card Expired Checking
	if(pData[playerid][pIDCard] > 0)
	{
		if(pData[playerid][pIDCardTime] != 0 && pData[playerid][pIDCardTime] <= gettime())
		{
			Info(playerid, "Masa berlaku ID Card anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pIDCard] = 0;
			pData[playerid][pIDCardTime] = 0;
		}
	}

	if(pData[playerid][pExitJob] != 0 && pData[playerid][pExitJob] <= gettime())
	{
		Info(playerid, "Now you can exit from your current job!");
		pData[playerid][pExitJob] = 0;
	}
	if(pData[playerid][pDriveLic] > 0)
	{
		if(pData[playerid][pDriveLicTime] != 0 && pData[playerid][pDriveLicTime] <= gettime())
		{
			Info(playerid, "Masa berlaku Driving anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pDriveLic] = 0;
			pData[playerid][pDriveLicTime] = 0;
		}
	}
	if(pData[playerid][pWeaponLic] > 0)
	{
		if(pData[playerid][pWeaponLicTime] != 0 && pData[playerid][pWeaponLicTime] <= gettime())
		{
			Info(playerid, "Masa berlaku License Weapon anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pWeaponLic] = 0;
			pData[playerid][pWeaponLicTime] = 0;
		}
	}
		//Player JobTime Delay
	if(pData[playerid][pJobTime] > 0)
	{
		pData[playerid][pJobTime]--;
	}
	if(pData[playerid][pSideJobTime] > 0)
	{
		pData[playerid][pSideJobTime]--;
	}
	if(pData[playerid][pSweeperTime] > 0)
	{
		pData[playerid][pSweeperTime]--;
	}
	if(pData[playerid][pForklifterTime] > 0)
	{
		pData[playerid][pForklifterTime]--;
	}
	if(pData[playerid][pBusTime] > 0)
	{
		pData[playerid][pBusTime]--;
	}
	if(pData[playerid][pMowerTime] > 0)
	{
		pData[playerid][pMowerTime]--;
	}
	//Twitter Post
	if(pData[playerid][pTwitterPostCooldown] > 0)
	{
		pData[playerid][pTwitterPostCooldown]--;
	}
	//Twitter Changename
	if(pData[playerid][pTwitterNameCooldown] > 0)
	{
		pData[playerid][pTwitterNameCooldown]--;
	}

		// Duty Delay
	if(pData[playerid][pDutyHour] > 0)
	{
		pData[playerid][pDutyHour]--;
	}
		// Rob Delay
	if(pData[playerid][pRobTime] > 0)
	{
		pData[playerid][pRobTime]--;
	}
		// Get Loc timer
	if(pData[playerid][pSuspectTimer] > 0)
	{
		pData[playerid][pSuspectTimer]--;
	}
	if(pData[playerid][pDelayIklan] > 0)
	{
		pData[playerid][pDelayIklan]--;
	}
		//Warn Player Check
	if(pData[playerid][pWarn] >= 20)
	{
		new ban_time = gettime() + (5 * 86400), query[512], PlayerIP[16], giveplayer[24];
		GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
		GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
		pData[playerid][pWarn] = 0;
			//SetPlayerPosition(playerid, 227.46, 110.0, 999.02, 360.0000, 10);
		BanPlayerMSG(playerid, playerid, "20 Total Warning", true);
		SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Player %s(%d) telah otomatis dibanned permanent dari server. [Reason: 20 Total Warning]", giveplayer, playerid);

		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', 'Server Ban', '20 Total Warning', %i, %d)", giveplayer, PlayerIP, gettime(), ban_time);
		mysql_tquery(g_SQL, query);
		KickEx(playerid);
	}
	return 1;
}

ptask FarmDetect[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == true)
	{
		if(pData[playerid][pPlant] >= 20)
		{
			pData[playerid][pPlant] = 0;
			pData[playerid][pPlantTime] = 600;
		}
		if(pData[playerid][pPlantTime] > 0)
		{
			pData[playerid][pPlantTime]--;
			if(pData[playerid][pPlantTime] < 1)
			{
				pData[playerid][pPlantTime] = 0;
				pData[playerid][pPlant] = 0;
			}
		}
		new pid = GetClosestPlant(playerid);
		if(pid != -1)
		{
			if(IsPlayerInDynamicCP(playerid, PlantData[pid][PlantCP]) && pid != -1)
			{
				new type[24], mstr[128];
				if(PlantData[pid][PlantType] == 1)
				{
					type = "Potato";
				}
				else if(PlantData[pid][PlantType] == 2)
				{
					type = "Wheat";
				}
				else if(PlantData[pid][PlantType] == 3)
				{
					type = "Orange";
				}
				else if(PlantData[pid][PlantType] == 4)
				{
					type = "Marijuana";
				}
				if(PlantData[pid][PlantTime] > 1)
				{
					format(mstr, sizeof(mstr), "~w~Plant Type: ~g~%s ~n~~w~Plant Time: ~r~%s", type, ConvertToMinutes(PlantData[pid][PlantTime]));
					InfoTD_MSG(playerid, 1000, mstr);
				}
				else
				{
					format(mstr, sizeof(mstr), "~w~Plant Type: ~g~%s ~n~~w~Plant Time: ~g~Now", type);
					InfoTD_MSG(playerid, 1000, mstr);
				}
			}
		}
	}
	return 1;
}

ptask playerTimer[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == true)
	{
		pData[playerid][pPaycheck] ++;
		pData[playerid][pSeconds] ++, pData[playerid][pCurrSeconds] ++;
		if(pData[playerid][pOnDuty] >= 1)
		{
			pData[playerid][pOnDutyTime]++;
		}
		if(pData[playerid][pTaxiDuty] >= 1)
		{
			pData[playerid][pTaxiTime]++;
		}
		if(theftInfo[tTime] > 0)
		{
			theftInfo[tTime]--;
		}
		if(pData[playerid][pSeconds] == 60)
		{
			new scoremath = ((pData[playerid][pLevel])*5);

			pData[playerid][pMinutes]++, pData[playerid][pCurrMinutes] ++;
			pData[playerid][pSeconds] = 0, pData[playerid][pCurrSeconds] = 0;

			switch(pData[playerid][pMinutes])
			{				
				case 40:
				{
					if(pData[playerid][pPaycheck] >= 3600)
					{
						Info(playerid, "Waktunya mengambil paycheck!");
						Servers(playerid, "{ffff00}silahkan pergi ke bank atau ATM terdekat untuk mengambil paycheck.");
						PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
					}
				}
				case 60:
				{
					if(pData[playerid][pPaycheck] >= 3600)
					{
						Info(playerid, "Waktunya mengambil paycheck!");
						Servers(playerid, "{ffff00}silahkan pergi ke bank atau ATM terdekat untuk mengambil paycheck.");
						PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
					}

					pData[playerid][pHours] ++;
					pData[playerid][pLevelUp] += 1;
					pData[playerid][pMinutes] = 0;
					UpdatePlayerData(playerid);

					if(pData[playerid][pLevelUp] >= scoremath)
					{
						new mstr[128];
						pData[playerid][pLevel] += 1;
						pData[playerid][pHours] ++;
						SetPlayerScore(playerid, pData[playerid][pLevel]);
						format(mstr,sizeof(mstr),"~g~Level Up!~n~~w~Sekarang anda level ~r~%d", pData[playerid][pLevel]);
						GameTextForPlayer(playerid, mstr, 6000, 1);
					}
				}
			}
			if(pData[playerid][pCurrMinutes] == 60)
			{
				pData[playerid][pCurrMinutes] = 0;
				pData[playerid][pCurrHours] ++;
			}
		}
	}
	return 1;
}
