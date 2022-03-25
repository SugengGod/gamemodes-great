new ForVeh[4];

AddForVehicle()
{
	ForVeh[0] = AddStaticVehicleEx(530, 2758.74,-2385.79, 13.64, 177.14, -1, -1, VEHICLE_RESPAWN);
	ForVeh[1] = AddStaticVehicleEx(530, 2749.74,-2385.79, 13.64, 177.14, -1, -1, VEHICLE_RESPAWN);
	ForVeh[2] = AddStaticVehicleEx(530, 2752.74,-2385.79, 13.64, 177.14, -1, -1, VEHICLE_RESPAWN);
	ForVeh[3] = AddStaticVehicleEx(530, 2755.74,-2385.79, 13.64, 177.14, -1, -1, VEHICLE_RESPAWN);
}

IsAForVeh(carid)
{
	for(new v = 0; v < sizeof(ForVeh); v++) {
	    if(carid == ForVeh[v]) return 1;
	}
	return 0;
}

#define forpoint1 		2745.33, -2431.58, 13.64
#define forpoint2 		2400.02, -2565.49, 13.21 
#define forpoint3 		2752.89, -2392.60, 13.64  

new Float:ForklifterAB[][] = //Ambil Box
{
    {2400.4866, -2564.0366, 13.4200, 2400.4866, -2564.0366, 13.4200, 3.0},
    {2368.2109, -2317.1807, 13.3095, 2368.2109, -2317.1807, 13.3095, 3.0},
    {2557.8413, -2466.2776, 13.3955, 2557.8413, -2466.2776, 13.3955, 3.0},
    {2445.4834, -2489.3865, 13.4051, 2445.4834, -2489.3865, 13.4051, 3.0},
	{2745.0618, -2431.6006, 13.6455, 2745.0618, -2431.6006, 13.6455, 3.0},
	{2782.6719, -2371.5759, 13.6328, 2782.6719, -2371.5759, 13.6328, 3.0},
	{2472.3818, -2566.6160, 13.6514, 2472.3818, -2566.6160, 13.6514, 3.0},
	{2769.2969, -2528.6450, 13.6391, 2769.2969, -2528.6450, 13.6391, 3.0}
};
new Float:ForklifterTB[][] = //Taruh Box
{
    {2794.8391, -2451.0833, 13.3937, 2794.8391, -2451.0833, 13.3937, 3.0},
    {2780.9692, -2460.8894, 13.3992, 2780.9692, -2460.8894, 13.3992, 3.0},
    {2787.7512, -2412.7749, 13.3964, 2787.7512, -2412.7749, 13.3964, 3.0},
    {2788.0793, -2489.2803, 13.4173, 2788.0793, -2489.2803, 13.4173, 3.0},
	{2787.5928, -2498.9932, 13.6505, 2787.5928, -2498.9932, 13.6505, 3.0},
	{2796.4807, -2498.9675, 13.6397, 2796.4807, -2498.9675, 13.6397, 3.0},
	{2787.9172, -2489.7322, 13.6501, 2787.9172, -2489.7322, 13.6501, 3.0},
	{2778.8757, -2450.5786, 13.6358, 2778.8757, -2450.5786, 13.6358, 3.0},
	{2795.4946, -2460.9917, 13.6318, 2795.4946, -2460.9917, 13.6318, 3.0},
	{2779.5471, -2412.6257, 13.6357, 2779.5471, -2412.6257, 13.6357, 3.0},
	{2794.9368, -2412.8442, 13.6319, 2794.9368, -2412.8442, 13.6319, 3.0}

};

function ForklifterLoadBox(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid), rand = random(sizeof(ForklifterTB));
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pForklifterLoadStatus] != 1) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 3000, "Loaded!");
		KillTimer(pData[playerid][pForklifterLoad]);
		pData[playerid][pForklifterLoadStatus] = 0;
		pData[playerid][pActivityTime] = 0;
		VehicleObject[vehicleid] = CreateDynamicObject(1220, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		AttachDynamicObjectToVehicle(VehicleObject[vehicleid], vehicleid, 0.0, 0.6, 0.28, 0.0, 0.0, 0.0);
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 1, ForklifterTB[rand][0], ForklifterTB[rand][1], ForklifterTB[rand][2], ForklifterTB[rand][3], ForklifterTB[rand][4], ForklifterTB[rand][5], ForklifterTB[rand][6]);
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 13;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	}
	return 0;	
}

function ForklifterUnLoadBox(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid), rand = random(sizeof(ForklifterAB));
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pForklifterUnLoadStatus] != 1) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 3000, "Unloaded!");
		KillTimer(pData[playerid][pForklifterUnLoad]);
		pData[playerid][pForklifterUnLoadStatus] = 0;
		pData[playerid][pActivityTime] = 0;
		DestroyDynamicObject(VehicleObject[vehicleid]);
		VehicleObject[vehicleid] = INVALID_OBJECT_ID;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, ForklifterAB[rand][0], ForklifterAB[rand][1], ForklifterAB[rand][2], ForklifterAB[rand][3], ForklifterAB[rand][4], ForklifterAB[rand][5], ForklifterAB[rand][6]);
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 15;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	}
	return 0;
}