/* Credits to SA:MP team for Dev package, Y_Less for SSCANF, Jeff for function to get closest vehicle, Zeex for ZCMD & Twinki for making this script*/
/* Special credits to Crayder for helping out & providing his code for the Vehicle damage updates */

#include <a_samp>

#if !defined COLOR_RED
	#define COLOR_RED 0xAA3333AA
#endif

#if !defined IsValidVehicle
	native IsValidVehicle(vehicleid);
#endif

forward OnVehicleStop(vehicleid);
forward OnVehicleStart(vehicleid);
forward OnVehicleLock(vehicleid);
forward OnVehicleUnlock(vehicleid);


new v_EngineStatus[MAX_VEHICLES],
	v_VehicleLights[MAX_VEHICLES],
	v_TrunkStatus[MAX_VEHICLES],
	v_VehicleLock[MAX_VEHICLES];



/* Vehicle Engine */
stock ToggleVehicleEngine(vehicle, status) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
	
	switch(status) {
		case 0: { v_EngineStatus[vehicle] = 0; SetVehicleParamsEx(vehicle, 0, lights, alarm, doors, bonnet, boot, objective); CallLocalFunction("OnVehicleStop", "i", vehicle); }
		case 1: { v_EngineStatus[vehicle] = 1; SetVehicleParamsEx(vehicle, 1, lights, alarm, doors, bonnet, boot, objective); CallLocalFunction("OnVehicleStart", "i", vehicle); }
	}
	return true;
}

stock GetVehicleEngineStatusString(vehicle) {
	new StatusString[4];
	switch(v_EngineStatus[vehicle]) {
		case 0: StatusString = "Off";
		case 1: StatusString = "On";
	}
	return StatusString; 
}

stock GetVehicleEngineStatus(vehicle) return v_EngineStatus[vehicle];

stock AutomaticEngineSwitch(vehicle) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(v_EngineStatus[vehicle]) {
		case 0: { v_EngineStatus[vehicle] = 1; SetVehicleParamsEx(vehicle, 1, lights, alarm, doors, bonnet, boot, objective); CallLocalFunction("OnVehicleStart", "i", vehicle);  }
		case 1: { v_EngineStatus[vehicle] = 0; SetVehicleParamsEx(vehicle, 0, lights, alarm, doors, bonnet, boot, objective); CallLocalFunction("OnVehicleStop", "i", vehicle);  }
	}
	return true;
}





/* Lights */
stock ToggleVehicleLights(vehicle, status) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(status) {
		case 0: { v_VehicleLights[vehicle] = 0; SetVehicleParamsEx(vehicle, engine, 0, alarm, doors, bonnet, boot, objective); }
		case 1: { v_VehicleLights[vehicle] = 1; SetVehicleParamsEx(vehicle, engine, 1, alarm, doors, bonnet, boot, objective); }
	}
	return true;
}

stock GetVehicleLightsStatusString(vehicle) {
	new LightsStatus[4];
	switch(v_VehicleLights[vehicle]) {
		case 0: LightsStatus = "Off";
		case 1: LightsStatus = "On";
	}
	return LightsStatus;
}

stock GetVehicleLightsStatus(vehicle) return v_VehicleLights[vehicle];

stock AutomaticLightSwitch(vehicle) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(v_VehicleLights[vehicle]) {
		case 0: { v_VehicleLights[vehicle] = 1; SetVehicleParamsEx(vehicle, engine, 1, alarm, doors, bonnet, boot, objective); }
		case 1: { v_VehicleLights[vehicle] = 0; SetVehicleParamsEx(vehicle, engine, 0, alarm, doors, bonnet, boot, objective); }
	}
	return true;
}




/* Trunk system */
stock ToggleVehicleTrunk(vehicle, status) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(status) {
		case 0: { v_TrunkStatus[vehicle] = 0; SetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, 0, objective); }
		case 1: { v_TrunkStatus[vehicle] = 1; SetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, 1, objective); }
	}
	return true;
}

stock GetVehicleTrunkStatus(vehicle) return v_TrunkStatus[vehicle]; 

stock GetVehicleTrunkStatusString(vehicle) {
	new TrunkStatus[7];
	switch(v_TrunkStatus[vehicle]) {
		case 0: TrunkStatus = "Closed";
		case 1: TrunkStatus = "Open";
	}
	return TrunkStatus;
}


stock ToggleNearestPlayerTrunk(playerid,status) {
	new sCar = GetClosestVehicleForPlayer(playerid);
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(sCar, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(status) {
		case 0: { v_TrunkStatus[sCar] = 0; SetVehicleParamsEx(sCar, engine, lights, alarm, doors, bonnet, 0, objective); }
		case 1: { v_TrunkStatus[sCar] = 1; SetVehicleParamsEx(sCar, engine, lights, alarm, doors, bonnet, 1, objective); }
	}
	return true;
}

stock ToggleAutomaticNearestTrunk(playerid) {
	new sCar = GetClosestVehicleForPlayer(playerid);
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(sCar, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(v_TrunkStatus[sCar]) {
		case 0: { v_TrunkStatus[sCar] = 1; SetVehicleParamsEx(sCar, engine, lights, alarm, doors, bonnet, 1, objective); }
		case 1: { v_TrunkStatus[sCar] = 0; SetVehicleParamsEx(sCar, engine, lights, alarm, doors, bonnet, 0, objective); }
	}
	return true;
}






/* Lock system */

stock ToggleVehicleLock(vehicle, status) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(status) {
		case 0: { v_VehicleLock[vehicle] = 0; SetVehicleParamsEx(vehicle, engine, lights, alarm, 0, bonnet, boot, objective); CallLocalFunction("OnVehicleUnlock", "i", vehicle); }
		case 1: { v_VehicleLock[vehicle] = 1; SetVehicleParamsEx(vehicle, engine, lights, alarm, 1, bonnet, boot, objective); CallLocalFunction("OnVehicleLock", "i", vehicle); }
	}
	return true;
}

stock GetVehicleLockStatus(vehicle) return v_VehicleLock[vehicle]; 


stock GetVehicleLockStatusString(vehicle) {
	new LockStatus[10];
	switch(v_VehicleLock[vehicle]) {
		case 0: LockStatus = "Unlocked";
		case 1: LockStatus = "Locked";
	}
	return LockStatus;
}

stock AutomaticLockSwitch(vehicle) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(v_VehicleLock[vehicle]) {
		case 0: { v_VehicleLock[vehicle] = 1; SetVehicleParamsEx(vehicle, engine, lights, alarm, 1, bonnet, boot, objective); CallLocalFunction("OnVehicleLock", "i", vehicle); }
		case 1: { v_VehicleLock[vehicle] = 0; SetVehicleParamsEx(vehicle, engine, lights, alarm, 0, bonnet, boot, objective); CallLocalFunction("OnVehicleUnlock", "i", vehicle); }
	}
	return true;
}

stock ToggleNearestVehicleLock(playerid) {
	new sCar = GetClosestVehicleForPlayer(playerid);
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(sCar, engine, lights, alarm, doors, bonnet, boot, objective);
	switch(v_VehicleLock[sCar]) {
		case 0: { v_VehicleLock[sCar] = 1; SetVehicleParamsEx(sCar, engine, lights, alarm, 1, bonnet, boot, objective); CallLocalFunction("OnVehicleLock", "i", sCar); }
		case 1: { v_VehicleLock[sCar] = 0; SetVehicleParamsEx(sCar, engine, lights, alarm, 0, bonnet, boot, objective); CallLocalFunction("OnVehicleUnlock", "i", sCar); }
	}
	return true;
}

stock GetNearCarLockString(playerid)  {
	new sCar = GetClosestVehicleForPlayer(playerid);
	new LockStatus[10];
	switch(v_VehicleLock[sCar]) {
		case 0: LockStatus = "Unlocked";
		case 1: LockStatus = "Locked";
	}
	return LockStatus;
}

stock GetNearCarLock(playerid) {
	new sCar = GetClosestVehicleForPlayer(playerid);
	return v_VehicleLock[sCar]; 
}












stock GetClosestVehicleForPlayer(playerid) //credits to Jeff
{
    new vehicleid = INVALID_VEHICLE_ID;
    new Float:distance = 10.0;
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    for(new i = 0; i < MAX_VEHICLES; i++) {
        if(!IsValidVehicle(i)) continue;
        new Float: tmp = GetVehicleDistanceFromPoint(i, X, Y, Z);
        if(tmp > distance) continue;
        vehicleid = i;
        distance = tmp;
    }
    if(vehicleid != INVALID_VEHICLE_ID) return vehicleid;
    else return SendClientMessage(playerid,0xAA3333AA,"There are no vehicle near to you!");
}