CreateCarStealingPoint()
{
    //JOBS
    new strings[128];
    CreateDynamicPickup(1239, 23, 1114.5065, -319.9304, 73.9922, -1, -1, -1, 50);
    format(strings, sizeof(strings), "[Car Stealing]\n{ffffff}/chopvehicle");
    CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1114.5065, -319.9304, 73.9922, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Kurir
}

enum theftEnum
{
	tTime,
};

new theftInfo[theftEnum];

ResetCarStealing()
{
	theftInfo[tTime] = 1;
}
forward CarStealing(playerid);
public CarStealing(playerid)
{
	new redmoney, materials;
    new vehid = Vehicle_Nearest2(playerid);
	redmoney = Random(2000, 3000);
	materials = Random(100, 300);
    
    InfoTD_MSG(playerid, 2000, "Pencurian kendaraan berhasil");

	pData[playerid][pRedMoney] += redmoney;
	pData[playerid][pMaterial] += materials;

    Info(playerid, "Kamu mendapatkan {ff0000}%s {ffffff}RedMoney & {ff0000}%d {ffffff}Material dari pencurian kendaraan", FormatMoney(redmoney), materials);
	TogglePlayerControllable(playerid, 1);
	
	foreach(new i : Player)  // Iterate through playerid of every logged in player5);
    { 
		for(new v = 0; v < MAX_PLAYER_VEHICLE; v++)
		{
            new query[500], brk = 1;
		  	mysql_format(g_SQL, query, sizeof(query), "UPDATE vehicle SET x='%f', y='%f', z='%f', a='%f', broken='%d' WHERE id='%d'", pvData[vehid][cPosX], pvData[vehid][cPosY], pvData[vehid][cPosZ], pvData[vehid][cPosA], brk, pvData[vehid][cID]);
			mysql_tquery(g_SQL, query);

            pvData[vehid][cStolen] = brk;
			RemovePlayerFromVehicle(playerid);
            if(IsValidVehicle(pvData[vehid][cVeh]))
			{
				DestroyVehicle(pvData[vehid][cVeh]);
				pvData[vehid][cVeh] = INVALID_VEHICLE_ID;
			}
		}
	}
	return 1;
}

CMD:chopvehicle(playerid, params[]) 
{
    new vehid2 = GetPlayerVehicleID(playerid);
    new clientMessage[128];
    if(theftInfo[tTime] > 0)
    {
        return Info(playerid, "Car Stealing cooldown %i jam. Kamu tidak bisa mencurinya sekarang.", theftInfo[tTime]);
    }
    if((gettime() - pData[playerid][pLastChop]) < 7200000)
    {
        return Error(playerid, " Kamu harus menunggu sekitar 2 Jam lagi untuk mencuri!");
    }
    if(pData[playerid][pFaction] == 1)
    {
        return Error(playerid, "Kamu ini polisi dek");
    }
    // If player isn't at the drop point, abort.
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1114.5065, -319.9304, 73.9922)) 
    {
        Error(playerid, "Kamu harus area carstealing untuk mencuri mobil ini.");
        return 1;
    }
        // If player isn't high enough level, abort.
    if(pData[playerid][pLevel] < 4) 
    {
        Error(playerid, "Minimal level 4 untuk menggunakan command ini");
        return 1;
    }
    // If player isn't in a car (driver or passenger), abort.
    if(!IsPlayerInAnyVehicle(playerid)) 
    {
        Error(playerid, "Kamu harus berada di dalam kendaraan untuk mencuri.");
        return 1;
    }
    if(AdminVehicle{vehid2} || pvData[vehid2][cRent] != 0 || IsASweeperVeh(vehid2) || IsABusVeh(vehid2) || IsAForVeh(vehid2) || IsAMowerVeh(vehid2) || IsABaggageVeh(vehid2) || IsADmvVeh(vehid2) || IsSAPDCar(vehid2) || IsGovCar(vehid2) || IsSAMDCar(vehid2) || IsSANACar(vehid2))
    {
        return Error(playerid, "Kendaraan ini tidak dimiliki oleh orang tertentu!.");
    }
    if(Vehicle_IsOwner(playerid, vehid2))
    {
        return Error(playerid, "Kamu tidak bisa mencuri kendaraanmu sendiri!.");
    }
    new count;
    foreach(new i : Player)
    {
        if(pData[i][pFaction] == 1 && pData[i][pOnDuty] == 1)
        {
            count++;
        }
    }
    if(count < 3)
    {
        return Error(playerid, "Setidaknya harus ada 3+ Aparat yang on duty untuk mencuri kendaraan.");
    }

    pData[playerid][pLastChopTime] = 120;
    new mstr[64];
    format(mstr, sizeof(mstr), "Waktu Pencurian ~r~%d ~w~detik", pData[playerid][pLastChopTime]);
    Info(playerid, "Usahakan kamu tidak keluar dari kendaraan yang kamu curi agar berhasil!");
    InfoTD_MSG(playerid, 1000, mstr);
    TogglePlayerControllable(playerid, 0);
    MalingKendaraan = SetTimerEx("CarStealing", 120000, false, "i", playerid);

    //SM(pvData[vehid2][cOwner], "[SMS] From SAPD: Kendaraan anda telah dicuri orang, Kami masih proses penyelidikan");
    format(clientMessage, sizeof(clientMessage), "____________ DISPATCH PANEL _____________");
    SendFactionMessage(1, COLOR_YELLOW, clientMessage);
    format(clientMessage,sizeof(clientMessage),"%s{ffffff} telah dilaporkan {FF0000}kendaraan dicuri{FFFFFF}. Lokasi dikirim ke GPSmu.", GetVehicleName(vehid2));
    SendFactionMessage(1, COLOR_YELLOW, clientMessage);
    pData[playerid][pLastChop] = gettime();
      
    ResetCarStealing();
      
    foreach(new p : Player)
    {
        if(pData[p][pFaction] == SAPD)
        {
            SetPlayerRaceCheckpoint(p, 1, 1114.5065, -319.9304, 73.9922, 1114.5065, -319.9304, 73.9922, 4.0);
        }
    }  
	return 1;  
}