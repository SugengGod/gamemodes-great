//Made by lokii.

/*
			Version 1.1
	Changes:
			Fixed DestroyKeypad bug,
			Added CreateKeypad and changed previous CreateKeypad to CreateKeyPadEx,
			Added SetKeypadCode you can now change keypad code,
			Removed uneeded code.
			
			Version 1.2
	Changes:
		Added colors,
		Functions Added:
		
		        	GetKeypadPos,
		        	GetPlayerKeypadID,
		        	GetKeypadHoverColor,
		        	GetKeypadInterior,
		        	GetKeypadWorld,
		        	SetKeypadHoverColor,
		        	SetKeypadInterior,
		        	SetKeypadWorld,
		        	SetKeypadPos
		        	
			Version 1.3
	Changes:
	            Optimized script,
		    Fixed small mistake
*/

#include <foreach> //credits to y_less
#include <streamer> //credits to incognito
#include <YSI\y_hooks> //credits to y_less

/*
native Natives();
native
native CreateKeypad(code[], color = 0x00FF00FF);
native CreateKeypadEx(Float:x, Float:y, Float:z, code[], color = 0x00FF00FF, worldid = 0, interior = 0);
native SetKeypadCode(keypadid, new_code[]);
native SetKeypadHoverColor(keypadid, color);
native SetKeypadInterior(keypadid, interior);
native SetKeypadWorld(keypadid, worldid);
native SetKeypadPos(keypadid, Float:x, Float:y, Float:z);
native ShowPlayerKeypad(playerid, keypadid);
native GetKeypadLength(keypadid);
native GetKeypadPos(keypadid, &Float:x, &Float:y, &Float:z);
native GetPlayerKeypadID(playerid);
native GetKeypadHoverColor(keypadid);
native GetKeypadInterior(keypadid);
native GetKeypadWorld(keypadid);
native HidePlayerKeypad(playerid, keypadid);
native DestroyKeypad(keypadid);
native DestroyAllKeypads();
native
native Callback();
native
native OnPlayerEnterKeypadArea(playerid, keypadid);
native OnKeypadResponse(playerid, keypadid, bool:response, bool:success, code[]);
native
*/

#if !defined MAX_KEYPADS
	#define MAX_KEYPADS (150)
#endif

static kp_chars[10][2] =
{
	"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
};

static kp_ptimer[MAX_PLAYERS] = {0,...};
static kp_id[MAX_PLAYERS] = {-1,...};
static Text:TD_KeyPad[15] = {Text:0xFFFF,...};
static KP_PlayerText[MAX_PLAYERS][11];
static KP_Text[MAX_KEYPADS][11];

enum ee_KeyPads
{
	Float:kp_x,
	Float:kp_y,
	Float:kp_z,
	kp_interior,
	kp_world,
	kp_color,
	kp_area,
	kp_length
}
static e_KeyPads[MAX_KEYPADS][ee_KeyPads];

forward KEYPAD_DONE(playerid);

public KEYPAD_DONE(playerid)
{
	for(new i = 0; i < 15; i++)
	{
	    TextDrawHideForPlayer(playerid, TD_KeyPad[i]);
	}
	kp_ptimer[playerid] = 0;
	return 1;
}

forward OnPlayerEnterKeypadArea(playerid, keypadid);

stock SetKeypadHoverColor(keypadid, color)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return -1;
	if(e_KeyPads[keypadid][kp_area] == -1) return -1;
	e_KeyPads[keypadid][kp_color] = color;
	return 1;
}

stock SetKeypadInterior(keypadid, interior)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return -1;
	if(e_KeyPads[keypadid][kp_area] == -1) return -1;
	e_KeyPads[keypadid][kp_interior] = interior;
	DestroyDynamicArea(e_KeyPads[keypadid][kp_area]);
	e_KeyPads[keypadid][kp_area] = CreateDynamicSphere(e_KeyPads[keypadid][kp_x], e_KeyPads[keypadid][kp_y], e_KeyPads[keypadid][kp_z], 2.5, e_KeyPads[keypadid][kp_world], interior);
	return 1;
}

stock SetKeypadWorld(keypadid, worldid)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return -1;
	if(e_KeyPads[keypadid][kp_area] == -1) return -1;
	e_KeyPads[keypadid][kp_world] = worldid;
	DestroyDynamicArea(e_KeyPads[keypadid][kp_area]);
	e_KeyPads[keypadid][kp_area] = CreateDynamicSphere(e_KeyPads[keypadid][kp_x], e_KeyPads[keypadid][kp_y], e_KeyPads[keypadid][kp_z], 2.5, worldid, e_KeyPads[keypadid][kp_interior]);
	return 1;
}

stock SetKeypadPos(keypadid, Float:x, Float:y, Float:z)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return -1;
	if(e_KeyPads[keypadid][kp_area] == -1) return -1;
	e_KeyPads[keypadid][kp_x] = x;
	e_KeyPads[keypadid][kp_y] = y;
	e_KeyPads[keypadid][kp_z] = z;
	DestroyDynamicArea(e_KeyPads[keypadid][kp_area]);
	e_KeyPads[keypadid][kp_area] = CreateDynamicSphere(x, y, z, 2.5, e_KeyPads[keypadid][kp_world], e_KeyPads[keypadid][kp_interior]);
	return 1;
}

stock SetKeypadCode(keypadid, new_code[])
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return 0;
	if(!strlen(new_code) || strlen(new_code) > 10 || !keypad_IsNumeric(new_code)) return 0;
	KP_Text[keypadid] = "";
	strcat(KP_Text[keypadid], new_code);
	e_KeyPads[keypadid][kp_length] = strlen(new_code);
	return 1;
}

stock GetKeypadPos(keypadid, &Float:x, &Float:y, &Float:z)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return -1;
	if(e_KeyPads[keypadid][kp_area] == -1) return -1;
	x = e_KeyPads[keypadid][kp_x];
	y = e_KeyPads[keypadid][kp_y];
	z = e_KeyPads[keypadid][kp_z];
	return 1;
}

stock GetPlayerKeypadID(playerid)
{
	return kp_id[playerid];
}

stock GetKeypadHoverColor(keypadid)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return -1;
	if(e_KeyPads[keypadid][kp_area] == -1) return -1;
	return e_KeyPads[keypadid][kp_color];
}

stock GetKeypadInterior(keypadid)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return -1;
	if(e_KeyPads[keypadid][kp_area] == -1) return -1;
	return e_KeyPads[keypadid][kp_interior];
}

stock GetKeypadWorld(keypadid)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return -1;
	if(e_KeyPads[keypadid][kp_area] == -1) return -1;
	return e_KeyPads[keypadid][kp_world];
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(IsPlayerNPC(playerid)) return 1;
	for(new i = 0; i < MAX_KEYPADS; i++)
	{
	    if(e_KeyPads[i][kp_area] == areaid)
	    {
			OnPlayerEnterKeypadArea(playerid, i);
			break;
	    }
	}

	#if defined kp_OnPlayerEnterDynamicArea
		return kp_OnPlayerEnterDynamicArea(playerid, areaid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea kp_OnPlayerEnterDynamicArea
#if defined kp_OnPlayerEnterDynamicArea
	forward kp_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

forward OnKeypadResponse(playerid, keypadid, bool:response, bool:success, code[]);

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(kp_id[playerid] != -1)
	{
		if(clickedid == Text:0xFFFF)
		{
		    PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
			OnKeypadResponse(playerid, kp_id[playerid], false, false, "");
	    	return 1;
		}
		for(new i = 0; i < 11; i++)
		{
		    if(clickedid == TD_KeyPad[i])
		    {
		        PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
		        strcat(KP_PlayerText[playerid], kp_chars[i-1]);
		        if(strlen(KP_PlayerText[playerid]) == GetKeypadLength(kp_id[playerid]))
		        {
		            if(strcmp(KP_PlayerText[playerid], KP_Text[kp_id[playerid]], true) == 0)
		            {
		                PlayerPlaySound(playerid, 21002, 0.0, 0.0, 0.0);
		                CancelSelectTextDraw(playerid);
		                TextDrawHideForPlayer(playerid, TD_KeyPad[12]);
		                TextDrawShowForPlayer(playerid, TD_KeyPad[14]);
		                kp_ptimer[playerid] = SetTimerEx("KEYPAD_DONE", 1000, false, "i", playerid);
                        OnKeypadResponse(playerid, kp_id[playerid], true, true, KP_PlayerText[playerid]);
                        kp_id[playerid] = -1;
                        KP_PlayerText[playerid] = "";
						return 1;
					}
					CancelSelectTextDraw(playerid);
					PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
					TextDrawHideForPlayer(playerid, TD_KeyPad[11]);
					TextDrawShowForPlayer(playerid, TD_KeyPad[13]);
					kp_ptimer[playerid] = SetTimerEx("KEYPAD_DONE", 1000, false, "i", playerid);
					OnKeypadResponse(playerid, kp_id[playerid], true, false, KP_PlayerText[playerid]);
					kp_id[playerid] = -1;
     				KP_PlayerText[playerid] = "";
				}
		    }
		}
	}
	return 0;
}

stock GetKeypadLength(keypadid)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return 0;
	if(e_KeyPads[keypadid][kp_area] == -1) return 0;
	return e_KeyPads[keypadid][kp_length];
}

stock CreateKeypadEx(Float:x, Float:y, Float:z, code[], color = 0x00FF00FF, worldid = 0, interior = 0)
{
	if(!strlen(code) || strlen(code) > 10 || !keypad_IsNumeric(code)) return -1;
	for(new i = 0; i < MAX_KEYPADS; i++)
	{
	    if(e_KeyPads[i][kp_area] != -1) continue;
    	e_KeyPads[i][kp_area] = CreateDynamicSphere(x, y, z, 2.5, worldid, interior);
    	e_KeyPads[i][kp_color] = color;
    	e_KeyPads[i][kp_x] = x;
    	e_KeyPads[i][kp_y] = y;
    	e_KeyPads[i][kp_z] = z;
    	e_KeyPads[i][kp_world] = worldid;
    	e_KeyPads[i][kp_interior] = interior;
		e_KeyPads[i][kp_length] = strlen(code);
		strcat(KP_Text[i], code);
		return i;
	}
	return -1;
}

stock CreateKeypad(code[], color = 0x00FF00FF)
{
	if(!strlen(code) || strlen(code) > 10 || !keypad_IsNumeric(code)) return -1;
	for(new i = 0; i < MAX_KEYPADS; i++)
	{
	    if(e_KeyPads[i][kp_area] != -1) continue;
    	e_KeyPads[i][kp_area] = 0;
    	e_KeyPads[i][kp_color] = color;
		e_KeyPads[i][kp_length] = strlen(code);
		strcat(KP_Text[i], code);
		return i;
	}
	return -1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(IsPlayerNPC(playerid)) return 1;
	KillTimer(kp_ptimer[playerid]);
	kp_ptimer[playerid] = 0;
	kp_id[playerid] = -1;
	KP_PlayerText[playerid] = "";
	return 1;
}

stock ShowPlayerKeypad(playerid, keypadid)
{
	if(keypadid < 0 || keypadid >= MAX_KEYPADS) return 0;
	if(IsPlayerNPC(playerid) || kp_id[playerid] != -1) return 0;
	if(e_KeyPads[keypadid][kp_area] == -1) return 0;
	kp_id[playerid] = keypadid;
 	KP_PlayerText[playerid] = "";
	for(new i = 0; i < 13; i++)
	{
	    TextDrawShowForPlayer(playerid, TD_KeyPad[i]);
	}
	SelectTextDraw(playerid, e_KeyPads[keypadid][kp_color]);
	return 1;
}

stock HidePlayerKeypad(playerid, keypadid)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return 0;
	if(kp_id[playerid] != keypadid) return 0;
	KillTimer(kp_ptimer[playerid]);
	kp_ptimer[playerid] = 0;
 	KP_PlayerText[playerid] = "";
	for(new i = 0; i < 15; i++)
	{
	    TextDrawHideForPlayer(playerid, TD_KeyPad[i]);
	}
	CancelSelectTextDraw(playerid);
	kp_id[playerid] = -1;
	return 1;
}

stock DestroyKeypad(keypadid)
{
    if(keypadid < 0 || keypadid >= MAX_KEYPADS) return 0;
	if(e_KeyPads[keypadid][kp_area] == -1) return 0;
	foreach(new i : Player)
	{
	    if(kp_id[i] != keypadid) continue;
	    HidePlayerKeypad(i, keypadid);
	}
	e_KeyPads[keypadid][kp_area] = -1;
	e_KeyPads[keypadid][kp_color] = 0;
	e_KeyPads[keypadid][kp_x] = 0.0;
	e_KeyPads[keypadid][kp_y] = 0.0;
	e_KeyPads[keypadid][kp_z] = 0.0;
	e_KeyPads[keypadid][kp_world] = 0;
	e_KeyPads[keypadid][kp_interior] = 0;
	e_KeyPads[keypadid][kp_length] = 0;
	KP_Text[keypadid] = "";
	return 1;
}

stock DestroyAllKeypads()
{
	for(new i = 0; i < MAX_KEYPADS; i++)
	{
	    DestroyKeypad(i);
	}
	return 1;
}

CreateKP()
{
    TD_KeyPad[0] = TextDrawCreate(548.666625, 268.814849, "box");
	TextDrawLetterSize(TD_KeyPad[0], 0.000000, 12.813338);
	TextDrawTextSize(TD_KeyPad[0], 635.000000, 0.000000);
	TextDrawAlignment(TD_KeyPad[0], 1);
	TextDrawColor(TD_KeyPad[0], -1);
	TextDrawUseBox(TD_KeyPad[0], 1);
	TextDrawBoxColor(TD_KeyPad[0], -1061109505);
	TextDrawSetShadow(TD_KeyPad[0], 0);
	TextDrawBackgroundColor(TD_KeyPad[0], 255);
	TextDrawFont(TD_KeyPad[0], 1);
	TextDrawSetProportional(TD_KeyPad[0], 1);
	TD_KeyPad[1] = TextDrawCreate(563.900085, 273.610839, "1");
	TextDrawLetterSize(TD_KeyPad[1], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[1], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[1], 2);
	TextDrawColor(TD_KeyPad[1], -1);
	TextDrawUseBox(TD_KeyPad[1], 1);
	TextDrawBoxColor(TD_KeyPad[1], 255);
	TextDrawSetShadow(TD_KeyPad[1], 0);
	TextDrawBackgroundColor(TD_KeyPad[1], 255);
	TextDrawFont(TD_KeyPad[1], 2);
	TextDrawSetProportional(TD_KeyPad[1], 1);
	TD_KeyPad[2] = TextDrawCreate(591.900573, 273.610839, "2");
	TextDrawLetterSize(TD_KeyPad[2], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[2], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[2], 2);
	TextDrawColor(TD_KeyPad[2], -1);
	TextDrawUseBox(TD_KeyPad[2], 1);
	TextDrawBoxColor(TD_KeyPad[2], 255);
	TextDrawSetShadow(TD_KeyPad[2], 0);
	TextDrawBackgroundColor(TD_KeyPad[2], 255);
	TextDrawFont(TD_KeyPad[2], 2);
	TextDrawSetProportional(TD_KeyPad[2], 1);
	TD_KeyPad[3] = TextDrawCreate(619.201049, 273.610839, "3");
	TextDrawLetterSize(TD_KeyPad[3], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[3], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[3], 2);
	TextDrawColor(TD_KeyPad[3], -1);
	TextDrawUseBox(TD_KeyPad[3], 1);
	TextDrawBoxColor(TD_KeyPad[3], 255);
	TextDrawSetShadow(TD_KeyPad[3], 0);
	TextDrawBackgroundColor(TD_KeyPad[3], 255);
	TextDrawFont(TD_KeyPad[3], 2);
	TextDrawSetProportional(TD_KeyPad[3], 1);
	TD_KeyPad[4] = TextDrawCreate(563.900085, 302.311340, "4");
	TextDrawLetterSize(TD_KeyPad[4], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[4], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[4], 2);
	TextDrawColor(TD_KeyPad[4], -1);
	TextDrawUseBox(TD_KeyPad[4], 1);
	TextDrawBoxColor(TD_KeyPad[4], 255);
	TextDrawSetShadow(TD_KeyPad[4], 0);
	TextDrawBackgroundColor(TD_KeyPad[4], 255);
	TextDrawFont(TD_KeyPad[4], 2);
	TextDrawSetProportional(TD_KeyPad[4], 1);
	TD_KeyPad[5] = TextDrawCreate(592.300292, 302.311340, "5");
	TextDrawLetterSize(TD_KeyPad[5], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[5], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[5], 2);
	TextDrawColor(TD_KeyPad[5], -1);
	TextDrawUseBox(TD_KeyPad[5], 1);
	TextDrawBoxColor(TD_KeyPad[5], 255);
	TextDrawSetShadow(TD_KeyPad[5], 0);
	TextDrawBackgroundColor(TD_KeyPad[5], 255);
	TextDrawFont(TD_KeyPad[5], 2);
	TextDrawSetProportional(TD_KeyPad[5], 1);
	TD_KeyPad[6] = TextDrawCreate(619.098754, 302.311340, "6");
	TextDrawLetterSize(TD_KeyPad[6], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[6], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[6], 2);
	TextDrawColor(TD_KeyPad[6], -1);
	TextDrawUseBox(TD_KeyPad[6], 1);
	TextDrawBoxColor(TD_KeyPad[6], 255);
	TextDrawSetShadow(TD_KeyPad[6], 0);
	TextDrawBackgroundColor(TD_KeyPad[6], 255);
	TextDrawFont(TD_KeyPad[6], 2);
	TextDrawSetProportional(TD_KeyPad[6], 1);
	TD_KeyPad[7] = TextDrawCreate(563.900085, 331.311950, "7");
	TextDrawLetterSize(TD_KeyPad[7], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[7], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[7], 2);
	TextDrawColor(TD_KeyPad[7], -1);
	TextDrawUseBox(TD_KeyPad[7], 1);
	TextDrawBoxColor(TD_KeyPad[7], 255);
	TextDrawSetShadow(TD_KeyPad[7], 0);
	TextDrawBackgroundColor(TD_KeyPad[7], 255);
	TextDrawFont(TD_KeyPad[7], 2);
	TextDrawSetProportional(TD_KeyPad[7], 1);
	TD_KeyPad[8] = TextDrawCreate(592.600402, 331.311950, "8");
	TextDrawLetterSize(TD_KeyPad[8], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[8], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[8], 2);
	TextDrawColor(TD_KeyPad[8], -1);
	TextDrawUseBox(TD_KeyPad[8], 1);
	TextDrawBoxColor(TD_KeyPad[8], 255);
	TextDrawSetShadow(TD_KeyPad[8], 0);
	TextDrawBackgroundColor(TD_KeyPad[8], 255);
	TextDrawFont(TD_KeyPad[8], 2);
	TextDrawSetProportional(TD_KeyPad[8], 1);
	TD_KeyPad[9] = TextDrawCreate(619.199523, 331.311950, "9");
	TextDrawLetterSize(TD_KeyPad[9], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[9], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[9], 2);
	TextDrawColor(TD_KeyPad[9], -1);
	TextDrawUseBox(TD_KeyPad[9], 1);
	TextDrawBoxColor(TD_KeyPad[9], 255);
	TextDrawSetShadow(TD_KeyPad[9], 0);
	TextDrawBackgroundColor(TD_KeyPad[9], 255);
	TextDrawFont(TD_KeyPad[9], 2);
	TextDrawSetProportional(TD_KeyPad[9], 1);
	TD_KeyPad[10] = TextDrawCreate(592.600158, 360.198089, "0");
	TextDrawLetterSize(TD_KeyPad[10], 0.645999, 2.085333);
	TextDrawTextSize(TD_KeyPad[10], 10.000000, 20.000000);
	TextDrawAlignment(TD_KeyPad[10], 2);
	TextDrawColor(TD_KeyPad[10], -1);
	TextDrawUseBox(TD_KeyPad[10], 1);
	TextDrawBoxColor(TD_KeyPad[10], 255);
	TextDrawSetShadow(TD_KeyPad[10], 0);
	TextDrawBackgroundColor(TD_KeyPad[10], 255);
	TextDrawFont(TD_KeyPad[10], 2);
	TextDrawSetProportional(TD_KeyPad[10], 1);
	TD_KeyPad[11] = TextDrawCreate(552.398559, 354.940704, "ld_spac:white");
	TextDrawTextSize(TD_KeyPad[11], 22.000000, 26.000000);
	TextDrawAlignment(TD_KeyPad[11], 1);
	TextDrawColor(TD_KeyPad[11], 1375731967);
	TextDrawSetShadow(TD_KeyPad[11], 0);
	TextDrawBackgroundColor(TD_KeyPad[11], 255);
	TextDrawFont(TD_KeyPad[11], 4);
	TextDrawSetProportional(TD_KeyPad[11], 0);
	TD_KeyPad[12] = TextDrawCreate(608.196289, 354.940704, "ld_spac:white");
	TextDrawTextSize(TD_KeyPad[12], 22.000000, 26.000000);
	TextDrawAlignment(TD_KeyPad[12], 1);
	TextDrawColor(TD_KeyPad[12], 5374207);
	TextDrawSetShadow(TD_KeyPad[12], 0);
	TextDrawBackgroundColor(TD_KeyPad[12], 255);
	TextDrawFont(TD_KeyPad[12], 4);
	TextDrawSetProportional(TD_KeyPad[12], 0);
	TD_KeyPad[13] = TextDrawCreate(552.398559, 354.940704, "ld_spac:white");
	TextDrawTextSize(TD_KeyPad[13], 22.000000, 26.000000);
	TextDrawAlignment(TD_KeyPad[13], 1);
	TextDrawColor(TD_KeyPad[13], 0xFF0000FF);
	TextDrawSetShadow(TD_KeyPad[13], 0);
	TextDrawBackgroundColor(TD_KeyPad[13], 255);
	TextDrawFont(TD_KeyPad[13], 4);
	TextDrawSetProportional(TD_KeyPad[13], 0);
	TD_KeyPad[14] = TextDrawCreate(552.398559, 354.940704, "ld_spac:white");
	TextDrawTextSize(TD_KeyPad[14], 22.000000, 26.000000);
	TextDrawAlignment(TD_KeyPad[14], 1);
	TextDrawColor(TD_KeyPad[14], 0x00FF00FF);
	TextDrawSetShadow(TD_KeyPad[14], 0);
	TextDrawBackgroundColor(TD_KeyPad[14], 255);
	TextDrawFont(TD_KeyPad[14], 4);
	TextDrawSetProportional(TD_KeyPad[14], 0);
	for(new i = 1; i < 11; i++)
	{
	    TextDrawSetSelectable(TD_KeyPad[i], 1);
	}
	return 1;
}

#if defined FILTERSCRIPT

hook OnFilterScriptInit()
{
	for(new i = 0; i < MAX_KEYPADS; i++)
	{
	    e_KeyPads[i][kp_area] = -1;
	}
    CreateKP();
	return 1;
}

hook OnFilterScriptExit()
{
	DestroyAllKeypads();
    for(new i = 0; i < 15; i++)
	{
	    TextDrawDestroy(TD_KeyPad[i]);
	}
	return 1;
}

#else

hook OnGameModeInit()
{
    for(new i = 0; i < MAX_KEYPADS; i++)
	{
	    e_KeyPads[i][kp_area] = -1;
	}
	CreateKP();
	return 1;
}

hook OnGameModeExit()
{
	DestroyAllKeypads();
    for(new i = 0; i < 15; i++)
	{
	    TextDrawDestroy(TD_KeyPad[i]);
	}
	return 1;
}

#endif

stock keypad_IsNumeric(const isthisnumeric[])
{
	if(!strlen(isthisnumeric)) return 0;
	for(new i = 0; i < strlen(isthisnumeric); i++)
	{
		if(isthisnumeric[i] > '9' || isthisnumeric[i] < '0') return 0;
	}
	return 1;
}

//EOF.