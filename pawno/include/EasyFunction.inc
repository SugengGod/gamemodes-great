/***********************************************************************************


		Easy Function ( Created for a Roleplay Scripts )
	  	Credits : Pateeer

        Tested on Compiler 3.2.3664 with Old YSI

***********************************************************************************/

#if !defined _samp_included
	#error Please include a_samp before using Easy Function.
#endif

#if !defined _streamer_included
	#error Please include streamer before using Easy Function.
#endif

enum EF_PLAYER_VAR {
    EF_Name,
    bool:UsingMask,
    EF_MaskID,
    Text3D:EF_MaskLabel,
};

new EF_Data[MAX_PLAYERS][EF_PLAYER_VAR];

// CALLBACKS
forward OnPlayerTeleportToOther(playerid, targetid, Float:px, Float:py, Float:pz, Float:pa, Float:x, Float:y, Float:z, Float:a);


// SCM Macros
#define SendInfoMessage(%1,%2) SendClientMessageEx(%1, -1, "{00ced1}INFO: {ffffff}"%2)
#define SendUsageMessage(%1,%2) SendClientMessage(%1, -1, "{00ced1}USAGE: {ffffff}"%2)
#define SendErrorMessage(%1,%2) SendClientMessageEx(%1, -1, "{ff0000}ERROR: {ffffff}"%2)

//
stock EF_SendPlayerToOther(playerid, targetid) {
	new Float:x, Float:y, Float:z, Float:a, Float:px, Float:py, Float:pz, Float:pa;
	GetPlayerPos(targetid, x, y, z);
	GetPlayerFacingAngle(targetid, a);
	if(targetid == INVALID_PLAYER_ID) {
		printf("[EUF DEBUG] %s Failed Teleport to ID: %d ( Reason: Target ID Not Valid )", PAT::GetName(playerid), targetid);
		return 0;
	}
	if(playerid == INVALID_PLAYER_ID) {
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

#define SendPlayerToOther EF_SendPlayerToOther

// MASK & NAMING SYSTEM

stock EF_ReturnMyName(playerid)
{
    static
        name[MAX_PLAYER_NAME + 1];

    GetPlayerName(playerid, name, sizeof(name));
    if(EF_Data[playerid][UsingMask] == true)
        format(name, sizeof(name), "Mask #%d", EF_Data[playerid][EF_MaskID]);

    return name;
}

#if !defined ReturnMyName
    #define ReturnMyName EF_ReturnMyName
#endif

stock EF_TogglePlayerMask(playerid, bool:toggle)
{
    if(toggle == true)
    {
        EF_Data[playerid][UsingMask] = true;
        if(IsValidDynamic3DTextLabel(EF_Data[playerid][EF_MaskLabel]))
            DestroyDynamic3DTextLabel(EF_Data[playerid][EF_MaskLabel]);

        new mstr[64], Float:pX, Float:pY, Float:pZ;
        GetPlayerPos(playerid, pX, pY, pZ);
        format(mstr, sizeof mstr,"Mask_#%d", EF_Data[playerid][EF_MaskID]);
        EF_Data[playerid][EF_MaskLabel] = CreateDynamic3DTextLabel(mstr, -1, pX, pY, pZ+0.3, 20.0, playerid, INVALID_VEHICLE_ID, 1, -1, -1, -1);
        for(new i = GetPlayerPoolSize(); i != -1; --i)
        {
            ShowPlayerNameTagForPlayer(i, playerid, 0);
        }
    }
    else
    {
        EF_Data[playerid][UsingMask] = false;
        if(IsValidDynamic3DTextLabel(EF_Data[playerid][EF_MaskLabel]))
            DestroyDynamic3DTextLabel(EF_Data[playerid][EF_MaskLabel]);

        for(new i = GetPlayerPoolSize(); i != -1; --i)
        {
            ShowPlayerNameTagForPlayer(i, playerid, 1);
        }
    }
    return 1;
}

#if !defined TogglePlayerMask
    #define TogglePlayerMask EF_TogglePlayerMask
#endif

stock EF_IsPlayerUsingMask(playerid)
{
    if(EF_Data[playerid][UsingMask] == true) return 1;
    else return 0;
}

#if !defined IsPlayerUsingMask
    #define IsPlayerUsingMask EF_IsPlayerUsingMask
#endif

// Hook OnPlayerConnect & Disconnect

public OnPlayerConnect(playerid)
{
	EF_Data[playerid][UsingMask] = false;
    EF_Data[playerid][EF_MaskID] = random(9999);
	#if defined EF_OnPlayerConnect
		return EF_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect EF_OnPlayerConnect
#if defined EF_OnPlayerConnect
	forward EF_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid)
{
	EF_Data[playerid][UsingMask] = false;
    EF_TogglePlayerMask(playerid, false);
	#if defined EF_OnPlayerConnect
		return EF_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect EF_OnPlayerConnect
#if defined EF_OnPlayerConnect
	forward EF_OnPlayerConnect(playerid);
#endif

// SendClientMessageEx

EF_SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
    static
        args,
            str[144];

    if((args = numargs()) == 3)
    {
            SendClientMessage(playerid, color, text);
    }
    else
    {
        while (--args >= 3)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit PUSH.S 8
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}

#if !defined SendClientMessageEx
    #define SendClientMessageEx EF_SendClientMessageEx
#endif