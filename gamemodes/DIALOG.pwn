//----------------[ Dialog System ]--------------

//----------[ Dialog Login Register]----------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	printf("[OnDialogResponse]: %s(%d) has used dialog id: %d Listitem: %d", pData[playerid][pUCP], playerid, dialogid, listitem);
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);

		new hashed_pass[65];
		SHA256_PassHash(inputtext, pData[playerid][pSalt], hashed_pass, 65);

		if (strcmp(hashed_pass, pData[playerid][pPassword]) == 0)
		{
			new query1[256];
			//mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", pData[playerid][pName]);
			//mysql_pquery(g_SQL, query, "AssignPlayerData", "d", playerid);
			CheckPlayerChar(playerid);
			printf("[LOGIN] %s(%d) berhasil login dengan password(%s)", pData[playerid][pUCP], playerid, inputtext);

			mysql_format(g_SQL, query1, sizeof(query1), "INSERT INTO loglogin (username,reg_id,password,time) VALUES('%s','%d','%s',CURRENT_TIMESTAMP())", pData[playerid][pUCP], pData[playerid][pID], inputtext);
			mysql_tquery(g_SQL, query1);
			
			/*//ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Login", "You have been successfully logged in.", "Okay", "");
			printf("[LOGIN] %s(%d) telah sukses login dengan password(%s)", pData[playerid][pName], playerid, inputtext);
			cache_set_active(pData[playerid][Cache_ID]);

			AssignPlayerData(playerid);

			cache_delete(pData[playerid][Cache_ID]);
			pData[playerid][Cache_ID] = MYSQL_INVALID_CACHE;

			KillTimer(pData[playerid][LoginTimer]);
			pData[playerid][LoginTimer] = 0;
			pData[playerid][IsLoggedIn] = true;

			SetSpawnInfo(playerid, NO_TEAM, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);*/
		}
		else
		{
			pData[playerid][LoginAttempts]++;

			if (pData[playerid][LoginAttempts] >= 3)
			{
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Login", "You have mistyped your password too often (3 times).", "Okay", "");
				KickEx(playerid);
			}
			else 
			{
				new lstring[300];
				format(lstring, sizeof lstring, "{ffffff}Welcome back to {15D4ED}"SERVER_NAME"\n{ffffff}Account: {15D4ED}%s\n{ffffff}Attemps: {FF0000}%i/3{ffffff}\nPassword: {3BBD44}(input below)\n\n{FF0000}Wrong password!", pData[playerid][pUCP], pData[playerid][LoginAttempts]);
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login to Great", lstring, "Login", "Quit");
			}
		}
        return 1;
    }
	if(dialogid == DIALOG_REGISTER)
    {
		if (!response) return Kick(playerid);
	
		if (strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Great", "Kata sandi minimal 5 Karakter!\nMohon isi Password dibawah ini:", "Register", "Tolak");
		
		if(!IsValidPassword(inputtext))
		{
			Error(playerid, "Sandi valid : A-Z, a-z, 0-9, _, [ ], ( )");
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Great", "Kata sandi yang anda gunakan mengandung karakter yang valid!\nMohon isi Password dibawah ini:", "Register", "Tolak");
			return 1;
		}
		
		for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
		SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

		new query[842], PlayerIP[16];
		GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
		pData[playerid][pExtraChar] = 0;
		mysql_format(g_SQL, query, sizeof query, "UPDATE playerucp SET password = '%s', salt = '%e', extrac = '%d' WHERE ucp = '%e'", pData[playerid][pPassword], pData[playerid][pSalt], pData[playerid][pExtraChar], pData[playerid][pUCP]);
		mysql_tquery(g_SQL, query, "CheckPlayerChar", "i", playerid);//rung bar
		return 1;
	}
	if(dialogid == DIALOG_CHARLIST)
    {
		if(response)
		{
			if(PlayerChar[playerid][listitem][0] == EOS)
				return ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "Create Character", "Insert your new Character Name\n\nExample: Finn_Xanderz, Javier_Cooper etc.", "Create", "Exit");
			pData[playerid][pChar] = listitem;
			SetPlayerName(playerid, PlayerChar[playerid][listitem]);	
			new cQuery[256];
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT * FROM `players` WHERE `username` = '%s' LIMIT 1;", PlayerChar[playerid][pData[playerid][pChar]]);
			mysql_tquery(g_SQL, cQuery, "AssignPlayerData", "d", playerid);		
		}
	}
	if(dialogid == DIALOG_MAKE_CHAR)
	{
	    if(response)
	    {
		    if(strlen(inputtext) < 1 || strlen(inputtext) > 24)
				return ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "Create Character", "Insert your new Character Name\n\nExample: Finn_Xanderz, Javier_Cooper etc.", "Create", "Back");
			if(!IsValidRoleplayName(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "Create Character", "Insert your new Character Name\n\nExample: Finn_Xanderz, Javier_Cooper etc.", "Create", "Back");
			//if()	
			new characterQuery[178];
			mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s'", inputtext);
			mysql_tquery(g_SQL, characterQuery, "CekNamaDobelJing", "ds", playerid, inputtext);
		    format(pData[playerid][pUCP], 22, GetName(playerid));
		}
	}
	if(dialogid == DIALOG_AGE)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;
				
			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tahun Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Bulan Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else 
			{
				format(pData[playerid][pAge], 50, inputtext);
				ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_GENDER)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
		if(response)
		{
			pData[playerid][pGender] = listitem + 1;
			switch (listitem) 
			{
				case 0: 
				{
					SendClientMessageEx(playerid,COLOR_WHITE,"[SERVER]: Registrasi Berhasil! Terima kasih telah bergabung ke dalam server!");
					SendClientMessageEx(playerid,COLOR_WHITE,"[SERVER]: Tanggal Lahir : %s | Gender : Male/Laki-Laki", pData[playerid][pAge]);
					ShowPlayerDialog(playerid, DIALOG_SPAWN_1, DIALOG_STYLE_LIST, "Select Your Location", "» Unity Station\n» Market Station\n» Airport Los Santos", "Select", "Cancel");
					
				}
				case 1: 
				{
					SendClientMessageEx(playerid,COLOR_WHITE,"[SERVER]: Registrasi Berhasil! Terima kasih telah bergabung ke dalam server!");
					SendClientMessageEx(playerid,COLOR_WHITE,"[SERVER]: Tanggal Lahir : %s | Gender : Female/Perempuan", pData[playerid][pAge]);
					ShowPlayerDialog(playerid, DIALOG_SPAWN_1, DIALOG_STYLE_LIST, "Select Your Location", "» Unity Station\n» Market Station\n» Airport Los Santos", "Select", "Cancel");
					
				}
				//pData[playerid][pSkin] = (listitem) ? (233) : (98);
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_EMAIL)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				Error(playerid, "This field cannot be left empty!");
				callcmd::email(playerid);
				return 1;
			}
			if(!(2 < strlen(inputtext) < 40))
			{
				Error(playerid, "Please insert a valid email! Must be between 3-40 characters.");
				callcmd::email(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Email can contain only A-Z, a-z, 0-9, _, [ ], ( )  and @");
				callcmd::email(playerid);
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET email='%e' WHERE reg_id='%d'", inputtext, pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your e-mail has been set to "YELLOW_E"%s!"WHITE_E"(relogin for /stats update)", inputtext);
			return 1;
		}
	}
	if(dialogid == DIALOG_PASSWORD)
	{
		if(response)
		{
			if(!(3 < strlen(inputtext) < 20))
			{
				Error(playerid, "Please insert a valid password! Must be between 4-20 characters.");
				callcmd::changepass(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Password can contain only A-Z, a-z, 0-9, _, [ ], ( )");
				callcmd::changepass(playerid);
				return 1;
			}
			new query[512];
			for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
			SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE playerucp SET password='%s', salt='%e' WHERE ucp='%e'", pData[playerid][pPassword], pData[playerid][pSalt], pData[playerid][pUCP]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your password has been updated to "YELLOW_E"'%s'", inputtext);
		}
	}
	if(dialogid == DIALOG_STATS)
	{
		if(response)
		{
			return callcmd::settings(playerid);
		}
	}
	if(dialogid == DIALOG_SETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::email(playerid);
				}
				case 1:
				{
					return callcmd::changepass(playerid);
				}
				case 2:
				{	
					ShowPlayerDialog(playerid, DIALOG_HBEMODE, DIALOG_STYLE_LIST, "HBE Mode", ""LG_E"Enable\n"RED_E"Disable", "Set", "Close");
				}
				case 3:
				{
					return callcmd::togpm(playerid);
				}
				case 4:
				{
					return callcmd::toglog(playerid);
				}
				case 5:
				{
					return callcmd::togads(playerid);
				}
				case 6:
				{
					return callcmd::togwt(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_HBEMODE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{					
					HidePlayerProgressBar(playerid, pData[playerid][sphungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][spenergybar]);
					for(new txd; txd < 7; txd++)
					{
						TextDrawHideForPlayer(playerid, StatsTD[txd]);
					}
					
					PlayerTextDrawHide(playerid,  PNameStats[playerid]);
					PlayerTextDrawHide(playerid,  PSkinStats[playerid]);
					TextDrawHideForPlayer(playerid, TextDate);
					TextDrawHideForPlayer(playerid, TextTime);

					pData[playerid][pHBEMode] = 1;
					
					ShowPlayerProgressBar(playerid, pData[playerid][sphungrybar]);
					ShowPlayerProgressBar(playerid, pData[playerid][spenergybar]);
					for(new txd; txd < 7; txd++)
					{
						TextDrawShowForPlayer(playerid, StatsTD[txd]);
					}
					PlayerTextDrawShow(playerid, PNameStats[playerid]);
					PlayerTextDrawSetPreviewModel(playerid, PSkinStats[playerid], GetPlayerSkin(playerid));
					PlayerTextDrawShow(playerid, PSkinStats[playerid]);
					TextDrawShowForPlayer(playerid, TextDate);
					TextDrawShowForPlayer(playerid, TextTime);
				}
				case 1:
				{
					pData[playerid][pHBEMode] = 0;
										
					HidePlayerProgressBar(playerid, pData[playerid][sphungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][spenergybar]);
					for(new txd; txd < 8; txd++)
					{
						TextDrawHideForPlayer(playerid, StatsTD[txd]);
					}
					
					PlayerTextDrawHide(playerid,  PNameStats[playerid]);
					PlayerTextDrawHide(playerid,  PSkinStats[playerid]);
					TextDrawHideForPlayer(playerid, TextDate);
					TextDrawHideForPlayer(playerid, TextTime);
				}
			}
		}
	}
	if(dialogid == DIALOG_CHANGEAGE)
    {
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;
				
			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tahun Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Bulan Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else 
			{
				format(pData[playerid][pAge], 50, inputtext);
				Info(playerid, "New Age for your character is "YELLOW_E"%s.", pData[playerid][pAge]);
				GivePlayerMoneyEx(playerid, -300);
				Server_AddMoney(300);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDSHOP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
					ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, "Change Name", "Input new nickname:\nExample: Charles_Sanders\n", "Change", "Cancel");
				}
				case 1:
				{
					if(pData[playerid][pGold] < 1000) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 1000;
					pData[playerid][pWarn] = 0;
					Info(playerid, "Warning have been reseted for 1000 gold. Total Warning: 0");
				}
				case 2:
				{
					if(pData[playerid][pGold] < 150) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 150;
					pData[playerid][pVip] = 1;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "You has bought VIP level 1 for 150 gold(7 days).");
				}
				case 3:
				{
					if(pData[playerid][pGold] < 250) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 250;
					pData[playerid][pVip] = 2;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "You has bought VIP level 2 for 250 gold(7 days).");
				}
				case 4:
				{
					if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 500;
					pData[playerid][pVip] = 3;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "You has bought VIP level 3 for 500 gold(7 days).");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDNAME)
	{
		if(response)
		{
			if(strlen(inputtext) < 4) return Error(playerid, "New name can't be shorter than 4 characters!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(strlen(inputtext) > 20) return Error(playerid, "New name can't be longer than 20 characters!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(!IsValidRoleplayName(inputtext))
			{
				Error(playerid, "Name contains invalid characters, please doublecheck!");
				ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", inputtext);
			mysql_tquery(g_SQL, query, "ChangeName", "is", playerid, inputtext);
		}
		return 1;
	}
	//-----------[ Bisnis Dialog ]------------
	if(dialogid == DIALOG_SELL_BISNISS)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell bisnis id: %d", GetPVarInt(playerid, "SellingBisnis"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_BISNIS, DIALOG_STYLE_MSGBOX, "Sell Bisnis", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_BISNIS)
	{
		if(response)
		{
			new bid = GetPVarInt(playerid, "SellingBisnis"), price;
			price = bData[bid][bPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual bisnis id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", bid, FormatMoney(price));
			new str[150];
			format(str,sizeof(str),"[BIZ]: %s menjual business id %d seharga %s!", GetRPName(playerid), bid, FormatMoney(price));
			LogServer("Property", str);
			Bisnis_Reset(bid);
			Bisnis_Save(bid);
			Bisnis_Refresh(bid);
		}
		DeletePVar(playerid, "SellingBisnis");
		return 1;
	}
	if(dialogid == DIALOG_MY_BISNIS)
	{
		if(!response) return true;
		SetPVarInt(playerid, "ClickedBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_LIST, "{0000FF}My Business", "Show Information\nTrack Bisnis", "Select", "Cancel");
		return 1;
	}
	if(dialogid == BISNIS_INFO)
	{
		if(!response) return true;
		new bid = GetPVarInt(playerid, "ClickedBisnis");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(bData[bid][bLocked] == 1)
				{
					lock = "{FF0000}Locked";
			
				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(bData[bid][bType] == 1)
				{
					type = "Fast Food";
			
				}
				else if(bData[bid][bType] == 2)
				{
					type = "Market";
				}
				else if(bData[bid][bType] == 3)
				{
					type = "Clothes";
				}
				else if(bData[bid][bType] == 4)
				{
					type = "Equipment";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "Bisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Price: %s\nBisnis Type: %s\nBisnis Status: %s\nBisnis Product: %d",
				bid, bData[bid][bOwner], bData[bid][bName], FormatMoney(bData[bid][bPrice]), type, lock, bData[bid][bProd]);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Bisnis Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackBisnis] = 1;
				SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan bisnis anda!");
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_MENU)
	{
		new bid = pData[playerid][pInBiz];
		new lock[128];
		if(bData[bid][bLocked] == 1)
		{
			lock = "Locked";
		}
		else
		{
			lock = "Unlocked";
		}
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new mstr[248], lstr[512];
					format(mstr,sizeof(mstr),"Bisnis ID %d", bid);
					format(lstr,sizeof(lstr),"Bisnis Name:\t%s\nBisnis Locked:\t%s\nBisnis Product:\t%d\nBisnis Vault:\t%s", bData[bid][bName], lock, bData[bid][bProd], FormatMoney(bData[bid][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_TABLIST, mstr, lstr,"Back","Close");
				}
				case 1:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Nama sebelumnya: %s\n\nMasukkan nama bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama bisnis", bData[bid][bName]);
					ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				}
				case 2: ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Bisnis Vault","Deposit\nWithdraw","Next","Back");
				case 3:
				{
					Bisnis_ProductMenu(playerid, bid);
				}
				case 4:
				{
					if(bData[bid][bProd] > 100)
						return Error(playerid, "Bisnis ini masih memiliki cukup produck.");
					if(bData[bid][bMoney] < 1000)
						return Error(playerid, "Setidaknya anda mempunyai uang dalam bisnis anda senilai $1.000 untuk merestock product.");
					bData[bid][bRestock] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock product kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_INFO)
	{
		if(response)
		{
			return callcmd::bm(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];

			if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return Error(playerid, "You don't own this bisnis.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis tidak di perbolehkan kosong!\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				return 1;
			}
			format(bData[bid][bName], 32, ColouredText(inputtext));

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET name='%s' WHERE ID='%d'", bData[bid][bName], bid);
			mysql_tquery(g_SQL, query);

			Bisnis_Refresh(bid);

			Servers(playerid, "Bisnis name set to: \"%s\".", bData[bid][bName]);
		}
		else return callcmd::bm(playerid, "\0");
		return 1;
	}
	if(dialogid == BISNIS_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam bisnis ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, BISNIS_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Business Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam bisnis ini", FormatMoney(bData[pData[playerid][pInBiz]][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_WITHDRAW, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > bData[bid][bMoney])
				return Error(playerid, "Invalid amount specified!");

			bData[bid][bMoney] -= amount;
			
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET money='%d' WHERE ID='%d'", bData[bid][bMoney], bid);
			mysql_tquery(g_SQL, query);

			GivePlayerMoneyEx(playerid, amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have withdrawn "GREEN_E"%s "WHITE_E"from the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == BISNIS_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return Error(playerid, "Invalid amount specified!");

			bData[bid][bMoney] += amount;

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET money='%d' WHERE ID='%d'", bData[bid][bMoney], bid);
			mysql_tquery(g_SQL, query);

			GivePlayerMoneyEx(playerid, -amount);
			
			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have deposit "GREEN_E"%s "WHITE_E"into the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == BISNIS_BUYPROD)
	{
		static
        bizid = -1,
        price;

		if((bizid = pData[playerid][pInBiz]) != -1 && response)
		{
			price = bData[bizid][bP][listitem];

			if(GetPlayerMoney(playerid) < price)
				return Error(playerid, "Not enough money!");

			if(bData[bizid][bProd] < 1)
				return Error(playerid, "This business is out of stock product.");
				
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(bData[bizid][bType] == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");

						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+30);
						pData[playerid][pHunger] += 35;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+45);
						pData[playerid][pHunger] += 50;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);

						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 2:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+70);
						pData[playerid][pHunger] += 75;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);

						pData[playerid][pEnergy] += 60;
						//SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli minuman seharga %s.", ReturnName(playerid), FormatMoney(price));
						//SetPVarInt(playerid, "UsingSprunk", 1);
					}
				}
			}
			else if(bData[bizid][bType] == 2)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSnack]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli snack seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSprunk]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Sprunk seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 2:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGas]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Gas Fuel seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBandage]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Perban seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData[bizid][bType] == 3)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						switch(pData[playerid][pGender])
						{
							case 1: ShowPlayerSelectionMenu(playerid, SHOP_SKIN_MALE, "Choose Your Skin", ShopSkinMale, sizeof(ShopSkinMale));
							case 2: ShowPlayerSelectionMenu(playerid, SHOP_SKIN_FEMALE, "Choose Your Skin", ShopSkinFemale, sizeof(ShopSkinFemale));
						}
					}
					case 1:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						new string[248];
						if(pToys[playerid][0][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 1\n");
						}
						else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

						if(pToys[playerid][1][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 2\n");
						}
						else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

						if(pToys[playerid][2][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 3\n");
						}
						else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

						if(pToys[playerid][3][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 4\n");
						}
						else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

						/*if(pToys[playerid][4][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 5\n");
						}
						else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

						if(pToys[playerid][5][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 6\n");
						}
						else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");*/

						ShowPlayerDialog(playerid, DIALOG_TOYBUY, DIALOG_STYLE_LIST, ""RED_E"Great RP: "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
					case 2:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMask] = 1;
						pData[playerid][pMaskID] = random(90000) + 10000;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli mask seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHelmet] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Helmet seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData[bizid][bType] == 4)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 1, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Brass Knuckles seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 4, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Knife seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return Error(playerid, "Job farmer only!");
					}
					case 2:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 5, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Baseball Bat seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 6, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Shovel seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return Error(playerid, "Job miner only!");
					}
					case 4:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pJob] == 3 || pData[playerid][pJob2] == 3)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 9, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Chainsaw seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return Error(playerid, "Job lumber jack only!");
					}
					case 5:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 15, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Cane seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 6:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pFishTool] > 2) return Error(playerid, "You only can get 3 fish tool!");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pFishTool]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli pancingan seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 7:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWorm] += 2;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 2 umpan cacing seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData[bizid][bType] == 5)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGPS] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli GPS seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						new query[128], rand = RandomEx(1111, 9888);
						new phone = rand+pData[playerid][pID];
						mysql_format(g_SQL, query, sizeof(query), "SELECT phone FROM players WHERE phone='%d'", phone);
						mysql_tquery(g_SQL, query, "PhoneNumber", "id", playerid, phone);
						//pData[playerid][pPhone] = ;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli phone seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new queryy[128];
						mysql_format(g_SQL, queryy, sizeof(queryy), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, queryy);
					}
					case 2:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneCredit] += 20;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 20 phone credit seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneBook] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah phone book seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 4:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWT] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah walkie talkie seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 5:
					{
						if(price == 0)
							return Error(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pKuota] += 10000000;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah kuota 10gb seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}	
		}
		return 1;
	}
	if(dialogid == BISNIS_EDITPROD)
	{
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
			}
			else
				return callcmd::bm(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_PRICESET)
	{
		static
        item[40];
		new bizid = pData[playerid][pInBiz];
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 5000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5,000):", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
					return 1;
				}
				bData[bizid][bP][pData[playerid][pProductModify]] = strval(inputtext);
				Bisnis_Save(bizid);

				Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				Bisnis_ProductMenu(playerid, bizid);
			}
			else
			{
				Bisnis_ProductMenu(playerid, bizid);
			}
		}
		return 1;
	}
	//-----------[ House Dialog ]------------------
	if(dialogid == DIALOG_SELL_HOUSES)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell house id: %d", GetPVarInt(playerid, "SellingHouse"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "Sell House", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_HOUSE)
	{
		if(response)
		{
			new hid = GetPVarInt(playerid, "SellingHouse"), price;
			price = hData[hid][hPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual rumah id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", hid, FormatMoney(price));
			new str[150];
			format(str,sizeof(str),"[HOUSE]: %s menjual house id %d seharga %s!", GetRPName(playerid), hid, FormatMoney(price));
			LogServer("Property", str);
			HouseReset(hid);
			House_Save(hid);
			House_Refresh(hid);
		}
		DeletePVar(playerid, "SellingHouse");
		return 1;
	}
	if(dialogid == DIALOG_MY_HOUSES)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, HOUSE_INFO, DIALOG_STYLE_LIST, "{0000FF}My Houses", "Show Information\nTrack House", "Select", "Cancel");
		return 1;
	}
	if(dialogid == HOUSE_INFO)
	{
		if(!response) return 1;
		new hid = GetPVarInt(playerid, "ClickedHouse");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(hData[hid][hLocked] == 1)
				{
					lock = "{FF0000}Locked";
			
				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(hData[hid][hType] == 1)
				{
					type = "Small";
			
				}
				else if(hData[hid][hType] == 2)
				{
					type = "Medium";
				}
				else if(hData[hid][hType] == 3)
				{
					type = "Big";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "House ID: %d\nHouse Owner: %s\nHouse Address: %s\nHouse Price: %s\nHouse Type: %s\nHouse Status: %s",
				hid, hData[hid][hOwner], hData[hid][hAddress], FormatMoney(hData[hid][hPrice]), type, lock);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "House Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackHouse] = 1;
				SetPlayerRaceCheckpoint(playerid,1, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan rumah anda!");
			}
		}
		return 1;
	}
	if(dialogid == HOUSE_STORAGE)
	{
		new hid = pData[playerid][pInHouse];
		new string[200];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) 
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this house.");
		if(response)
		{
			if(listitem == 0) 
			{
				House_WeaponStorage(playerid, hid);
			}
			else if(listitem == 1) 
			{
				format(string, sizeof(string), "Money\t{3BBD44}%s{ffffff}\n{FF0000}RedMoney\t%s{ffffff}", FormatMoney(hData[hid][hMoney]), FormatMoney(hData[hid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_TABLIST, "Money Safe", string, "Select", "Back");
			}
			else if(listitem == 2)
			{
				format(string, sizeof(string), "Food\t({3BBD44}%d{ffffff}/%d)\nDrink\t({3BBD44}%d{ffffff}/%d)", hData[hid][hSnack], GetHouseStorage(hid, LIMIT_SNACK), hData[hid][hSprunk], GetHouseStorage(hid, LIMIT_SPRUNK));
				ShowPlayerDialog(playerid, HOUSE_FOODDRINK, DIALOG_STYLE_TABLIST, "Food & Drink", string, "Select", "Back");
			} 
			else if(listitem == 3)
			{
				format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", hData[hid][hMedicine], GetHouseStorage(hid, LIMIT_MEDICINE), hData[hid][hMedkit], GetHouseStorage(hid, LIMIT_MEDKIT), hData[hid][hBandage], GetHouseStorage(hid, LIMIT_BANDAGE));
				ShowPlayerDialog(playerid, HOUSE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Select", "Back");
			} 
			else if(listitem == 4)
			{
				format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[hid][hSeed], GetHouseStorage(hid, LIMIT_SEED), hData[hid][hMaterial], GetHouseStorage(hid, LIMIT_MATERIAL),  hData[hid][hComponent], GetHouseStorage(hid, LIMIT_COMPONENT), hData[hid][hMarijuana], GetHouseStorage(hid, LIMIT_MARIJUANA));
				ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
			} 
		}
		return 1;
	}
	if(dialogid == HOUSE_WEAPONS)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) 
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this house.");
				
		if(response)
		{
			if(hData[houseid][hWeapon][listitem] != 0)
			{
				GivePlayerWeaponEx(playerid, hData[houseid][hWeapon][listitem], hData[houseid][hAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(hData[houseid][hWeapon][listitem]));

				hData[houseid][hWeapon][listitem] = 0;
				hData[houseid][hAmmo][listitem] = 0;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				hData[houseid][hWeapon][listitem] = weaponid;
				hData[houseid][hAmmo][listitem] = ammo;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
		}
		else
		{
			House_OpenStorage(playerid, houseid);
		}
		return 1;
	}
	if(dialogid == HOUSE_MONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, houseid)) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					ShowPlayerDialog(playerid, HOUSE_REALMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, HOUSE_REDMONEY, DIALOG_STYLE_LIST, "RedMoney Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}			
	if(dialogid == HOUSE_REALMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REALMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REALMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAW_REALMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REALMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REALMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_REALMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSIT_REALMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REALMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REALMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_REALMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//////////////////////////////////////////////////////
	if(dialogid == HOUSE_REDMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hRedMoney]));
					ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REDMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hRedMoney]));
					ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REDMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAW_REDMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REDMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hRedMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REDMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hRedMoney] -= amount;
			pData[playerid][pRedMoney] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_REDMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSIT_REDMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REDMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pRedMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REDMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hRedMoney] += amount;
			pData[playerid][pRedMoney] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_REDMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//======================================================[ FOOD HOME STORAGE ]=============================================================//
	if(dialogid == HOUSE_FOODDRINK)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, houseid)) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					ShowPlayerDialog(playerid, HOUSE_FOOD, DIALOG_STYLE_LIST, "Snack Storage", "Ambil Snack dari penyimpanan\nSimpan Snack ke penyimpanan", "Pilih", "Kembali");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, HOUSE_DRINK, DIALOG_STYLE_LIST, "Sprunk Storage", "Ambil Sprunk dari penyimpanan\nSimpan Sprunk dari penyimpanan", "Pilih", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}	
	if(dialogid == HOUSE_FOOD)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Snack yang tersedia: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSnack]);
					ShowPlayerDialog(playerid, HOUSE_FOOD_WITHDRAW, DIALOG_STYLE_INPUT, "Snack Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Snack yang anda bawa: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pSnack]);
					ShowPlayerDialog(playerid, HOUSE_FOOD_DEPOSIT, DIALOG_STYLE_INPUT, "Snack Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Food\t({3BBD44}%d{ffffff}/%d)\nDrink\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hSnack], GetHouseStorage(houseid, LIMIT_SNACK), hData[houseid][hSprunk], GetHouseStorage(houseid, LIMIT_SPRUNK));
			ShowPlayerDialog(playerid, HOUSE_FOODDRINK, DIALOG_STYLE_TABLIST, "Food & Drink", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_FOOD_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Snack yang tersedia: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_WITHDRAW, DIALOG_STYLE_INPUT, "Snack Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hSnack])
			{
				new str[128];
				format(str, sizeof(str), "Error: Snack tidak mencukupi!.\n\nSnack yang tersedia: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_WITHDRAW, DIALOG_STYLE_INPUT, "Snack Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hSnack] -= amount;
			pData[playerid][pSnack] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d snack dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_FOOD, DIALOG_STYLE_LIST, "Snack Storage", "Ambil Snack dari penyimpanan\nSimpan Snack ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_FOOD_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Snack yang anda bawa: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_DEPOSIT, DIALOG_STYLE_INPUT, "Snack Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pSnack])
			{
				new str[128];
				format(str, sizeof(str), "Error: Snack tidak mencukupi!.\n\nSnack yang anda bawa: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_DEPOSIT, DIALOG_STYLE_INPUT, "Snack Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_SNACK) < hData[houseid][hSnack] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Snack!.\n\nSnack yang anda bawa: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_SNACK), pData[playerid][pSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_DEPOSIT, DIALOG_STYLE_INPUT, "Snack Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hSnack] += amount;
			pData[playerid][pSnack] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d snack ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_FOOD, DIALOG_STYLE_LIST, "Snack Storage", "Ambil Snack dari penyimpanan\nSimpan Snack ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//======================================================[ SPRUNK HOME STORAGE ]==============================================//
	if(dialogid == HOUSE_DRINK)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Sprunk yang tersedia: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSprunk]);
					ShowPlayerDialog(playerid, HOUSE_DRINK_WITHDRAW, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Sprunk yang anda bawa: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pSprunk]);
					ShowPlayerDialog(playerid, HOUSE_DRINK_DEPOSIT, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Food\t({3BBD44}%d{ffffff}/%d)\nDrink\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hSnack], GetHouseStorage(houseid, LIMIT_SNACK), hData[houseid][hSprunk], GetHouseStorage(houseid, LIMIT_SPRUNK));
			ShowPlayerDialog(playerid, HOUSE_FOODDRINK, DIALOG_STYLE_TABLIST, "Food & Drink", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_DRINK_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Sprunk yang tersedia: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_WITHDRAW, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hSprunk])
			{
				new str[128];
				format(str, sizeof(str), "Error: Sprunk tidak mencukupi!.\n\nSprunk yang tersedia: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_WITHDRAW, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hSprunk] -= amount;
			pData[playerid][pSprunk] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d sprunk dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_DRINK, DIALOG_STYLE_LIST, "Sprunk Storage", "Ambil Sprunk dari penyimpanan\nSimpan Sprunk ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_DRINK_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Sprunk yang anda bawa: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_DEPOSIT, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pSprunk])
			{
				new str[128];
				format(str, sizeof(str), "Error: Sprunk tidak mencukupi!.\n\nSprunk yang anda bawa: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_DEPOSIT, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_SPRUNK) < hData[houseid][hSprunk] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Sprunk!.\n\nSprunk yang anda bawa: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_SPRUNK), pData[playerid][pSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_DEPOSIT, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Simpan", "Kembali");
				return 1;
			}
			hData[houseid][hSprunk] += amount;
			pData[playerid][pSprunk] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d sprunk ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_DRINK, DIALOG_STYLE_LIST, "Sprunk Storage", "Ambil Sprunk dari penyimpanan\nSimpan Sprunk ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=====================================================[ DRUGS HOME STORAGE ]=================================================//
	if(dialogid == HOUSE_DRUGS)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, houseid)) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					ShowPlayerDialog(playerid, HOUSE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, HOUSE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit dari penyimpanan", "Pilih", "Kembali");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, HOUSE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage dari penyimpanan", "Pilih", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}	
	//=======================================================[ MEDICINE HOME STORAGE]===============================================//
	if(dialogid == HOUSE_MEDICINE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Medicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedicine]);
					ShowPlayerDialog(playerid, HOUSE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Medicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pMedicine]);
					ShowPlayerDialog(playerid, HOUSE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hMedicine], GetHouseStorage(houseid, LIMIT_MEDICINE), hData[houseid][hMedkit], GetHouseStorage(houseid, LIMIT_MEDKIT), hData[houseid][hBandage], GetHouseStorage(houseid, LIMIT_BANDAGE));
			ShowPlayerDialog(playerid, HOUSE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_MEDICINE_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Medicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMedicine])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Medicine tidak mencukupi!{ffffff}.\n\nMedicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hMedicine] -= amount;
			pData[playerid][pMedicine] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d medicine dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_MEDICINE_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Medicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMedicine])
			{
				new str[200];
				format(str, sizeof(str), "Error: {ff0000}Medicine anda tidak mencukupi!{ffffff}.\n\nMedicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_MEDICINE) < hData[houseid][hMedicine] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Medicine!.\n\nMedicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_MEDICINE), pData[playerid][pMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hMedicine] += amount;
			pData[playerid][pMedicine] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d medicine ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ MEDKIT HOME STORAGE]===============================================//
	if(dialogid == HOUSE_MEDKIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Medkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedkit]);
					ShowPlayerDialog(playerid, HOUSE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Medkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pMedkit]);
					ShowPlayerDialog(playerid, HOUSE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hMedicine], GetHouseStorage(houseid, LIMIT_MEDICINE), hData[houseid][hMedkit], GetHouseStorage(houseid, LIMIT_MEDKIT), hData[houseid][hBandage], GetHouseStorage(houseid, LIMIT_BANDAGE));
			ShowPlayerDialog(playerid, HOUSE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_MEDKIT_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Medkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMedkit])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Medkit tidak mencukupi!{ffffff}.\n\nMedkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hMedkit] -= amount;
			pData[playerid][pMedkit] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d medkit dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_MEDKIT_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Medkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMedkit])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Medkit anda tidak mencukupi!{ffffff}.\n\nMedkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_MEDKIT) < hData[houseid][hMedkit] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Medkit!.\n\nMedkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_MEDKIT), pData[playerid][pMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hMedkit] += amount;
			pData[playerid][pMedkit] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d medkit ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ BANDAGE HOME STORAGE]===============================================//
	if(dialogid == HOUSE_BANDAGE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Bandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", hData[houseid][hBandage]);
					ShowPlayerDialog(playerid, HOUSE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Bandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pBandage]);
					ShowPlayerDialog(playerid, HOUSE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hMedicine], GetHouseStorage(houseid, LIMIT_MEDICINE), hData[houseid][hMedkit], GetHouseStorage(houseid, LIMIT_MEDKIT), hData[houseid][hBandage], GetHouseStorage(houseid, LIMIT_BANDAGE));
			ShowPlayerDialog(playerid, HOUSE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_BANDAGE_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Bandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", hData[houseid][hBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hBandage])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Bandage tidak mencukupi!{ffffff}.\n\nBandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", hData[houseid][hBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hBandage] -= amount;
			pData[playerid][pBandage] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d bandage dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_BANDAGE_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Bandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pBandage])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Bandage anda tidak mencukupi!{ffffff}.\n\nBandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_BANDAGE) < hData[houseid][hBandage] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Bandage!.\n\nBandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_BANDAGE), pData[playerid][pBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hBandage] += amount;
			pData[playerid][pBandage] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d bandage ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=====================================================[ OTHER HOME STORAGE ]=================================================//
	if(dialogid == HOUSE_OTHER)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, houseid)) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					ShowPlayerDialog(playerid, HOUSE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material dari penyimpanan", "Pilih", "Kembali");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component dari penyimpanan", "Pilih", "Kembali");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana dari penyimpanan", "Pilih", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}	
	//=======================================================[ SEED HOME STORAGE]===============================================//
	if(dialogid == HOUSE_SEED)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Seed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSeed]);
					ShowPlayerDialog(playerid, HOUSE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pSeed]);
					ShowPlayerDialog(playerid, HOUSE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[houseid][hSeed], GetHouseStorage(houseid, LIMIT_SEED), hData[houseid][hMaterial], GetHouseStorage(houseid, LIMIT_MATERIAL),  hData[houseid][hComponent], GetHouseStorage(houseid, LIMIT_COMPONENT), hData[houseid][hMarijuana], GetHouseStorage(houseid, LIMIT_MARIJUANA));
			ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_SEED_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Seed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hSeed])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Seed tidak mencukupi!{ffffff}.\n\nSeed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hSeed] -= amount;
			pData[playerid][pSeed] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d seed dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_SEED_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pSeed])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Seed anda tidak mencukupi!{ffffff}.\n\nSeed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_SEED) < hData[houseid][hSeed] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Seed!.\n\nSeed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_SEED), pData[playerid][pSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hSeed] += amount;
			pData[playerid][pSeed] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d seed ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ MATERIAL HOME STORAGE]===============================================//
	if(dialogid == HOUSE_MATERIAL)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Material yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMaterial]);
					ShowPlayerDialog(playerid, HOUSE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Material yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pMaterial]);
					ShowPlayerDialog(playerid, HOUSE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[houseid][hSeed], GetHouseStorage(houseid, LIMIT_SEED), hData[houseid][hMaterial], GetHouseStorage(houseid, LIMIT_MATERIAL),  hData[houseid][hComponent], GetHouseStorage(houseid, LIMIT_COMPONENT), hData[houseid][hMarijuana], GetHouseStorage(houseid, LIMIT_MARIJUANA));
			ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_MATERIAL_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Material tidak mencukupi!{ffffff}.\n\nMaterial yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hMaterial] -= amount;
			pData[playerid][pMaterial] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d material dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_MATERIAL_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Material anda tidak mencukupi!{ffffff}.\n\nMaterial yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_MATERIAL) < hData[houseid][hMaterial] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Material!.\n\nMaterial yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_MATERIAL), pData[playerid][pMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hMaterial] += amount;
			pData[playerid][pMaterial] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d material ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ COMPONENT HOME STORAGE]===============================================//
	if(dialogid == HOUSE_COMPONENT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", hData[houseid][hComponent]);
					ShowPlayerDialog(playerid, HOUSE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pComponent]);
					ShowPlayerDialog(playerid, HOUSE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[houseid][hSeed], GetHouseStorage(houseid, LIMIT_SEED), hData[houseid][hMaterial], GetHouseStorage(houseid, LIMIT_MATERIAL),  hData[houseid][hComponent], GetHouseStorage(houseid, LIMIT_COMPONENT), hData[houseid][hMarijuana], GetHouseStorage(houseid, LIMIT_MARIJUANA));
			ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_COMPONENT_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", hData[houseid][hComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Component tidak mencukupi!{ffffff}.\n\nComponent yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", hData[houseid][hComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hComponent] -= amount;
			pData[playerid][pComponent] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d component dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_COMPONENT_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Component anda tidak mencukupi!{ffffff}.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_COMPONENT) < hData[houseid][hComponent] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Component!.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_COMPONENT), pData[playerid][pComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hComponent] += amount;
			pData[playerid][pComponent] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d component ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ MARIJUANA HOME STORAGE]===============================================//
	if(dialogid == HOUSE_MARIJUANA)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMarijuana]);
					ShowPlayerDialog(playerid, HOUSE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pMarijuana]);
					ShowPlayerDialog(playerid, HOUSE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[houseid][hSeed], GetHouseStorage(houseid, LIMIT_SEED), hData[houseid][hMaterial], GetHouseStorage(houseid, LIMIT_MATERIAL),  hData[houseid][hComponent], GetHouseStorage(houseid, LIMIT_COMPONENT), hData[houseid][hMarijuana], GetHouseStorage(houseid, LIMIT_MARIJUANA));
			ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
		}
		return 1;
	}
	if(dialogid == HOUSE_MARIJUANA_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Marijuana tidak mencukupi!{ffffff}.\n\nMarijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hMarijuana] -= amount;
			pData[playerid][pMarijuana] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d marijuana dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_MARIJUANA_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Marijuana anda tidak mencukupi!{ffffff}.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_MARIJUANA) < hData[houseid][hMarijuana] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Marijuana!.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_MARIJUANA), pData[playerid][pMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hMarijuana] += amount;
			pData[playerid][pMarijuana] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d marijuana ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//------------[ Private Player Vehicle Dialog ]--------
	/*if(dialogid == DIALOG_FINDVEH)
	{
		if(response) 
		{
			foreach(new i : PVehicles)
			{
				if(pvData[i][cOwner] == pData[playerid][pID])
				{
					if(pvData[i][cPark] != -1)
					{
						ShowPlayerDialog(playerid, DIALOG_TRACKPARKEDVEH, DIALOG_STYLE_LIST, "Find Parked Vehicle", "Track Vehicle\nInfo Vehicle:", "Select", "Close");
					}
					else 
					{
						ShowPlayerDialog(playerid, DIALOG_TRACKVEH, DIALOG_STYLE_INPUT, "Find Veh", "Enter your own vehicle id:", "Find", "Close");
					}	
				}		
			}	
		}
		return 1;
	}*/
	if(dialogid == DIALOG_FINDVEH)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_TRACKVEH, DIALOG_STYLE_LIST, "Vehicle", "Track Vehicle\nInfo Vehicle:", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_TRACKVEH)
	{
		if(response) 
		{	
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_TRACKVEH, DIALOG_STYLE_INPUT, "Find Veh", "Enter your own vehicle id:", "Find", "Close");					
				}	
				case 1:
				{
					Info(playerid, "Masih Proses Suhu");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TRACKVEH2)
	{
		if(response)
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
			carid = strval(inputtext);
					
			foreach(new veh : PVehicles)
			{
				if(pvData[veh][cVeh] == carid)
				{
					if(IsValidVehicle(pvData[veh][cVeh]))
					{
						if(pvData[veh][cOwner] == pData[playerid][pID])
						{
							GetVehiclePos(carid, posisiX, posisiY, posisiZ);
							pData[playerid][pTrackCar] = 1;
							//SetPlayerCheckpoint(playerid, posisi[0], posisi[1], posisi[2], 4.0);
							SetPlayerRaceCheckpoint(playerid,1, posisiX, posisiY, posisiZ, 0.0, 0.0, 0.0, 3.5);
							Info(playerid, "Your car waypoint was set to \"%s\" (marked on radar).", GetLocation(posisiX, posisiY, posisiZ));
						}
						else return Error(playerid, "Id kendaraan ini bukan milik anda!");
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_TRACKPARKEDVEH)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					Info(playerid, "Oke Bro");
				}
				case 1:
				{
					Info(playerid, "Oke Bro2");
				}
			}
		}
	}
	if(dialogid == DIALOG_GOTOVEH)
	{
		if(response) 
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			GetVehiclePos(carid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your teleport to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetPlayerPosition(playerid, posisiX, posisiY, posisiZ+3.0, 4.0, 0);
		}
		return 1;
	}
	if(dialogid == DIALOG_GETVEH)
	{
		if(response) 
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			GetPlayerPos(playerid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your get spawn vehicle to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetVehiclePos(carid, posisiX, posisiY, posisiZ+0.5);
		}
		return 1;
	}
	if(dialogid == DIALOG_DELETEVEH)
	{
		if(response) 
		{
			new carid = strval(inputtext);
			
			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)			
			{
				if(carid == pvData[i][cVeh])
				{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					DestroyVehicle(pvData[i][cVeh]);
					pvData[i][cVeh] = INVALID_VEHICLE_ID;
					Iter_SafeRemove(PVehicles, i, i);
					Servers(playerid, "Your deleted private vehicle id %d (database id: %d).", pvData[i][cVeh], pvData[i][cID]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPLATE)
	{
		if(response) 
		{
			new carid = strval(inputtext);
			
			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)
			{
				if(carid == pvData[i][cVeh])
				{
					if(GetPlayerMoney(playerid) < 500) return Error(playerid, "Anda butuh $500 untuk membeli Plate baru.");
					GivePlayerMoneyEx(playerid, -500);
					new rand = RandomEx(1111, 9999);
					format(pvData[i][cPlate], 32, "Great-%d", rand);
					SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
					pvData[i][cPlateTime] = gettime() + (15 * 86400);
					Info(playerid, "Model: %s || New plate: %s || Plate Time: %s || Plate Price: $500", GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				}
			}
		}
		return 1;
	}
	//--------------[ Player Toy Dialog ]-------------
	if(dialogid == DIALOG_TOY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					new status[20];
					if(pToys[playerid][0][toy_status] == 1)
					{
						status = "{ff0000}Hide";
					}
					else 
					{
						status = "{3BBD44}Show";
					}

					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot"%s {ffffff}Toys\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", status);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					new status[20];
					if(pToys[playerid][1][toy_status] == 1)
					{
						status = "{ff0000}Hide";
					}
					else 
					{
						status = "{3BBD44}Show";
					}
					
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot"%s {ffffff}Toys\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", status);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					new status[20];
					if(pToys[playerid][2][toy_status] == 1)
					{
						status = "{ff0000}Hide";
					}
					else 
					{
						status = "{3BBD44}Show";
					}

					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot"%s {ffffff}Toys\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", status);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					new status[20];
					if(pToys[playerid][3][toy_status] == 1)
					{
						status = "{ff0000}Hide";
					}
					else 
					{
						status = "{3BBD44}Show";
					}

					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot"%s {ffffff}Toys\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", status);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 4:
				{
					if(pData[playerid][PurchasedToy] == true)
					{
						for(new i = 0; i < 4; i++)
						{
							pToys[playerid][i][toy_model] = 0;
							pToys[playerid][i][toy_bone] = 1;
							pToys[playerid][i][toy_status] = 1;
							pToys[playerid][i][toy_x] = 0.0;
							pToys[playerid][i][toy_y] = 0.0;
							pToys[playerid][i][toy_z] = 0.0;
							pToys[playerid][i][toy_rx] = 0.0;
							pToys[playerid][i][toy_ry] = 0.0;
							pToys[playerid][i][toy_rz] = 0.0;
							pToys[playerid][i][toy_sx] = 1.0;
							pToys[playerid][i][toy_sy] = 1.0;
							pToys[playerid][i][toy_sz] = 1.0;
							
							if(IsPlayerAttachedObjectSlotUsed(playerid, i))
							{
								RemovePlayerAttachedObject(playerid, i);
							}
						}
						new string[128];
						mysql_format(g_SQL, string, sizeof(string), "DELETE FROM toys WHERE Owner = '%s'", pData[playerid][pName]);
						mysql_tquery(g_SQL, string);
						pData[playerid][PurchasedToy] = false;
						GameTextForPlayer(playerid, "~r~~h~All Toy Rested!~y~!", 3000, 4);
					}
				}
				/*case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}*/
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYEDIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // edit
				{
					//if(IsPlayerAndroid(playerid))
					//	return Error(playerid, "You're connected from android. This feature only for PC users!");
						
					EditAttachedObject(playerid, pData[playerid][toySelected]);
					InfoTD_MSG(playerid, 4000, "~b~~h~You are now editing your toy.");
				}
				case 1:
				{
					new string[750];
					format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
					pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
					pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
					pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
					ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
				}
				case 2: // change bone
				{
					new finstring[750];

					strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
					strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");

					ShowPlayerDialog(playerid, DIALOG_TOYPOSISI, DIALOG_STYLE_LIST, ""RED_E"Great RP: "WHITE_E"Player Toys", finstring, "Select", "Cancel");
				}
				case 3:
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_status] == 1)
					{
						if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
						{
							RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
						}
						pToys[playerid][pData[playerid][toySelected]][toy_status] = 0;
						InfoTD_MSG(playerid, 4000, "Toys ~r~hiden.");
					}
					else
					{
						SetPlayerAttachedObject(playerid,
							pData[playerid][toySelected],
							pToys[playerid][pData[playerid][toySelected]][toy_model],
							pToys[playerid][pData[playerid][toySelected]][toy_bone],
							pToys[playerid][pData[playerid][toySelected]][toy_x],
							pToys[playerid][pData[playerid][toySelected]][toy_y],
							pToys[playerid][pData[playerid][toySelected]][toy_z],
							pToys[playerid][pData[playerid][toySelected]][toy_rx],
							pToys[playerid][pData[playerid][toySelected]][toy_ry],
							pToys[playerid][pData[playerid][toySelected]][toy_rz],
							pToys[playerid][pData[playerid][toySelected]][toy_sx],
							pToys[playerid][pData[playerid][toySelected]][toy_sy],
							pToys[playerid][pData[playerid][toySelected]][toy_sz]);

						SetPVarInt(playerid, "UpdatedToy", 1);
						pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
						InfoTD_MSG(playerid, 4000, "Toys ~g~showed.");
					}
				}
				case 4: // remove toy
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
					{
						RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
					}
					pToys[playerid][pData[playerid][toySelected]][toy_model] = 0;
					GameTextForPlayer(playerid, "~r~~h~Toy Removed~y~!", 3000, 4);
					SetPVarInt(playerid, "UpdatedToy", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 5:	//share toy pos
				{
					SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[TOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f",
					ReturnName(playerid), pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
					pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
				}
			}
		}
		else
		{
			new string[350];
			if(pToys[playerid][0][toy_model] == 0)
			{
				strcat(string, ""dot"Slot 1\n");
			}
			else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

			if(pToys[playerid][1][toy_model] == 0)
			{
				strcat(string, ""dot"Slot 2\n");
			}
			else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

			if(pToys[playerid][2][toy_model] == 0)
			{
				strcat(string, ""dot"Slot 3\n");
			}
			else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

			if(pToys[playerid][3][toy_model] == 0)
			{
				strcat(string, ""dot"Slot 4\n");
			}
			else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");
			
			strcat(string, ""dot""RED_E"Reset Toys");

			ShowPlayerDialog(playerid, DIALOG_TOY, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYEDIT_ANDROID)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Pos X
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosX: %f\nInput new Toy PosX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_x]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSX, DIALOG_STYLE_INPUT, "Toy PosX", mstr, "Edit", "Cancel");
				}
				case 1: //Pos Y
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosY: %f\nInput new Toy PosY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_y]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSY, DIALOG_STYLE_INPUT, "Toy PosY", mstr, "Edit", "Cancel");
				}
				case 2: //Pos Z
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosZ: %f\nInput new Toy PosZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_z]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSZ, DIALOG_STYLE_INPUT, "Toy PosZ", mstr, "Edit", "Cancel");
				}
				case 3: //Pos RX
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRX: %f\nInput new Toy PosRX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rx]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRX, DIALOG_STYLE_INPUT, "Toy PosRX", mstr, "Edit", "Cancel");
				}
				case 4: //Pos RY
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRY: %f\nInput new Toy PosRY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_ry]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Cancel");
				}
				case 5: //Pos RZ
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rz]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Cancel");
				}
				case 6: //Pos ScaleX
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleX: %f\nInput new Toy ScaleX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sx]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSSX, DIALOG_STYLE_INPUT, "Toy ScaleX", mstr, "Edit", "Cancel");
				}
				case 7: //Pos ScaleY
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleY: %f\nInput new Toy ScaleY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sy]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSSY, DIALOG_STYLE_INPUT, "Toy ScaleY", mstr, "Edit", "Cancel");
				}
				case 8: //Pos ScaleZ
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleZ: %f\nInput new Toy ScaleZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sz]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSSZ, DIALOG_STYLE_INPUT, "Toy ScaleZ", mstr, "Edit", "Cancel");
				}
			}
		}
		else
		{
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos");
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSISI)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
			{
				RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
			}
			listitem = pData[playerid][toySelected];
			SetPlayerAttachedObject(playerid,
					listitem,
					pToys[playerid][listitem][toy_model],
					pToys[playerid][listitem][toy_bone],
					pToys[playerid][listitem][toy_x],
					pToys[playerid][listitem][toy_y],
					pToys[playerid][listitem][toy_z],
					pToys[playerid][listitem][toy_rx],
					pToys[playerid][listitem][toy_ry],
					pToys[playerid][listitem][toy_rz],
					pToys[playerid][listitem][toy_sx],
					pToys[playerid][listitem][toy_sy],
					pToys[playerid][listitem][toy_sz]);
			GameTextForPlayer(playerid, "~g~~h~Bone Changed~y~!", 3000, 4);
			SetPVarInt(playerid, "UpdatedToy", 1);
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSISIBUY)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			SetPlayerAttachedObject(playerid, pData[playerid][toySelected], pToys[playerid][pData[playerid][toySelected]][toy_model], listitem);
			//EditAttachedObject(playerid, pData[playerid][toySelected]);
			InfoTD_MSG(playerid, 5000, "~g~~h~Object Attached!~n~~w~Adjust the position than click on the save icon!");
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYBUY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYVIP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_x] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_y] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_z] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_rx] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_ry] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_rz] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
		
	}
	if(dialogid == DIALOG_TOYPOSSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_sx] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_sy] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				posisi);
			
			pToys[playerid][pData[playerid][toySelected]][toy_sz] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	//-----------[ Player Commands Dialog ]----------
	if(dialogid == DIALOG_HELP)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, "{7fffd4}PLAYER: {7fff00}/help /afk /drag /undrag /pay /stats /items /frisk /use /give /idcard /drivelic /togphone /reqloc\n");
				strcat(str, "{7fffd4}PLAYER: {7fff00}/weapon /settings /ask /answer /mask /helmet /death /accept /deny /revive /buy /health /destroycp /phone\n");
				strcat(str, "{7fffd4}TWITTER: {7fff00}/togtw /tw\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Player Commands", str, "Close", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, ""LG_E"CHAT: /b /l /t /s /pm /togpm /w /o /me /ame /do /ado /try /ab\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Chat Commands", str, "Close", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, ""LG_E"VEHICLE: /engine - Toggle Engine || /light - Toggle lights\n");
				strcat(str, ""LB_E"VEHICLE: /hood - Toggle Hood || /trunk - Toggle Trunk\n");
				strcat(str, ""LG_E"VEHICLE: /lock - Toggle Lock || /myinsu - Check Insu\n");
				strcat(str, ""LB_E"VEHICLE: /tow - Tow Vehicle || /untow - Untow Vehicle\n");
				strcat(str, ""LG_E"VEHICLE: /mypv - Check Vehicles || /claimpv - Claim Insurance\n");
				strcat(str, ""LG_E"VEHICLE: /buyplate - Buy Plate || /buyinsu - Buy Insurance\n");
				strcat(str, ""LG_E"VEHICLE: /eject\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Vehicle Commands", str, "Close", "");
			}
			case 3:
			{
				new line3[500];
				strcat(line3, "{ffffff}Taxi\nMechanic\nLumberjack\nTrucker\nMiner\nProduct\nFarmer\nCourier\nBaggage Airport");
				ShowPlayerDialog(playerid, DIALOG_JOB, DIALOG_STYLE_LIST, "Job Help", line3, "Pilih", "Batal");
				return 1;
			}
			case 4:
			{
				return callcmd::factionhelp(playerid);
			}
			case 5:
			{
				new str[3500];
				strcat(str, ""LG_E"BUSINESS: /buy /bm /lockbisnis /unlockbisnis /mybis\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Business Commands", str, "Close", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, ""LG_E"HOUSE: /buy /storage /lockhouse /unlockhouse /myhouse\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"House Commands", str, "Close", "");
			}
			case 7:
			{
				new str[3500];
				strcat(str, ""LG_E"WORKSHOP: /buy /wsmenu /myworkshop /service\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Workshop Commands", str, "Close", "");
			}
			case 8:
			{
				new str[3500];
				strcat(str, ""LG_E"VENDING: /vendingmanage /buy\n");
				strcat(str, ""LG_E"VENDING: klik '"RED_E"ENTER{ffffff}' atau '"RED_E"F{ffffff}' untuk membeli.\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Vending Commands", str, "Close", "");
			}
			case 9:
			{
				new str[3500];
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpgun rpcrash rpfall rprob rpfish rpmad rpcj rpdrink\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpwar rpdie rpfixmeka rpcheckmeka rpfight rpcry rpeat\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpfear rpdropgun rpgivegun rptakegun rprun rpnodong\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpshy rpnusuk rplock rpharvest rplockhouse rplockcar\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Auto RP", str, "Close", "");
			}
			case 10:
			{
				//return callcmd::donate(playerid);
			}
			case 11:
			{
				return callcmd::credits(playerid);
			}
			case 12:
			{
				new str[3500];
				strcat(str, ""LG_E"ROBBERY: /setrobbery /inviterob /rob\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Robbery Commands", str, "Close", "");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_JOB)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Unity Station\n\n{7fffd4}CMDS: /taxiduty /fare\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Taxi Job", str, "Close", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Idlewood\n\n{7fffd4}CMDS: /mechduty /service\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Mechanic Job", str, "Close", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini khusus untuk Lumber Profesional\n\n{7fffd4}CMDS: /(lum)ber\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Lumber Job", str, "Close", "");
			}
			case 3:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country\n\n{7fffd4}CMDS: /mission /storeproduct /storegas /storestock /gps\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Trucker Job", str, "Close", "");
			}
			case 4:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Las Venturas\n\n{7fffd4}CMDS: /ore\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Miner Job", str, "Close", "");
			}
			case 5:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country arah Angel Pine\n\n{7fffd4}CMDS: /createproduct /sellproduct\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Production Job", str, "Close", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country\n\n{7fffd4}CMDS: /plant /price /offer\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Farmer Job", str, "Close", "");
			}
			case 7:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Market\n\n{7fffd4}CMDS: /startkurir /stopkurir /angkatbox\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Courier Job", str, "Close", "");
			}
			case 8:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Bandara Los Santos\n\n{7fffd4}CMDS: /startbg\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Baggage Job", str, "Close", "");
			}
		}
	}			
	if(dialogid == DIALOG_GPS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pCP] > 1 || pData[playerid][pSideJob] > 1)
						return Error(playerid, "Harap selesaikan Pekerjaan mu terlebih dahulu");

					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_GENERAL, DIALOG_STYLE_LIST, "GPS General", "Bank Los Santos\nCity Hall\nPolice Departement\nASGH Hospital\nNews Agency", "Select", "Back");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_PUBLIC, DIALOG_STYLE_LIST, "GPS Public", "Business\nWorkshop\nATM\nDealership\nPublic Park\nDMV\nInsurance Center\nMechanic\nComponent Shop", "Select", "Back");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_JOB, DIALOG_STYLE_LIST, "GPS Jobs & Sidejobs", "{15D4ED}JOB: {ffffff}Taxi\n{15D4ED}JOB: {ffffff}Mechanic\n{15D4ED}JOB: {ffffff}Lumber Jack\n{15D4ED}JOB: {ffffff}Trucker\n{15D4ED}JOB: {ffffff}Miner\n{15D4ED}JOB: {ffffff}Production\n{15D4ED}JOB: {ffffff}Farmer\n{15D4ED}JOB: {ffffff}Baggage Airport\n{D2D2AB}SIDEJOB: {ffffff}Sweeper\n{D2D2AB}SIDEJOB: {ffffff}Bus\n{D2D2AB}SIDEJOB: {ffffff}Forklift\n{D2D2AB}SIDEJOB: {ffffff}Mower", "Select", "Back");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_PROPERTIES, DIALOG_STYLE_LIST, "GPS My Properties", "My House\nMy Business\nMy Vending Machine\nMy Vehicle", "Select", "Close");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_MISSION, DIALOG_STYLE_LIST, "GPS My Mission", "My Mission (Trucker)\nMy Hauling (Trucker)", "Select", "Back");
				}
			}
		}
	}
	if(dialogid == DIALOG_GPS_JOB)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1753.46, -1893.96, 13.55, 0.0,0.0,0.0, 3.5); //Taxi
					Gps(playerid, "Active!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1867.0510, -1815.1311, 14.2783, 0.0, 0.0, 0.0, 3.5); //Mechanic City
					Gps(playerid, "Active!");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, -265.81, -2213.57, 29.04, 0.0, 0.0, 0.0, 3.5); //Lumber
					Gps(playerid, "Active!");
					
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, -77.38, -1136.52, 1.07, 0.0, 0.0, 0.0, 3.5); //Trucker
					Gps(playerid, "Active!");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, 319.94, 874.77, 20.39, 0.0, 0.0, 0.0, 3.5); //Miner
					Gps(playerid, "Active!");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, -283.02, -2174.36, 28.66, 0.0, 0.0, 0.0, 3.5); //Production
					Gps(playerid, "Active!");
				}
				case 6:
				{
					SetPlayerRaceCheckpoint(playerid,1, -382.68, -1438.80, 26.13, 0.0, 0.0, 0.0, 3.5); //Farmer
					Gps(playerid, "Active!");
				}
				case 7:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2060.2942, -2220.8250, 13.5469, 0.0, 0.0, 0.0, 3.5); //Baggage
					Gps(playerid, "Active!");
					
				}
				case 8:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1296.80, -1870.97, 13.54, 0.0, 0.0, 0.0, 3.5); //Swpper
					Gps(playerid, "Active!");
					
				}
				case 9:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1699.25, -1513.80, 13.38, 0.0, 0.0, 0.0, 3.5); //Bus
					Gps(playerid, "Active!");
					
				}
				case 10:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2749.74,-2385.79, 13.64, 0.0, 0.0, 0.0, 3.5); //Forklift
					Gps(playerid, "Active!");
				}
				case 11:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2054.3213, -1248.9930, 23.8252, 0.0, 0.0, 0.0, 3.5); //Mower
					Gps(playerid, "Active!");
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PROPERTIES)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::myhouse(playerid);
				}
				case 1:
				{
					return callcmd::mybusiness(playerid);
				}
				case 2:
				{
					return callcmd::myvending(playerid);
				}
				case 3:
				{
					return callcmd::mypv(playerid, "");
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_MISSION)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pMission] == -1) return Error(playerid, "You dont have mission.");
					new bid = pData[playerid][pMission];
					Gps(playerid, "Follow the mission checkpoint to find your bisnis mission location.");
					//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 3.5);
					SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				}
				case 1:
				{
					if(pData[playerid][pHauling] == -1) return Error(playerid, "You dont have hauling.");
					new id = pData[playerid][pHauling];
					Gps(playerid, "Follow the hauling checkpoint to find your gas station location.");
					//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 3.5);
					SetPlayerRaceCheckpoint(playerid,1, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ], 0.0, 0.0, 0.0, 3.5);
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_GENERAL)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1464.98, -1011.79, 26.84, 0.0, 0.0, 0.0, 3);//bank
					Gps(playerid, "Active!");
				}
				case 1:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1481.2115, -1769.2195, 18.7929, 0.0, 0.0, 0.0, 3);//city hall
					Gps(playerid, "Active!");
				}
				case 2:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1552.6306, -1675.5353, 16.1953, 0.0, 0.0, 0.0, 3);//sapd
					Gps(playerid, "Active!");
				}
				case 3:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1176.6331, -1325.2738, 14.0309, 0.0, 0.0, 0.0, 3);//asgh
					Gps(playerid, "Active!");
				}
				case 4:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 645.6101, -1360.7520, 13.5887, 0.0, 0.0, 0.0, 3);//sanews
					Gps(playerid, "Active!");
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}		
	if(dialogid == DIALOG_GPS_PUBLIC)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetAnyBusiness() <= 0) return Error(playerid, "Tidak ada Business di kota.");
					new id, count = GetAnyBusiness(), location[4096], lstr[596];
					strcat(location,"No\tName Business\tType Business\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBusinessID(itt);

						new type[128];
						if(bData[id][bType] == 1)
						{
							type= "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type= "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type= "Clothes";
						}
						else if(bData[id][bType] == 4)
						{
							type= "Equipment";
						}
						else if(bData[id][bType] == 5)
						{
							type= "Electronics";
						}
						else
						{
							type= "Unknown";
						}

						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData[id][bName], type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData[id][bName], type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKBUSINESS, DIALOG_STYLE_TABLIST_HEADERS,"Track Business",location,"Track","Cancel");
				}
				case 1:
				{
					if(GetAnyWorkshop() <= 0) return Error(playerid, "Tidak ada Workshop.");
					new id, count = GetAnyWorkshop(), location[4096], lstr[596], lock[64];
					strcat(location,"No\tName(Status)\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnWorkshopID(itt);
						if(wsData[id][wStatus] == 1)
						{
							lock = "{00FF00}Open{ffffff}";
						}
						else
						{
							lock = "{FF0000}Closed{ffffff}";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s{ffffff}(%s)\t%0.2fm\n", itt, wsData[id][wName], lock, GetPlayerDistanceFromPoint(playerid, wsData[id][wX], wsData[id][wY], wsData[id][wZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s{ffffff}(%s)\t%0.2fm\n", itt, wsData[id][wName], lock, GetPlayerDistanceFromPoint(playerid, wsData[id][wX], wsData[id][wY], wsData[id][wZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKWS, DIALOG_STYLE_TABLIST_HEADERS,"Track Workshop",location,"Track","Cancel");
				}
				case 2:
				{
					if(GetAnyAtm() <= 0) return Error(playerid, "Tidak ada ATM di kota.");
					new id, count = GetAnyAtm(), location[4096], lstr[596];
					strcat(location,"No\tLocation\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnAtmID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), GetPlayerDistanceFromPoint(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), GetPlayerDistanceFromPoint(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKATM, DIALOG_STYLE_TABLIST_HEADERS,"Track ATM",location,"Track","Cancel");
				}
				case 3:
				{
					if(GetAnyPark() <= 0) return Error(playerid, "Tidak ada Custom Park yang terbuka.");
					new id, count = GetAnyPark(), location[4096], lstr[596];
					strcat(location,"No\tLocation\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnAnyPark(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]), GetPlayerDistanceFromPoint(playerid, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]), GetPlayerDistanceFromPoint(playerid, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKPARK, DIALOG_STYLE_TABLIST_HEADERS,"Track Park",location,"Track","Cancel");
				}
				case 4:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 538.8544, -1292.9434, 17.2422, 0.0, 0.0, 0.0, 3);//Dealership
					Gps(playerid, "Active!");
				}
				case 5:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 2062.9805, -1899.6351, 13.5538, 0.0, 0.0, 0.0, 3);//DMV
					Gps(playerid, "Active!");
				}
				case 6:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1335.0966, -1266.0402, 13.5469, 0.0, 0.0, 0.0, 3);//Insurance
					Gps(playerid, "Active!");
				}
				case 7:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 2856.9448, -1981.2794, 10.9372, 0.0, 0.0, 0.0, 3);//Mechanic
					Gps(playerid, "Active!");
				}
				
				case 8:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 854.5555, -605.2056, 18.4219, 0.0, 0.0, 0.0, 3);//Component Shop
					Gps(playerid, "Active!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}		
	if(dialogid == DIALOG_TRACKWS)
	{
		if(response)
		{
			new wid = ReturnWorkshopID((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Workshop Checkpoint targeted! (%s)", GetLocation(wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]));
		}
	}
	if(dialogid == DIALOG_TRACKPARK)
	{
		if(response)
		{
			new id = ReturnAnyPark((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Custom Park Checkpoint targeted! (%s)", GetLocation(ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]));
		}
	}
	if(dialogid == DIALOG_TRACKBUSINESS)
	{
		if(response)
		{
			new id = ReturnBusinessID((listitem + 1));

			pData[playerid][pTrackBisnis] = 1;
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Business checkpoint targeted! (%s)", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}
	if(dialogid == DIALOG_TRACKATM)
	{
		if(response)
		{
			new id = ReturnAtmID((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Atm checkpoint targeted! (%s)", GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
		}
	}
	if(dialogid == DIALOG_PAY)
	{
		if(response)
		{
			new mstr[128];
			new otherid = GetPVarInt(playerid, "gcPlayer");
			new money = GetPVarInt(playerid, "gcAmount");

			if(otherid == playerid)
				return Error(playerid, "kamu tidak bisa tf ke akunmu sendiri!");
			if(otherid == INVALID_PLAYER_ID)
				return Error(playerid, "Player not connected!");
			GivePlayerMoneyEx(otherid, money);
			GivePlayerMoneyEx(playerid, -money);

			format(mstr, sizeof(mstr), "Server: "YELLOW_E"You have sent %s(%i) "GREEN_E"%s", ReturnName(otherid), otherid, FormatMoney(money));
			SendClientMessage(playerid, COLOR_GREY, mstr);
			format(mstr, sizeof(mstr), "Server: "YELLOW_E"%s(%i) has sent you "GREEN_E"%s", ReturnName(playerid), playerid, FormatMoney(money));
			SendClientMessage(otherid, COLOR_GREY, mstr);
			InfoTD_MSG(playerid, 3500, "~g~~h~Money Sent!");
			InfoTD_MSG(otherid, 3500, "~g~~h~Money received!");
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s memberikan uang kepada %s sebesar %s", ReturnName(playerid), ReturnName(otherid), FormatMoney(money));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s menerima uang dari %s sebesar %s", ReturnName(otherid), ReturnName(playerid), FormatMoney(money));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logpay (player,playerid,toplayer,toplayerid,ammount,time) VALUES('%s','%d','%s','%d','%d',UNIX_TIMESTAMP())", pData[playerid][pName], pData[playerid][pID], pData[otherid][pName], pData[otherid][pID], money);
			mysql_tquery(g_SQL, query);
		}
		return 1;
	}
	//-------------[ Player Weapons Atth ]-----------
	if(dialogid == DIALOG_EDITBONE)
	{
		if(response)
		{
			new weaponid = EditingWeapon[playerid], weaponname[18], string[150];
	 
			GetWeaponName(weaponid, weaponname, sizeof(weaponname));
		   
			WeaponSettings[playerid][weaponid - 22][Bone] = listitem + 1;

			Servers(playerid, "You have successfully changed the bone of your %s.", weaponname);
		   
			mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, Bone) VALUES ('%d', %d, %d) ON DUPLICATE KEY UPDATE Bone = VALUES(Bone)", pData[playerid][pID], weaponid, listitem + 1);
			mysql_tquery(g_SQL, string);
		}
		EditingWeapon[playerid] = 0;
	}
	//------------[ Family Dialog ]------------
	if(dialogid == FAMILY_SAFE)
	{
		if(!response) return 1;
		new fid = pData[playerid][pFamily];
		switch(listitem) 
		{
			case 0: Family_OpenStorage(playerid, fid);
			case 1:
			{
				//Marijuana
				ShowPlayerDialog(playerid, FAMILY_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 2:
			{
				//Component
				ShowPlayerDialog(playerid, FAMILY_COMPONENT, DIALOG_STYLE_LIST, "Component", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 3:
			{
				//Material
				ShowPlayerDialog(playerid, FAMILY_MATERIAL, DIALOG_STYLE_LIST, "Material", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 4:
			{
				//Money
				ShowPlayerDialog(playerid, FAMILY_MONEY, DIALOG_STYLE_LIST, "Money", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_STORAGE)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(listitem == 0) 
			{
				Family_WeaponStorage(playerid, fid);
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_WEAPONS)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(fData[fid][fGun][listitem] != 0)
			{
				if(pData[playerid][pFamilyRank] < 5)
					return Error(playerid, "Only boss can taken the weapon!");
					
				GivePlayerWeaponEx(playerid, fData[fid][fGun][listitem], fData[fid][fAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(fData[fid][fGun][listitem]));

				fData[fid][fGun][listitem] = 0;
				fData[fid][fAmmo][listitem] = 0;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				fData[fid][fGun][listitem] = weaponid;
				fData[fid][fAmmo][listitem] = ammo;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
		}
		else
		{
			Family_OpenStorage(playerid, fid);
		}
		return 1;
	}
	if(dialogid == FAMILY_MARIJUANA)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw marijuana!");
							
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMarijuana] -= amount;
			pData[playerid][pMarijuana] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d marijuana from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMarijuana] += amount;
			pData[playerid][pMarijuana] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d marijuana into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_COMPONENT)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw component!");
							
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fComponent] -= amount;
			pData[playerid][pComponent] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d component from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fComponent] += amount;
			pData[playerid][pComponent] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d component into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MATERIAL)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw material!");
							
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMaterial] -= amount;
			pData[playerid][pMaterial] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d material from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMaterial] += amount;
			pData[playerid][pMaterial] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d material into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MONEY)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw money!");
							
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from their family safe.", ReturnName(playerid), FormatMoney(amount));
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into their family safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_INFO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT name,leader,marijuana,component,material,money FROM familys WHERE ID = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyInfo", "i", playerid);
				}
				case 1:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");
						
					new lstr[1024];
					format(lstr, sizeof(lstr), "Rank\tName\n");
					foreach(new i: Player)
					{
						if(pData[i][pFamily] == pData[playerid][pFamily])
						{
							format(lstr, sizeof(lstr), "%s%s\t%s(%d)", lstr, GetFamilyRank(i), pData[i][pName], i);
							format(lstr, sizeof(lstr), "%s\n", lstr);
						}
					}
					format(lstr, sizeof(lstr), "%s\n", lstr);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Family Online", lstr, "Close", "");
					
				}
				case 2:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,familyrank FROM players WHERE family = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	//------------[ VIP Locker Dialog ]----------
	if(dialogid == DIALOG_LOCKERVIP)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					SetPlayerHealthEx(playerid, 100);
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 1, 1);
					GivePlayerWeaponEx(playerid, 7, 1);
					GivePlayerWeaponEx(playerid, 15, 1);
				}
				case 2:
				{
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, VIP_SKIN_MALE, "Choose Your Skin", VipSkinMale, sizeof(VipSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, VIP_SKIN_FEMALE, "Choose Your Skin", VipSkinFemale, sizeof(VipSkinFemale));
					}
				}
				case 3:
				{
					new string[248];
					if(pToys[playerid][0][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 1\n");
					}
					else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

					if(pToys[playerid][1][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 2\n");
					}
					else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

					if(pToys[playerid][2][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 3\n");
					}
					else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

					if(pToys[playerid][3][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 4\n");
					}
					else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

					/*if(pToys[playerid][4][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 5\n");
					}
					else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

					if(pToys[playerid][5][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 6\n");
					}
					else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");*/

					ShowPlayerDialog(playerid, DIALOG_TOYVIP, DIALOG_STYLE_LIST, ""WHITE_E"VIP Toys", string, "Select", "Cancel");
				}
			}
		}
	}
	//-------------[ Faction Commands Dialog ]-----------
	if(dialogid == DIALOG_LOCKERSAPD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
						ResetWeapon(playerid, 25);
						ResetWeapon(playerid, 27);
						ResetWeapon(playerid, 29);
						ResetWeapon(playerid, 31);
						ResetWeapon(playerid, 33);
						ResetWeapon(playerid, 34);
						KillTimer(DutyTimer);
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 300);
							pData[playerid][pFacSkin] = 300;
						}
						else
						{
							SetPlayerSkin(playerid, 306);
							pData[playerid][pFacSkin] = 306;
						}
						DutyTimer = SetTimerEx("DutyHour", 1000, true, "i", playerid);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAPD, DIALOG_STYLE_LIST, "SAPD Weapons", "SPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE\nSHOTGUN\nSHOTGSPA\nMP5\nM4\nRIFLE\nSNIPER", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SAPD_SKIN_MALE, "Choose Your Skin", SAPDSkinMale, sizeof(SAPDSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SAPD_SKIN_FEMALE, "Choose Your Skin", SAPDSkinFemale, sizeof(SAPDSkinFemale));
					}
				}
				case 5:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
					
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SAPD_SKIN_WAR, "Choose Your Skin", SAPDSkinWar, sizeof(SAPDSkinWar));
						case 2: ShowPlayerSelectionMenu(playerid, SAPD_SKIN_FEMALE, "Choose Your Skin", SAPDSkinFemale, sizeof(SAPDSkinFemale));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAPD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 3, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 3:
				{
					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 4:
				{
					GivePlayerWeaponEx(playerid, 22, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 2)
						return Error(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 23, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 2)
						return Error(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
				case 7:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 25, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(25));
				}
				case 8:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 27, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(27));
				}
				case 9:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
				case 10:
				{
					if(pData[playerid][pFactionRank] < 4)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 31, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(31));
				}
				case 11:
				{
					if(pData[playerid][pFactionRank] < 4)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 33, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(33));
				}
				case 12:
				{
					if(pData[playerid][pFactionRank] < 4)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 34, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(34));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAGS)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 295);
							pData[playerid][pFacSkin] = 295;
						}
						else
						{
							SetPlayerSkin(playerid, 141);
							pData[playerid][pFacSkin] = 141;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAGS, DIALOG_STYLE_LIST, "SAGS Weapons", "SPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE\nMP5", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SAGS_SKIN_MALE, "Choose Your Skin", SAGSSkinMale, sizeof(SAGSSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SAGS_SKIN_FEMALE, "Choose Your Skin", SAGSSkinFemale, sizeof(SAGSSkinFemale));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAGS)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 3, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 3:
				{
					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 4:
				{
					GivePlayerWeaponEx(playerid, 22, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 2)
						return Error(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 23, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
				case 7:
				{
					if(pData[playerid][pFactionRank] < 4)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAMD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 276);
							pData[playerid][pFacSkin] = 276;
						}
						else
						{
							SetPlayerSkin(playerid, 308);
							pData[playerid][pFacSkin] = 308;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAMD, DIALOG_STYLE_LIST, "SAMD Weapons", "FIREEXTINGUISHER\nSPRAYCAN\nPARACHUTE", "Pilih", "Batal");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_DRUGSSAMD, DIALOG_STYLE_LIST, "SAMD Drugs", "Bandage\nMedkit\nMedicine", "Select", "Cancel");
				}
				case 5:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SAMD_SKIN_MALE, "Choose Your Skin", SAMDSkinMale, sizeof(SAMDSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SAMD_SKIN_FEMALE, "Choose Your Skin", SAMDSkinFemale, sizeof(SAMDSkinFemale));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAMD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 42, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(42));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 3:
				{
					//GivePlayerWeaponEx(playerid, 3, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 4:
				{
					//GivePlayerWeaponEx(playerid, 4, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
						
					//GivePlayerWeaponEx(playerid, 22, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
						
					//GivePlayerWeaponEx(playerid, 23, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 7:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
						
					//GivePlayerWeaponEx(playerid, 24, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DRUGSSAMD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pBandage] += 5;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reached into the locker and took 5 bandages.", ReturnName(playerid));
				}
				case 1:
				{
					pData[playerid][pMedkit] += 5;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reached into the locker and took 5 medkit.", ReturnName(playerid));
				}
				case 2:
				{
					pData[playerid][pMedicine] += 5;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reached into the locker and took 5 medicine.", ReturnName(playerid));
				}
			}
		}
	}
	if(dialogid == DIALOG_LOCKERSANEW)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 189);
							pData[playerid][pFacSkin] = 189;
						}
						else
						{
							SetPlayerSkin(playerid, 150); //194
							pData[playerid][pFacSkin] = 150; //194
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSANEW, DIALOG_STYLE_LIST, "SAPD Weapons", "CAMERA\nSPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SANA_SKIN_MALE, "Choose Your Skin", SANASkinMale, sizeof(SANASkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SANA_SKIN_FEMALE, "Choose Your Skin", SANASkinFemale, sizeof(SANASkinFemale));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSANEW)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 43, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(43));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 3:
				{
					//GivePlayerWeaponEx(playerid, 3, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 4:
				{
					//GivePlayerWeaponEx(playerid, 4, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
						
					//GivePlayerWeaponEx(playerid, 22, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
			}
		}
		return 1;
	}
	//--------[ DIALOG JOB ]--------
	if(dialogid == DIALOG_SERVICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new Float:health, comp;
						GetVehicleHealth(pData[playerid][pMechVeh], health);
						if(health > 1000.0) health = 1000.0;
						if(health > 0.0) health *= -1;
						comp = floatround(health, floatround_round) / 10 + 100;
						
						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("EngineFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Engine...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new panels, doors, light, tires, comp;
						
						GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
						new cpanels = panels / 1000000;
						new lights = light / 2;
						new pintu;
						if(doors != 0) pintu = 5;
						if(doors == 0) pintu = 0;
						comp = cpanels + lights + pintu + 20;
						
						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki body kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("BodyFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Body...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					if(IsAtMech(playerid))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 40) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechanicStatus] = 0;
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 3:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 4:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 85) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 5:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SPOILER,DIALOG_STYLE_LIST,"Choose below","Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 6:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 7:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 8:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 9:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 10:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_FRONT_BUMPERS, DIALOG_STYLE_LIST, "Front bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 11:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_REAR_BUMPERS, DIALOG_STYLE_LIST, "Rear bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 12:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 13:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SIDE_SKIRTS, DIALOG_STYLE_LIST, "Side skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
					Info(playerid, "Side blm ada.");
				}
				case 14:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_BULLBARS, DIALOG_STYLE_LIST, "Bull bars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 15:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1086;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 16:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1087;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 17:
				{
					if(IsAtMech(playerid))
					{
						pData[playerid][pMechColor1] = 1009;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 250) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 250;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"250 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 18:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1008;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 375) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 375;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"375 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 19:
				{
					if(IsAtMech(playerid))
					{
						pData[playerid][pMechColor1] = 1010;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 500) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 500;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"500 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 20:
				{
					if(IsAtMech(playerid))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_NEON,DIALOG_STYLE_LIST,"Neon","RED\nBLUE\nGREEN\nYELLOW\nPINK\nWHITE\nREMOVE","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_COLOR)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
			
			ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Close");
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_COLOR2)
	{
		if(response)
		{
			pData[playerid][pMechColor2] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor2] < 0 || pData[playerid][pMechColor2] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Close");
			
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{	
				if(pData[playerid][pComponent] < 40) return Error(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 40;
				Info(playerid, "Anda mengganti warna kendaraan dengan "RED_E"30 component.");
				pData[playerid][pMechanicStatus] = 1;
				pData[playerid][pMechanic] = SetTimerEx("SprayCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Spraying Car...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechanicStatus] = 0;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_PAINTJOB)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 3)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
			
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{	
				if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 100;
				Info(playerid, "Anda mengganti paintjob kendaraan dengan "RED_E"50 component.");
				pData[playerid][pMechanicStatus] = 1;
				pData[playerid][pMechanic] = SetTimerEx("PaintjobCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Painting Car...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechanicStatus] = 0;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_WHEELS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = 1025;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 85) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 85;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = 1074;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = 1076;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = 1078;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = 1081;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = 1082;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 1085;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					pData[playerid][pMechColor1] = 1096;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					pData[playerid][pMechColor1] = 1097;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 9:
				{
					pData[playerid][pMechColor1] = 1098;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 10:
				{
					pData[playerid][pMechColor1] = 1084;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 11:
				{
					pData[playerid][pMechColor1] = 1073;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 12:
				{
					pData[playerid][pMechColor1] = 1075;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 13:
				{
					pData[playerid][pMechColor1] = 1077;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 14:
				{
					pData[playerid][pMechColor1] = 1079;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 15:
				{
					pData[playerid][pMechColor1] = 1080;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 16:
				{
					pData[playerid][pMechColor1] = 1083;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SPOILER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1147;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1049;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1162;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1058;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1164;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1138;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1146;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1050;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1158;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1060;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1163;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1139;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1001;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1023;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 401 ||
						VehicleModel == 517 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 477 ||
						VehicleModel == 547 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1003;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 547 ||
						VehicleModel == 405)
						{
				
							pData[playerid][pMechColor1] = 1000;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 405)
						{
				
							pData[playerid][pMechColor1] = 1014;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542)
						{
				
							pData[playerid][pMechColor1] = 1015;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 546 ||
						VehicleModel == 517)
						{
				
							pData[playerid][pMechColor1] = 1002;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_HOODS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{
				
							pData[playerid][pMechColor1] = 1005;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 402 ||
						VehicleModel == 546 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{
				
							pData[playerid][pMechColor1] = 1004;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401)
						{
				
							pData[playerid][pMechColor1] = 1011;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1012;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_VENTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 547 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1142;
							pData[playerid][pMechColor2] = 1143;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1144;
							pData[playerid][pMechColor2] = 1145;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_LIGHTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 436 ||
						VehicleModel == 439)
						{
				
							pData[playerid][pMechColor1] = 1013;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 603 ||
						VehicleModel == 400)
						{
				
							pData[playerid][pMechColor1] = 1024;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_EXHAUSTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1034;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1046;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1065;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1064;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1028;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1089;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1037;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1045;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1066;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1059;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1029;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1092;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1044;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1126;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1129;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1104;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1113;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1136;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1043;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1127;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1132;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1105;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1135;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1114;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1020;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 400 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1021;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 436)
						{
							
							pData[playerid][pMechColor1] = 1022;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1019;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 415 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1018;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_FRONT_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1171;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1153;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1160;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1155;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1166;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1169;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1172;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1152;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1173;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1157;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1165;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1170;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1174;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1179;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1189;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1182;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1191;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1115;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1175;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1185;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1188;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1181;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1190;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1116;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_REAR_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1149;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1150;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1159;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1154;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1168;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1141;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1148;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1151;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1161;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1156;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1167;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1140;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1176;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1180;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1187;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1184;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1192;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1109;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1177;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1178;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1186;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1183;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1193;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1110;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_ROOFS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1054;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1067;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1055;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1088;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1032;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1053;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1068;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1061;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1091;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1033;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1130;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1128;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1131;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1103;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1006;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SIDE_SKIRTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1036;
								pData[playerid][pMechColor2] = 1040;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1047;
								pData[playerid][pMechColor2] = 1051;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1069;
								pData[playerid][pMechColor2] = 1071;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1056;
								pData[playerid][pMechColor2] = 1062;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1090;
								pData[playerid][pMechColor2] = 1094;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1026;
								pData[playerid][pMechColor2] = 1027;
							}
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1039;
								pData[playerid][pMechColor2] = 1041;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1048;
								pData[playerid][pMechColor2] = 1052;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1070;
								pData[playerid][pMechColor2] = 1072;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1057;
								pData[playerid][pMechColor2] = 1063;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1093;
								pData[playerid][pMechColor2] = 1095;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1031;
								pData[playerid][pMechColor2] = 1030;
							}
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 567)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1042;
								pData[playerid][pMechColor2] = 1099;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1108;
								pData[playerid][pMechColor2] = 1107;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1134;
								pData[playerid][pMechColor2] = 1137;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1102;
								pData[playerid][pMechColor2] = 1133;
							}
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1102;
							pData[playerid][pMechColor2] = 1101;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1106;
							pData[playerid][pMechColor2] = 1124;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{
				
							pData[playerid][pMechColor1] = 1118;
							pData[playerid][pMechColor2] = 1120;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{
				
							pData[playerid][pMechColor1] = 1119;
							pData[playerid][pMechColor2] = 1121;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 436 ||
						VehicleModel == 439 ||
						VehicleModel == 580 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
				
							pData[playerid][pMechColor1] = 1007;
							pData[playerid][pMechColor2] = 1017;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_BULLBARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1100;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1123;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1125;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1117;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_NEON)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = RED_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = BLUE_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = GREEN_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = YELLOW_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = PINK_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = WHITE_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	//ARMS Dealer
	if(dialogid == DIALOG_ARMS_GUN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slc pistol
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 320) return Error(playerid, "Material tidak cukup!(Butuh: 320).");
					
					pData[playerid][pMaterial] -= 320;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 320 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SILENCED, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 1: //colt45 9mm
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 250) return Error(playerid, "Material tidak cukup!(Butuh: 250).");
					
					pData[playerid][pMaterial] -= 250;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 250 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_COLT45, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 2: //deagle
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 350) return Error(playerid, "Material tidak cukup!(Butuh: 350).");
					
					pData[playerid][pMaterial] -= 350;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 350 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_DEAGLE, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 3: //shotgun
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 300) return Error(playerid, "Material tidak cukup!(Butuh: 300).");
					
					pData[playerid][pMaterial] -= 300;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 300 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SHOTGUN, 50);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 4: //ak-47
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return Error(playerid, "Material tidak cukup!(Butuh: 500).");
					
					pData[playerid][pMaterial] -= 500;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 500 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_AK47, 100);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PLANT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pSeed] < 5) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");
					
					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");
					
					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");
					
					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{
					
						pData[playerid][pSeed] -= 5;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);
						
						PlantData[id][PlantType] = 1;
						PlantData[id][PlantTime] = 1800;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Potato.");
					}
					else return Error(playerid, "You must in farmer flint area!");
				}
				case 1:
				{
					if(pData[playerid][pSeed] < 18) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");
					
					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");
					
					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");
					
					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{
					
						pData[playerid][pSeed] -= 18;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);
						
						PlantData[id][PlantType] = 2;
						PlantData[id][PlantTime] = 3600;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Wheat.");
					}
					else return Error(playerid, "You must in farmer flint area!");
				}
				case 2:
				{
					if(pData[playerid][pSeed] < 11) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");
					
					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");
					
					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");
					
					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{
					
						pData[playerid][pSeed] -= 11;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);
						
						PlantData[id][PlantType] = 3;
						PlantData[id][PlantTime] = 2700;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Orange.");
					}
					else return Error(playerid, "You must in farmer flint area!");
				}
				case 3:
				{
					if(pData[playerid][pSeed] < 50) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");
					
					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");
					
					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");
					
					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{
					
						pData[playerid][pSeed] -= 50;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);
						
						PlantData[id][PlantType] = 4;
						PlantData[id][PlantTime] = 4500;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Marijuana.");
					}
					else return Error(playerid, "You must in farmer flint area!");
				}
			}
		}
	}
	if(dialogid == DIALOG_HAULING)
	{
		if(response)
		{
			new id = ReturnRestockGStationID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);

			if(IsValidVehicle(pData[playerid][pTrailer]))
			{
				DestroyVehicle(pData[playerid][pTrailer]);
				pData[playerid][pTrailer] = INVALID_VEHICLE_ID;
			}
			
			if(pData[playerid][pHauling] > -1 || pData[playerid][pMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan Mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Error(playerid, "Anda harus mengendarai truck.");
			if(!IsAHaulTruck(vehicleid)) return Error(playerid, "You're not in Hauling Truck ( Attachable Truck )");

			pData[playerid][pHauling] = id;
			
			new line9[900];

			format(line9, sizeof(line9), "Silahkan anda mengambil trailer gas oil di gudang miner!\n\nGas Station ID: %d\nLocation: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke Gas Station tujuan hauling anda!",
				id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
			SetPlayerRaceCheckpoint(playerid, 1, 335.66, 861.02, 21.01, 0, 0, 0, 5.5);
			pData[playerid][pTrailer] = CreateVehicle(584, 326.57, 857.31, 20.40, 290.67, -1, -1, -1, 0);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Hauling Info", line9, "Close","");
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK)
	{
		if(response)
		{
			new id = ReturnRestockBisnisID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);
			if(bData[id][bMoney] < 1000)
				return Error(playerid, "Maaf, Bisnis ini kehabisan uang product.");
			
			if(pData[playerid][pMission] > -1 || pData[playerid][pHauling] > -1)
				return Error(playerid, "Anda sudah sedang melakukan mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pMission] = id;
			bData[id][bRestock] = 0;
			
			new line9[900];
			new type[128];
			if(bData[id][bType] == 1)
			{
				type = "Fast Food";

			}
			else if(bData[id][bType] == 2)
			{
				type = "Market";
			}
			else if(bData[id][bType] == 3)
			{
				type = "Clothes";
			}
			else if(bData[id][bType] == 4)
			{
				type = "Equipment";
			}
			else
			{
				type = "Unknow";
			}
			format(line9, sizeof(line9), "Silahkan anda membeli stock product di gudang!\n\nBisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Type: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke bisnis mission anda!",
			id, bData[id][bOwner], bData[id][bName], type);
			SetPlayerRaceCheckpoint(playerid,1, -279.67, -2148.42, 28.54, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Mission Info", line9, "Close","");
		}
	}
	if(dialogid == DIALOG_PRODUCT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * ProductPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehProduct[vehicleid] + amount;
			if(amount < 0 || amount > 150) return Error(playerid, "amount maximal 0 - 150.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Product < amount) return Error(playerid, "Product stock tidak mencukupi.");
			if(total > 150) return Error(playerid, "Product Maximal 150 in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehProduct[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += amount;
			}
			
			Product -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"product seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_GASOIL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * GasOilPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehGasOil[vehicleid] + amount;
			
			if(amount < 0 || amount > 1000) return Error(playerid, "amount maximal 0 - 1000.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(GasOil < amount) return Error(playerid, "GasOil stock tidak mencukupi.");
			if(total > 1000) return Error(playerid, "Gas Oil Maximal 1000 liter in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehGasOil[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cGasOil] += amount;
			}
			
			GasOil -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"liter gas oil seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_MATERIAL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMaterial] + amount;
			new value = amount * MaterialPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Material terlalu penuh di Inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Material < amount) return Error(playerid, "Material stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMaterial] += amount;
			Material -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"material seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_OBAT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pObat] + amount;
			new value = amount * ObatPrice;
			if(amount < 0 || amount > 5) return Error(playerid, "amount maximal 0 - 5.");
			if(total > 5) return Error(playerid, "Obat terlalu penuh di Inventory! Maximal 5.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(ObatMyr < amount) return Error(playerid, "Obat stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pObat] += amount;
			ObatMyr -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"obat seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_COMPONENT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pComponent] + amount;
			new value = amount * ComponentPrice;
			if(amount < 0 || amount > 701) return Error(playerid, "amount maximal 0 - 700.");
			if(total > 700) return Error(playerid, "Component terlalu penuh di Inventory! Maximal 700.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Component < amount) return Error(playerid, "Component stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pComponent] += amount;
			Component -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"component seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_DRUGS)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMarijuana] + amount;
			new value = amount * MarijuanaPrice;
			if(amount < 0 || amount > 100) return Error(playerid, "amount maximal 0 - 100.");
			if(total > 100) return Error(playerid, "Marijuana full in your inventory! max: 100 kg.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Marijuana < amount) return Error(playerid, "Marijuana stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMarijuana] += amount;
			Marijuana -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Marijuana seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_FOOD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//buy food
					if(pData[playerid][pFood] > 500) return Error(playerid, "Anda sudah membawa 500 Food!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Food:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Food Price"GREEN_E"%s /item", Food, FormatMoney(FoodPrice));
					ShowPlayerDialog(playerid, DIALOG_FOOD_BUY, DIALOG_STYLE_INPUT, "Buy Food", mstr, "Buy", "Cancel");
				}
				case 1:
				{
					//buy seed
					if(pData[playerid][pSeed] > 100) return Error(playerid, "Anda sudah membawa 100 Seed!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Seed:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Seed Price"GREEN_E"%s /item", Food, FormatMoney(SeedPrice));
					ShowPlayerDialog(playerid, DIALOG_SEED_BUY, DIALOG_STYLE_INPUT, "Buy Seed", mstr, "Buy", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_FOOD_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pFood] + amount;
			new value = amount * FoodPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Food terlalu penuh di Inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Food < amount) return Error(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pFood] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Food seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_SEED_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pSeed] + amount;
			new value = amount * SeedPrice;
			if(amount < 0 || amount > 100) return Error(playerid, "amount maximal 0 - 100.");
			if(total > 100) return Error(playerid, "Seed terlalu penuh di Inventory! Maximal 100.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Food < amount) return Error(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pSeed] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Seed seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Sprunk(1 - 500):\nPrice 1(Sprunk): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice1]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE1, DIALOG_STYLE_INPUT, "Price 1", mstr, "Edit", "Cancel");
				}
				case 1:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Snack(1 - 500):\nPrice 2(Snack): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice2]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE2, DIALOG_STYLE_INPUT, "Price 2", mstr, "Edit", "Cancel");
				}
				case 2:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Ice Cream Orange(1 - 500):\nPrice 3(Ice Cream Orange): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice3]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE3, DIALOG_STYLE_INPUT, "Price 3", mstr, "Edit", "Cancel");
				}
				case 3:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Hotdog(1 - 500):\nPrice 4(Hotdog): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice4]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE4, DIALOG_STYLE_INPUT, "Price 4", mstr, "Edit", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE1)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice1] = amount;
			Info(playerid, "Anda berhasil mengedit price 1(Sprunk) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE2)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice2] = amount;
			Info(playerid, "Anda berhasil mengedit price 2(Snack) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE3)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice3] = amount;
			Info(playerid, "Anda berhasil mengedit price 3(Ice Cream Orange) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE4)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice4] = amount;
			Info(playerid, "Anda berhasil mengedit price 4(Hotdog) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_OFFER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice1])
						return Error(playerid, "Not enough money!");
						
					if(pData[id][pFood] < 5)
						return Error(playerid, "Food stock empty!");
					
					GivePlayerMoneyEx(id, pData[id][pPrice1]);
					pData[id][pFood] -= 5;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice1]);
					pData[playerid][pSprunk] += 1;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli sprunk seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice1]));
				}
				case 1:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice2])
						return Error(playerid, "Not enough money!");
					
					if(pData[id][pFood] < 5)
						return Error(playerid, "Food stock empty!");
						
					GivePlayerMoneyEx(id, pData[id][pPrice2]);
					pData[id][pFood] -= 5;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice2]);
					pData[playerid][pSnack] += 1;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli snack seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice2]));	
				}
				case 2:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice3])
						return Error(playerid, "Not enough money!");
					
					if(pData[id][pFood] < 10)
						return Error(playerid, "Food stock empty!");
						
					GivePlayerMoneyEx(id, pData[id][pPrice3]);
					pData[id][pFood] -= 10;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice3]);
					pData[playerid][pEnergy] += 30;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli ice cream orange seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice3]));
				}
				case 3:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice4])
						return Error(playerid, "Not enough money!");
						
					if(pData[id][pFood] < 10)
						return Error(playerid, "Food stock empty!");
					
					GivePlayerMoneyEx(id, pData[id][pPrice4]);
					pData[id][pFood] -= 10;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice4]);
					pData[playerid][pHunger] += 30;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli hotdog seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice4]));
				}
			}
		}
		pData[playerid][pOffer] = -1;
	}
	if(dialogid == DIALOG_APOTEK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(GetPlayerMoney(playerid) < MedicinePrice) return Error(playerid, "Not enough money.");
					pData[playerid][pMedicine]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -MedicinePrice);
					Server_AddMoney(MedicinePrice);
					Info(playerid, "Anda membeli medicine seharga "RED_E"%s,"WHITE_E" /use untuk menggunakannya.", FormatMoney(MedicinePrice));
				}
				case 1:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return Error(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < MedkitPrice) return Error(playerid, "Not enough money.");
					pData[playerid][pMedkit]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -MedkitPrice);
					Server_AddMoney(MedkitPrice);
					Info(playerid, "Anda membeli medkit seharga "RED_E"%s", FormatMoney(MedkitPrice));
				}
				case 2:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return Error(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < 100) return Error(playerid, "Not enough money.");
					pData[playerid][pBandage]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -100);
					Server_AddMoney(100);
					Info(playerid, "Anda membeli bandage seharga "RED_E"$100");
				}
			}
		}
	}
	if(dialogid == DIALOG_ATM)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
			}
			case 1: // Withdraw
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"My Balance: "LB_E"%s", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_LIST, mstr, "$50\n$200\n$500\n$1.000\n$5.000", "Withdraw", "Cancel");
			}
			case 2: // Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
			}
			case 3: //Paycheck
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_ATMWITHDRAW)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pBankMoney] < 50)
						return Error(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 50);
					pData[playerid][pBankMoney] -= 50;
					Info(playerid, "ATM withdraw "LG_E"$50");
				}
				case 1:
				{
					if(pData[playerid][pBankMoney] < 200)
						return Error(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 200);
					pData[playerid][pBankMoney] -= 200;
					Info(playerid, "ATM withdraw "LG_E"$200");
				}
				case 2:
				{
					if(pData[playerid][pBankMoney] < 500)
						return Error(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 500);
					pData[playerid][pBankMoney] -= 500;
					Info(playerid, "ATM withdraw "LG_E"$500");
				}
				case 3:
				{
					if(pData[playerid][pBankMoney] < 1000)
						return Error(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 1000);
					pData[playerid][pBankMoney] -= 1000;
					Info(playerid, "ATM withdraw "LG_E"$1.000");
				}
				case 4:
				{
					if(pData[playerid][pBankMoney] < 5000)
						return Error(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 5000);
					pData[playerid][pBankMoney] -= 5000;
					Info(playerid, "ATM withdraw "LG_E"$5.000");
				}
			}
		}
	}
	if(dialogid == DIALOG_BANK)
	{
		if(!response) return true;
		switch(listitem)
		{
			case 0: // Deposit
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Cancel");
			}
			case 1: // Withdraw
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.\n\nType in the amount you want to withdraw below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Withdraw", "Cancel");
			}
			case 2: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
			}
			case 3: //Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
			}
			case 4:
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_BANKDEPOSIT)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pMoney]) return Error(playerid, "You do not have the sufficient funds to make this transaction.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");

		else
		{
			new query[512], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] + amount);
			GivePlayerMoneyEx(playerid, -amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "{F6F6F6}You have successfully deposited "LB_E"%s {F6F6F6}into your bank account.\n"LB_E"Current Balance: {F6F6F6}%s", FormatMoney(amount), FormatMoney(pData[playerid][pBankMoney]));
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Great RP: "LB_E"Bank", lstr, "Close", "");
		}
	}
	if(dialogid == DIALOG_BANKWITHDRAW)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return Error(playerid, "You do not have the sufficient funds to make this transaction.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		else
		{
			new query[128], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - amount);
			GivePlayerMoneyEx(playerid, amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "{F6F6F6}You have successfully withdrawed "LB_E"%s {F6F6F6}from your bank account.\n"LB_E"Current Balance: {F6F6F6}%s", FormatMoney(amount), FormatMoney(pData[playerid][pBankMoney]));
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Great RP: "LB_E"Bank", lstr, "Close", "");
		}
	}
	if(dialogid == DIALOG_BANKREKENING)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return Error(playerid, "Uang dalam rekening anda kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");

		else
		{
			pData[playerid][pTransfer] = amount;
			ShowPlayerDialog(playerid, DIALOG_BANKTRANSFER, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan nomor rekening target:", "Transfer", "Cancel");
		}
	}
	if(dialogid == DIALOG_BANKTRANSFER)
	{
		if(!response) return true;
		new rek = floatround(strval(inputtext)), query[128];
		
		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRek", "id", playerid, rek);
		return 1;
	}
	if(dialogid == DIALOG_BANKCONFIRM)
	{
		if(response)
		{
			new query[128], mstr[248];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=bmoney+%d WHERE brek=%d", pData[playerid][pTransfer], pData[playerid][pTransferRek]);
			mysql_tquery(g_SQL, query);
			
			foreach(new ii : Player)
			{
				if(pData[ii][pBankRek] == pData[playerid][pTransferRek])
				{
					pData[ii][pBankMoney] += pData[playerid][pTransfer];
				}
			}
			
			pData[playerid][pBankMoney] -= pData[playerid][pTransfer];
			
			format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda telah berhasil mentransfer!", pData[playerid][pTransferRek], pData[playerid][pTransferName], FormatMoney(pData[playerid][pTransfer]));
			ShowPlayerDialog(playerid, DIALOG_BANKSUKSES, DIALOG_STYLE_MSGBOX, ""LB_E"Transfer Sukses", mstr, "Sukses", "");
		}
	}
	if(dialogid == DIALOG_BANKSUKSES)
	{
		if(response)
		{
			pData[playerid][pTransfer] = 0;
			pData[playerid][pTransferRek] = 0;
		}
	}
	if(dialogid == DIALOG_ASKS)
	{
		if(response) 
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, AskData[i][askText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Ask Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Asked: "GREEN_E"%s\n"WHITE_E"Question: "RED_E"%s.", pData[AskData[i][askPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	if(dialogid == DIALOG_REPORTS)
	{
		if(response) 
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, ReportData[i][rText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Report Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Reported: "GREEN_E"%s\n"WHITE_E"Reason: "RED_E"%s.", pData[ReportData[i][rPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	/*if(dialogid == DIALOG_REPORTS)
	{
	    new
		id = g_player_listitem[playerid][listitem],
		otherid = ReportData[id][rPlayer];

	    if(response)
	    {
	        if(!IsPlayerConnected(otherid))
		        return ClearReport(id);

			ShowPlayerDialog(playerid, DIALOG_ANSWER_REPORTS, DIALOG_STYLE_INPUT, "Panel Keluhan",
			"Apa yang anda ingin lakukan pada keluhan ini?\n"\
			"Jika anda ingin menolaknya anda bisa mengisi alasan pada box dibawah\n"\
			"Namun, jika anda ingin menerimanya. Anda hanya perlu melakukan klik pada tombol terima", "Terima", "Tolak");

			SetPVarInt(playerid, "TEMP_LISTITEM", id);
		}
    }
	if(dialogid == DIALOG_ANSWER_REPORTS)
	{
	    new id = GetPVarInt(playerid, "TEMP_LISTITEM");
	    new string[144];
	            
	    if(Iter_Contains(Reports, id))
	    {
	        if(response)
			{
				format(string, sizeof(string), "{FF0000}[REPORT] {FFFFFF}Admin {FFFF00}%s {FFFFFF}menerima laporan anda", g_player_name[playerid]);
		        SendClientMessage(ReportData[id][rPlayer], -1, string);

		        format(string, sizeof(string), "{FF0000}[REPORT] {FFFFFF}Anda menerima laporan dari {FFFF00}%s", ReportData[id][rPlayerName]);
		        SendClientMessage(playerid, -1, string);
		    }
		    else
		    {
		        format(string, sizeof(string), "{FF0000}[REPORT] {FFFFFF}Admin {FFFF00}%s {FFFFFF}menolak laporan anda | %s", g_player_name[playerid], inputtext);
		        SendClientMessage(ReportData[id][rPlayer], -1, string);

                format(string, sizeof(string), "{FF0000}[REPORT] {FFFFFF}Anda menerima laporan dari {FFFF00}%s", ReportData[id][rPlayerName]);
                SendClientMessage(playerid, -1, string);
            }
        }
        ClearReport(id);
        DeletePVar(playerid, "TEMP_LISTITEM");
    }*/
	if(dialogid == DIALOG_BUYPV)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				TogglePlayerControllable(playerid, 1);
				Error(playerid,"Anda harus berada di dalam kendaraan untuk membelinya.");
				return 1;
			}
			new cost = GetVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pMoney] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly+1.2, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			//if(playerid == INVALID_PLAYER_ID) return Error(playerid, "Invalid player ID!");
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = GetVehicleModel(GetPlayerVehicleID(playerid));
			x = 1805.93;
			y = -1791.19;
			z = 13.54;
			a = 2.22;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			/*new cQuery[1024], model = GetVehicleModel(GetPlayerVehicleID(playerid)), color1 = 0, color2 = 0,
			Float:x = 1805.13, Float:y = -1708.09, Float:z = 13.54, Float:a = 179.23, price = GetVehicleCost(GetVehicleModel(GetPlayerVehicleID(playerid)));
			format(cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			MySQL_query(cQuery, false, "OnVehBuyed", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			Servers(playerid, "harusnya bisaa");*/
			return 1;
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			//new Float:slx, Float:sly, Float:slz;
			//GetPlayerPos(playerid, slx, sly, slz);
			//SetPlayerPos(playerid, slx, sly, slz+1.3);
			//TogglePlayerControllable(playerid, 1);
			//SetVehicleToRespawn(vehicleid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
	}
	if(dialogid == DIALOG_BUYVIPPV)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				TogglePlayerControllable(playerid, 1);
				Error(playerid,"Anda harus berada di dalam kendaraan untuk membelinya.");
				return 1;
			}
			new gold = GetVipVehicleCost(GetVehicleModel(vehicleid));
			new cost = GetVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pGold] < gold)
			{
				Error(playerid, "gold anda tidak mencukupi!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			//if(playerid == INVALID_PLAYER_ID) return Error(playerid, "Invalid player ID!");
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			pData[playerid][pGold] -= gold;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = GetVehicleModel(GetPlayerVehicleID(playerid));
			x = 1805.93;
			y = -1791.19;
			z = 13.54;
			a = 2.22;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			/*new cQuery[1024], model = GetVehicleModel(GetPlayerVehicleID(playerid)), color1 = 0, color2 = 0,
			Float:x = 1805.13, Float:y = -1708.09, Float:z = 13.54, Float:a = 179.23, price = GetVehicleCost(GetVehicleModel(GetPlayerVehicleID(playerid)));
			format(cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			MySQL_query(cQuery, false, "OnVehBuyed", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			Servers(playerid, "harusnya bisaa");*/
			return 1;
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			//new Float:slx, Float:sly, Float:slz;
			//GetPlayerPos(playerid, slx, sly, slz);
			//SetPlayerPos(playerid, slx, sly, slz+1.3);
			//TogglePlayerControllable(playerid, 1);
			//SetVehicleToRespawn(vehicleid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
	}
	if(dialogid == DIALOG_BUYPVCP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//Bikes
					new str[1024];
					/*format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(481), FormatMoney(GetVehicleCost(481)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(509), FormatMoney(GetVehicleCost(509)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(510), FormatMoney(GetVehicleCost(510)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(462), FormatMoney(GetVehicleCost(462)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(586), FormatMoney(GetVehicleCost(586)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(581), FormatMoney(GetVehicleCost(581)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(461), FormatMoney(GetVehicleCost(461)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(521), FormatMoney(GetVehicleCost(521)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(463), FormatMoney(GetVehicleCost(463)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(468), FormatMoney(GetVehicleCost(468)));*/
					
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(481), FormatMoney(GetVehicleCost(481)), 
					GetVehicleModelName(509), FormatMoney(GetVehicleCost(509)),
					GetVehicleModelName(510), FormatMoney(GetVehicleCost(510)),
					GetVehicleModelName(462), FormatMoney(GetVehicleCost(462)),
					GetVehicleModelName(586), FormatMoney(GetVehicleCost(586)),
					GetVehicleModelName(581), FormatMoney(GetVehicleCost(581)),
					GetVehicleModelName(461), FormatMoney(GetVehicleCost(461)),
					GetVehicleModelName(521), FormatMoney(GetVehicleCost(521)),
					GetVehicleModelName(463), FormatMoney(GetVehicleCost(463)),
					GetVehicleModelName(468), FormatMoney(GetVehicleCost(468))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_BIKES, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Motorcycle", str, "Buy", "Close");
				}
				case 1:
				{
					//Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(400), FormatMoney(GetVehicleCost(400)), 
					GetVehicleModelName(412), FormatMoney(GetVehicleCost(412)),
					GetVehicleModelName(419), FormatMoney(GetVehicleCost(419)),
					GetVehicleModelName(426), FormatMoney(GetVehicleCost(426)),
					GetVehicleModelName(436), FormatMoney(GetVehicleCost(436)),
					GetVehicleModelName(466), FormatMoney(GetVehicleCost(466)),
					GetVehicleModelName(467), FormatMoney(GetVehicleCost(467)),
					GetVehicleModelName(474), FormatMoney(GetVehicleCost(474)),
					GetVehicleModelName(475), FormatMoney(GetVehicleCost(475)),
					GetVehicleModelName(480), FormatMoney(GetVehicleCost(480)),
					GetVehicleModelName(603), FormatMoney(GetVehicleCost(603)),
					GetVehicleModelName(421), FormatMoney(GetVehicleCost(421)),
					GetVehicleModelName(602), FormatMoney(GetVehicleCost(602)),
					GetVehicleModelName(492), FormatMoney(GetVehicleCost(492)),
					GetVehicleModelName(545), FormatMoney(GetVehicleCost(545)),
					GetVehicleModelName(489), FormatMoney(GetVehicleCost(489)),
					GetVehicleModelName(405), FormatMoney(GetVehicleCost(405)),
					GetVehicleModelName(445), FormatMoney(GetVehicleCost(445)),
					GetVehicleModelName(579), FormatMoney(GetVehicleCost(579)),
					GetVehicleModelName(507), FormatMoney(GetVehicleCost(507))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Mobil", str, "Buy", "Close");
				}
				case 2:
				{
					//Unique Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(483), FormatMoney(GetVehicleCost(483)), 
					GetVehicleModelName(534), FormatMoney(GetVehicleCost(534)),
					GetVehicleModelName(535), FormatMoney(GetVehicleCost(535)),
					GetVehicleModelName(536), FormatMoney(GetVehicleCost(536)),
					GetVehicleModelName(558), FormatMoney(GetVehicleCost(558)),
					GetVehicleModelName(559), FormatMoney(GetVehicleCost(559)),
					GetVehicleModelName(560), FormatMoney(GetVehicleCost(560)),
					GetVehicleModelName(561), FormatMoney(GetVehicleCost(561)),
					GetVehicleModelName(562), FormatMoney(GetVehicleCost(562)),
					GetVehicleModelName(565), FormatMoney(GetVehicleCost(565)),
					GetVehicleModelName(567), FormatMoney(GetVehicleCost(567)),
					GetVehicleModelName(575), FormatMoney(GetVehicleCost(575)),
					GetVehicleModelName(576), FormatMoney(GetVehicleCost(576))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_UCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan Unik", str, "Buy", "Close");
				}
				case 3:
				{
					//Job Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s", 
					GetVehicleModelName(420), FormatMoney(GetVehicleCost(420)), 
					GetVehicleModelName(438), FormatMoney(GetVehicleCost(438)), 
					GetVehicleModelName(403), FormatMoney(GetVehicleCost(403)), 
					GetVehicleModelName(413), FormatMoney(GetVehicleCost(413)),
					GetVehicleModelName(414), FormatMoney(GetVehicleCost(414)),
					GetVehicleModelName(422), FormatMoney(GetVehicleCost(422)),
					GetVehicleModelName(440), FormatMoney(GetVehicleCost(440)),
					GetVehicleModelName(455), FormatMoney(GetVehicleCost(455)),
					GetVehicleModelName(456), FormatMoney(GetVehicleCost(456)),
					GetVehicleModelName(478), FormatMoney(GetVehicleCost(478)),
					GetVehicleModelName(482), FormatMoney(GetVehicleCost(482)),
					GetVehicleModelName(498), FormatMoney(GetVehicleCost(498)),
					GetVehicleModelName(499), FormatMoney(GetVehicleCost(499)),
					GetVehicleModelName(423), FormatMoney(GetVehicleCost(423)),
					GetVehicleModelName(588), FormatMoney(GetVehicleCost(588)),
					GetVehicleModelName(524), FormatMoney(GetVehicleCost(524)),
					GetVehicleModelName(525), FormatMoney(GetVehicleCost(525)),
					GetVehicleModelName(543), FormatMoney(GetVehicleCost(543)),
					GetVehicleModelName(552), FormatMoney(GetVehicleCost(552)),
					GetVehicleModelName(554), FormatMoney(GetVehicleCost(554)),
					GetVehicleModelName(578), FormatMoney(GetVehicleCost(578)),
					GetVehicleModelName(609), FormatMoney(GetVehicleCost(609))
					//GetVehicleModelName(530), FormatMoney(GetVehicleCost(530)) //fortklift
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_JOBCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan Job", str, "Buy", "Close");
				}
				case 4:
				{
					// VIP Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n", 
					GetVehicleModelName(522), GetVipVehicleCost(522), 
					GetVehicleModelName(411), GetVipVehicleCost(411), 
					GetVehicleModelName(451), GetVipVehicleCost(451),
					GetVehicleModelName(415), GetVipVehicleCost(415), 
					GetVehicleModelName(402), GetVipVehicleCost(402), 
					GetVehicleModelName(541), GetVipVehicleCost(541), 
					GetVehicleModelName(429), GetVipVehicleCost(429), 
					GetVehicleModelName(506), GetVipVehicleCost(506), 
					GetVehicleModelName(494), GetVipVehicleCost(494), 
					GetVehicleModelName(502), GetVipVehicleCost(502), 
					GetVehicleModelName(503), GetVipVehicleCost(503), 
					GetVehicleModelName(409), GetVipVehicleCost(409), 
					GetVehicleModelName(477), GetVipVehicleCost(477)
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan VIP", str, "Buy", "Close");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_BIKES)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 509;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 510;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 462;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 586;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 581;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 461;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 521;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 463;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 468;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 400;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 412;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 419;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 426;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 436;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 466;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 467;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 474;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 475;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 480;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 603;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 421;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 602;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 492;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 545;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 489;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 405;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 445;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 579;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 507;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_UCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 483;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 534;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 535;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 536;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 558;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 559;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 560;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 561;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 562;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 565;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 567;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 575;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 576;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 420;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 438;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 403;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 413;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 414;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 422;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 440;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 455;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 456;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 478;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 482;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 498;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 499;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 423;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 588;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 524;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 525;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 543;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 552;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 554;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 20:
				{
					new modelid = 578;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 21:
				{
					new modelid = 609;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 522;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 411;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 451;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 415;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 541;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 429;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 506;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 494;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 503;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 409;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 477;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 414;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 455;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 456;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 3:
				{
					new modelid = 498;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 4:
				{
					new modelid = 499;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 5:
				{
					new modelid = 609;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 6:
				{
					new modelid = 478;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 7:
				{
					new modelid = 422;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 8:
				{
					new modelid = 543;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 9:
				{
					new modelid = 554;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 10:
				{
					new modelid = 525;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 11:
				{
					new modelid = 438;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 12:
				{
					new modelid = 420;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARSCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < 500)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -500);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2, rental;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 535.2369;
			y = -1277.7272;
			z = 16.8134;
			a = 222.1837;
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentPV", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_RENT_BOAT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 473;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kapal "PINK_E"%s "WHITE_E"dengan harga "LG_E"$750 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_BOATCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boats", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 453;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kapal "PINK_E"%s "WHITE_E"dengan harga "LG_E"$1.250 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_BOATCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boats", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 452;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kapal "PINK_E"%s "WHITE_E"dengan harga "LG_E"$1.500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_BOATCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boats", tstr, "Rental", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_BOATCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleRentalCost(modelid);
			if(pData[playerid][pMoney] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2, rental;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 223.3398;
			y = -1992.5416;
			z = -0.4823;
			a = 268.7136;
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentBoat", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_RENT_BIKE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa sepeda "PINK_E"%s "WHITE_E"dengan harga "LG_E"$50 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Rental Bike", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 462;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa motor "PINK_E"%s "WHITE_E"dengan harga "LG_E"$200 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Rental Bike", tstr, "Rental", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_BIKECONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleRentalCost(modelid);
			if(pData[playerid][pMoney] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2, rental;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, a);
			color1 = 0;
			color2 = 0;
			model = modelid;
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentBike", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 535.2369;
			y = -1277.7272;
			z = 16.8134;
			a = 222.1837;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVipVehicleCost(modelid);
			if(pData[playerid][pGold] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			pData[playerid][pGold] -= cost;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 535.2369;
			y = -1277.7272;
			z = 16.8134;
			a = 222.1837;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	/*if(dialogid == DIALOG_SALARY)
	{
		if(!response) 
		{
			ListPage[playerid]--;
			if(ListPage[playerid] < 0)
			{
				ListPage[playerid] = 0;
				return 1;
			}
		}
		else
		{
			ListPage[playerid]++;
		}
		
		DisplaySalary(playerid);
		return 1;
	}*/
	if(dialogid == DIALOG_PAYCHECK)
	{
		if(response)
		{
			if(pData[playerid][pPaycheck] < 3600) return Error(playerid, "Sekarang belum waktunya anda mengambil paycheck.");
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM salary WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
			mysql_query(g_SQL, query);
			new rows = cache_num_rows();
			if(rows) 
			{
				new list[2000], date[30], info[16], money, totalduty, gajiduty, totalsal, total, pajak, hasil;
				
				totalduty = pData[playerid][pOnDutyTime] + pData[playerid][pTaxiTime];
				for(new i; i < rows; ++i)
				{
					cache_get_value_name(i, "info", info);
					cache_get_value_name(i, "date", date);
					cache_get_value_name_int(i, "money", money);
					totalsal += money;
				}
				
				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty + totalsal;
				pajak = total / 100 * 10;
				hasil = total - pajak;
				
				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Close", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				pData[playerid][pTaxiTime] = 0;
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM salary WHERE owner='%d'", pData[playerid][pID]);
				mysql_query(g_SQL, query);
			}
			else
			{
				new list[2000], totalduty, gajiduty, total, pajak, hasil;
				
				totalduty = pData[playerid][pOnDutyTime] + pData[playerid][pTaxiTime];
				
				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty;
				pajak = total / 100 * 10;
				hasil = total - pajak;
				
				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Close", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				pData[playerid][pTaxiTime] = 0;
			}
		}
	}
	if(dialogid == DIALOG_SWEEPER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_RUTE_SWEEPER, DIALOG_STYLE_LIST, "Pilih Rute Sweeper", ">> Route A\n>> Route B", "Pilih", "Batal");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_RUTE_SWEEPER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pSweeperTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSweeperTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else
					{
						pData[playerid][pSideJob] = 1;
						pData[playerid][pSweeper] = 1;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint1, sweperpoint1, 4.0);
						pData[playerid][pCheckPoint] = CHECKPOINT_SWEEPER;
						InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
					}	
				}
				case 1:
				{
					if(pData[playerid][pSweeperTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSweeperTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else 
					{
						pData[playerid][pSideJob] = 1;
						pData[playerid][pSweeper] = 13;
						SetPlayerRaceCheckpoint(playerid, 2, cpswep2, cpswep2, 4.0);
						pData[playerid][pCheckPoint] = CHECKPOINT_SWEEPER;
						InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
					}
				}
			}
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}			
	}
	if(dialogid == DIALOG_BUS)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_RUTE_BUS, DIALOG_STYLE_LIST, "Pilih Rute Bus", ">> Route A\n>> Route B", "Pilih", "Batal");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_RUTE_BUS)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pBusTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pBusTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else
					{
						pData[playerid][pSideJob] = 2;
						pData[playerid][pBus] = 1;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint1, buspoint1, 4.0);
						pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
						InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
					}
						
				}
				case 1:
				{
					if(pData[playerid][pBusTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pBusTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else
					{
						pData[playerid][pSideJob] = 2;
						pData[playerid][pBus] = 28;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus2, cpbus2, 4.0);
						pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
						InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
					}
				}
			}
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		} 
	}
	if(dialogid == DIALOG_FORKLIFT)
	{
		new vehicleid = GetPlayerVehicleID(playerid), rand = random(sizeof(ForklifterAB));
		if(response)
		{
			if(pData[playerid][pForklifterTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pForklifterTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			
			pData[playerid][pSideJob] = 3;
			pData[playerid][pForklifter] = 1;
			pData[playerid][pCheckPoint] = CHECKPOINT_FORKLIFTER;
			SetPlayerRaceCheckpoint(playerid, 2, ForklifterAB[rand][0], ForklifterAB[rand][1], ForklifterAB[rand][2], ForklifterAB[rand][3], ForklifterAB[rand][4], ForklifterAB[rand][5], ForklifterAB[rand][6]);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
			
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_MOWER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pMowerTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pMowerTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}

			pData[playerid][pSideJob] = 4;
			pData[playerid][pMower] = 1;
			pData[playerid][pCheckPoint] = CHECKPOINT_MOWER;
			SetPlayerRaceCheckpoint(playerid, 2, mowerpoint1, mowerpoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_BAGGAGE)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
				case 0://Rute 1
				{
				    if(DialogBaggage[0] == false) // Kalau False atau tidak dipilih
				    {
					    DialogBaggage[0] = true; // Dialog 0 telah di pilih
					    MyBaggage[playerid][0] = true;
						SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2137.2085, -2380.0925, 13.2078, 2137.2085, -2380.0925, 13.2078, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2137.2085, -2380.0925, 13.2078, 180.7874, 1, 1, -1);
						pData[playerid][pBaggage] = 1;
						pData[playerid][pCheckPoint] = CHECKPOINT_BAGGAGE;
					}
					else
					    SendClientMessage(playerid,-1,"{FF0000}<!> {FFFFFF}Misi Baggage ini sudah diambil oleh seseorang");
				}
				case 1://Rute 2
				{
				    if(DialogBaggage[1] == false) // Kalau False atau tidak dipilih
				    {
					    DialogBaggage[1] = true; // Dialog 0 telah di pilih
					    MyBaggage[playerid][1] = true;
						SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2009.4430, -2273.0322, 13.2024, 2009.4430, -2273.0322, 13.2024, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 2009.4430, -2273.0322, 13.2024, 91.8682, 1, 1, -1);
						pData[playerid][pBaggage] = 12;
						pData[playerid][pCheckPoint] = CHECKPOINT_BAGGAGE;
					}
					else
					    SendClientMessage(playerid,-1,"{FF0000}<!> {FFFFFF}Misi Baggage ini sudah diambil oleh seseorang");
				}
				case 2://Rute 3
				{
				    if(DialogBaggage[2] == false) // Kalau False atau tidak dipilih
				    {
					    DialogBaggage[2] = true; // Dialog 0 telah di pilih
					    MyBaggage[playerid][2] = true;
						SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1897.6689, -2225.1143, 13.2150, 1897.6689, -2225.1143, 13.2150, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 1897.6689, -2225.1143, 13.2150, 180.8993, 1, 1, -1);
						pData[playerid][pBaggage] = 23;
						pData[playerid][pCheckPoint] = CHECKPOINT_BAGGAGE;
					}
					else
					    SendClientMessage(playerid,-1,"{FF0000}<!> {FFFFFF}Misi Baggage ini sudah diambil oleh seseorang");
				}
			}
		}
		else 
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_ISIKUOTA)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					new string[512], twitter[64];
					if(pData[playerid][pTwitter] < 1)
					{
						twitter = ""RED_E"Pasang";
					}
					else
					{
						twitter = ""LG_E"Terinstall";
					}
					download[playerid] = 1;
					format(string, sizeof(string),"Aplikasi\tStatus\n{7fffd4}Twitter ( 38mb )\t%s", twitter);
					ShowPlayerDialog(playerid, DIALOG_DOWNLOAD, DIALOG_STYLE_TABLIST_HEADERS, "App Store",string,"Download","Batal");
				}
				case 1:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), "Kuota\tHarga Pulsa\n{ffffff}Kuota 512MB\t{7fff00}3\n{ffffff}Kuota 1GB\t{7fff00}6\n{ffffff}Kuota 2GB\t{7fff00}12\n");
					ShowPlayerDialog(playerid, DIALOG_KUOTA, DIALOG_STYLE_TABLIST_HEADERS, "Isi Kuota", mstr, "Buy", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_DOWNLOAD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new sisa = pData[playerid][pKuota]/1000;
					if(pData[playerid][pKuota] <= 38000)
						return Error(playerid, "Kuota yang anda miliki tidak mencukup ( Sisa %dmb )", sisa);

					SetTimerEx("DownloadTwitter", 10000, false, "i", playerid);
					GameTextForPlayer(playerid, "Downloading...", 10000, 4);
				}
			}
		}
		else
		{
			Servers(playerid, "Berhasil membatalkan Download Twitter");
		}
	}
	if(dialogid == DIALOG_KUOTA)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pPhoneCredit] < 3)
						return Error(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 512000;
					pData[playerid][pPhoneCredit] -= 3;
					Servers(playerid, "Berhasil membeli Kuota 512mb");
				}
				case 1:
				{
					if(pData[playerid][pPhoneCredit] < 6)
						return Error(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 1000000;
					pData[playerid][pPhoneCredit] -= 6;
					Servers(playerid, "Berhasil membeli Kuota 1gb");
				}
				case 2:
				{
					if(pData[playerid][pPhoneCredit] < 12)
						return Error(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 2000000;
					pData[playerid][pPhoneCredit] -= 6;
					Servers(playerid, "Berhasil membeli Kuota 2gb");
				}
			}
		}
	}
	if(dialogid ==  DIALOG_STUCK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut di Gedung", pData[playerid][pName], playerid);
				}
				case 1:
				{
					SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut setelah keluar masuk Interior", pData[playerid][pName], playerid);
				}
				case 2:
				{

					if((Vehicle_Nearest(playerid)) != -1)
					{
						new Float:vX, Float:vY, Float:vZ;
						GetPlayerPos(playerid, vX, vY, vZ);
						SetPlayerPos(playerid, vX, vY, vZ+2);
						SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut diKendaraan (Non Visual Bug)", pData[playerid][pName], playerid);
					}
					else
					{
						Error(playerid, "Anda tidak berada didekat Kendaraan apapun");
						SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut diKendaraan (Visual Bug)", pData[playerid][pName], playerid);
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_TDM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetPlayerTeam(playerid) == 1)
						return Error(playerid, "Anda sudah bergabung ke Tim ini");

					if(RedTeam >= MaxRedTeam)
						return Error(playerid, "Pemain didalam tim ini sudah terlalu penuh");

					SetPlayerTeam(playerid, 1);
					SetPlayerPos(playerid, RedX, RedY, RedZ);
					IsAtEvent[playerid] = 1;
					SetPlayerVirtualWorld(playerid, EventWorld);
					SetPlayerInterior(playerid, EventInt);
					SetPlayerHealthEx(playerid, EventHP);
					SetPlayerArmourEx(playerid, EventArmour);
					ResetPlayerWeapons(playerid);
					GivePlayerWeaponEx(playerid, EventWeapon1, 150);
					GivePlayerWeaponEx(playerid, EventWeapon2, 150);
					GivePlayerWeaponEx(playerid, EventWeapon3, 150);
					GivePlayerWeaponEx(playerid, EventWeapon4, 150);
					GivePlayerWeaponEx(playerid, EventWeapon5, 150);
					TogglePlayerControllable(playerid, 0);
					SetPlayerColor(playerid, COLOR_RED);
					Servers(playerid, "Berhasil bergabung kedalam Tim, Harap tunggu Admin memulai Event");
					RedTeam += 1;
				}
				case 1:
				{
					if(GetPlayerTeam(playerid) == 2)
						return Error(playerid, "Anda sudah bergabung ke Tim ini");

					if(BlueTeam >= MaxBlueTeam)
						return Error(playerid, "Pemain didalam tim ini sudah terlalu penuh");

					SetPlayerTeam(playerid, 2);
					SetPlayerPos(playerid, BlueX, BlueY, BlueZ);
					IsAtEvent[playerid] = 1;
					SetPlayerVirtualWorld(playerid, EventWorld);
					SetPlayerInterior(playerid, EventInt);
					SetPlayerHealthEx(playerid, EventHP);
					SetPlayerArmourEx(playerid, EventArmour);
					ResetPlayerWeapons(playerid);
					GivePlayerWeaponEx(playerid, EventWeapon1, 150);
					GivePlayerWeaponEx(playerid, EventWeapon2, 150);
					GivePlayerWeaponEx(playerid, EventWeapon3, 150);
					GivePlayerWeaponEx(playerid, EventWeapon4, 150);
					GivePlayerWeaponEx(playerid, EventWeapon5, 150);
					TogglePlayerControllable(playerid, 0);
					SetPlayerColor(playerid, COLOR_BLUE);
					Servers(playerid, "Berhasil bergabung kedalam Tim, Harap tunggu Admin memulai Event");
					BlueTeam += 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_PICKUPVEH)
	{
		if(response)
		{
			new id = ReturnAnyVehiclePark((listitem + 1), pData[playerid][pPark]);

			if(pvData[id][cOwner] != pData[playerid][pID]) return Error(playerid, "This is not your Vehicle!");
			pvData[id][cPark] = -1;
			GetPlayerPos(playerid, pvData[id][cPosX], pvData[id][cPosY], pvData[id][cPosZ]);
			GetPlayerFacingAngle(playerid, pvData[id][cPosA]);
			OnPlayerVehicleRespawn(id);
			InfoTD_MSG(playerid, 4000, "Vehicle ~g~Spawned");
			PutPlayerInVehicle(playerid, pvData[id][cVeh], 0);
		}
	}
	if(dialogid == DIALOG_MY_WS)
	{
		if(!response) return true;
		new id = ReturnPlayerWorkshopID(playerid, (listitem + 1));
		SetPlayerRaceCheckpoint(playerid,1, wsData[id][wX], wsData[id][wY], wsData[id][wZ], 0.0, 0.0, 0.0, 3.5);
		Info(playerid, "Ikuti checkpoint untuk menemukan Business anda!");
		return 1;
	}
	if(dialogid == WS_MENU)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					if(!IsWorkshopOwner(playerid, id))
						return Error(playerid, "Only Workshop Owner who can use this");

					new str[256];
					format(str, sizeof str,"Current Workshop Name:\n%s\n\nInput new name to Change Workshop Name", wsData[id][wName]);
					ShowPlayerDialog(playerid, WS_SETNAME, DIALOG_STYLE_INPUT, "Change Workshop Name", str,"Change","Cancel");
				}
				case 1:
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
								ShowWorkshopMenu(playerid, wid);

								InfoTD_MSG(playerid, 4000, "Workshop anda berhasil ~g~Dibuka!");
								PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
							}
							else
							{
								wsData[wid][wStatus] = 0;
								Workshop_Save(wid);
								ShowWorkshopMenu(playerid, wid);

								InfoTD_MSG(playerid, 4000,"Workshop anda berhasil ~r~Ditutup");
								PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
							}
							Workshop_Refresh(wid);
						}
					}
					return 1;
				}
				case 2:
				{
					new str[556];
					format(str, sizeof str,"Name\tRank\n(%s)\tOwner\n",wsData[id][wOwner]);
					for(new z = 0; z < MAX_WORKSHOP_EMPLOYEE; z++)
					{
						format(str, sizeof str,"%s(%s)\tEmploye\n", str, wsEmploy[id][z]);
					}
					ShowPlayerDialog(playerid, WS_SETEMPLOYE, DIALOG_STYLE_TABLIST_HEADERS, "Employe Menu", str, "Change","Cancel");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, WS_COMPONENT, DIALOG_STYLE_LIST, "Workshop Component", "Withdraw\nDeposit", "Select","Cancel");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, WS_MATERIAL, DIALOG_STYLE_LIST, "Workshop Material", "Withdraw\nDeposit", "Select","Cancel");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, WS_MONEY, DIALOG_STYLE_LIST, "Workshop Money", "Withdraw\nDeposit", "Select","Cancel");
				}
			}
		}
	}
	if(dialogid == WS_SETNAME)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];

			if(!IsWorkshopOwner(playerid, id))
				return Error(playerid, "Only Workshop Owner who can use this");

			if(strlen(inputtext) > 24) 
				return Error(playerid, "Maximal 24 Character");

			if(strfind(inputtext, "'", true) != -1)
				return Error(playerid, "You can't put ' in Workshop Name");
			
			SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully set Workshop Name from {ffff00}%s{ffffff} to {7fffd4}%s", wsData[id][wName], inputtext);
			format(wsData[id][wName], 24, inputtext);
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_SETEMPLOYE)
	{
		if(response)
		{
			new id = pData[playerid][pInWs], str[256];

			if(!IsWorkshopOwner(playerid, id))
				return Error(playerid, "Only Workshop Owner who can use this");

			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 0;
					format(str, sizeof str, "Current Owner:\n%s\n\nInput Player ID/Name to Change Ownership", wsData[id][wOwner]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][0]);
				}
				case 2:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][1]);
				}
				case 3:
				{
					pData[playerid][pMenuType] = 3;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][2]);
				}
			}
			ShowPlayerDialog(playerid, WS_SETEMPLOYEE, DIALOG_STYLE_INPUT, "Employe Menu", str, "Change", "Cancel");
		}
	}
	if(dialogid == WS_SETEMPLOYEE)
	{
		if(response)
		{
			new otherid, id = pData[playerid][pInWs], eid = pData[playerid][pMenuType];
			if(!strcmp(inputtext, "-", true))
			{
				SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully removed %s from Workshop", wsEmploy[id][(eid - 1)]);
				format(wsEmploy[id][(eid - 1)], MAX_PLAYER_NAME, "-");
				Workshop_Save(id);
				return 1;
			}

			if(sscanf(inputtext,"u", otherid))
				return Error(playerid, "You must put Player ID/Name");

			if(!IsWorkshopOwner(playerid, id))
				return Error(playerid, "Only Workshop Owner who can use this");

			if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
				return Error(playerid, "Player itu Disconnect or not near you.");

			if(otherid == playerid)
				return Error(playerid, "You can't set to yourself as owner.");

			if(eid == 0)
			{
				new str[128];
				pData[playerid][pTransferWS] = otherid;
				format(str, sizeof str,"Are you sure want to transfer ownership to %s?", ReturnName(otherid));
				ShowPlayerDialog(playerid, WS_SETOWNERCONFIRM, DIALOG_STYLE_MSGBOX, "Transfer Ownership", str,"Confirm","Cancel");
			}
			else if(eid > 0 && eid < 4)
			{
				format(wsEmploy[id][(eid - 1)], MAX_PLAYER_NAME, pData[otherid][pName]);
				SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully add %s to Workshop", pData[otherid][pName]);
				SendClientMessageEx(otherid, ARWIN, "WORKSHOP: {ffffff}You've been hired in Workshop %s by %s", wsData[id][wName], pData[playerid][pName]);
				Workshop_Save(id);
			}
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_SETOWNERCONFIRM)
	{
		if(!response) 
			pData[playerid][pTransferWS] = INVALID_PLAYER_ID;

		new otherid = pData[playerid][pTransferWS], id = pData[playerid][pInWs];
		if(response)
		{
			if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
				return Error(playerid, "Player itu Disconnect or not near you.");

			SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully transfered %s Workshop to %s",wsData[id][wName], pData[otherid][pName]);
			SendClientMessageEx(otherid, ARWIN, "WORKSHOP: {ffffff}You've been transfered to owner in %s Workshop by %s", wsData[id][wName], pData[playerid][pName]);
			format(wsData[id][wOwner], MAX_PLAYER_NAME, pData[otherid][pName]);
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_COMPONENT)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Withdraw", wsData[id][wComp]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Deposit", wsData[id][wComp]);
				}
			}
			ShowPlayerDialog(playerid, WS_COMPONENT2, DIALOG_STYLE_INPUT, "Component Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == WS_COMPONENT2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Minimum amount is 1");

				if(wsData[id][wComp] < amount) return Error(playerid, "Not Enough Workshop Component");

				if((pData[playerid][pComponent] + amount) >= 701)
					return Error(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] += amount;
				wsData[id][wComp] -= amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully withdraw %d Component from Workshop", amount);
			}
			else if(pData[playerid][pMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Minimum amount is 1");

				if(pData[playerid][pComponent] < amount) return Error(playerid, "Not Enough Component");

				if((wsData[id][wComp] + amount) >= MAX_WORKSHOP_INT)
					return Error(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] -= amount;
				wsData[id][wComp] += amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully deposit %d Component to Workshop", amount);
			}
		}
	}
	if(dialogid == WS_MATERIAL)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Withdraw", wsData[id][wMat]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Deposit", wsData[id][wMat]);
				}
			}
			ShowPlayerDialog(playerid, WS_MATERIAL2, DIALOG_STYLE_INPUT, "Material Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == WS_MATERIAL2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Minimum amount is 1");

				if(wsData[id][wMat] < amount) return Error(playerid, "Not Enough Workshop Material");

				if((pData[playerid][pMaterial] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] += amount;
				wsData[id][wMat] -= amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully withdraw %d Material from Workshop", amount);
			}
			else if(pData[playerid][pMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Minimum amount is 1");

				if(pData[playerid][pMaterial] < amount) return Error(playerid, "Not Enough Material");

				if((wsData[id][wMat] + amount) >= MAX_WORKSHOP_INT)
					return Error(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] -= amount;
				wsData[id][wMat] += amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully deposit %d Material to Workshop", amount);
			}
		}
	}
	if(dialogid == WS_MONEY)
	{
		if(response)
		{
			new str[264], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					if(!IsWorkshopOwner(playerid, id))
						return Error(playerid, "Only Workshop Owner who can use this");

					format(str, sizeof str, "Current Money:\n{7fff00}%s\n\n{ffffff}Input Amount to Withdraw", FormatMoney(wsData[id][wMoney]));
					ShowPlayerDialog(playerid, WS_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Workshop Money",str,"Withdraw","Cancel");
				}
				case 1:
				{
					format(str, sizeof str, "Current Money:\n{7fff00}%s\n\n{ffffff}Input Amount to Deposit", FormatMoney(wsData[id][wMoney]));
					ShowPlayerDialog(playerid, WS_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Workshop Money",str,"Deposit","Cancel");
				}
			}
		}
	}
	if(dialogid == WS_WITHDRAWMONEY)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];

			if(amount < 1)
				return Error(playerid, "Minimum amount is $1");

			if(wsData[id][wMoney] < amount)
				return Error(playerid, "Not Enough Workshop Money");

			GivePlayerMoneyEx(playerid, amount);
			wsData[id][wMoney] -= amount;
			Workshop_Save(id);
		}
	}
	if(dialogid == WS_DEPOSITMONEY)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			
			if(amount < 1)
				return Error(playerid, "Minimum amount is $1");

			if(pData[playerid][pMoney] < amount)
				return Error(playerid, "Not Enough Money");

			GivePlayerMoneyEx(playerid, -amount);
			wsData[id][wMoney] += amount;
			Workshop_Save(id);
		}
	}
	if(dialogid == DIALOG_GARKOT)
	{
		if(response)
		{
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");
			new id = -1;
			id = GetClosestParks(playerid);
			
			if(id > -1)
			{
				if(CountParkedVeh(id) >= 40)
					return Error(playerid, "Garasi Kota sudah memenuhi Kapasitas!");

				new carid = -1,
					found = 0;

				if((carid = Vehicle_Nearest2(playerid)) != -1)
				{

					GetVehiclePos(pvData[carid][cVeh], pvData[carid][cPosX], pvData[carid][cPosY], pvData[carid][cPosZ]);
					GetVehicleZAngle(pvData[carid][cVeh], pvData[carid][cPosA]);
					GetVehicleHealth(pvData[carid][cVeh], pvData[carid][cHealth]);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					InfoTD_MSG(playerid, 4000, "Vehicle ~r~Despawned");
					RemovePlayerFromVehicle(playerid);
					pvData[carid][cPark] = id;					
					SetPlayerArmedWeapon(playerid, 0);
					found++;
					if(IsValidVehicle(pvData[carid][cVeh]))
					{
						DestroyVehicle(pvData[carid][cVeh]);
						pvData[carid][cVeh] = INVALID_VEHICLE_ID;
					}
				}
				if(!found)
					return Error(playerid, "Kendaraan ini tidak dapat di Park!");
			}
			return 1;
		}
		else
		{
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be not in Vehicle");
			foreach(new i : Parks)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.3, ppData[i][parkX], ppData[i][parkY], ppData[i][parkZ]))
				{
					pData[playerid][pPark] = i;
					if(GetAnyVehiclePark(i) <= 0) return Error(playerid, "Tidak ada Kendaraan yang diparkirkan disini.");
					new id, count = GetAnyVehiclePark(i), location[4080], lstr[596];

					strcat(location,"No\tVehicle\tPlate\tOwner\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnAnyVehiclePark(itt, i);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", itt, GetVehicleModelName(pvData[id][cModel]), pvData[id][cPlate], GetVehicleOwnerName(id));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", itt, GetVehicleModelName(pvData[id][cModel]), pvData[id][cPlate], GetVehicleOwnerName(id));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_PICKUPVEH, DIALOG_STYLE_TABLIST_HEADERS,"Parked Vehicle",location,"Pickup","Cancel");
				}
			}
			return 1;
		}
	}
	//ACTOR SYSTEM
	if(dialogid == DIALOG_ACTORANIM)
	{
	    if(!response) return -1;
        new id = GetPVarInt(playerid, "aPlayAnim");
	    if(response)
	    {
	        if(listitem == 0)
	        {
				ApplyActorAnimation(id,"ped","SEAT_down",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 1;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 1)
	        {
				ApplyActorAnimation(id,"ped","Idlestance_fat",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 2;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 2)
	        {
				ApplyActorAnimation(id,"ped","Idlestance_old",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 3;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 3)
	        {
				ApplyActorAnimation(id,"POOL","POOL_Idle_Stance",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 4;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 4)
	        {
				ApplyActorAnimation(id,"ped","woman_idlestance",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 5;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 5)
	        {
				ApplyActorAnimation(id,"ped","IDLE_stance",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 6;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 6)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_in",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 7;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 7)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_loop",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 8;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 8)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_nod",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 9;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 9)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_out",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 10;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 10)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_shake",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 11;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 11)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_in",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 12;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 12)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_loop",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 13;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 13)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_nod",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 14;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 14)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_out",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 15;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 15)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_shake",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 16;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 16)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_think",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 17;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 17)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_watch",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 18;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 18)
	        {
				ApplyActorAnimation(id,"GANGS","leanIDLE",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 19;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 19)
	        {
				ApplyActorAnimation(id,"MISC","Plyrlean_loop",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 20;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 20)
	        {
				ApplyActorAnimation(id,"KNIFE", "KILL_Knife_Ped_Die",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 21;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 21)
	        {
				ApplyActorAnimation(id,"PED", "KO_shot_face",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 22;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 22)
	        {
				ApplyActorAnimation(id,"PED", "KO_shot_stom",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 23;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 23)
	        {
				ApplyActorAnimation(id,"PED", "BIKE_fallR",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 24;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 24)
	        {
				ApplyActorAnimation(id,"PED", "BIKE_fall_off",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 25;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 25)
	        {
				ApplyActorAnimation(id,"SWAT","gnstwall_injurd",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 26;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 26)
	        {
				ApplyActorAnimation(id,"SWEET","Sweet_injuredloop",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 27;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
		}
	}
	//Vending System
	if(dialogid == DIALOG_VENDING_BUYPROD)
	{
		static
        vid = -1,
        price;

		if((vid = pData[playerid][pInVending]) != -1 && response)
		{
			price = VendingData[vid][vendingItemPrice][listitem];

			if(GetPlayerMoney(playerid) < price)
				return Error(playerid, "Not enough money!");

			if(VendingData[vid][vendingStock] < 1)
				return Error(playerid, "This vending is out of stock product.");
				
			
			switch(listitem)
			{
				case 0:
				{
					GivePlayerMoneyEx(playerid, -price);
					/*SetPlayerHealthEx(playerid, health+30);*/
					pData[playerid][pHunger] += 16;
					Vend(playerid, "{FFFFFF}You have purchased PotaBee for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;						
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
				case 1:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pHunger] += 26;
					Vend(playerid, "{FFFFFF}You have purchased Cheetos for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;			
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
				case 2:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pHunger] += 38;
				    Vend(playerid, "{FFFFFF}You have purchased Sprunk for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
                case 3:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pEnergy] += 18;
				    Vend(playerid, "{FFFFFF}You have purchased Cofee for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
			}		
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_MANAGE)
	{
		new vid = pData[playerid][pInVending];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new string[258];
					format(string, sizeof(string), "Vending ID: %d\nVending Name : %s\nVending Location: %s\nVending Vault: %s",
					vid, VendingData[vid][vendingName], GetLocation(VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]), FormatMoney(VendingData[vid][vendingMoney]));

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Vending Information", string, "Cancel", "");
				}
				case 1:
				{
					new string[218];
					format(string, sizeof(string), "Tulis Nama Vending baru yang anda inginkan : ( Nama Vending Lama %s )", VendingData[vid][vendingName]);
					ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT, "Vending Change Name", string, "Select", "Cancel");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Select","Cancel");
				}
				case 3:
				{
					VendingProductMenu(playerid, vid);
				}
				case 4:
				{
					if(VendingData[vid][vendingStock] > 100)
						return Error(playerid, "Vending ini masih memiliki cukup produck.");
					if(VendingData[vid][vendingMoney] < 1000)
						return Error(playerid, "Setidaknya anda mempunyai uang dalamam vending anda senilai $1000 untuk merestock product.");
					VendingData[vid][vendingRestock] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock product kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];

			if(!PlayerOwnVending(playerid, bid)) return Error(playerid, "You don't own this Vending Machine.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Vending tidak di perbolehkan kosong!\n\n"WHITE_E"Nama Vending sebelumnya: %s\n\nMasukkan nama Vending yang kamu inginkan\nMaksimal 32 karakter untuk nama Vending", VendingData[bid][vendingName]);
				ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT,"Vending Change Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Vending harus 5 sampai 32 kata.\n\n"WHITE_E"Nama Vending sebelumnya: %s\n\nMasukkan nama Vending yang kamu inginkan\nMaksimal 32 karakter untuk nama Vending", VendingData[bid][vendingName]);
				ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT,"Vending Change Name", mstr,"Done","Back");
				return 1;
			}
			format(VendingData[bid][vendingName], 32, ColouredText(inputtext));

			Vending_RefreshText(bid);
			Vending_Save(bid);

			Vend(playerid, "Vending name set to: \"%s\".", VendingData[bid][vendingName]);
		}
		else return callcmd::vendingmanage(playerid, "\0");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_VAULT)
	{
		new vid = pData[playerid][pInVending];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam Vending ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, DIALOG_VENDING_DEPOSIT, DIALOG_STYLE_INPUT, "Vending Deposit Input", mstr, "Deposit", "Cancel");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Vending Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam Vending ini", FormatMoney(VendingData[vid][vendingMoney]));
					ShowPlayerDialog(playerid, DIALOG_VENDING_WITHDRAW, DIALOG_STYLE_INPUT,"Vending Withdraw Input", mstr, "Withdraw","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_VENDING_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > VendingData[bid][vendingMoney])
				return Error(playerid, "Invalid amount specified!");

			VendingData[bid][vendingMoney] -= amount;
			Vending_Save(bid);

			GivePlayerMoneyEx(playerid, amount);

			Info(playerid, "You have withdrawn %s from the Vending vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Next","Back");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return Error(playerid, "Invalid amount specified!");

			VendingData[bid][vendingMoney] += amount;
			Vending_Save(bid);

			GivePlayerMoneyEx(playerid, -amount);
			
			Info(playerid, "You have deposit %s into the Vending vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Next","Back");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_EDITPROD)
	{
		new vid = pData[playerid][pInVending];
		if(PlayerOwnVending(playerid, vid))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingVendingItem], item, 40 char);

				pData[playerid][pVendingProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
			}
			else
				return callcmd::vendingmanage(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_PRICESET)
	{
		static
        item[40];
		new vid = pData[playerid][pInVending];
		if(PlayerOwnVending(playerid, vid))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingVendingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 5000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5,000):", item);
					ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
					return 1;
				}
				VendingData[vid][vendingItemPrice][pData[playerid][pVendingProductModify]] = strval(inputtext);
				Vending_Save(vid);

				Vend(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				VendingProductMenu(playerid, vid);
			}
			else
			{
				VendingProductMenu(playerid, vid);
			}
		}
	}
	if(dialogid == DIALOG_MY_VENDING)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVending", ReturnPlayerVendingID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_VENDING_INFO, DIALOG_STYLE_LIST, "{0000FF}My Vending", "Show Information\nTrack Vending", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_INFO)
	{
		if(!response) return 1;
		new ved = GetPVarInt(playerid, "ClickedVending");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new type[128];
				type = "Food & Drink";
				format(line9, sizeof(line9), "Vending ID: %d\nVending Owner: %s\nVending Address: %s\nVending Price: %s\nVending Type: %s",
				ved, VendingData[ved][vendingOwner], GetLocation(VendingData[ved][vendingX], VendingData[ved][vendingY], VendingData[ved][vendingZ]), FormatMoney(VendingData[ved][vendingPrice]), type);
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vending Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackVending] = 1;
				SetPlayerRaceCheckpoint(playerid,1, VendingData[ved][vendingX], VendingData[ved][vendingY], VendingData[ved][vendingZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan mesin vending anda!");
			}
		}
		return 1;
	}
	/*if(dialogid == DIALOG_VENDING_RESTOCK)
	{
		if(response)
		{
			new id = ReturnRestockVendingID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);
			if(VendingData[id][vendingMoney] < 1000)
				return Error(playerid, "Maaf, Vending ini kehabisan uang product.");
			
			if(pData[playerid][pRestock] == 1)
				return Error(playerid, "Anda sudah sedang melakukan restock!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pRestock] = id;
			VendingData[id][vendingRestock] = 0;
			
			new line9[900];
			new type[128];
			if(VendingData[id][vendingType] == 1)
			{
				type = "Froozen Snack";

			}
			else if(VendingData[id][vendingType] == 2)
			{
				type = "Soda";
			}
			else
			{
				type = "Unknown";
			}
			format(line9, sizeof(line9), "Silahkan anda membeli stock Vending di gudang!\n\nVending ID: %d\nVending Owner: %s\nVending Name: %s\nVending Type: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke vending mission anda!",
			id, VendingData[id][vendingOwner], VendingData[id][vendingName], type);
			SetPlayerRaceCheckpoint(playerid,1, -279.67, -2148.42, 28.54, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Restock Info", line9, "Close","");
		}
	}*/
	if(dialogid == DIALOG_MENU_TRUCKER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetRestockBisnis() <= 0) return Error(playerid, "Mission sedang kosong.");
					new id, count = GetRestockBisnis(), mission[400], type[32], lstr[512];
					
					strcat(mission,"No\tBusID\tBusType\tBusName\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockBisnisID(itt);
						if(bData[id][bType] == 1)
						{
							type= "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type= "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type= "Clothes";
						}
						else if(bData[id][bType] == 4)
						{
							type= "Ammunation";
						}
						else
						{
							type= "Unknow";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%d\t%s\t%s\n", itt, id, type, bData[id][bName]);	
						}
						else format(lstr,sizeof(lstr), "%d\t%d\t%s\t%s\n", itt, id, type, bData[id][bName]);
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK, DIALOG_STYLE_TABLIST_HEADERS,"Mission",mission,"Start","Cancel");
				}
				case 1:
				{
					if(GetRestockGStation() <= 0) return Error(playerid, "Hauling sedang kosong.");
					new id, count = GetRestockGStation(), hauling[400], lstr[512];
					
					strcat(hauling,"No\tGas Station ID\tLocation\n",sizeof(hauling));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockGStationID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%d\t%s\n", itt, id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));	
						}
						else format(lstr,sizeof(lstr), "%d\t%d\t%s\n", itt, id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
						strcat(hauling,lstr,sizeof(hauling));
					}
					ShowPlayerDialog(playerid, DIALOG_HAULING, DIALOG_STYLE_TABLIST_HEADERS,"Hauling",hauling,"Start","Cancel");
				}
				case 2:
				{
					if(GetRestockVending() <= 0) return Error(playerid, "Misi Restock sedang kosong.");
					new id, count = GetRestockVending(), vending[400], lstr[512];
					
					strcat(vending,"No\tName Vending (ID)\tLocation\n",sizeof(vending));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockVendingID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s (%d)\t%s\n", itt, VendingData[id][vendingName], id, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));	
						}
						else format(lstr,sizeof(lstr), "%d\t%s (%d)\t%s\n", itt, VendingData[id][vendingName], id, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						strcat(vending,lstr,sizeof(vending));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_VENDING, DIALOG_STYLE_TABLIST_HEADERS, "Vending", vending, "Start", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_SHIPMENTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{

				}
				case 1:
				{
					if(GetAnyVendings() <= 0) return Error(playerid, "Tidak ada Vendings di kota.");
					new id, count = GetAnyVendings(), location[4096], lstr[596];
					strcat(location,"No\tLocation\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnVendingsID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]), GetPlayerDistanceFromPoint(playerid, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]), GetPlayerDistanceFromPoint(playerid, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_SHIPMENTS_VENDING, DIALOG_STYLE_TABLIST_HEADERS,"Vendings List",location,"Select","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_SHIPMENTS_VENDING)
	{
		if(response)
		{
			new id = ReturnVendingsID((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Vendings checkpoint targeted! (%s)", GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
		}
	}
	if(dialogid == DIALOG_RESTOCK_VENDING)
	{
		if(response)
		{
			new id = ReturnRestockVendingID((listitem + 1));
			if(VendingData[id][vendingMoney] < 1000)
				return Error(playerid, "Maaf, Vending ini kehabisan uang product.");
			
			if(pData[playerid][pVendingRestock] == 1)
				return Error(playerid, "Anda sudah sedang melakukan restock!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetVehicleModel(GetPlayerVehicleID(playerid)) != 586) return Error(playerid, "Kamu harus mengendarai wayfarer.");
				
			pData[playerid][pVendingRestock] = id;
			VendingData[id][vendingRestock] = 0;
			
			new line9[900];
			
			format(line9, sizeof(line9), "Silahkan anda membeli stock Vending di gudang!\n\nVending ID: %d\nVending Owner: %s\nVending Name: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke vending mission anda!",
			id, VendingData[id][vendingOwner], VendingData[id][vendingName]);
			SetPlayerRaceCheckpoint(playerid, 1, -56.39, -223.73, 5.42, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Restock Info", line9, "Close","");
		}	
	}
	//Spawn 4 Titik FiveM
	if(dialogid == DIALOG_SPAWN_1)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pSpawnList] = 1;
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_MALE, "Choose Your Skin", SpawnSkinMale, sizeof(SpawnSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_FEMALE, "Choose Your Skin", SpawnSkinFemale, sizeof(SpawnSkinFemale));
					}
				}
				case 1:
				{
					pData[playerid][pSpawnList] = 2;
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_MALE, "Choose Your Skin", SpawnSkinMale, sizeof(SpawnSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_FEMALE, "Choose Your Skin", SpawnSkinFemale, sizeof(SpawnSkinFemale));
					}					
				}
				case 2:
				{
					pData[playerid][pSpawnList] = 3;
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_MALE, "Choose Your Skin", SpawnSkinMale, sizeof(SpawnSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_FEMALE, "Choose Your Skin", SpawnSkinFemale, sizeof(SpawnSkinFemale));
					}					
				}
			}
		}
	}
	//Verify Code Discord New System UCP
	if(dialogid == DIALOG_VERIFYCODE)
	{
		if(response)
		{
			new str[200];
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT", pData[playerid][pUCP]);
				return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Cancel");
			}
			if(!IsNumeric(inputtext))
			{
				format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT\n\n{FF0000}PIN hanya berisi 6 Digit angka bukan huruf", pData[playerid][pUCP]);
				return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Cancel");	
			}
			if(strval(inputtext) == pData[playerid][pVerifyCode])
			{
				new lstring[512];
				format(lstring, sizeof lstring, "{ffffff}Welcome to {15D4ED}"SERVER_NAME"\n{ffffff}UCP: {15D4ED}%s\n{ffffff}Password: \nSilahkan buat password baru kamu!:", pData[playerid][pUCP]);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Great", lstring, "Register", "Quit");	
				return 1;
			}

			format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT\n\n{FF0000}PIN salah!", pData[playerid][pUCP]);
			return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Cancel");	
		}
		else 
		{
			Kick(playerid);
		}
	}
	//Last Phone System
	if(dialogid == DIALOG_TWITTER)
	{
		if(response)
		{
			switch(listitem)
			{
				/*case 0:
				{
					if(pData[playerid][pTwitterStatus] > 0)
					{
						Error(playerid, "Notifikasi twitter anda belum kamu hidupkan");
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
					}
					else
					{
						new str[200];
						format(str, sizeof (str), "Name Twitter: %s\nApa yang ingin kamu post?", pData[playerid][pTwittername]);
						ShowPlayerDialog(playerid, DIALOG_TWITTERPOST, DIALOG_STYLE_INPUT, "Twitter Post", str, "Post", "Back");
					}
				}
				case 1:
				{
					if(pData[playerid][pTwitterStatus] > 0)
					{
						Error(playerid, "Notifikasi twitter anda belum kamu hidupkan");
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
					}
					else
					{
						new str[200];
						format(str, sizeof (str), "Current Name: %s\nIsi kotak di bawah ini untuk menganti nama Twittermu.", pData[playerid][pTwittername]);
						ShowPlayerDialog(playerid, DIALOG_TWITTERNAME, DIALOG_STYLE_INPUT, "Twitter Post", str, "Change", "Back");
					}
				}
				case 2:
				{
					if(pData[playerid][pTwitterStatus] == 1)
					{
						pData[playerid][pTwitterStatus] = 0;
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
					}
					else
					{
						pData[playerid][pTwitterStatus] = 1;
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
					}
				}*/
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Announcement", "> Sementara Twitter Maintenance", "Close", "");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Announcement", "> Sementara Twitter Maintenance", "Close", "");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Announcement", "> Sementara Twitter Maintenance", "Close", "");
				}
			}
		}
	}
	if(dialogid == DIALOG_TWITTERPOST)
	{
		if(response)
		{
			if(pData[playerid][pTwitterPostCooldown] > 0)
			{
				Error(playerid, "Twitter masih cooldown %d detik", pData[playerid][pTwitterPostCooldown]);
				
				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
			}
			else
			{
				// Decide about multi-line msgs
				strcpy(tweet, inputtext);
				new i = -1;
				new line[512];
				new payout = strlen(tweet) * 7;
				new kuotamb = pData[playerid][pKuota]/1000;
				if(pData[playerid][pKuota] < payout)
					return Error(playerid, "Kuota anda sisa %dmb untuk mengirim %d Character", kuotamb, strlen(tweet));

				if(strlen(tweet) > 70)
				{
					i = strfind(tweet, " ", false, 60);
					if(i > 80 || i == -1) i = 70;

					// store the second line text
					line = " ";
					strcat(line, tweet[i]);

					// delete the rest from msg
					tweet[i] = EOS;
				}
				

				foreach(new ii : Player)
				{
					if(pData[ii][pTwitterStatus] == 0)
					{
						pData[playerid][pTwitterPostCooldown] = 40;
						SendClientMessageEx(ii, COLOR_YELLOW, "{1e90ff}[TWITTER] {7fffd4}@%s:{ffffff} %s", pData[playerid][pTwittername], tweet);
					}
				}
				
				new dc[128];
				format(dc, sizeof(dc),  "```\n[TWITTER] @%s: %s```", pData[playerid][pTwittername], tweet);
				SendDiscordMessage(4, dc);
				return 1;
			}	
		}
		else 
		{
			new notif[20];
			if(pData[playerid][pTwitterStatus] == 1)
			{
				notif = "{ff0000}OFF";
			}
			else
			{
				notif = "{3BBD44}ON";
			}

			new string[100];
			format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
			ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
		}
	}
	if(dialogid == DIALOG_TWITTERNAME)
	{
		if(response)
		{
			if(pData[playerid][pTwitterNameCooldown] > 0)
			{
				Error(playerid, "Twitter changename masih cooldown %d detik", pData[playerid][pTwitterNameCooldown]);
				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
			}
			else
			{
				new query[512];
				format(pData[playerid][pTwittername], 64, inputtext);
				Info(playerid, "Kamu telah mengubah nama Twitter kamu menjadi {0099ff}%s", inputtext);
				pData[playerid][pTwitterNameCooldown] = 600;

				mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET twittername = '%s' WHERE reg_id = %i", inputtext, pData[playerid][pID]);
				mysql_tquery(g_SQL, query);

				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
			}	
		}
		else
		{
			new notif[20];
			if(pData[playerid][pTwitterStatus] == 1)
			{
				notif = "{ff0000}OFF";
			}
			else
			{
				notif = "{3BBD44}ON";
			}

			new string[100];
			format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
			ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
		}
	}
	if(dialogid == DIALOG_TOGGLEPHONE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pPhoneStatus] = 1;
					Servers(playerid, "Berhasil menyalakan Handphone");
					return 0;
				}
				case 1:
				{
					pData[playerid][pPhoneStatus] = 0;
					Servers(playerid, "Berhasil mematikan Handphone");
					return 0;
				}
			}
		}
	}
	if(dialogid == DIALOG_IBANK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[200];
					format(str, sizeof(str), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"I-Bank", str, "Close", "");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"I-Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
				}
				case 2:
				{
					DisplayPaycheck(playerid);
				}
			}
		}
	}
	//New Phone System
	if(dialogid == DIALOG_PHONE_CONTACT)
	{
		if (response)
		{
		    if (!listitem) 
			{
		        ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "New Contact", "Please enter the name of the contact below:", "Submit", "Back");
		    }
		    else 
			{
		    	pData[playerid][pContact] = ListedContacts[playerid][listitem - 1];
		        ShowPlayerDialog(playerid, DIALOG_PHONE_INFOCONTACT, DIALOG_STYLE_LIST, "Contact Info", "Call Contact\nDelete Contact", "Select", "Back");
		    }
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		for (new i = 0; i != MAX_CONTACTS; i ++) 
		{
		    ListedContacts[playerid][i] = -1;
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_ADDCONTACT)
	{
		if (response)
		{
		    static
		        name[32],
		        str[128],
				string[128];

			strunpack(name, pData[playerid][pEditingItem]);
			format(str, sizeof(str), "Contact Name: %s\n\nPlease enter the phone number for this contact:", name);
		    if (isnull(inputtext) || !IsNumeric(inputtext))
		    	return ShowPlayerDialog(playerid, DIALOG_PHONE_ADDCONTACT, DIALOG_STYLE_INPUT, "Contact Number", str, "Submit", "Back");

			for (new i = 0; i != MAX_CONTACTS; i ++)
			{
				if (!ContactData[playerid][i][contactExists])
				{
	            	ContactData[playerid][i][contactExists] = true;
	            	ContactData[playerid][i][contactNumber] = strval(inputtext);

					format(ContactData[playerid][i][contactName], 32, name);

					mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%d', '%s', '%d')", pData[playerid][pID], name, ContactData[playerid][i][contactNumber]);
					mysql_tquery(g_SQL, string, "OnContactAdd", "dd", playerid, i);
					Info(playerid, "You have added \"%s\" to your contacts.", name);
	                return 1;
				}
		    }
		    Error(playerid, "There is no room left for anymore contacts.");
		}
		else {
			ShowContacts(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_NEWCONTACT)
	{
		if (response)
		{
			new str[128];

		    if (isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "New Contact", "Error: Please enter a contact name.\n\nPlease enter the name of the contact below:", "Submit", "Back");

		    if (strlen(inputtext) > 32)
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "New Contact", "Error: The contact name can't exceed 32 characters.\n\nPlease enter the name of the contact below:", "Submit", "Back");

			strpack(pData[playerid][pEditingItem], inputtext, 32);
			format(str, sizeof(str), "Contact Name: %s\n\nPlease enter the phone number for this contact:", inputtext);
		    ShowPlayerDialog(playerid, DIALOG_PHONE_ADDCONTACT, DIALOG_STYLE_INPUT, "Contact Number", str, "Submit", "Back");
		}
		else 
		{
			ShowContacts(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_INFOCONTACT)
	{
		if (response)
		{
		    new
				id = pData[playerid][pContact],
				string[72];

			switch (listitem)
			{
			    case 0:
			    {
			    	format(string, 16, "%d", ContactData[playerid][id][contactNumber]);
			    	callcmd::call(playerid, string);
			    }
			    case 1:
			    {
			        mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `contacts` WHERE `ID` = '%d' AND `contactID` = '%d'", pData[playerid][pID], ContactData[playerid][id][contactID]);
			        mysql_tquery(g_SQL, string);

			        Info(playerid, "You have deleted \"%s\" from your contacts.", ContactData[playerid][id][contactName]);

			        ContactData[playerid][id][contactExists] = false;
			        ContactData[playerid][id][contactNumber] = 0;
			        ContactData[playerid][id][contactID] = 0;

			        ShowContacts(playerid);
			    }
			}
		}
		else {
		    ShowContacts(playerid);
		}
		return 1;
	}
	//
	if(dialogid == DIALOG_PHONE_SENDSMS)
	{
		if (response)
		{
		    new ph = strval(inputtext);

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Back");

		    foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == ph)
				{
		        	if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
		            	return ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Error: That number is not online right now.\n\nPlease enter the number that you wish to send a text message to:", "Dial", "Back");

		            ShowPlayerDialog(playerid, DIALOG_PHONE_TEXTSMS, DIALOG_STYLE_INPUT, "Text Message", "Please enter the message to send", "Send", "Back");
		        	pData[playerid][pContact] = ph;
		        }
		    }
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_TEXTSMS)
	{
		if (response)
		{
			if (isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_PHONE_TEXTSMS, DIALOG_STYLE_INPUT, "Text Message", "Error: Please enter a message to send.", "Send", "Back");

			new targetid = pData[playerid][pContact];
			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == targetid)
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", targetid, inputtext);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], inputtext);
					Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];

					pData[playerid][pPhoneCredit] -= 1;
				}
			}
		}
		else {
	        ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Submit", "Back");
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_DIALUMBER)
	{
		if (response)
		{
		    new
		        string[16];

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Back");

	        format(string, 16, "%d", strval(inputtext));
			callcmd::call(playerid, string);
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_MYVEH)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVeh", ReturnPlayerVehID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_MYVEH_INFO, DIALOG_STYLE_LIST, "Vehicle Info", "Information Vehicle\nTrack Vehicle\nUnstuck Vehicle", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DIALOG_MYVEH_INFO)
	{
		if(!response) return 1;
		new vid = GetPVarInt(playerid, "ClickedVeh");
		switch(listitem)
		{
			case 0:
			{
				
				if(IsValidVehicle(pvData[vid][cVeh]))
				{
					new line9[900];
				
					format(line9, sizeof(line9), "{ffffff}[{7348EB}INFO VEHICLE{ffffff}]:\nVehicle ID: {ffff00}%d\n{ffffff}Model: {ffff00}%s\n{ffffff}Plate: {ffff00}%s{ffffff}\n\n{ffffff}[{7348EB}DATA VEHICLE{ffffff}]:\nInsurance: {ffff00}%d{ffffff}",
					pvData[vid][cVeh], GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cPlate], pvData[vid][cInsu]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Info", line9, "Close","");
				}
				else
				{
					new line9[900];
				
					format(line9, sizeof(line9), "{ffffff}[{7348EB}INFO VEHICLE{ffffff}]:\nVehicle UID: {ffff00}%d\n{ffffff}Model: {ffff00}%s\n{ffffff}Plate: {ffff00}%s{ffffff}\n\n{ffffff}[{7348EB}DATA VEHICLE{ffffff}]:\nInsurance: {ffff00}%d{ffffff}",
					pvData[vid][cID], GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cPlate], pvData[vid][cInsu]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Info", line9, "Close","");
				}
			}
			case 1:
			{
				if(IsValidVehicle(pvData[vid][cVeh]))
				{
					new palid = pvData[vid][cVeh];
					new
			        	Float:x,
			        	Float:y,
			        	Float:z;

					pData[playerid][pTrackCar] = 1;
					GetVehiclePos(palid, x, y, z);
					SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Ikuti checkpoint untuk menemukan kendaraan anda!");
				}
				else if(pvData[vid][cPark] > 0)
				{
					SetPlayerRaceCheckpoint(playerid, 1, pvData[vid][cPosX], pvData[vid][cPosY], pvData[vid][cPosZ], 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Ikuti checkpoint untuk menemukan kendaraan yang ada di dalam garkot!");
				}
				else if(pvData[vid][cClaim] != 0)
				{
					Info(playerid, "Kendaraan kamu di kantor insuransi!");
				}
				else if(pvData[vid][cStolen] != 0)
				{
					Info(playerid, "Kendaraan kamu di rusak kamu bisa memperbaikinya di kantor insuransi!");
				}
				else
					return Error(playerid, "Kendaraanmu belum di spawn!");
			}
			case 2:
			{
				static
				carid = -1;

				if((carid = Vehicle_Nearest(playerid)) != -1)
				{
					if(Vehicle_IsOwner(playerid, carid))
					{
						if(IsValidVehicle(pvData[vid][cVeh]))
						{
							Vehicle_Save(vid);
							//SetTimerEx("DestroyVehicle", 2000, false, "d", vid);
							DestroyVehicle(pvData[vid][cVeh]);
							pvData[vid][cVeh] = INVALID_VEHICLE_ID;
						}	
						SetTimerEx("OnPlayerVehicleRespawn", 3000, false, "d", vid);
					}
				}	
				else Error(playerid, "Kamu tidak berada didekat Kendaraan tersebut.");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_FAMILY_INTERIOR)
	{
	    if(response)
	    {
	        SetPlayerPosition(playerid, famInteriorArray[listitem][intX], famInteriorArray[listitem][intY], famInteriorArray[listitem][intZ], famInteriorArray[listitem][intA]);
			SetPlayerInterior(playerid, famInteriorArray[listitem][intID]);
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid));
	        InfoTD_MSG(playerid, 4000, "~g~Teleport");
	    }
	}
	if(dialogid == DIALOG_SPAREPART)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new harga = 1000;
					if(pData[playerid][pMoney] < harga)
					{
						return Error(playerid, "Uang anda tidak cukup untuk membeli Sparepart baru!");
					}
					
					GivePlayerMoneyEx(playerid, -harga);
					pData[playerid][pSparepart] += 1;
					Info(playerid, "Kamu berhasil membeli Sparepart baru seharga %s", FormatMoney(harga));

				}
				case 1:
				{
					if(!GetVehicleStolen(playerid)) return Error(playerid, "You don't have any Vehicle.");
					new vid, _tmpstring[128], count = GetVehicleStolen(playerid), CMDSString[512];
					CMDSString = "";
					strcat(CMDSString,"#\tModel\n",sizeof(CMDSString));
					Loop(itt, (count + 1), 1)
					{
						vid = ReturnPlayerVehStolen(playerid, itt);
						
						if(itt == count)
						{
							format(_tmpstring, sizeof(_tmpstring), "{ffffff}%d.\t%s\n", itt, GetVehicleModelName(pvData[vid][cModel]));
						}
						else format(_tmpstring, sizeof(_tmpstring), "{ffffff}%d.\t%s\n", itt, GetVehicleModelName(pvData[vid][cModel]));
						strcat(CMDSString, _tmpstring);
					}
					ShowPlayerDialog(playerid, DIALOG_BUYPARTS, DIALOG_STYLE_TABLIST_HEADERS, "Shop Sparepart", CMDSString, "Select", "Cancel");
				}		
			}
		}
	}
	if(dialogid == DIALOG_BUYPARTS)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVehStolen", ReturnPlayerVehStolen(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_BUYPARTS_DONE, DIALOG_STYLE_LIST, "Shop Sparepart", "Fixing Vehicle", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DIALOG_BUYPARTS_DONE)
	{
		if(!response) return 1;
		new vehid = GetPVarInt(playerid, "ClickedVehStolen");
		switch(listitem)
		{
			case 0:
			{
				if(pData[playerid][pSparepart] < 1)
				{
					return Error(playerid, "Kamu membutuhkan suku cadang kendaraan untuk memperbaiki kendaraan yang rusak ini.");
				}
				
				pData[playerid][pSparepart] -= 1;
				pvData[vehid][cStolen] = 0;

				OnPlayerVehicleRespawn(vehid);
				pvData[vehid][cPosX] = 1290.7111;
				pvData[vehid][cPosY] = -1243.8767;
				pvData[vehid][cPosZ] = 13.3901;
				pvData[vehid][cPosA] = 2.5077;
				SetValidVehicleHealth(pvData[vehid][cVeh], 1500);
				SetVehiclePos(pvData[vehid][cVeh], 1290.7111, -1243.8767, 13.3901);
				SetVehicleZAngle(pvData[vehid][cVeh], 2.5077);
				SetVehicleFuel(pvData[vehid][cVeh], 1000);
				ValidRepairVehicle(pvData[vehid][cVeh]);

				Info(playerid, "Kamu telah menggunakan Sparepart untuk memperbarui kendaraan %s.", GetVehicleModelName(pvData[vehid][cModel]));
			}
		}	
	}
	if(dialogid == VEHICLE_STORAGE)
	{
		new string[200];
        new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                
                if(response)
                {
                    if(listitem == 0) 
                    {
                        Vehicle_WeaponStorage(playerid, vehicleid);
                    }
                    else if(listitem == 1) 
                    {
                        format(string, sizeof(string), "Money\t{3BBD44}%s{ffffff}\n{FF0000}RedMoney\t%s{ffffff}", FormatMoney(vsData[vehicleid][vsMoney]), FormatMoney(vsData[vehicleid][vsRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_MONEY, DIALOG_STYLE_TABLIST, "Money Safe", string, "Select", "Back");
                    }
                    else if(listitem == 2)
                    {
                        format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsMedicine], GetVehicleStorage(vehicleid, LIMIT_MEDICINE), vsData[vehicleid][vsMedkit], GetVehicleStorage(vehicleid, LIMIT_MEDKIT), vsData[vehicleid][vsBandage], GetVehicleStorage(vehicleid, LIMIT_BANDAGE));
                        ShowPlayerDialog(playerid, VEHICLE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Select", "Back");
                    } 
                    else if(listitem == 3)
                    {
                        format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                        ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
                    }
                }
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_WEAPON)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    if(vsData[vehicleid][vsWeapon][listitem] != 0)
                    {
                        GivePlayerWeaponEx(playerid, vsData[vehicleid][vsWeapon][listitem], vsData[vehicleid][vsAmmo][listitem]);

                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(vsData[vehicleid][vsWeapon][listitem]));

                        vsData[vehicleid][vsWeapon][listitem] = 0;
                        vsData[vehicleid][vsAmmo][listitem] = 0;

                        Vehicle_StorageSave(i);
                        Vehicle_WeaponStorage(playerid, vehicleid);
                    }
                    else
                    {
                        new
                            weaponid = GetPlayerWeaponEx(playerid),
                            ammo = GetPlayerAmmoEx(playerid);

                        if(!weaponid)
                            return Error(playerid, "You are not holding any weapon!");

                        /*if(weaponid == 23 && pData[playerid][pTazer])
                            return Error(playerid, "You can't store a tazer into your safe.");

                        if(weaponid == 25 && pData[playerid][pBeanBag])
                            return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

                        ResetWeapon(playerid, weaponid);
                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

                        vsData[vehicleid][vsWeapon][listitem] = weaponid;
                        vsData[vehicleid][vsAmmo][listitem] = ammo;

                        Vehicle_StorageSave(i);
                        Vehicle_WeaponStorage(playerid, vehicleid);
                    }
                }
                else
                {
                     Vehicle_OpenStorage(playerid, vehicleid);
                }
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MONEY)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            ShowPlayerDialog(playerid, VEHICLE_REALMONEY, DIALOG_STYLE_LIST, "Money Storage", "Ambil Money dari penyimpanan\nSimpan Money ke penyimpanan", "Pilih", "Kembali");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_REDMONEY, DIALOG_STYLE_LIST, "Redmoney Storage", "Ambil Redmoney dari penyimpanan\nSimpan Redmoney dari penyimpanan", "Pilih", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}			
	if(dialogid == VEHICLE_REALMONEY)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                    	{
                            new str[200];
                            format(str, sizeof(str), "Money yang tersedia: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda ambil dari penyimpanan:", FormatMoney(vsData[vehicleid][vsMoney]));
                            ShowPlayerDialog(playerid, VEHICLE_REALMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Money Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Money yang anda bawa: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda simpan ke dalam penyimpanan kendaraan:", FormatMoney(pData[playerid][pMoney]));
                            ShowPlayerDialog(playerid, VEHICLE_REALMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Money Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_REALMONEY_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Money yang tersedia: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda ambil dari penyimpanan:", FormatMoney(vsData[vehicleid][vsMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REALMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Money Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMoney])
                    {
                        new str[128];
                        format(str, sizeof(str), "Error: Money tidak mencukupi!.\n\nMoney yang tersedia: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda ambil dari kendaraan:", FormatMoney(vsData[vehicleid][vsMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REALMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Money Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMoney] -= amount;
                    GivePlayerMoneyEx(playerid, amount);

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %s dari penyimpanan rumah.", ReturnName(playerid), FormatMoney(amount));
                }
                else ShowPlayerDialog(playerid, VEHICLE_REALMONEY, DIALOG_STYLE_LIST, "Money Storage", "Ambil Money dari penyimpanan\nSimpan Money ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_REALMONEY_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Money yang anda bawa: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda simpan ke dalam penyimpanan:", FormatMoney(pData[playerid][pMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REALMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Money Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > GetPlayerMoney(playerid))
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Money tidak mencukupi!.\n\nMoney yang anda bawa: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda simpan ke dalam penyimpanan:", FormatMoney(pData[playerid][pMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REALMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Money Storage", str, "Simpan", "Kembali");
                        return 1;
					}
                        
                    vsData[vehicleid][vsMoney] += amount;
                    GivePlayerMoneyEx(playerid, -amount);

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %s ke penyimpanan kendaraan.", ReturnName(playerid), FormatMoney(amount));
                }
                else ShowPlayerDialog(playerid, VEHICLE_REALMONEY, DIALOG_STYLE_LIST, "Money Storage", "Ambil Money dari penyimpanan\nSimpan Money ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//===================================================================================
	if(dialogid == VEHICLE_REDMONEY)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "RedMoney yang tersedia: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda ambil dari penyimpanan:", FormatMoney(vsData[vehicleid][vsRedMoney]));
                            ShowPlayerDialog(playerid, VEHICLE_REDMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "RedMoney yang anda bawa: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda simpan ke dalam penyimpanan kendaraan:", FormatMoney(pData[playerid][pRedMoney]));
                            ShowPlayerDialog(playerid, VEHICLE_REDMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_REDMONEY_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "RedMoney yang tersedia: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda ambil dari penyimpanan:", FormatMoney(vsData[vehicleid][vsRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REDMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsRedMoney])
                    {
                        new str[128];
                        format(str, sizeof(str), "Error: RedMoney tidak mencukupi!.\n\nRedMoney yang tersedia: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda ambil dari kendaraan:", FormatMoney(vsData[vehicleid][vsRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REDMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsRedMoney] -= amount;
                    pData[playerid][pRedMoney] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %s RedMoney dari penyimpanan kendaraan.", ReturnName(playerid), FormatMoney(amount));
                }
                else ShowPlayerDialog(playerid, VEHICLE_REDMONEY, DIALOG_STYLE_LIST, "RedMoney Storage", "Ambil RedMoney dari penyimpanan\nSimpan RedMoney ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_REDMONEY_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "RedMoney yang anda bawa: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda simpan ke dalam penyimpanan:", FormatMoney(pData[playerid][pRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REDMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pRedMoney])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: RedMoney tidak mencukupi!.\n\nRedMoney yang anda bawa: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda simpan ke dalam penyimpanan:", FormatMoney(pData[playerid][pRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REDMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                        
                    vsData[vehicleid][vsRedMoney] += amount;
                    pData[playerid][pRedMoney] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %s RedMoney ke penyimpanan kendaraan.", ReturnName(playerid), FormatMoney(amount));
                }
                else ShowPlayerDialog(playerid, VEHICLE_REDMONEY, DIALOG_STYLE_LIST, "RedMoney Storage", "Ambil RedMoney dari penyimpanan\nSimpan RedMoney ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//===================================================================================
	if(dialogid == VEHICLE_DRUGS)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit dari penyimpanan", "Pilih", "Kembali");
                        }
                        case 2:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage dari penyimpanan", "Pilih", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}			
	if(dialogid == VEHICLE_MEDICINE)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Medicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedicine]);
                            ShowPlayerDialog(playerid, VEHICLE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Medicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMedicine]);
                            ShowPlayerDialog(playerid, VEHICLE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsMedicine], GetVehicleStorage(vehicleid, LIMIT_MEDICINE), vsData[vehicleid][vsMedkit], GetVehicleStorage(vehicleid, LIMIT_MEDKIT), vsData[vehicleid][vsBandage], GetVehicleStorage(vehicleid, LIMIT_BANDAGE));
                    ShowPlayerDialog(playerid, VEHICLE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Select", "Back");
                }
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MEDICINE_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Medicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMedicine])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Medicine tidak mencukupi!{ffffff}.\n\nMedicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMedicine] -= amount;
                    pData[playerid][pMedicine] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d medicine dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MEDICINE_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Medicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMedicine])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Medicine anda tidak mencukupi!{ffffff}.\n\nMedicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MEDICINE) < vsData[vehicleid][vsMedicine] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Medicine!.\n\nMedicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MEDICINE), pData[playerid][pMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMedicine] += amount;
                    pData[playerid][pMedicine] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d medicine ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
        	}    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//=========================================================================================
	if(dialogid == VEHICLE_MEDKIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Medkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedkit]);
                            ShowPlayerDialog(playerid, VEHICLE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Medkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMedkit]);
                            ShowPlayerDialog(playerid, VEHICLE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsMedicine], GetVehicleStorage(vehicleid, LIMIT_MEDICINE), vsData[vehicleid][vsMedkit], GetVehicleStorage(vehicleid, LIMIT_MEDKIT), vsData[vehicleid][vsBandage], GetVehicleStorage(vehicleid, LIMIT_BANDAGE));
                    ShowPlayerDialog(playerid, VEHICLE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Select", "Back");
                }
			}    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MEDKIT_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Medkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMedkit])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Medkit tidak mencukupi!{ffffff}.\n\nMedkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMedkit] -= amount;
                    pData[playerid][pMedkit] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d medkit dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MEDKIT_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Medkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMedkit])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Medkit anda tidak mencukupi!{ffffff}.\n\nMedkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MEDKIT) < vsData[vehicleid][vsMedkit] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Medkit!.\n\nMedkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MEDKIT), pData[playerid][pMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMedkit] += amount;
                    pData[playerid][pMedkit] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d medkit ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//=========================================================================================
	if(dialogid == VEHICLE_BANDAGE)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Bandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsBandage]);
                            ShowPlayerDialog(playerid, VEHICLE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Bandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pBandage]);
                            ShowPlayerDialog(playerid, VEHICLE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsMedicine], GetVehicleStorage(vehicleid, LIMIT_MEDICINE), vsData[vehicleid][vsMedkit], GetVehicleStorage(vehicleid, LIMIT_MEDKIT), vsData[vehicleid][vsBandage], GetVehicleStorage(vehicleid, LIMIT_BANDAGE));
                    ShowPlayerDialog(playerid, VEHICLE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Select", "Back");
                }
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_BANDAGE_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Bandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsBandage])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Bandage tidak mencukupi!{ffffff}.\n\nBandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsBandage] -= amount;
                    pData[playerid][pBandage] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d bandage dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_BANDAGE_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Bandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pBandage])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Bandage anda tidak mencukupi!{ffffff}.\n\nBandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_BANDAGE) < vsData[vehicleid][vsBandage] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Bandage!.\n\nBandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_BANDAGE), pData[playerid][pBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsBandage] += amount;
                    pData[playerid][pBandage] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d bandage ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//===================================================================================
	if(dialogid == VEHICLE_OTHER)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material dari penyimpanan", "Pilih", "Kembali");
                        }
                        case 2:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component dari penyimpanan", "Pilih", "Kembali");
                        }
                        case 3:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana dari penyimpanan", "Pilih", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}			
	if(dialogid == VEHICLE_SEED)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Seed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                            ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pSeed]);
                            ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                    ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
                }
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_SEED_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Seed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsSeed])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Seed tidak mencukupi!{ffffff}.\n\nSeed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsSeed] -= amount;
                    pData[playerid][pSeed] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d seed dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_SEED_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pSeed])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Seed anda tidak mencukupi!{ffffff}.\n\nSeed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_SEED) < vsData[vehicleid][vsSeed] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Seed!.\n\nSeed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_SEED), pData[playerid][pSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsSeed] += amount;
                    pData[playerid][pSeed] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d seed ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	if(dialogid == VEHICLE_MATERIAL)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Material yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Material yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMaterial]);
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Seed\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                    ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
                }
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MATERIAL_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Material yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMaterial])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Material tidak mencukupi!{ffffff}.\n\nMaterial yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMaterial] -= amount;
                    pData[playerid][pMaterial] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d material dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
            }
        }
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MATERIAL_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Material yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMaterial])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Material anda tidak mencukupi!{ffffff}.\n\nMaterial yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MATERIAL) < vsData[vehicleid][vsMaterial] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Material!.\n\nMaterial yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MATERIAL), pData[playerid][pMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMaterial] += amount;
                    pData[playerid][pMaterial] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d material ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
            }
        }
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//==============================================
	if(dialogid == VEHICLE_COMPONENT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pComponent]);
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Seed\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                    ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
                }
            }
        }
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_COMPONENT_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsComponent])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Component tidak mencukupi!{ffffff}.\n\nComponent yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsComponent] -= amount;
                    pData[playerid][pComponent] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d component dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_COMPONENT_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pComponent])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Component anda tidak mencukupi!{ffffff}.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_COMPONENT) < vsData[vehicleid][vsComponent] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Component!.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_COMPONENT), pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsComponent] += amount;
                    pData[playerid][pComponent] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d component ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//=====================================================
	if(dialogid == VEHICLE_MARIJUANA)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMarijuana]);
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Seed\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                    ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Select", "Back");
                } 
			}
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MARIJUANA_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMarijuana])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Marijuana tidak mencukupi!{ffffff}.\n\nMarijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMarijuana] -= amount;
                    pData[playerid][pMarijuana] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d marijuana dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MARIJUANA_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                	new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMarijuana])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Marijuana anda tidak mencukupi!{ffffff}.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MARIJUANA) < vsData[vehicleid][vsMarijuana] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Marijuana!.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MARIJUANA), pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMarijuana] += amount;
                    pData[playerid][pMarijuana] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d marijuana ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	if(dialogid == DIALOG_SERVERMONEY)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_STORAGE, DIALOG_STYLE_LIST, "Storage City Money", "Withdraw City Money\nDeposit City Money", "Select", "Cancel");
			return 1;
		}
	}
	if(dialogid == DIALOG_SERVERMONEY_STORAGE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[200];
					format(str, sizeof(str), "City Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang negara yang ingin anda ambil?", FormatMoney(ServerMoney));
					ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Storage City Money", str, "Withdraw", "Back");
					return 1;
				}
				case 1:
				{
					new str[200];
					format(str, sizeof(str), "Your Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang yang mau anda simpan ke uang negara?", FormatMoney(pData[playerid][pMoney]));
					ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Storage City Money", str, "Deposit", "Back");
					return 1;
				}
			}
		}
		else 
		{
			new lstr[300];
			pData[playerid][pUangKorup] = 0;
			format(lstr, sizeof(lstr), "City Money: {3BBD44}%s", FormatMoney(ServerMoney));
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY, DIALOG_STYLE_MSGBOX, "Great City Money", lstr, "Manage", "Close");
		}
	}
	if(dialogid == DIALOG_SERVERMONEY_WITHDRAW)
	{
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext) || !IsNumeric(inputtext))
			{
				new str[200];
				format(str, sizeof(str), "{ff0000}ERROR: {ffff00}Masukan sebuah angka!!\n{ffffff}City Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang negara yang ingin anda ambil?", FormatMoney(ServerMoney));
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Storage City Money", str, "Withdraw", "Back");
			}
			if(amount < 1 || amount > ServerMoney)
			{
				new str[200];
				format(str, sizeof(str), "{ff0000}ERROR: {ffff00}Jumlah tidak mencukupi!!\n{ffffff}City Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang negara yang ingin anda ambil?", FormatMoney(ServerMoney));
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Storage City Money", str, "Withdraw", "Back");
			}

			pData[playerid][pUangKorup] += amount;

			new str[200];
			format(str, sizeof(str), "Masukan alasan kamu mengambil uang");
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_REASON, DIALOG_STYLE_INPUT, "Reason", str, "Masukkan", "Back");
			return 1;
		}
		else
		{
			pData[playerid][pUangKorup] = 0;
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_STORAGE, DIALOG_STYLE_LIST, "Storage City Money", "Withdraw City Money\nDeposit City Money", "Select", "Cancel");
			return 1;
		}
	}
	if(dialogid == DIALOG_SERVERMONEY_DEPOSIT)
	{
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext) || !IsNumeric(inputtext))
			{
				new str[200];
				format(str, sizeof(str), "Your Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang yang mau anda simpan ke uang negara?", FormatMoney(pData[playerid][pMoney]));
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Storage City Money", str, "Deposit", "Back");
			}
			if(amount < 1 || amount > ServerMoney)
			{
				new str[200];
				format(str, sizeof(str), "Your Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang yang mau anda simpan ke uang negara?", FormatMoney(pData[playerid][pMoney]));
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Storage City Money", str, "Deposit", "Back");
			}

			pData[playerid][pMoney] -= amount;
			Server_AddMoney(amount);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %s uang ke penyimpanan uang ngeara.", ReturnName(playerid), FormatMoney(amount));
			new str[200];
			format(str, sizeof(str), "```\nKorup Detect: %s menyimpan uang kota sebesar %s```", ReturnName(playerid), FormatMoney(amount));
			SendDiscordMessage(6, str);
			return 1;
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_STORAGE, DIALOG_STYLE_LIST, "Storage City Money", "Withdraw City Money\nDeposit City Money", "Select", "Cancel");
			return 1;
		}
	}
	if(dialogid == DIALOG_SERVERMONEY_REASON)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				new str[200];
				format(str, sizeof(str), "Masukan alasan kamu mengambil uang");
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_REASON, DIALOG_STYLE_INPUT, "Reason", str, "Masukkan", "Back");
			}

			GivePlayerMoneyEx(playerid, pData[playerid][pUangKorup]);
			Server_MinMoney(pData[playerid][pUangKorup]);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %s uang dari penyimpanan uang ngeara.", ReturnName(playerid), FormatMoney(pData[playerid][pUangKorup]));
			new str[200];
			format(str, sizeof(str), "```\nKorup Detect: %s mengambil uang kota sebesar %s\nReason: %s```", ReturnName(playerid), FormatMoney(pData[playerid][pUangKorup]), inputtext);
			SendDiscordMessage(6, str);
			pData[playerid][pUangKorup] = 0;
		}
		else
		{
			pData[playerid][pUangKorup] = 0;
		}
	}
	if(dialogid == DIALOG_NONRPNAME)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				Error(playerid, "Masukan namamu!");
				new string[256];
				format(string, sizeof (string), "{ff0000}Nama kamu non rp name!\n{ffffff}Contoh Nama RP: {3BBD44}James_Petterson, Antonio_Whitford, Javier_Valdes.{ffffff}\n\n{ffff00}Silahkan isi nama kamu baru dibawah ini!");
				ShowPlayerDialog(playerid, DIALOG_NONRPNAME, DIALOG_STYLE_INPUT, "{ffff00}Non Roleplay Name", string, "Change", "Cancel");
				return 1;
			}
			if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
			{
				Error(playerid, "Minimal nama berisi 4 huruf dan Maximal 32 huruf");
				new string[256];
				format(string, sizeof (string), "{ff0000}Nama kamu non rp name!\n{ffffff}Contoh Nama RP: {3BBD44}James_Petterson, Antonio_Whitford, Javier_Valdes.{ffffff}\n\n{ffff00}Silahkan isi nama kamu baru dibawah ini!");
				ShowPlayerDialog(playerid, DIALOG_NONRPNAME, DIALOG_STYLE_INPUT, "{ffff00}Non Roleplay Name", string, "Change", "Cancel");
				return 1;
			}
			if(!IsValidRoleplayName(inputtext))
			{
				Error(playerid, "Nama karakter tidak valid, silahkan cek 2x");
				new string[256];
				format(string, sizeof (string), "{ff0000}Nama kamu non rp name!\n{ffffff}Contoh Nama RP: {3BBD44}James_Petterson, Antonio_Whitford, Javier_Valdes.{ffffff}\n\n{ffff00}Silahkan isi nama kamu baru dibawah ini!");
				ShowPlayerDialog(playerid, DIALOG_NONRPNAME, DIALOG_STYLE_INPUT, "{ffff00}Non Roleplay Name", string, "Change", "Cancel");
				return 1;
			}

			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", inputtext);
			mysql_tquery(g_SQL, query, "NonRPName", "is", playerid, inputtext);
		}
		else
		{
			SendStaffMessage(COLOR_RED, "%s{ffffff} membatalkan pengubahan namanya!", GetRPName(playerid));
		}
	}
	
    return 1;
}
