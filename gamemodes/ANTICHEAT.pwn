//=========[ Anticheat ]
new AntiCheatKontol = 1;
#define MAX_ANTICHEAT_WARNINGS   	3

public OnPlayerTeleport(playerid, Float:distance)
{
	if((AntiCheatKontol) && pData[playerid][pAdmin] < 2)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 3.0, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]))
	    {
		    pData[playerid][pACWarns]++;

		    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
		    {
	    	    SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly teleport hacking (distance: %.1f).", ReturnName(playerid), playerid, distance);
	        	new dc[128];
				format(dc, sizeof(dc),  "```\n<!> %s kemungkinan teleport hack [Jarak: %.1f]```", ReturnName(playerid), distance);
				SendDiscordMessage(3, dc);
			}
			else
			{
		    	SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Teleport hacks", ReturnName(playerid), SERVER_BOT);
		    	new dc[128];
				format(dc, sizeof(dc),  "```\n<!> %s telah dikick otomatis oleh %s\nAlasan: Teleport Hack```", ReturnName(playerid), SERVER_BOT);
				SendDiscordMessage(3, dc);
		    	KickEx(playerid);
			}
		}
	}

	return 1;
}

public OnPlayerAirbreak(playerid)
{
	if((AntiCheatKontol) && pData[playerid][pAdmin] < 2)
	{
	    pData[playerid][pACWarns]++;

	    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
	    {
	        SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly using airbreak hacks.", ReturnName(playerid), playerid);
	        new dc[128];
			format(dc, sizeof(dc),  "```\n<!> %s kemungkinan airbreak hack.```", ReturnName(playerid));
			SendDiscordMessage(3, dc);
		}
		else
		{
			new PlayerIP[16], giveplayer[24];
	
			GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
			GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));

		    SendClientMessageToAllEx(COLOR_RED, ""RED_E"[ANTICHEAT]: %s"WHITE_E" telah dibanned otomatis oleh %s, Alasan: Airbreak", ReturnName(playerid), SERVER_BOT);
		    new dc[128];
			format(dc, sizeof(dc),  "```\n<!> %s telah diBanned otomatis oleh %s\nAlasan: Airbreak```", ReturnName(playerid), SERVER_BOT);
			SendDiscordMessage(3, dc);

			new query[248];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", giveplayer, PlayerIP, SERVER_BOT, "Airbreak", gettime(), 0);
			mysql_tquery(g_SQL, query);
			KickEx(playerid);
		}
	}
	return 1;
}

NgecekCiter(playerid)
{
	if(gettime() > pData[playerid][pACTime])
	{
	    // Speedhacking
		if((AntiCheatKontol) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 350 && pData[playerid][pAdmin] < 2)
		{
		    pData[playerid][pACWarns]++;

		    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
		    {
                new dc[128];
                SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly speedhacking, speed: %.1f km/h.", ReturnName(playerid), playerid, GetVehicleSpeed(GetPlayerVehicleID(playerid)));
	        	format(dc, sizeof(dc),  "```\n<!> %s kemungkinan speed hack, Kecepatan: [%.1f Km/H]```", ReturnName(playerid), GetVehicleSpeed(GetPlayerVehicleID(playerid)));
				SendDiscordMessage(3, dc);
			}
			else
			{
                new dc[128];
                SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Speed hacks", ReturnName(playerid), SERVER_BOT);
		    	format(dc, sizeof(dc),  "```\n<!> %s telah dikick otomatis oleh %s\nAlasan: Speed Hack```", ReturnName(playerid), SERVER_BOT);
				SendDiscordMessage(3, dc);
		    	KickEx(playerid);
			}
		}

		// Jetpack
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && pData[playerid][pAdmin] < 2 && !pData[playerid][pJetpack])
		{
            new dc[128];
            SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Jetpack hacks", ReturnName(playerid), SERVER_BOT);
			format(dc, sizeof(dc),  "```\n<!> %s telah dikick otomatis oleh %s\nAlasan: Jetpack Hack```", ReturnName(playerid), SERVER_BOT);
			SendDiscordMessage(3, dc);
		    KickEx(playerid);
		}

		// Flying hacks
		if((AntiCheatKontol) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			switch(GetPlayerAnimationIndex(playerid))
			{
			    case 958, 1538, 1539, 1543:
			    {
			        new
			            Float:z,
			            Float:vx,
			            Float:vy,
			            Float:vz;

					GetPlayerPos(playerid, z, z, z);
                    GetPlayerVelocity(playerid, vx, vy, vz);

                    if((z > 20.0) && (0.9 <= floatsqroot((vx * vx) + (vy * vy) + (vz * vz)) <= 1.9) && pData[playerid][pAdmin] < 2)
                    {
                        new dc[128];
                        SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Flying hacks", ReturnName(playerid), SERVER_BOT);
                        format(dc, sizeof(dc),  "```\n<!> %s telah dikick otomatis oleh %s\nAlasan: Flying Hack```", ReturnName(playerid), SERVER_BOT);
                        SendDiscordMessage(3, dc);
                        KickEx(playerid);
					}
				}
			}
		}

			// Armor hacks
		if(!IsAtEvent[playerid])
		{
		    new
   				Float:armor;

			GetPlayerArmour(playerid, armor);

  			if(!(gettime() - pData[playerid][pLastUpdate] > 5))
  			{
				if(floatround(armor) > floatround(pData[playerid][pArmour]) && gettime() > pData[playerid][pACTime] && gettime() > pData[playerid][pArmorTime] && pData[playerid][pAdmin] < 2)
				{
		            pData[playerid][pACWarns]++;
	    	        pData[playerid][pArmorTime] = gettime() + 10;

				    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
				    {
                        new dc[128];
                        SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly Armor hacks, (old: %.2f, new: %.2f)", ReturnName(playerid), playerid, pData[playerid][pArmour], armor);
                        format(dc, sizeof(dc),  "```\n<!> %s kemungkinan Armor hack. (old: %.2f, new: %.2f)```", ReturnName(playerid), pData[playerid][pArmour], armor);
                        SendDiscordMessage(3, dc);
					}
					else
					{
                        new dc[128];
                        SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Armor hacks", ReturnName(playerid), SERVER_BOT);
                        format(dc, sizeof(dc),  "```\n<!> %s telah dikick otomatis oleh %s\nAlasan: Armor Hack```", ReturnName(playerid), SERVER_BOT);
                        SendDiscordMessage(3, dc);
                        KickEx(playerid);
					}
				}
			}

			pData[playerid][pArmour] = armor;
		}
	}

	// Ammo hacks
	if(!IsAtEvent[playerid])
	{
	    new
			weapon,
			ammo;

		GetPlayerWeaponData(playerid, 8, weapon, ammo);

		if((16 <= weapon <= 18) && ammo <= 0)
		{
			RemovePlayerWeapon(playerid, weapon);
		}
	}

	// Warping into vehicles while locked
	/*if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetVehicleParams(GetPlayerVehicleID(playerid), VEHICLE_DOORS) && (!IsVehicleOwner(playerid, GetPlayerVehicleID(playerid)) && pData[playerid][pVehicleKeys] != GetPlayerVehicleID(playerid)))
    {
        new
            Float:x,
            Float:y,
            Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(playerid, x, y, z + 1.0);
        GameTextForPlayer(playerid, "~r~This vehicle is locked!", 3000, 3);
    }*/
}

RemovePlayerWeapon(playerid, weaponid)
{
	// Reset the player's weapons.
	ResetPlayerWeapons(playerid);
	// Set the armed slot to zero.
	SetPlayerArmedWeapon(playerid, 0);
	// Set the weapon in the slot to zero.
	pData[playerid][pACTime] = gettime() + 2;
	pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
	// Set the player's weapons.
	SetWeapons(playerid);
}