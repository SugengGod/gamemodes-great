// -279.67, -2148.42, 28.54 buy product
//-249.79, -2148.05, 29.30 point1
//-244.14, -2146.05, 29.30 point2
//-250.88, -2143.23, 29.32 point 3
//-245.74, -2141.65, 29.32 point4
CreateJoinProductionPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, -283.02, -2174.36, 28.66, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[PRODUCTION JOBS]\n{ffffff}Jadilah Pekerja Production disini\n{7fffd4}/getjob /accept job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -283.02, -2174.36, 28.66, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job
	
	format(strings, sizeof(strings), "[PRODUCTION JOBS]\n{FFFFFF}/createproduct");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -249.79, -2148.05, 29.30, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job
	
	format(strings, sizeof(strings), "[PRODUCTION JOBS]\n{FFFFFF}/createproduct");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -244.14, -2146.05, 29.30, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job
	
	format(strings, sizeof(strings), "[PRODUCTION JOBS]\n{FFFFFF}/createproduct");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -250.88, -2143.23, 29.32, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job
	
	format(strings, sizeof(strings), "[PRODUCTION JOBS]\n{FFFFFF}/createproduct");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -245.74, -2141.65, 29.32, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // production job
}


CMD:createproduct(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
	if(pData[playerid][pJob] == 6 || pData[playerid][pJob2] == 6)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.79, -2148.05, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -244.14, -2146.05, 29.30)
		|| IsPlayerInRangeOfPoint(playerid, 2.0, -250.88, -2143.23, 29.32) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.74, -2141.65, 29.32))
		{
			new type;
			if(sscanf(params, "d", type)) return Usage(playerid, "/createproduct [type, 1.Food 2.Clothes 3.Equipment");
			
			if(type < 1 || type > 3) return Error(playerid, "Invalid type id.");
			
			if(type == 1)
			{
				if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
				if(pData[playerid][pFood] < 40) return Error(playerid, "Food tidak cukup!(Minimal: 40).");
				if(pData[playerid][CarryProduct] != 0) return Error(playerid, "Anda sedang membawa sebuah product");
				pData[playerid][pFood] -= 40;
				
				TogglePlayerControllable(playerid, 0);
				Info(playerid, "Anda sedang memproduksi bahan makanan dengan 40 food!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pProductingStatus] = 1;
				pData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 1);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else if(type == 2)
			{
				if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
				if(pData[playerid][pMaterial] < 40) return Error(playerid, "Material tidak cukup!(Butuh: 40).");
				if(pData[playerid][CarryProduct] != 0) return Error(playerid, "Anda sedang membawa sebuah product");
				pData[playerid][pMaterial] -= 40;
				
				TogglePlayerControllable(playerid, 0);
				Info(playerid, "Anda sedang memproduksi baju dengan 40 material!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pProductingStatus] = 1;
				pData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 2);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				
			}
			else if(type == 3)
			{
				if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
				if(pData[playerid][pMaterial] < 40) return Error(playerid, "Material tidak cukup!(Butuh: 40).");
				if(pData[playerid][pComponent] < 20) return Error(playerid, "Component tidak cukup!(Butuh: 20).");
				if(pData[playerid][CarryProduct] != 0) return Error(playerid, "Anda sedang membawa sebuah product");
				pData[playerid][pMaterial] -= 40;
				pData[playerid][pComponent] -= 20;
				
				TogglePlayerControllable(playerid, 0);
				Info(playerid, "Anda sedang memproduksi equipment dengan 40 material dan 20 component!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pProductingStatus] = 1;
				pData[playerid][pProducting] = SetTimerEx("CreateProduct", 1000, true, "id", playerid, 3);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
		}
		else return Error(playerid, "You're not near in production warehouse.");
	}
	else Error(playerid, "Anda bukan pekerja sebagai operator produksi.");
	return 1;
}

function CreateProduct(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pProductingStatus] != 1) return 0;
	if(pData[playerid][pJob] == 6 || pData[playerid][pJob2] == 6)
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.79, -2148.05, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -244.14, -2146.05, 29.30)
			|| IsPlayerInRangeOfPoint(playerid, 2.0, -250.88, -2143.23, 29.32) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.74, -2141.65, 29.32))
			{
				if(type == 1)
				{
					SetPlayerAttachedObject(playerid, 9, 2453, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					pData[playerid][CarryProduct] = 1;
					Info(playerid, "Anda telah berhasil membuat bahan makanan, /sellproduct untuk menjualnya.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Food Created!");
					KillTimer(pData[playerid][pProducting]);
					pData[playerid][pActivityTime] = 0;
					pData[playerid][pProductingStatus] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else if(type == 2)
				{
					SetPlayerAttachedObject(playerid, 9, 2391, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					pData[playerid][CarryProduct] = 2;
					Info(playerid, "Anda telah berhasil membuat product baju, /sellproduct untuk menjualnya.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Clothes Created!");
					KillTimer(pData[playerid][pProducting]);
					pData[playerid][pActivityTime] = 0;
					pData[playerid][pProductingStatus] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else if(type == 3)
				{
					SetPlayerAttachedObject(playerid, 9, 2912, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
					pData[playerid][CarryProduct] = 3;
					Info(playerid, "Anda telah berhasil membuat product equipment, /sellproduct untuk menjualnya.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Equipment Created!");
					KillTimer(pData[playerid][pProducting]);
					pData[playerid][pActivityTime] = 0;
					pData[playerid][pProductingStatus] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				}
				else
				{
					KillTimer(pData[playerid][pProducting]);
					pData[playerid][pActivityTime] = 0;
					pData[playerid][pProductingStatus] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					return 1;
				}
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, -249.79, -2148.05, 29.30) || IsPlayerInRangeOfPoint(playerid, 2.0, -244.14, -2146.05, 29.30)
			|| IsPlayerInRangeOfPoint(playerid, 2.0, -250.88, -2143.23, 29.32) || IsPlayerInRangeOfPoint(playerid, 2.0, -245.74, -2141.65, 29.32))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}

CMD:sellproduct(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -279.67, -2148.42, 28.54)) return Error(playerid, "Kamu tidak didekat Warehouse.");
	if(pData[playerid][CarryProduct] == 0) return Error(playerid, "Kamu sedang tidak memegang apapun.");
	
	if(pData[playerid][CarryProduct] == 1)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		pData[playerid][CarryProduct] = 0;
		GivePlayerMoneyEx(playerid, 500);
		
		Product += 10;
		Server_MinMoney(500);
		Info(playerid, "Anda menjual 10 bahan makanan dengan harga "GREEN_E"$500");
		pData[playerid][pJobTime] += 480;
	}
	else if(pData[playerid][CarryProduct] == 2)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		pData[playerid][CarryProduct] = 0;
		GivePlayerMoneyEx(playerid, 550);
		
		Product += 10;
		Server_MinMoney(500);
		Info(playerid, "Anda menjual 10 product baju dengan harga "GREEN_E"$550");
		pData[playerid][pJobTime] += 480;
	}
	else if(pData[playerid][CarryProduct] == 3)
	{
		RemovePlayerAttachedObject(playerid, 9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		pData[playerid][CarryProduct] = 0;
		GivePlayerMoneyEx(playerid, 630);
		
		Product += 10;
		Server_MinMoney(630);
		Info(playerid, "Anda menjual 10 product equipment dengan harga "GREEN_E"$630");
		pData[playerid][pJobTime] += 480;
	}
	return 1;
}
