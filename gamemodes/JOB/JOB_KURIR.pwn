/*


       JOB KURIR

*/

CreateJoinKurirPoint()
{
    //JOBS
    new strings[128];
    CreateDynamicPickup(1239, 23, 988.890563, -1349.136962, 13.545228, -1, -1, -1, 50);
    format(strings, sizeof(strings), "[KURIR JOBS]\n{ffffff}Jadilah Pekerja Kurir disini\n{7fffd4}/getjob /accept job");
    CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 988.890563, -1349.136962, 13.545228, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Kurir
}

new Float: DeliveryCP[][3] =// Kordinat Lokasi pengiriman
{
	{1894.2181,-2133.8342,15.4663},
    {1975.510, -1924.191, 13.547},
    {1684.952, -1583.4090, 13.5468},
    {1370.320, -1341.021, 13.546},
    {1802.0742,-2099.5574,14.0210},
    {1074.7089, -1581.084, 13.526},
    {1781.5271,-2101.9512,14.0566},
    {1370.320, -1361.021, 13.546},
    {1074.7089, -1581.084, 13.526},
    {1734.7061,-2129.8684,14.0210},
    {921.80, -1803.751, 13.832},
    {1136.543, -897.055, 43.39},
    {1684.7278,-2099.4089,13.8343},
    {808.275, -1553.287, 13.6204},
    {1111.366, -974.116, 42.765},
    {921.80, -1803.751, 13.832},
    {808.275, -1553.287, 13.6204},
    {816.959, -1027.113, 25.019},
    {1895.4196,-2068.2354,15.6689},
    {1370.320, -1341.021, 13.546},
    {1928.5251,-1916.0890,15.2568},
    {842.977, -1006.935, 28.562},
    {1891.9386,-1914.6025,15.2568},
    {816.959, -1027.113, 25.019},
    {1074.7089, -1581.084, 13.526},
    {1897.8868,-2037.9088,13.5469},
    {842.977, -1006.935, 28.562},
    {1916.7900,-2029.1899,13.5469},
    {1916.8823,-2001.3242,13.5469},
    {1908.0764,-1982.5504,13.5469},
    {1074.7089, -1581.084, 13.526},
    {1370.320, -1341.021, 13.546},
    {808.275, -1553.287, 13.6204},
    {1849.1951,-2037.8882,13.5469},
    {816.959, -1027.113, 25.019},
    {1835.8282,-2006.0781,13.5469},
    {1817.5377,-2005.6517,13.5544}
};

new bool:angkatBox[MAX_PLAYERS];
new bool:LagiKerja[MAX_PLAYERS];
new bool:Kurir[MAX_PLAYERS];
new Unload_Timer[MAX_PLAYERS];

new KurirCar[5];

AddKurirVehicle()
{
    KurirCar[0] = AddStaticVehicle(482, 1000.29,-1368.507,12.992, 0.0071, 6, 6);
    KurirCar[1] = AddStaticVehicle(482, 1004.29,-1368.507,12.992, 359.8188, 6, 6);
    KurirCar[2] = AddStaticVehicle(482, 1008.29,-1368.507,12.992, 357.6033, 6, 6);
    KurirCar[3] = AddStaticVehicle(482, 1012.29,-1368.507,12.992, 359.1634, 6, 6);
    KurirCar[4] = AddStaticVehicle(482, 1015.29,-1368.507,12.992, 359.2516, 6, 6);
}

IsAKurirVeh(carid)
{
    for(new v = 0; v < sizeof(KurirCar); v++) {
        if(carid == KurirCar[v]) return 1;
    }
    return 0;
}
     
CMD:stopkurir(playerid,params[])
{
    if(pData[playerid][pJob] != 8)
        return Error(playerid, "Anda bukan Pekerja Kurir");

    if(pData[playerid][pKurirEnd] == 3)
    	return Error(playerid, "Anda sedang menyelesaikan Pekerjaan, Tidak dapat stop");

    if(Kurir[playerid] == true)
    {
        Kurir[playerid] = false;
        LagiKerja[playerid] = false;
        angkatBox[playerid] = false;
        DisablePlayerCheckpoint(playerid);
        SetPlayerColor(playerid, 0xFFFFFFAA);
        Servers(playerid,"Anda telah menghentikan Misi Pengiriman Kurir, Gaji hanya diterima $100 ke Pending Salary anda.");
    }
    return 1;
}

CMD:angkatbox(playerid,params[])
{
    if(pData[playerid][pJob] != 8)
        return Error(playerid, "Anda bukan Pekerja Kurir");

    if(LagiKerja[playerid] == false)
        return Error(playerid,"Ngapain ngangkat Box? Kerja jadi kurir dulu!");

    if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Kamu harus keluar dari kendaraan.");

    if(pData[playerid][pKurirEnd] == 3)
    	return Error(playerid, "Sudah max.3 , harap kembalikan Mobil ini ke tempat Job");

    else if(LagiKerja[playerid] == true)
    {
        if(angkatBox[playerid] == true)
        {
            Error(playerid,"* Kamu sudah mengangkat BOX!");
        }
        else if(angkatBox[playerid] == false)
        {
            angkatBox[playerid] = true;
            Servers(playerid,"Kamu sedang mengangkat BOX, Harap lanjutkan Pengiriman!");
            ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1,1);
            SetPlayerAttachedObject( playerid, BOX_INDEX, 1271, 1, 0.002953, 0.469660, -0.009797, 269.851104, 34.443557, 0.000000, 0.804894, 1.000000, 0.822361 );
        }
    }
    return 1;
}

CMD:startkurir(playerid,params[])
{
    if(pData[playerid][pJob] != 8)
        return Error(playerid, "Anda bukan Pekerja Kurir");

    if(pData[playerid][pKurirEnd] == 3)
    	return Error(playerid, "Sudah max.3 , harap kembalikan Mobil ini ke tempat Job");

    if(IsAKurirVeh(GetPlayerVehicleID(playerid)))
    {
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            new rand = random(sizeof(DeliveryCP));
            if(LagiKerja[playerid] == true) return Servers(playerid,"Anda saat ini dalam misi. Harap selesaikan untuk memulai pengiriman lain.");
            if(IsAKurirVeh(GetPlayerVehicleID(playerid)))
            {
                LagiKerja[playerid] = true;
                Kurir[playerid] = true;
                SetPlayerCheckpoint(playerid, DeliveryCP[rand][0], DeliveryCP[rand][1], DeliveryCP[rand][2], 1.5);
                GameTextForPlayer(playerid, "~w~PEKERJAAN DIMULAI HARAP IKUTI ~n~~r~RED ~w~CHECKPOINT", 5000, 3);
                SendClientMessage(playerid, 0x76EEC6FF, "* Anda dapat menghentikan misi pengiriman dengan mengetik /stopkurir");
            }
        }
    }
    return 1;
}

forward PekerjaanSelesai(playerid);
public PekerjaanSelesai(playerid)
{
    ClearAnimations(playerid);
    Servers(playerid, "Lanjutkan pekerjaan mu");
    TogglePlayerControllable(playerid,1);
    DisablePlayerCheckpoint(playerid);
    LagiKerja[playerid] = false;
    angkatBox[playerid] = false;
    pData[playerid][pKurirEnd] += 1;
    DisablePlayerCheckpoint(playerid);
    if(pData[playerid][pKurirEnd] == 3)
    {
        SetPlayerCheckpoint(playerid, 988.890563, -1349.136962, 13.545228, 4.0);
        Servers(playerid, "Ke Tempat Job Kurir dan kembalikan Mobil nya");
        pData[playerid][pCP] = 1;
    }
}