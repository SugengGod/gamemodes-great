//======== Bus ===========
#define buspoint1 		1671.5015, -1477.9338, 13.4804
#define buspoint2 		1655.4309, -1578.8663, 13.4876
#define buspoint3 		1675.6584, -1594.5546, 13.4830
#define buspoint4 		1808.3151, -1614.4534, 13.4606
#define buspoint5 		1822.1866, -1602.4225, 13.4650
#define buspoint6 		1852.0515, -1477.0760, 13.4892
#define buspoint7 		1976.1843, -1468.7709, 13.4898
#define buspoint8 		1988.9058, -1453.9619, 13.4881
#define buspoint9 		1989.5841, -1354.7592, 23.8970
#define buspoint10 		2055.3843, -1343.6346, 23.9209
#define buspoint11 		2073.3601, -1237.0232, 23.9111
#define buspoint12 		2074.4985, -1106.5936, 24.7291
#define buspoint13 		1995.6899, -1054.9963, 24.5139
#define buspoint14 		1867.9518, -1058.5884, 23.7857
#define buspoint15 		1863.6049, -1169.5271, 23.7625
#define buspoint16 		1657.9583, -1157.8536, 23.8513
#define buspoint17 		1592.6194, -1159.1958, 24.0051
#define buspoint18 		1549.6796, -1055.4402, 23.7095
#define buspoint19 		1458.6635, -1030.3673, 23.7568
#define buspoint20 		1383.3145, -1032.3024, 26.1900
#define buspoint21 		1355.6470, -1045.0482, 26.4642
#define buspoint22 		1340.4150, -1127.6436, 23.7744
#define buspoint23 		1340.1676, -1379.0829, 13.5948
#define buspoint24 		1363.4252, -1405.9730, 13.4503
#define buspoint25 		1393.6683, -1430.9860, 13.5163
#define buspoint26 		1640.2510, -1443.0830, 13.4826
#define buspoint27 		1654.4456, -1539.0234, 13.4815
#define cpbus1 			1639.3451, -1439.9066, 13.3746
#define cpbus2 			1578.5664, -1297.4679, 17.2882
#define cpbus3 			1366.4038, -1239.3553, 13.3771
#define cpbus4 			1376.0468,  -933.2687, 34.1769
#define cpbus5 		 	 960.3029,  -969.7812, 38.8355
#define cpbus6 			1016.2396, -1146.9741, 23.6474
#define cpbus7 			1449.8273, -1163.9070, 23.6518
#define cpbus8 			1501.6725, -1440.9535, 13.3748
#define cpbus9 			1655.5128, -1481.2784, 13.3828

new BusVeh[4];

AddBusVehicle()
{
	BusVeh[0] = AddStaticVehicleEx(431, 1704.6984, -1524.3541, 13.3736, 0.0000, -1, -1, VEHICLE_RESPAWN);
	BusVeh[1] = AddStaticVehicleEx(431, 1705.1564, -1488.2904, 13.3736, 0.0000, -1, -1, VEHICLE_RESPAWN);
	BusVeh[2] = AddStaticVehicleEx(431, 1705.3203, -1505.8333, 13.3736, 0.0000, -1, -1, VEHICLE_RESPAWN);
	BusVeh[3] = AddStaticVehicleEx(431, 1705.1434, -1543.4546, 13.3736, 0.0000, -1, -1, VEHICLE_RESPAWN);
}

IsABusVeh(carid)
{
	for(new v = 0; v < sizeof(BusVeh); v++) {
	    if(carid == BusVeh[v]) return 1;
	}
	return 0;
}
