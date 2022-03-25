//========[ DMV ]===========
#define dmvpoint1   2016.6686, -1929.8794, 13.1538
#define dmvpoint2   1838.9573, -1930.4949, 13.2007
#define dmvpoint3   1766.1115, -1822.3604, 13.2002
#define dmvpoint4   1641.6093, -1729.6578, 13.2009
#define dmvpoint5   1431.6963, -1648.9756, 13.1967
#define dmvpoint6   1600.3162, -1595.3844, 13.2809
#define dmvpoint7   1845.4076, -1556.2655, 13.1508
#define dmvpoint8   2005.6715, -1526.2715, 3.2457
#define dmvpoint9   2079.2603, -1658.3865, 13.2081
#define dmvpoint10  2079.2976, -1808.6200, 13.2023
#define dmvpoint11  2069.4094, -1919.2617, 13.3618

new DmvVeh[4];

AddDmvVehicle()
{
	DmvVeh[0] = AddStaticVehicleEx(602, 2052.7083, -1904.0043, 13.3536, 179.3548, 1, 1, VEHICLE_RESPAWN);
	DmvVeh[1] = AddStaticVehicleEx(602, 2056.0083, -1903.9602, 13.3530, 178.6753, 1, 1, VEHICLE_RESPAWN);
	DmvVeh[2] = AddStaticVehicleEx(602, 2059.1909, -1904.1512, 13.3532, 179.2641, 1, 1, VEHICLE_RESPAWN);
	DmvVeh[3] = AddStaticVehicleEx(602, 2062.4348, -1903.9548, 13.3536, 179.3495, 1, 1, VEHICLE_RESPAWN);
}

IsADmvVeh(carid)
{
	for(new v = 0; v < sizeof(DmvVeh); v++) {
	    if(carid == DmvVeh[v]) return 1;
	}
	return 0;
}
