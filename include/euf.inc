/*************************************************************************************


		Easy Usefull Function
	  	Credits : Pateeer


*************************  [ FUNCTIONS ] ********************************************

[+] PAT::SendPlayerToOther(playerid, targetid);
[+] PAT::PayMoneyTo(playerid, targetid);
[+] KillTimerEx(timerid[playerid])
[+] IsValidTimer(playerid, timerid[playerid]);

*************************  [ CALLBACKS ] ********************************************

[+] OnPlayerTeleportToOther(playerid, targetid, Float:px, Float:py, Float:pz, Float:pa, Float:x, Float:y, Float:z, Float:a)
[+] OnPlayerFailTeleportToOther(playerid, targetid, reason)
[+] OnPlayerFailPayMoney(playerid, targetid, reason, amount)
[+] OnPlayerPayMoney(playerid, targetid, amount)
[+] OnPlayerEnterDriver(playerid, vehicleid);
[+] OnPlayerEnterPassenger(playerid, vehicleid);
[+] OnPlayerExitDriver(playerid, vehicleid);
[+] OnPlayerExitPassenger(playerid, vehicleid);
[+] OnPlayerLeaveVehicle(playerid, vehicleid);

************************************************************************************/

#if !defined _samp_included
	#error Please include a_samp before TimerCheck.
#endif

#if !defined _inc_y_timers
	#error Please include YSI\y_timers to use this.
#endif

#define PAT:: PAT_

// Forwards
forward OnPlayerTeleportToOther(playerid, targetid, Float:px, Float:py, Float:pz, Float:pa, Float:x, Float:y, Float:z, Float:a);
forward OnPlayerFailTeleportToOther(playerid, targetid, reason);
forward OnPlayerFailPayMoney(playerid, targetid, reason, amount);
forward OnPlayerPayMoney(playerid, targetid, amount);
forward OnPlayerEnterDriver(playerid, vehicleid);
forward OnPlayerEnterPassenger(playerid, vehicleid);
forward OnPlayerExitDriver(playerid, vehicleid);
forward OnPlayerExitPassenger(playerid, vehicleid);
forward OnPlayerLeaveVehicle(playerid, vehicleid);

// Functions
stock PAT::GetName(playerid)
{
	new name[ 64 ];
	GetPlayerName(playerid, name, sizeof( name ));
	return name;
}

//////////////////////////////////////////
//   Send Player To Other Player ID    ///
//////////////////////////////////////////
// Fail Reason 1 : Target ID not Valid ///
// Fail Reason 2 : Player ID not Valid ///
//////////////////////////////////////////

stock PAT::SendPlayerToOther(playerid, targetid) {
	new Float:x, Float:y, Float:z, Float:a, Float:px, Float:py, Float:pz, Float:pa;
	GetPlayerPos(targetid, x, y, z);
	GetPlayerFacingAngle(targetid, a);
	if(targetid == INVALID_PLAYER_ID) {
		CallLocalFunction("OnPlayerFailTeleportToOther","iid", playerid, targetid, 1);
		printf("[EUF DEBUG] %s Failed Teleport to ID: %d ( Reason: Target ID Not Valid )", PAT::GetName(playerid), targetid);
		return 0;
	}
	if(playerid == INVALID_PLAYER_ID) {
		CallLocalFunction("OnPlayerFailTeleportToOther","iid", playerid, targetid, 2);
		printf("[EUF DEBUG] %d Failed Teleport to ID: %d ( Reason: Player ID Not Valid )", playerid, targetid);
		return 0;
	}
	SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, a);
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	CallLocalFunction("OnPlayerTeleportToOther","iiffffffff", playerid, targetid, px, py, pz, pa, x, y, z, a);
	printf("[EUF DEBUG] %d Teleport to ID: %d", playerid, targetid);
}

//////////////////////////////////////////
///   Pay Player To Other Player ID    ///
//////////////////////////////////////////

stock PAT::PayMoneyTo(playerid, targetid, amount) {
	if(amount < GetPlayerMoney(playerid)) {
		CallLocalFunction("OnPlayerFailPayMoney","iid", playerid, targetid, 1, amount);
		printf("[EUF DEBUG] %d Failed Pay to ID: %d ( Reason: Not Enough Money )", playerid, targetid);
		return 0;
	}
	if(playerid == INVALID_PLAYER_ID) {
		CallLocalFunction("OnPlayerFailPayMoney","iid", playerid, targetid, 2, amount);
		printf("[EUF DEBUG] %d Failed Pay to ID: %d ( Reason: Player ID Not Valid )", playerid, targetid);
		return 0;
	}
	if(targetid == INVALID_PLAYER_ID) {
		CallLocalFunction("OnPlayerFailPayMoney","iid", playerid, targetid, 3, amount);
		printf("[EUF DEBUG] %d Failed Pay to ID: %d ( Reason: Target ID Not Valid )", playerid, targetid);
		return 0;
	}
	GivePlayerMoney(playerid, -amount);
	GivePlayerMoney(targetid, amount);
	CallLocalFunction("OnPlayerPayMoney","iid", playerid, targetid, amount);
	printf("[EUF DEBUG] %d Pay to ID: %d (Amount: %d)", playerid, targetid, amount);
}

//////////////////////////////////////////
///           IsValidTimer             ///
//////////////////////////////////////////

#if !defined IsValidTimer
	forward IsValidTimer(timerid);
#endif


#if defined KillTimer
	forward KillTimerEx(id, timerid[]);
#endif

public KillTimerEx(id, timerid[]){
	KillTimer(timerid[id]);
	timerid[id] = 0;
}

public IsValidTimer(timerid){	
	return (timerid);
}

//////////////////////////////////////////
///         State Function             ///
//////////////////////////////////////////


//Hook: OnPlayerStateChange
public OnPlayerStateChange(playerid,newstate,oldstate){
	if(newstate == PLAYER_STATE_DRIVER){
		new vehicleid = GetPlayerVehicleID(playerid);
		CallLocalFunction("OnPlayerEnterDriver","ii",playerid, vehicleid);
	}
	if(newstate == PLAYER_STATE_PASSENGER){
		new vehicleid = GetPlayerVehicleID(playerid);
		CallLocalFunction("OnPlayerEnterPassenger","ii",playerid, vehicleid);
	}
	if(oldstate == PLAYER_STATE_DRIVER){
		CallLocalFunction("OnPlayerExitDriver","i",playerid);
	}
	if(oldstate == PLAYER_STATE_PASSENGER){
		CallLocalFunction("OnPlayerExitPassenger","i",playerid);
	}
	if(newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER){
		CallLocalFunction("OnPlayerLeaveVehicle","i",playerid);
	}
	if(newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_PASSENGER){
		CallLocalFunction("OnPlayerLeaveVehicle","i",playerid);
	}
	#if defined PAT_OnPlayerStateChange
		EVF::OnPlayerStateChange(playerid,newstate,oldstate);
	#endif
	return 1;
}
#if defined PAT_OnPlayerStateChange
	forward PAT_OnPlayerStateChange(playerid,newstate,oldstate);
#endif
#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange PAT_OnPlayerStateChange