//-----------[ Faction Commands ]------------
CMD:factionhelp(playerid)
{
	if(pData[playerid][pFaction] == 1)
	{
		new str[3500];
		strcat(str, ""BLUE_E"SAPD: /locker /or (/r)adio /od /d(epartement) (/gov)ernment (/m)egaphone /invite /uninvite /setrank\n");
		strcat(str, ""WHITE_E"SAPD: /sapdonline /(un)cuff /tazer /detain /arrest /release /flare /destroyflare /checkveh /takedl\n");
		strcat(str, ""BLUE_E"SAPD: /takemarijuana /spike /destroyspike /destroyallspike /getloc\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"SAPD", str, "Close", "");
	}
	else if(pData[playerid][pFaction] == 2)
	{
		new str[3500];
		strcat(str, ""LB_E"SAGS: /locker /or (/r)adio /od /d(epartement) (/gov)ernment (/m)egaphone /invite /uninvite /setrank\n");
		strcat(str, ""WHITE_E"SAGS: /sagsonline /(un)cuff /checkcitymoney\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"SAGS", str, "Close", "");
	}
	else if(pData[playerid][pFaction] == 3)
	{
		new str[3500];
		strcat(str, ""PINK_E"SAMD: /locker /or (/r)adio /od /d(epartement) (/gov)ernment (/m)egaphone /invite /uninvite /setrank\n");
		strcat(str, ""WHITE_E"SAMD: /samdonline /loadinjured /dropinjured /ems /findems /healbone /rescue /salve /mix /treatment\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"SAMD", str, "Close", "");
	}
	else if(pData[playerid][pFaction] == 4)
	{
		new str[3500];
		strcat(str, ""ORANGE_E"SANA: /locker /or (/r)adio /od /d(epartement) (/gov)ernment (/m)egaphone /invite /uninvite /setrank\n");
		strcat(str, ""WHITE_E"SANA: /sanaonline /broadcast /bc /live /inviteguest /removeguest\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"SANEWS", str, "Close", "");
	}
	else if(pData[playerid][pFamily] != -1)
	{
		new str[3500];
		strcat(str, ""WHITE_E"Family: /fsafe /f(amily) /finvite /funinvite /fsetrank\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Family", str, "Close", "");
	}
	else
	{
		Error(playerid, "Anda tidak bergabung dalam faction/family manapun!");
	}
	return 1;
}

CMD:or(playerid, params[])
{
    new text[128];
    
    if(pData[playerid][pFaction] == 0)
        return Error(playerid, "You must in faction member to use this command");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/or(OOC radio) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");

    if(pData[playerid][pFaction] == 1) {
        SendFactionMessage(1, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 2) {
        SendFactionMessage(2, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 3) {
        SendFactionMessage(3, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 4) {
        SendFactionMessage(4, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else
            return Error(playerid, "You are'nt in any faction");
    return 1;
}

CMD:r(playerid, params[])
{
    new text[128], mstr[512];
    
    if(pData[playerid][pFaction] == 0)
        return Error(playerid, "You must in faction member to use this command");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/r(adio) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");

    if(pData[playerid][pFaction] == 1) {
        SendFactionMessage(1, COLOR_RADIO, "** [SAPD Radio] %s(%d) %s: %s", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 2) {
        SendFactionMessage(2, COLOR_RADIO, "** [SAGS Radio] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 3) {
        SendFactionMessage(3, COLOR_RADIO, "** [SAMD Radio] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 4) {
        SendFactionMessage(4, COLOR_RADIO, "** [SANA Radio] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else
            return Error(playerid, "You are'nt in any faction");
    return 1;
}

CMD:od(playerid, params[])
{
    new text[128];
    
    if(pData[playerid][pFaction] == 0)
        return Error(playerid, "You must in faction member to use this command");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/od(OOC departement) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");
	
	for(new fid = 1; fid < 5; fid++)
	{
		if(pData[playerid][pFaction] == 1) {
			SendFactionMessage(fid, 0xFFD7004A, "** (( %s: %s ))", pData[playerid][pName], text);
			//format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			//SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 2) {
			SendFactionMessage(fid, 0xFFD7004A, "** (( %s: %s ))", pData[playerid][pName], text);
			//format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			//SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 3) {
			SendFactionMessage(fid, 0xFFD7004A, "** (( %s: %s ))", pData[playerid][pName], text);
			//format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			//SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 4) {
			SendFactionMessage(fid, 0xFFD7004A, "** (( %s: %s ))", pData[playerid][pName], text);
			//format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			//SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else
				return Error(playerid, "You are'nt in any faction");
	}
    return 1;
}

CMD:d(playerid, params[])
{
    new text[128], mstr[512];
    
    if(pData[playerid][pFaction] == 0)
        return Error(playerid, "You must in faction member to use this command");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/d(epartement) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");
	
	for(new fid = 1; fid < 5; fid++)
	{
		if(pData[playerid][pFaction] == 1) 
		{
			SendFactionMessage(fid, 0xFFD7004A, "** [SAPD Departement] %s(%d) %s: %s", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], text);
			format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 2) 
		{
			SendFactionMessage(fid, 0xFFD7004A, "** [SAGS Departement] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
			format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 3) 
		{
			SendFactionMessage(fid, 0xFFD7004A, "** [SAMD Departement] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
			format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 4) 
		{
			SendFactionMessage(fid, 0xFFD7004A, "** [SANA Departement] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
			format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else
				return Error(playerid, "You are'nt in any faction");
	}
    return 1;
}

CMD:m(playerid, params[])
{
	new facname[16];
	if(pData[playerid][pFaction] <= 0)
		return Error(playerid, "You are not faction!");
		
	if(isnull(params)) return Usage(playerid, "/m(egaphone) [text]");
	
	if(pData[playerid][pFaction] == 1)
	{
		facname = "SAPD";
	}
	else if(pData[playerid][pFaction] == 2)
	{
		facname = "SAGS";
	}
	else if(pData[playerid][pFaction] == 3)
	{
		facname = "SAMD";
	}
	else if(pData[playerid][pFaction] == 4)
	{
		facname = "SANA";
	}
	else
	{
		facname ="Unknown";
	}
	
	if(strlen(params) > 64) {
        SendNearbyMessage(playerid, 60.0, COLOR_YELLOW, "[%s Megaphone] %s says: %.64s", facname, ReturnName(playerid), params);
        SendNearbyMessage(playerid, 60.0, COLOR_YELLOW, "...%s", params[64]);
    }
    else {
        SendNearbyMessage(playerid, 60.0, COLOR_YELLOW, "[%s Megaphone] %s says: %s", facname, ReturnName(playerid), params);
    }
	return 1;
}

CMD:gov(playerid, params[])
{
	if(pData[playerid][pFaction] <= 0)
		return Error(playerid, "You are not faction!");
	
	if(pData[playerid][pFactionRank] < 5)
		return Error(playerid, "Only faction level 5-6");
		
	if(pData[playerid][pFaction] == 1)
	{
		new lstr[1024];
		format(lstr, sizeof(lstr), "** SAPD: %s(%d) %s: %s **", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], params);
		SendClientMessageToAll(COLOR_WHITE, "|___________ Government News Announcement ___________|");
		SendClientMessageToAll(COLOR_BLUE, lstr);
	}
	else if(pData[playerid][pFaction] == 2)
	{
		new lstr[1024];
		format(lstr, sizeof(lstr), "** SAGS: %s(%d) %s: %s **", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], params);
		SendClientMessageToAll(COLOR_WHITE, "|___________ Government News Announcement ___________|");
		SendClientMessageToAll(COLOR_LBLUE, lstr);
	}
	else if(pData[playerid][pFaction] == 3)
	{
		new lstr[1024];
		format(lstr, sizeof(lstr), "** SAMD: %s(%d) %s: %s **", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], params);
		SendClientMessageToAll(COLOR_WHITE, "|___________ Government News Announcement ___________|");
		SendClientMessageToAll(COLOR_PINK2, lstr);
	}
	else if(pData[playerid][pFaction] == 4)
	{
		new lstr[1024];
		format(lstr, sizeof(lstr), "** SANA: %s(%d) %s: %s **", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], params);
		SendClientMessageToAll(COLOR_WHITE, "|___________ Government News Announcement ___________|");
		SendClientMessageToAll(COLOR_ORANGE2, lstr);
	}
	return 1;
}

CMD:setrank(playerid, params[])
{
	new rank, otherid;
	if(pData[playerid][pFactionLead] == 0 && pData[playerid][pFactionRank] > 12)
		return Error(playerid, "You must faction leader!");
		
	if(sscanf(params, "ud", otherid, rank))
        return Usage(playerid, "/setrank [playerid/PartOfName] [rank 1-12]");
		
	if(otherid == INVALID_PLAYER_ID)
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pFaction] != pData[playerid][pFaction])
		return Error(playerid, "This player is not in your devision!");
	
	if(rank < 1 || rank > 13)
		return Error(playerid, "rank must 1 - 12 only");
	
	pData[otherid][pFactionRank] = rank;
	Servers(playerid, "You has set %s faction rank to level %d", pData[otherid][pName], rank);
	Servers(otherid, "%s has set your faction rank to level %d", pData[playerid][pName], rank);
	new str[150];
	format(str,sizeof(str),"[FACTION]: %s menyetel fraksi %s ke rank!", GetRPName(playerid), GetRPName(otherid), rank);
	LogServer("Faction", str);
	return 1;
}

CMD:uninvite(playerid, params[])
{
	if(pData[playerid][pFaction] <= 0)
		return Error(playerid, "You are not faction!");
		
	if(pData[playerid][pFactionRank] < 12)
		return Error(playerid, "You must faction level 12 - 13!");
	
	if(!pData[playerid][pOnDuty])
        return Error(playerid, "You must on duty!.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/uninvite [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pFactionRank] > pData[playerid][pFactionRank])
		return Error(playerid, "You cant kick him.");
		
	pData[otherid][pFactionRank] = 0;
	pData[otherid][pFaction] = 0;
	Servers(playerid, "Anda telah mengeluarkan %s dari faction.", pData[otherid][pName]);
	Servers(otherid, "%s telah mengkick anda dari faction.", pData[playerid][pName]);
	new str[150];
	format(str,sizeof(str),"[FACTION]: %s mengeluarkan %s dari fraksi!", GetRPName(playerid), GetRPName(otherid));
	LogServer("Faction", str);
	return 1;
}

CMD:invite(playerid, params[])
{
	if(pData[playerid][pFaction] <= 0)
		return Error(playerid, "You are not faction!");
		
	if(pData[playerid][pFactionRank] < 12)
		return Error(playerid, "You must faction level 12 - 13!");
	
	if(!pData[playerid][pOnDuty])
        return Error(playerid, "You must on duty!.");
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
		return Error(playerid, "Player tersebut sudah bergabung family");
		
	if(pData[otherid][pFaction] != 0)
		return Error(playerid, "Player tersebut sudah bergabung faction!");
		
	pData[otherid][pFacInvite] = pData[playerid][pFaction];
	pData[otherid][pFacOffer] = playerid;
	Servers(playerid, "Anda telah menginvite %s untuk menjadi faction.", pData[otherid][pName]);
	Servers(otherid, "%s telah menginvite anda untuk menjadi faction. Type: /accept faction or /deny faction!", pData[playerid][pName]);
	new str[150];
	format(str,sizeof(str),"[FACTION]: %s mengundang %s menjadi fraksi!", GetRPName(playerid), GetRPName(otherid));
	LogServer("Faction", str);
	return 1;
}

CMD:locker(playerid, params[])
{
	if(pData[playerid][pFaction] < 1)
		if(pData[playerid][pVip] < 1)
			return Error(playerid, "You cant use this commands!");
		
	foreach(new lid : Lockers)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]))
		{
			if(pData[playerid][pVip] > 0 && lData[lid][lType] == 5)
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERVIP, DIALOG_STYLE_LIST, "VIP Locker", "Health\nWeapons\nClothing\nVip Toys", "Okay", "Cancel");
			}
			else if(pData[playerid][pFaction] == 1 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERSAPD, DIALOG_STYLE_LIST, "SAPD Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing\nClothing War", "Proceed", "Cancel");
			}
			else if(pData[playerid][pFaction] == 2 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERSAGS, DIALOG_STYLE_LIST, "SAGS Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
			}
			else if(pData[playerid][pFaction] == 3 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERSAMD, DIALOG_STYLE_LIST, "SAMD Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nDrugs\nClothing", "Proceed", "Cancel");
			}
			else if(pData[playerid][pFaction] == 4 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERSANEW, DIALOG_STYLE_LIST, "SANA Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
			}
			else return Error(playerid, "You are not in this faction type!");
		}
	}
	/*if(pData[playerid][pFaction] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 1573.26, -1652.93, -40.59))
    	{
     		ShowPlayerDialog(playerid, LockerSAPD, DIALOG_STYLE_LIST, "SAPD Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing\nClothing War", "Proceed", "Cancel");
     	}
 		else
   		{
     		Error(playerid, "You aren't in range in area lockers.");
			return 1;
     	}
	}
	else if(pData[playerid][pFaction] == 2)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 1464.10, -1790.31, 2349.68))
    	{
     		ShowPlayerDialog(playerid, LockerSAGS, DIALOG_STYLE_LIST, "SAGS Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
     	}
 		else
   		{
     		Error(playerid, "You aren't in range in area lockers.");
			return 1;
     	}
	}
	else if(pData[playerid][pFaction] == 3)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, -1100.25, 1980.02, -58.91) || IsPlayerInRangeOfPoint(playerid, 4.0, -196.35, -1748.86, 675.76))
    	{
     		ShowPlayerDialog(playerid, LockerSAMD, DIALOG_STYLE_LIST, "SAMD Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
     	}
 		else
   		{
     		Error(playerid, "You aren't in range in area lockers.");
			return 1;
     	}
	}
	else if(pData[playerid][pFaction] == 4)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 256.14, 1776.99, 701.08))
    	{
     		ShowPlayerDialog(playerid, LockerSANEW, DIALOG_STYLE_LIST, "SANEW Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
     	}
 		else
   		{
     		Error(playerid, "You aren't in range in area lockers.");
			return 1;
     	}
	}
	else return Error(playerid, "You are not faction!");*/
	return 1;
}

//SAPD Commands
CMD:sapdonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "Kamu harus memiliki peringkat tertinggi!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 1)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SAPD Online", lstr, "Close", "");
	return 1;
}

CMD:flare(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");
		
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	
	if(IsValidDynamicObject(pData[playerid][pFlare]))
		DestroyDynamicObject(pData[playerid][pFlare]);
		
	pData[playerid][pFlare] = CreateDynamicObject(18728, x, y, z-2.8, 0, 0, a-90);
	Info(playerid, "Flare: request backup is actived! /destroyflare to delete flare.");
	SendFactionMessage(1, COLOR_RADIO, "[FLARE] "WHITE_E"Officer %s has request a backup in near (%s).", ReturnName(playerid), GetLocation(x, y, z));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s deployed a flare on the ground.", ReturnName(playerid));
    return 1;
}

CMD:destroyflare(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");
		
	if(IsValidDynamicObject(pData[playerid][pFlare]))
		DestroyDynamicObject(pData[playerid][pFlare]);
	Info(playerid, "Your flare is deleted.");
	return 1;
}

alias:detain("undetain")
CMD:detain(playerid, params[])
{
    new vehicleid = GetNearestVehicleToPlayer(playerid, 3.0, false), otherid;

    if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");
	
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/detain [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "That player is disconnected.");

    if(otherid == playerid)
        return Error(playerid, "You cannot detained yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");

    if(!pData[otherid][pCuffed])
        return Error(playerid, "The player is not cuffed at the moment.");

    if(vehicleid == INVALID_VEHICLE_ID)
        return Error(playerid, "You are not near any vehicle.");

    if(GetVehicleMaxSeats(vehicleid) < 2)
        return Error(playerid, "You can't detain that player in this vehicle.");

    if(IsPlayerInVehicle(otherid, vehicleid))
    {
        TogglePlayerControllable(otherid, 1);

        RemoveFromVehicle(otherid);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens the door and pulls %s out the vehicle.", ReturnName(playerid), ReturnName(otherid));
    }
    else
    {
        new seatid = GetAvailableSeat(vehicleid, 2);

        if(seatid == -1)
            return Error(playerid, "There are no more seats remaining.");

        new
            string[64];

        format(string, sizeof(string), "You've been ~r~detained~w~ by %s.", ReturnName(playerid));
        TogglePlayerControllable(otherid, 0);

        //StopDragging(otherid);
        PutPlayerInVehicle(otherid, vehicleid, seatid);

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens the door and places %s into the vehicle.", ReturnName(playerid), ReturnName(otherid));
        InfoTD_MSG(otherid, 3500, string);
    }
    return 1;
}

CMD:cuff(playerid, params[])
{
	if(pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2)
	{
		if(!pData[playerid][pOnDuty])
			return Error(playerid, "You must on duty to use cuff.");
		
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/cuff [playerid/PartOfName]");

		if(otherid == INVALID_PLAYER_ID)
			return Error(playerid, "That player is disconnected.");

		if(otherid == playerid)
			return Error(playerid, "You cannot handcuff yourself.");

		if(!NearPlayer(playerid, otherid, 5.0))
			return Error(playerid, "You must be near this player.");

		if(GetPlayerState(otherid) != PLAYER_STATE_ONFOOT)
			return Error(playerid, "The player must be onfoot before you can cuff them.");

		if(pData[otherid][pCuffed])
			return Error(playerid, "The player is already cuffed at the moment.");

		pData[otherid][pCuffed] = 1;
		SetPlayerSpecialAction(otherid, SPECIAL_ACTION_CUFFED);
		
		new mstr[128];
		format(mstr, sizeof(mstr), "You've been ~r~cuffed~w~ by %s.", ReturnName(playerid));
		InfoTD_MSG(otherid, 3500, mstr);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s tightens a pair of handcuffs on %s's wrists.", ReturnName(playerid), ReturnName(otherid));
	}
	else
	{
		return Error(playerid, "You not police/gov.");
	}
    return 1;
}

CMD:uncuff(playerid, params[])
{
	if(pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2)
	{
	
		if(!pData[playerid][pOnDuty])
			return Error(playerid, "You must on duty to use cuff.");
		
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/uncuff [playerid/PartOfName]");

		if(otherid == INVALID_PLAYER_ID)
			return Error(playerid, "That player is disconnected.");

		if(otherid == playerid)
			return Error(playerid, "You cannot uncuff yourself.");

		if(!NearPlayer(playerid, otherid, 5.0))
			return Error(playerid, "You must be near this player.");

		if(!pData[otherid][pCuffed])
			return Error(playerid, "The player is not cuffed at the moment.");

		static
			string[64];

		pData[otherid][pCuffed] = 0;
		SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

		format(string, sizeof(string), "You've been ~g~uncuffed~w~ by %s.", ReturnName(playerid));
		InfoTD_MSG(otherid, 3500, string);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s loosens the pair of handcuffs on %s's wrists.", ReturnName(playerid), ReturnName(otherid));
	}
	else
	{
		return Error(playerid, "You not police/gov.");
	}
    return 1;
}

CMD:release(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");
	
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 59.6879, 1067.4708, -50.9141))
		return Error(playerid, "You must be near an arrest point.");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/release <ID/Name>");
	    return true;
	}

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player tersebut belum masuk!");
	
	if(otherid == playerid)
		return Error(playerid, "You cant release yourself!");

	if(pData[otherid][pArrest] == 0)
	    return Error(playerid, "The player isn't in arrest!");

	pData[otherid][pArrest] = 0;
	pData[otherid][pArrestTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPositionEx(otherid, 1526.69, -1678.05, 5.89, 267.76, 2000);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

	SendClientMessageToAllEx(COLOR_BLUE, "[PRISON]"WHITE_E"Officer %s telah membebaskan %s dari penjara.", ReturnName(playerid), ReturnName(otherid));
	new str[150];
	format(str,sizeof(str),"[FACTION]: %s membebaskan %s dari penjara!", GetRPName(playerid), GetRPName(otherid));
	LogServer("Faction", str);
	return true;
}


CMD:arrest(playerid, params[])
{
    static
        denda,
		cellid,
        times,
		otherid;

    if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");
		
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 59.6879, 1067.4708, -50.9141))
		return Error(playerid, "You must be near an arrest point.");

    if(sscanf(params, "uddd", otherid, cellid, times, denda))
        return Usage(playerid, "/arrest [playerid/PartOfName] [cell id] [minutes] [denda]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "The player is disconnected or not near you.");
		
	/*if(otherid == playerid)
		return Error(playerid, "You cant arrest yourself!");*/

    if(times < 1 || times > 120)
        return Error(playerid, "The specified time can't be below 1 or above 120.");
		
	if(cellid < 1 || cellid > 4)
        return Error(playerid, "The specified cell id can't be below 1 or above 4.");
		
	if(denda < 100 || denda > 20000)
        return Error(playerid, "The specified denda can't be below 100 or above 20,000.");

    /*if(!IsPlayerNearArrest(playerid))
        return Error(playerid, "You must be near an arrest point.");*/

	GivePlayerMoneyEx(otherid, -denda);
    pData[otherid][pArrest] = cellid;
    pData[otherid][pArrestTime] = times * 60;
	
	SetPlayerArrest(otherid, cellid);

    
    SendClientMessageToAllEx(COLOR_BLUE, "[PRISON]"WHITE_E" %s telah ditangkap dan dipenjarakan oleh polisi selama %d hari dengan denda "GREEN_E"%s.", ReturnName(otherid), times, FormatMoney(denda));
    new str[150];
	format(str,sizeof(str),"[FACTION]: %s mempenjarakan %s selama %d hari dan denda %s!", GetRPName(playerid), GetRPName(otherid), times, FormatMoney(denda));
	LogServer("Faction", str);
	return 1;
}

CMD:getloc(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu harus menjadi police officer.");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/getloc <ID/Name>");
	    return true;
	}

	if(pData[playerid][pSuspectTimer] > 1)
		return Error(playerid, "Anad harus menunggu %d detik untuk melanjutkan GetLoc",pData[playerid][pSuspectTimer]);

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player tersebut belum masuk!");
	
	if(otherid == playerid)
		return Error(playerid, "You cant getloc yourself!");

	if(pData[otherid][pPhone] == 0) return Error(playerid, "Player tersebut belum memiliki Ponsel");
	if(pData[otherid][pPhoneStatus] == 0) return Error(playerid, "Tidak dapat mendeteksi lokasi, Ponsel tersebut yang dituju sedang Offline");

    new zone[MAX_ZONE_NAME];
	GetPlayer3DZone(otherid, zone, sizeof(zone));
	new Float:sX, Float:sY, Float:sZ;
	GetPlayerPos(otherid, sX, sY, sZ);
	SetPlayerCheckpoint(playerid, sX, sY, sZ, 5.0);
	pData[playerid][pSuspectTimer] = 120;
	Info(playerid, "Target Nama : %s", pData[otherid][pName]);
	Info(playerid, "Target Akun Twitter : %s", pData[otherid][pTwittername]);
	Info(playerid, "Lokasi : %s", zone);
	Info(playerid, "Nomer Telepon : %d", pData[otherid][pPhone]);
	return 1;
}

/*CMD:su(playerid, params[])
{
	new crime[64];
	if(sscanf(params, "us[64]", otherid, crime)) return Usage(playerid, "(/su)spect [playerid] [crime discription]");

	if (pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2)
	{
		if(IsPlayerConnected(otherid))
		{
			if(otherid != INVALID_PLAYER_ID)
			{
				if(otherid == playerid)
				{
					Error(playerid, COLOR_GREY, "Kamu tidak dapat mensuspek dirimu!");
					return 1;
				}
				if(pData[playerid][pFaction] > 0)
				{
					Error(playerid, COLOR_GREY, "Tidak dapat mensuspek fraksi!");
					return 1;
				}
				WantedPoints[otherid] += 1;
				pData[playerid][pSuspect] = 1;
				SetPlayerCriminal(otherid,playerid, crime);
				return 1;
			}
		}
		else
		{
			Error(playerid, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		Error(playerid, "   You are not a Cop/Gov!");
	}
	return 1;
}*/

CMD:ticket(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
			return Error(playerid, "Kamu harus menjadi sapd officer.");
	
	new vehid, ticket;
	if(sscanf(params, "dd", vehid, ticket))
		return Usage(playerid, "/ticket [vehid] [ammount] | /checkveh - for find vehid");
	
	if(vehid == INVALID_VEHICLE_ID || !IsValidVehicle(vehid))
		return Error(playerid, "Invalid id");
	
	if(ticket < 0 || ticket > 500)
		return Error(playerid, "Ammount max of ticket is $1 - $500!");
	
	new nearid = GetNearestVehicleToPlayer(playerid, 5.0, false);
	
	foreach(new ii : PVehicles)
	{
		if(vehid == pvData[ii][cVeh])
		{
			if(vehid == nearid)
			{
				if(pvData[ii][cTicket] >= 2000)
					return Error(playerid, "Kendaraan ini sudah mempunyai terlalu banyak ticket!");
					
				pvData[ii][cTicket] += ticket;
				Info(playerid, "Anda telah menilang kendaraan %s(id: %d) dengan denda sejumlah "RED_E"%s", GetVehicleName(vehid), vehid, FormatMoney(ticket));
				new str[150];
				format(str,sizeof(str),"[FACTION]: %s menilang kendaraan %s(id: %d) dengan denda %s!", GetRPName(playerid), GetVehicleName(vehid), vehid, FormatMoney(ticket));
				LogServer("Faction", str);
				return 1;
			}
			else return Error(playerid, "Anda harus berada dekat dengan kendaraan tersebut!");
		}
	}
	return 1;
}

CMD:checkveh(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		if(pData[playerid][pAdmin] < 1)
			return Error(playerid, "Kamu harus menjadi sapd officer.");
		
	static carid = -1;
	new vehicleid = GetNearestVehicleToPlayer(playerid, 3.0, false);

	if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
		return Error(playerid, "You not in near any vehicles.");
	
	if((carid = Vehicle_Nearest(playerid)) != -1)
	{
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE reg_id='%d'", pvData[carid][cOwner]);
		mysql_query(g_SQL, query);
		new rows = cache_num_rows();
		if(rows) 
		{
			new owner[32];
			cache_get_value_index(0, 0, owner);
			
			if(strcmp(pvData[carid][cPlate], "NoHave"))
			{
				Info(playerid, "ID: %d | Model: %s | Owner: %s | Plate: %s | Plate Time: %s", vehicleid, GetVehicleName(vehicleid), owner, pvData[carid][cPlate], ReturnTimelapse(gettime(), pvData[carid][cPlateTime]));
			}
			else
			{
				Info(playerid, "ID: %d | Model: %s | Owner: %s | Plate: None | Plate Time: None", vehicleid, GetVehicleName(vehicleid), owner);
			}
		}
		else
		{
			Error(playerid, "This vehicle no owned found!");
			return 1;
		}
	}
	else
	{
		Error(playerid, "You are not in near owned private vehicle.");
		return 1;
	}	
	return 1;
}


CMD:takemarijuana(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi sapd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be 1 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takemarijuana <ID/Name> | Melenyapkan Marijuana");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player tersebut belum masuk!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
		
	pData[otherid][pMarijuana] = 0;
	Info(playerid, "Anda telah mengambil semua marijuana milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah mengambil semua marijuana milik anda", ReturnName(playerid));
	return 1;
}

CMD:takedl(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi sapd officer.");
	if(pData[playerid][pFactionRank] < 2)
		return Error(playerid, "You must be 2 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takedl <ID/Name> | Tilang Driving License(SIM)");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player tersebut belum masuk!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
		
	pData[otherid][pDriveLic] = 0;
	pData[otherid][pDriveLicTime] = 0;
	Info(playerid, "Anda telah menilang Driving License milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah menilang Driving License milik anda", ReturnName(playerid));
	return 1;
}

//SAGS Commands
CMD:sagsonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 2)
        return Error(playerid, "Kamu harus menjadi sags officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "Kamu harus memiliki peringkat tertinggi!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 2)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SAGS Online", lstr, "Close", "");
	return 1;
}

CMD:checkcitymoney(playerid, params)
{
	if(pData[playerid][pFaction] != 2)
        return Error(playerid, "Kamu harus menjadi sags officer.");
	if(pData[playerid][pFactionRank] < 12)
		return Error(playerid, "Kamu harus memiliki peringkat tertinggi!");

	new lstr[300];
	format(lstr, sizeof(lstr), "City Money: {3BBD44}%s", FormatMoney(ServerMoney));
	ShowPlayerDialog(playerid, DIALOG_SERVERMONEY, DIALOG_STYLE_MSGBOX, "Great City Money", lstr, "Manage", "Close");
	return 1;
}

//SAMD Commands
CMD:loadinjured(playerid, params[])
{
    static
        seatid,
		otherid;

    if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be part of a medical faction.");

    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/loadinjured [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 10.0))
        return Error(playerid, "Player tersebut tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "You can't load yourself into an ambulance.");

    if(!pData[otherid][pInjured])
        return Error(playerid, "That player is not injured.");
	
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    Error(playerid, "You must be in a Ambulance to load patient!");
	    return true;
	}
		
	new i = GetPlayerVehicleID(playerid);
    if(GetVehicleModel(i) == 416)
    {
        seatid = GetAvailableSeat(i, 2);

        if(seatid == -1)
            return Error(playerid, "There is no room for the patient.");

        ClearAnimations(otherid);
        pData[otherid][pInjured] = 2;

        PutPlayerInVehicle(otherid, i, seatid);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens up the ambulance and loads %s on the stretcher.", ReturnName(playerid), ReturnName(otherid));

        TogglePlayerControllable(otherid, 0);
        SetPlayerHealth(otherid, 100.0);
        Info(otherid, "You're injured ~r~now you're on ambulance.");
        return 1;
    }
    else Error(playerid, "You must be in an ambulance.");
    return 1;
}

CMD:dropinjured(playerid, params[])
{

    if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be part of a medical faction.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/dropinjured [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !IsPlayerInVehicle(playerid, GetPlayerVehicleID(playerid)))
        return Error(playerid, "Player tersebut tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "You can't deliver yourself to the hospital.");

    if(pData[otherid][pInjured] != 2)
        return Error(playerid, "That player is not injured.");

    if(IsPlayerInRangeOfPoint(playerid, 5.0, 1142.38, -1330.74, 13.62))
    {
		RemovePlayerFromVehicle(otherid);
		pData[otherid][pHospital] = 1;
		pData[otherid][pHospitalTime] = 0;
		pData[otherid][pInjured] = 1;
		ResetPlayerWeaponsEx(otherid);
        Info(playerid, "You have delivered %s to the hospital.", ReturnName(otherid));
        Info(otherid, "You have recovered at the nearest hospital by officer %s.", ReturnName(playerid));
    }
    else Error(playerid, "You must be near a hospital deliver location.");
    return 1;
}

CMD:samdonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "Kamu harus memiliki peringkat tertinggi!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 3)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SAMD Online", lstr, "Close", "");
	return 1;
}

CMD:ems(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");
	
	foreach(new ii : Player)
	{
		if(pData[ii][pInjured])
		{
			SendClientMessageEx(playerid, COLOR_PINK2, "EMS Player: "WHITE_E"%s(id: %d)", ReturnName(ii), ii);
		}
	}
	Info(playerid, "/findems [id] to search injured player!");
	return 1;
}

CMD:findems(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");
		
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/findems [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid)) return Error(playerid, "Player is not connected");
	
	if(otherid == playerid)
        return Error(playerid, "You can't find yourself.");
	
	if(!pData[otherid][pInjured]) return Error(playerid, "You can't find a player that's not injured.");
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(otherid, x, y, z);
	SetPlayerCheckpoint(playerid, x, y, x, 4.0);
	pData[playerid][pFindEms] = otherid;
	Info(otherid, "SAMD Officer %s sedang menuju ke lokasi anda. harap tunggu!", ReturnName(playerid));
	return 1;
}

CMD:rescue(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");
	
	if(pData[playerid][pMedkit] < 1) return Error(playerid, "You need medkit.");
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/rescue [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tersebut tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "You can't rescue yourself.");

    if(!pData[otherid][pInjured])
        return Error(playerid, "That player is not injured.");
	
	pData[playerid][pMedkit]--;
	
	SetPlayerHealthEx(otherid, 50.0);
    pData[otherid][pInjured] = 0;
	pData[otherid][pHospital] = 0;
	pData[otherid][pSick] = 0;
    ClearAnimations(otherid);
	ApplyAnimation(otherid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
	
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has rescuered %s with medkit tools.", ReturnName(playerid), ReturnName(otherid));
    Info(otherid, "Officer %s has rescue your character.", ReturnName(playerid));
	return 1;
}

CMD:sellobat(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1430.44, 2.16,1000.92)) return Error(playerid, "You're not near in sell places.");

	if(pData[playerid][pObat] < 1)
		return Error(playerid, "Anda tidak memiliki Obat");

	ObatMyr += 1;
	pData[playerid][pObat] -= 1;
	Servers(playerid, "Anda berhasil menjual 1 Obat anda!");
	Server_Save();
	return 1;
}

CMD:mix(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");

    if(IsPlayerInRangeOfPoint(playerid, 2.0, -1775.2911, -1994.0675, 1500.7853))
    {
    	if(pData[playerid][pMedicine] < 4)
    		return Error(playerid, "Anda harus memiliki 4 Medicine & 1 Marijuana");

    	if(pData[playerid][pMarijuana] < 1)
    		return Error(playerid, "Anda harus memiliki 4 Medicine & 1 Marijuana");

    	TogglePlayerControllable(playerid, 0);
    	Info(playerid, "Anda sedang memproduksi bahan makanan dengan 40 food!");
    	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pProductingStatus] = 1;
    	pData[playerid][pProducting] = SetTimerEx("CreateObat", 1000, true, "id", playerid, 1);
    	PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Meracik...");
    	PlayerTextDrawShow(playerid, ActiveTD[playerid]);
    	ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	}
	return 1;
}

CMD:salve(playerid, params[])
{
	new Float:health;
	health = GetPlayerHealth(playerid, health);
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");
	
	if(pData[playerid][pMedicine] < 1) return Error(playerid, "Kamu butuh Medicine.");
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/salve [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tersebut tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa mensalve dirimu sendiri.");

    if(pData[otherid][pSick] == 0)
        return Error(playerid, "Player itu tidak sakit.");
	
	pData[playerid][pMedicine]--;
	
	//SetPlayerHealthEx(otherid, 50.0);
    //pData[otherid][pInjured] = 0;
	//pData[otherid][pHospital] = 0;
	SetPlayerHealth(playerid, health+50);
	pData[otherid][pHunger] += 20;
	pData[otherid][pEnergy] += 20;
	pData[otherid][pSick] = 0;
	pData[otherid][pSickTime] = 0;
    ClearAnimations(otherid);
	ApplyAnimation(otherid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
	SetPlayerDrunkLevel(otherid, 0);
	
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has given medicine to %s with the right hand.", ReturnName(playerid), ReturnName(otherid));
    Info(otherid, "Officer %s has resalve your sick character.", ReturnName(playerid));
	return 1;
}

CMD:healbone(playerid, params[])
{
	new Float:health;
	health = GetPlayerHealth(playerid, health);
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");
	
	if(pData[playerid][pMedicine] < 1) return Error(playerid, "Kamu butuh Medicine.");
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/healbone [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tersebut tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa memperbaiki kesehatan tulang dirimu sendiri.");
	
	pData[playerid][pMedicine]--;
	
	//SetPlayerHealthEx(otherid, 50.0);
    //pData[otherid][pInjured] = 0;
	//pData[otherid][pHospital] = 0;
	SetPlayerHealth(playerid, health+50);
	pData[otherid][pHead] += 60;
	pData[otherid][pPerut] += 60;
	pData[otherid][pRHand] += 60;
	pData[otherid][pLHand] += 60;
	pData[otherid][pRFoot] += 60;
	pData[otherid][pLFoot] += 60;
	pData[otherid][pSickTime] = 0;
    ClearAnimations(otherid);
	SetPlayerDrunkLevel(otherid, 0);
	
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has given medicine to %s with the right hand.", ReturnName(playerid), ReturnName(otherid));
    Info(otherid, "Officer %s has resalve your sick character.", ReturnName(playerid));
	return 1;
}

CMD:treatment(playerid, params[])
{
	new otherid;
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");
	
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/treatment [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tersebut tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa treatment dirimu sendiri.");

   	TogglePlayerControllable(playerid, 0);
	TogglePlayerControllable(otherid, 0);   
   	Info(playerid, "Kamu sedang mentreatment %s!", ReturnName(otherid));
	Info(otherid, "Kamu sedang ditreatment oleh medis, Mohon tenang!");
   	//ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	pData[playerid][pProductingStatus] = 1;
   	pData[playerid][pProducting] = SetTimerEx("TreatmentPlayer", 1000, true, "iid", playerid, otherid, 1);
   	PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Treatment...");
   	PlayerTextDrawShow(playerid, ActiveTD[playerid]);
   	ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	return 1;
}

CMD:revive(playerid, params[])
{
			
	new otherid;
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "Kamu harus menjadi samd officer.");
		
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/revive [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

    if(!pData[otherid][pInjured])
        return Error(playerid, "Tidak bisa revive karena tidak injured.");

	if(otherid == playerid)
        return Error(playerid, "Tidak bisa revive kedirimu sendiri.");

    if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "Player disconnect atau tidak berada didekat anda.");

    if(pData[playerid][pObat] < 1)
    	return Error(playerid, "Tidak dapat Revive karena anda tidak memiliki Obat");

    SetTimerEx("Reviving", 5000, 0, "i", playerid);
    TogglePlayerControllable(playerid, 0);
    GameTextForPlayer(playerid, "~w~REVIVING...", 5000, 3);
    pData[playerid][pObat] -= 1;
    pData[otherid][pInjured] = 0;
    pData[otherid][pHospital] = 0;
    pData[otherid][pSick] = 0;
    pData[otherid][pHead] = 100;
    pData[otherid][pPerut] = 100;
    pData[otherid][pRHand] = 100;
    pData[otherid][pLHand] = 100;
    pData[otherid][pRFoot] = 100;
    pData[otherid][pLFoot] = 100;
    SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);
    ClearAnimations(otherid);
	ApplyAnimation(otherid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
    TogglePlayerControllable(otherid, 1);
    SetPVarInt(playerid, "gcPlayer", otherid);
    ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 1, 1, 1);
    SetPlayerHealthEx(otherid, 100.0);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s menyembuhkan segala luka %s.", ReturnName(playerid), ReturnName(otherid));
    Info(otherid, "%s has revived you.", pData[playerid][pAdminname]);
    return 1;
}

//SANEW Commands
CMD:sanaonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 4)
        return Error(playerid, "Kamu harus menjadi sanew officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "Kamu harus memiliki peringkat tertinggi!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 4)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SANA Online", lstr, "Close", "");
	return 1;
}

CMD:broadcast(playerid, params[])
{
    if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");

    //if(!IsSANEWCar(GetPlayerVehicleID(playerid)) || !IsPlayerInRangeOfPoint(playerid, 5, 255.63, 1757.39, 701.09))
    //    return Error(playerid, "You must be inside a news van or chopper or in sanew studio.");

    if(!pData[playerid][pBroadcast])
    {
        pData[playerid][pBroadcast] = true;

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has started a news broadcast.", ReturnName(playerid));
        Servers(playerid, "You have started a news broadcast (use \"/bc [broadcast text]\" to broadcast).");
    }
    else
    {
        pData[playerid][pBroadcast] = false;

        foreach (new i : Player) if(pData[i][pNewsGuest] == playerid) 
		{
            pData[i][pNewsGuest] = INVALID_PLAYER_ID;
        }
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has stopped a news broadcast.", ReturnName(playerid));
        Servers(playerid, "You have stopped the news broadcast.");
    }
    return 1;
}


CMD:bc(playerid, params[])
{
    if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");

    if(isnull(params))
        return Usage(playerid, "/bc [broadcast text]");

    //if(!IsSANEWCar(GetPlayerVehicleID(playerid)) || !IsPlayerInRangeOfPoint(playerid, 5, 255.63, 1757.39, 701.09))
    //    return Error(playerid, "You must be inside a news van or chopper or in sanew studio.");

    if(!pData[playerid][pBroadcast])
        return Error(playerid, "You must be broadcasting to use this command.");

    if(strlen(params) > 64) {
        foreach (new i : Player) /*if(!pData[i][pDisableBC])*/ {
            SendClientMessageEx(i, COLOR_ORANGE, "[SANA] Reporter %s: %.64s", ReturnName(playerid), params);
            SendClientMessageEx(i, COLOR_ORANGE, "...%s", params[64]);
        }
    }
    else {
        foreach (new i : Player) /*if(!pData[i][pDisableBC])*/ {
            SendClientMessageEx(i, COLOR_ORANGE, "[SANA] Reporter %s: %s", ReturnName(playerid), params);
        }
    }
    return 1;
}

CMD:live(playerid, params[])
{
    static
        livechat[128];
        
    if(sscanf(params, "s[128]", livechat))
        return Usage(playerid, "/live [live chat]");

    if(pData[playerid][pNewsGuest] == INVALID_PLAYER_ID)
        return Error(playerid, "You're now invite by sanew member to live!");

    /*if(!IsNewsVehicle(GetPlayerVehicleID(playerid)) || !IsPlayerInRangeOfPoint(playerid, 5, 255.63, 1757.39, 701.09))
        return Error(playerid, "You must in news chopper or in studio to live.");*/

    if(pData[pData[playerid][pNewsGuest]][pFaction] == 4)
    {
        foreach (new i : Player) /*if(!pData[i][pDisableBC])*/ {
            SendClientMessageEx(i, COLOR_LIGHTGREEN, "[SANA] Guest %s: %s", ReturnName(playerid), livechat);
        }
    }
    return 1;
}

CMD:inviteguest(playerid, params[])
{
    if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");
		
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/inviteguest [playerid/PartOfName]");

    if(!pData[playerid][pBroadcast])
        return Error(playerid, "You must be broadcasting to use this command.");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tersebut tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "You can't add yourself as a guest.");

    if(pData[otherid][pNewsGuest] == playerid)
        return Error(playerid, "That player is already a guest of your broadcast.");

    if(pData[otherid][pNewsGuest] != INVALID_PLAYER_ID)
        return Error(playerid, "That player is already a guest of another broadcast.");

    pData[otherid][pNewsGuest] = playerid;

    Info(playerid, "You have added %s as a broadcast guest.", ReturnName(otherid));
    Info(otherid, "%s has added you as a broadcast guest ((/live to start broadcast)).", ReturnName(otherid));
    return 1;
}

CMD:removeguest(playerid, params[])
{

    if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/removeguest [playerid/PartOfName]");

    if(!pData[playerid][pBroadcast])
        return Error(playerid, "You must be broadcasting to use this command.");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tersebut tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "You can't remove yourself as a guest.");

    if(pData[otherid][pNewsGuest] != playerid)
        return Error(playerid, "That player is not a guest of your broadcast.");

    pData[otherid][pNewsGuest] = INVALID_PLAYER_ID;

    Info(playerid, "You have removed %s from your broadcast.", ReturnName(otherid));
    Info(otherid, "%s has removed you from their broadcast.", ReturnName(otherid));
    return 1;
}

forward CreateObat(playerid);
public CreateObat(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pProductingStatus] != 1) return 0;

	if(pData[playerid][pActivityTime] >= 100)
	{
		new bonus = RandomEx(80,100);
		GivePlayerMoneyEx(playerid, bonus);
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Myricous Created!");
		KillTimer(pData[playerid][pProducting]);
		pData[playerid][pProductingStatus] = 0;
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pObat] += 1;
		pData[playerid][pMedicine] -= 4;
		pData[playerid][pMarijuana] -= 1;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pEnergy] -= 3;
		ClearAnimations(playerid);
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

forward DutyHour(playerid);
public DutyHour(playerid)
{
	if(pData[playerid][pOnDuty] < 1)
		return KillTimer(DutyTimer);

	pData[playerid][pDutyHour] += 1;
	if(pData[playerid][pDutyHour] == 3600)
	{
		if(pData[playerid][pFaction] == 1)
		{
			AddPlayerSalary(playerid, "Duty(SAPD)", 1500);
			pData[playerid][pDutyHour] = 0;
			Servers(playerid, "Anda telah Duty selama 1 Jam dan Anda mendapatkan Pending Salary anda");
		}
		else if(pData[playerid][pFaction] == 2)
		{
			AddPlayerSalary(playerid, "Duty(SAGS)", 1500);
			pData[playerid][pDutyHour] = 0;
			Servers(playerid, "Anda telah Duty selama 1 Jam dan Anda mendapatkan Pending Salary anda");
		}
		else if(pData[playerid][pFaction] == 3)
		{
			AddPlayerSalary(playerid, "Duty(SAMD)", 1500);
			pData[playerid][pDutyHour] = 0;
			Servers(playerid, "Anda telah Duty selama 1 Jam dan Anda mendapatkan Pending Salary anda");
		}
		else if(pData[playerid][pFaction] == 4)
		{
			AddPlayerSalary(playerid, "Duty(SANEWS)", 1500);
			pData[playerid][pDutyHour] = 0;
			Servers(playerid, "Anda telah Duty selama 1 Jam dan Anda mendapatkan Pending Salary anda");
		}
	}
	return 1;
}

forward TreatmentPlayer(playerid, otherid);
public TreatmentPlayer(playerid, otherid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pProductingStatus] != 1) return 0;

	if(pData[playerid][pActivityTime] >= 100)
	{
		TogglePlayerControllable(playerid, 1);
		TogglePlayerControllable(otherid, 1);
		SetPlayerHealthEx(otherid, 100);
		InfoTD_MSG(playerid, 8000, "Treatment Sucess!");
		InfoTD_MSG(otherid, 8000, "Treatment Sucess!");
		KillTimer(pData[playerid][pProducting]);
		pData[playerid][pProductingStatus] = 0;
		pData[playerid][pActivityTime] = 0;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pEnergy] -= 3;
		ClearAnimations(playerid);
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		//ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}