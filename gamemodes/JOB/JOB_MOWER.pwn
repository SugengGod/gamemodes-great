//==============[ Mower ]
#define mowerpoint1 	2051.55, -1228.84, 23.17
#define mowerpoint2 	2022.30, -1149.99, 23.43
#define mowerpoint3 	1926.21, -1150.19, 23.45
#define mowerpoint4 	1873.11, -1205.79, 19.96
#define mowerpoint5 	1875.16, -1246.80, 13.39
#define mowerpoint6 	1945.98, -1229.07, 19.36
#define mowerpoint7 	1945.66, -1176.68, 19.74
#define mowerpoint8 	1907.55, -1174.76, 23.20
#define mowerpoint9 	1917.37, -1234.30, 16.67
#define mowerpoint10	2006.07, -1245.38, 22.33
#define mowerpoint11 	2027.11, -1248.52, 23.38
#define mowerpoint12 	2036.20, -1248.76, 23.31

new MowerVeh[4];

AddMowerVehicle()
{
    MowerVeh[0] = AddStaticVehicleEx(572, 2051.766, -1248.560, 23.312, 0.0000, 6, 6, VEHICLE_RESPAWN);
	MowerVeh[1] = AddStaticVehicleEx(572, 2049.542, -1248.549, 23.277, 0.0000, 6, 6, VEHICLE_RESPAWN);
	MowerVeh[2] = AddStaticVehicleEx(572, 2047.028, -1248.613, 23.297, 0.0000, 6, 6, VEHICLE_RESPAWN);
	MowerVeh[3] = AddStaticVehicleEx(572, 2044.255, -1248.675, 23.302, 0.0000, 6, 6, VEHICLE_RESPAWN);
}

IsAMowerVeh(carid)
{
	for(new v = 0; v < sizeof(MowerVeh); v++) {
	    if(carid == MowerVeh[v]) return 1;
	}
	return 0;
}