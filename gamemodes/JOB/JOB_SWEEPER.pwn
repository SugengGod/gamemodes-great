//======== Sweper ===========
#define sweperpoint1 	1300.1277, -1746.0057, 13.3828
#define sweperpoint2 	1198.3400, -1706.6813, 13.5469
#define sweperpoint3 	1040.1805, -1695.5941, 13.3828
#define sweperpoint4 	1041.1193, -1559.6353, 13.3828
#define sweperpoint5 	1065.2335, -1408.1826, 13.3828
#define sweperpoint6 	1175.8345, -1407.7174, 13.3828
#define sweperpoint7 	1328.8345, -1408.1843, 13.3828
#define sweperpoint8	1344.8881, -1436.1655, 13.3828
#define sweperpoint9 	1295.4325, -1557.7495, 13.3828
#define sweperpoint10	1295.0022, -1698.7495, 13.3828
#define sweperpoint11 	1301.3141, -1819.2825, 13.3828
#define sweperpoint12 	1302.6243, -1863.4994, 13.5469
#define cpswep2 		1381.1786, -1874.3966, 13.3760
#define cpswep3 		1526.6534, -1893.9142, 13.8306
#define cpswep4 		1817.1177, -2169.6882, 13.3749
#define cpswep5 		2144.9812, -2218.9775, 13.3737
#define cpswep6 		1921.4847, -2053.1807, 13.3749
#define cpswep7 		1562.5206, -2101.6809, 33.6503
#define cpswep8 		1495.9819, -1870.9498, 13.3749
#define cpswep9 		1299.1281, -1862.7358, 13.5369

new SweepVeh[5];

AddSweeperVehicle()
{
	SweepVeh[0] = AddStaticVehicleEx(574, 1303.5151, -1878.5725, 14.0000, 0.0000, 1, 1, VEHICLE_RESPAWN);
	SweepVeh[1] = AddStaticVehicleEx(574, 1301.2148, -1878.5293, 14.0000, 0.0000, 1, 1, VEHICLE_RESPAWN);
	SweepVeh[2] = AddStaticVehicleEx(574, 1298.8950, -1878.4896, 14.0000, 0.0000, 1, 1, VEHICLE_RESPAWN);
	//SweepVeh[3] = AddStaticVehicleEx(574, 1295.0103, -1878.3979, 14.0000, 0.0000, 1, 1, VEHICLE_RESPAWN);
	//SweepVeh[4] = AddStaticVehicleEx(574, 1291.9260, -1878.4087, 14.0000, 0.0000, 1, 1, VEHICLE_RESPAWN);
}

IsASweeperVeh(carid)
{
	for(new v = 0; v < sizeof(SweepVeh); v++) {
	    if(carid == SweepVeh[v]) return 1;
	}
	return 0;
}