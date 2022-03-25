// built-in include guard removal
// just in case the user has a local dependency with the same file name
#if defined _inc_SAMP037COMPATFIX
	#undef _inc_SAMP037COMPATFIX
#endif
// custom include-guard to ensure we don't duplicate
#if defined _SAMP037COMPATFIX_included
	#endinput
#endif
#define _SAMP037COMPATFIX_included

native scompat_SetPlayerVirtualWorld(playerid, worldid); 

scmpfix_SetPlayerVirtualWorld(playerid, worldid)
{
	if(IsClient037(playerid))
		return scompat_SetPlayerVirtualWorld(playerid, worldid);
	else
		return SetPlayerVirtualWorld(playerid, worldid);
}

// Hook
#if defined _ALS_SetPlayerVirtualWorld
#undef SetPlayerVirtualWorld
#else
#define _ALS_SetPlayerVirtualWorld
#endif

#define SetPlayerVirtualWorld scmpfix_SetPlayerVirtualWorld