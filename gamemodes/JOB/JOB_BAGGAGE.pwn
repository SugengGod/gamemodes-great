CreateJoinBaggagePoint()
{
    //JOBS
    new strings[128];
    CreateDynamicPickup(1239, 23, 2060.2942, -2220.8250, 13.5469, -1, -1, -1, 50);
    format(strings, sizeof(strings), "[BAGGAGE JOBS]\n{ffffff}Jadilah Pekerja Baggage disini\n{7fffd4}/getjob /accept job");
    CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 2060.2942, -2220.8250, 13.5469, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Kurir
}

new BaggageVeh[4];

AddBaggageVehicle()
{
    BaggageVeh[0] = AddStaticVehicleEx(485, 2109.9346, -2234.4961, 13.2080, 45.9019, -1, -1, VEHICLE_RESPAWN);
	BaggageVeh[1] = AddStaticVehicleEx(485, 2107.4749, -2237.0952, 13.2043, 47.3460, -1, -1, VEHICLE_RESPAWN);
	BaggageVeh[2] = AddStaticVehicleEx(485, 2104.8237, -2239.7996, 13.2029, 46.3262, -1, -1, VEHICLE_RESPAWN);
	BaggageVeh[3] = AddStaticVehicleEx(485, 2102.3191, -2242.4695, 13.2049, 47.7862, -1, -1, VEHICLE_RESPAWN);
}

IsABaggageVeh(carid)
{
	for(new v = 0; v < sizeof(BaggageVeh); v++) {
	    if(carid == BaggageVeh[v]) return 1;
	}
	return 0;
}

CMD:startbg(playerid, params[])
{
	new dedyvariabel[500], String[500];
	if(pData[playerid][pJob] == 10 || pData[playerid][pJob2] == 10)
	{
	    if(pData[playerid][pBaggage] >= 1)
        {
            return Error(playerid,"Kamu sedang dalam pengiriman Baggage.");
        }
        if(pData[playerid][pJobTime] > 0)
        {
            return Info(playerid, "Kamu dapat bekerja lagi setelah %i detik.", pData[playerid][pJobTime]);
        }
        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 485)
        {
            strcat(dedyvariabel, "Type\tRoute\n");
            format(String, sizeof(String), "Baggage 1\t%s\n", (DialogBaggage[0] == true) ? ("{FF0000}Taken") : ("{33AA33}Route A"));
            strcat(dedyvariabel, String);
            format(String, sizeof(String), "Baggage 2\t%s\n", (DialogBaggage[1] == true) ? ("{FF0000}Taken") : ("{33AA33}Route B"));
            strcat(dedyvariabel, String);
            format(String, sizeof(String), "Baggage 3\t%s\n", (DialogBaggage[2] == true) ? ("{FF0000}Taken") : ("{33AA33}Route C"));
            strcat(dedyvariabel, String);
            ShowPlayerDialog(playerid, DIALOG_BAGGAGE, DIALOG_STYLE_TABLIST_HEADERS, "Baggage Airport", dedyvariabel, "Pilih", "Batal");
            return 1;
        }
        else return Error(playerid, "Kamu tidak berada di dalam Kendaraan Baggage.");
	}
    else 
        Error(playerid, "Kamu bukan pekerja Baggage Airport.");
    return 1;
}