/*
	actor+

		Include started at 19/01/18.
		Last update: 30/08/18
		-Dayrion
		Public version - v5.0.2
*/


#if defined _actor_plus_included
	#endinput
#else
	#define _actor_plus_included
#endif

#if __Pawn < 0x030A
	#error "<actor+> You must use the latest Zeex's compiler due to implicite 4D arrays - Download: https://github.com/pawn-lang/compiler/releases"
#endif

#if !defined _samp_included
	#error "<actor+> a_samp is not included."
#endif

#if defined AP_DEBUG_ENABLED
	#define APD(%0) printf("<actor+> "%0)
#else
	#define APD(%0);
#endif

// =====================================================================================

#if defined _streamer_included && !defined FORCE_DISABLED_STREAMER
	#if !defined GetDynamicActorAnimation
		#warning "<actor+> Streamer version is not up to date. actor+ won't use it"
		#define USING_STREAMER (0)
		#define DEFAULT_IS_DYNAMIC_PARAMETER (false)
	#else
		#define USING_STREAMER (1)
		#define DEFAULT_IS_DYNAMIC_PARAMETER (true)
		#if defined AP_DEBUG_ENABLED
			#warning "<actor+> Using streamer"
		#endif
	#endif
#else
	#define USING_STREAMER (0)
	#define DEFAULT_IS_DYNAMIC_PARAMETER (false)
#endif

// =====================================================================================

#if defined _inc_y_iterate && !defined FORCE_DISABLED_Y_ITERATE
	#define USING_Y_ITERATE (1)
	#if defined AP_DEBUG_ENABLED
		#warning "<actor+> Using y_iterate"
	#endif
#else
	#define USING_Y_ITERATE (0)
#endif

// =====================================================================================

#if defined YSI_timer && defined defer && !defined FORCE_DISABLED_Y_TIMERS
	#define USING_Y_TIMERS (1)
	#if defined AP_DEBUG_ENABLED
		#warning "<actor+> Using y_timers"
	#endif
#else
	#define USING_Y_TIMERS (0)
#endif

// =====================================================================================

#if defined PAWNRAKNET_INC_ && !defined FORCE_DISABLED_PAWNRAKNET
	#define USING_PAWN_RAKNET (1)
	#if defined AP_DEBUG_ENABLED
		#warning "<actor+> Using pawn_raknet"
	#endif
#else
	#define USING_PAWN_RAKNET (0)
#endif

// =====================================================================================

#if !defined GetDistanceBetween2Points
	#define GetDistanceBetween2Points(%0,%1,%2,%3,%4,%5) VectorSize(%0-%3, %1-%4, %2-%5)
#endif

#if !defined strcpy
	#define strcpy(%0,%1) strcat((%0[0] = EOS, %0), %1)
#endif

#if !defined isnull
	#define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

// =====================================================================================

// #define DONT_DETECT_OPTA can be defined if you won't detect use any timer for OnPlayerTargetActor(playerid, actorid, weaponid);

enum _:E_TYPE_SEARCH(<<= 1)
{
	SEARCH_TYPE_DYNAMIC = 1,
	SEARCH_TYPE_STATIC,
	SEARCH_TYPE_ALL = SEARCH_TYPE_DYNAMIC | SEARCH_TYPE_STATIC
};

#define 	MULTIPLE_TARGET_FOUND 	(0xFFFF01)
#define 	DEFAULT_ACTOR_VALUE 	(0x8FFFFFFF)

#if !defined DONT_DETECT_OPTA
	#define DEFAULT_CHECKING_TIME 	(200)
#else
	#if defined AP_DEBUG_ENABLED
		#warning "<actor+> OnPlayerTargetActor is unavailable (from DONT_DETECT_OPTA)"
	#endif
#endif

#define 	DYNAMIC_CATEGORY				(1)
#define 	STATIC_CATEGORY					(0)
#define 	DEFAULT_ACTOR_REPLACEMENT 		(500)
#define 	MAX_ANIMATION_LIBRARY_LENGTH	(12)
#define 	MAX_ANIMATION_NAME_LENGTH		(23)
#define 	INVALID_RANGE_ID				(65535.0)

#if !defined DEFAULT_ACTOR_DRAW_DISTANCE
	#define DEFAULT_ACTOR_DRAW_DISTANCE (13.0)
#endif

#if !defined DEFAULT_TEXT_RANGE_DETECTION
	#define DEFAULT_TEXT_RANGE_DETECTION (3.0)
#endif

#if !defined MAX_ACTOR_LABEL_LENGTH
	#define MAX_ACTOR_LABEL_LENGTH (60)
#endif

#if !defined DEFAULT_ACTOR_COLOR
	#define DEFAULT_ACTOR_COLOR (0xFFFFFFFF)
#endif

#if !defined DEFAULT_ACTOR_COLOR_NAME
	#define DEFAULT_ACTOR_COLOR_NAME (0x6699FFFF)
#endif

// =====================================================================================

#if defined OnPlayerShotActor
	forward OnPlayerShotActor(playerid, actorid, weaponid, bool:IsDynamicActor);
#endif

#if defined OnPlayerTargetActor
	forward OnPlayerTargetActor(playerid, actorid, weaponid);
#endif

#if defined OnPlayerStopTargetActor
	forward OnPlayerStopTargetActor(playerid, actorid, weaponid);
#endif

#if defined OnPlayerMakeDamageToActor
	forward OnPlayerMakeDamageToActor(playerid, damaged_actorid, Float:amount, weaponid, bodypart, bool:death, bool:IsDynamicActor);
#endif

#if defined OnActorDeath
	forward OnActorDeath(actorid, killerid, reason, bool:IsDynamicActor);
#endif

#if defined OnActorSpawn
	forward OnActorSpawn(actorid, bool:IsDynamicActor);
#endif

#if defined OnPlayerStreamForActor
	#if !USING_PAWN_RAKNET
		#warning "<actor+> Pawn RakNet isn't included ; OnPlayerStreamForActor(...) won't be called."
	#endif
	forward OnPlayerStreamForActor(forplayerid, actorid, actor_flags, bool:IsDynamicActor);
#endif

#if defined OnDynamicActorInteriorChange
	forward OnDynamicActorInteriorChange(actorid, oldinterior, newinteriorid);
#endif

#if defined OnActorVirtualWorldChange
	forward OnActorVirtualWorldChange(actorid, oldvw, newvw, bool:IsDynamicActor);
#endif

#if defined OnPlayerTextNearActor
	forward OnPlayerTextNearActor(playerid, actorid, text[], bool:IsDynamicActor);
#endif

// =======================================================================================================================================================================================
// =======================================================================================================================================================================================

enum E_ACTOR_PLUS_DATA
{
	eapSkin,
	eapName[MAX_PLAYER_NAME],
	Float:eapPosX,
	Float:eapPosY,
	Float:eapPosZ,
	Float:eapPosAngle,
	eapInvulnerable,
	Float:eapHealth,
	eapVW,

	#if USING_STREAMER
	eapInt,
	eapPlayerid,
	Float:eapStreamDistance,
	STREAMER_TAG_AREA:eapAreaid,
	eapPriority,
	#endif

	#if !USING_Y_TIMERS
	eapTimerChatBubble,
	#else
	Timer:eapTimerChatBubble,
	#endif

	// Text3D -- Label
	Text3D:eapLabel,
	eapLabelText[MAX_ACTOR_LABEL_LENGTH],
	eapLabelColor,
	eapLabelNameColor,
	Float:eapLabelPosX,
	Float:eapLabelPosY,
	Float:eapLabelPosZ,
	Float:eapLabelDrawDistance,
	eapLabelVW,
	eapLabelInt
}

enum E_ACTOR_PLUS_FLAGS (<<= 1)
{
	HAS_NAME_DISPLAYED = 1,
	HAS_TEXT_DISPLAYED,
	#if !USING_Y_ITERATE
	IS_EXISTING,
	#endif
	IS_DEAD,
	IS_INVULNERABLE,
};

enum E_ACTOR_PLUS_ANIM_DATA
{
	apadAnimLib[MAX_ANIMATION_LIBRARY_LENGTH],
	apadLibLength,
	apadAnimName[MAX_ANIMATION_NAME_LENGTH],
	apadAnimLength,
	Float:apadDelta,
	apadLoop,
	apadLockx,
	apadLocky,
	apadFreeze,
	apadTime
};

// =====================================================================================

enum E_PLAYER_ACTOR
{
	appAnimLib[MAX_ANIMATION_LIBRARY_LENGTH],
	appLibLength,
	appAnimName[MAX_ANIMATION_NAME_LENGTH],
	appAnimLength,
	Float:appDelta,
	appLoop,
	appLockx,
	appLocky,
	appFreeze,
	appTime,

	Float:appPosX,
	Float:appPosY,
	Float:appPosZ,
	Float:appPosAngle,
};

enum _:E_PLAYER_AP_FLAGS(<<= 1)
{
	HIDE_TYPE_NONE = 1,
	HIDE_TYPE_ONE_TIME,
	HIDE_TYPE_PERMANENT,

	ANIMATION_PLAY_NONE,
	ANIMATION_PLAY_ONE_TIME,
	ANIMATION_PLAY_PERMANENT,

	FAKE_POSITION_NONE,
	FAKE_POSITION_ONE_TIME,
	FAKE_POSITION_PERMANENT,
};

enum E_AP_AIMING_ACTORS
{
	eaaActorID,
	bool:eaaIsDynamicActor,
}

// =======================================================================================================================================================================================
// =======================================================================================================================================================================================
stock static
	// Actors
	Actors_Plus[MAX_ACTORS][2][E_ACTOR_PLUS_DATA],
	E_ACTOR_PLUS_FLAGS:Actors_Flags[MAX_ACTORS][2],
	Actors_Plus_Animations[MAX_ACTORS][E_ACTOR_PLUS_ANIM_DATA],

	// Players
	PAttributes_StaticActor[MAX_PLAYERS][MAX_ACTORS][E_PLAYER_ACTOR], // Avoiding to create an 4D array which should be Player_Attributes[MAX_PLAYERS][MAX_ACTORS][2][E_PLAYER_ACTOR]
	PAttributes_DynamicActor[MAX_PLAYERS][MAX_ACTORS][E_PLAYER_ACTOR],
	Player_Actor_Target[MAX_PLAYERS][E_AP_AIMING_ACTORS] = {{INVALID_ACTOR_ID, false}, {INVALID_ACTOR_ID, false}, ...},
	Player_Flags[MAX_PLAYERS][2][MAX_ACTORS];


#if USING_Y_ITERATE && USING_STREAMER
	new
		Iterator:Dynamic_Actor<MAX_ACTORS>;
#endif

// =====================================================================================

#define ActorHasNameDisplayed(%0,%1) (Actors_Flags[%0][%1] & HAS_NAME_DISPLAYED)
#define ActorHasTextDisplayed(%0,%1) (Actors_Flags[%0][%1] & HAS_TEXT_DISPLAYED)

// =======================================================================================================================================================================================
// =======================================================================================================================================================================================

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype != BULLET_HIT_TYPE_NONE || (fX == 0.0 && fY == 0.0))
		return 1;

	new bool:isdynamic,
		actorid = GetNearestActorByCoord(fX, fY, fZ, isdynamic, .max_range = 1.0);

	if(actorid != INVALID_ACTOR_ID)
		CallRemoteFunction("OnPlayerShotActor", "iiii", playerid, actorid, weaponid, isdynamic);

	#if defined AP_OnPlayerWeaponShot
		return AP_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerWeaponShot
    #undef OnPlayerWeaponShot
#else
    #define _ALS_OnPlayerWeaponShot
#endif
#define OnPlayerWeaponShot AP_OnPlayerWeaponShot
#if defined AP_OnPlayerWeaponShot
	forward AP_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif

// =====================================================================================

public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float:amount, weaponid, bodypart)
{
	new 
		Float:fOriginX, Float:fOriginY, Float:fOriginZ,
		Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;

	GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);

	if(GetNearestActorByCoord(fHitPosX, fHitPosY, fHitPosZ, .type = SEARCH_TYPE_STATIC, .max_range = 1.0) == damaged_actorid)
	{
		new bool:death = ((Actors_Plus[damaged_actorid][STATIC_CATEGORY][eapHealth] - amount) <= 0.0);
		
		#if defined OnPlayerMakeDamageToActor

			if(!OnPlayerMakeDamageToActor(playerid, damaged_actorid, amount, weaponid, bodypart, death, false))
			{
				#if defined AP_OnPlayerGiveDamageActor
					return AP_OnPlayerGiveDamageActor(playerid, damaged_actorid, amount, weaponid, bodypart);
				#else
					return 1;
				#endif
			}

			Actors_Plus[damaged_actorid][STATIC_CATEGORY][eapHealth] -= amount;
			
			if(death)
			{
				Actors_Plus[damaged_actorid][STATIC_CATEGORY][eapHealth] = 0.0;
				Actors_Flags[damaged_actorid][STATIC_CATEGORY] |= IS_DEAD;
			}

			SetActorHealth(damaged_actorid, Actors_Plus[damaged_actorid][STATIC_CATEGORY][eapHealth]);
		#endif

		if(death)
			CallRemoteFunction("OnActorDeath", "iiii", damaged_actorid, playerid, weaponid, false);

		#if defined AP_OnPlayerGiveDamageActor
			return AP_OnPlayerGiveDamageActor(playerid, damaged_actorid, amount, weaponid, bodypart);
		#else
			return 1;
		#endif
	}

	#if defined AP_OnPlayerGiveDamageActor
		return AP_OnPlayerGiveDamageActor(playerid, damaged_actorid, amount, weaponid, bodypart);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerGiveDamageActor
    #undef OnPlayerGiveDamageActor
#else
    #define _ALS_OnPlayerGiveDamageActor
#endif
#define OnPlayerGiveDamageActor AP_OnPlayerGiveDamageActor
#if defined AP_OnPlayerGiveDamageActor
	forward AP_OnPlayerGiveDamageActor(playerid, damaged_actorid, Float:amount, weaponid, bodypart);
#endif


#if USING_STREAMER

public OnPlayerGiveDamageDynamicActor(playerid, STREAMER_TAG_ACTOR:actorid, Float:amount, weaponid, bodypart)
{
	new 
		Float:fOriginX, Float:fOriginY, Float:fOriginZ,
		Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;

	GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);

	if(GetNearestActorByCoord(fHitPosX, fHitPosY, fHitPosZ, .type = SEARCH_TYPE_DYNAMIC, .max_range = 1.0) == actorid)
	{
		new bool:death = ((Actors_Plus[actorid][DYNAMIC_CATEGORY][eapHealth] - amount) <= 0.0);

		#pragma unused death

		#if defined OnPlayerMakeDamageToActor

			if(!OnPlayerMakeDamageToActor(playerid, actorid, amount, weaponid, bodypart, true, death))
			{
				#if defined OnPlayerGiveDamageDynamicActorA
					return OnPlayerGiveDamageDynamicActorA(playerid, actorid, amount, weaponid, bodypart);
				#else
					return 1;
				#endif
			}

			Actors_Plus[actorid][DYNAMIC_CATEGORY][eapHealth] -= amount;
			
			if(death)
			{
				Actors_Flags[actorid][DYNAMIC_CATEGORY] |= IS_DEAD;
				Actors_Plus[actorid][DYNAMIC_CATEGORY][eapHealth] = 0.0;
			}

			SetDynamicActorHealth(actorid, Actors_Plus[actorid][DYNAMIC_CATEGORY][eapHealth]);
		#endif

		#if defined OnActorDeath
			if(death)
				OnActorDeath(actorid, playerid, weaponid, true);
		#endif

		#if defined OnPlayerGiveDamageDynamicActorA
			return OnPlayerGiveDamageDynamicActorA(playerid, actorid, amount, weaponid, bodypart);
		#else
			return 1;
		#endif
	}

	#if defined OnPlayerGiveDamageDynamicActorA
		return OnPlayerGiveDamageDynamicActorA(playerid, actorid, amount, weaponid, bodypart);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerGiveDamageDynActor
    #undef OnPlayerGiveDamageDynamicActor
#else
    #define _ALS_OnPlayerGiveDamageDynActor
#endif
#define OnPlayerGiveDamageDynamicActor OnPlayerGiveDamageDynamicActorA
#if defined OnPlayerGiveDamageDynamicActorA
	forward OnPlayerGiveDamageDynamicActorA(playerid, STREAMER_TAG_ACTOR:actorid, Float:amount, weaponid, bodypart);
#endif

#endif // #if USING_STREAMER

public OnPlayerConnect(playerid)
{
	Player_Actor_Target[playerid][eaaActorID] = INVALID_ACTOR_ID;
	Player_Actor_Target[playerid][eaaIsDynamicActor] = false;
	new reset_player_actors_flags[MAX_ACTORS] = {(HIDE_TYPE_NONE | ANIMATION_PLAY_NONE | FAKE_POSITION_NONE), (HIDE_TYPE_NONE | ANIMATION_PLAY_NONE | FAKE_POSITION_NONE), ...};
	Player_Flags[playerid][STATIC_CATEGORY] = reset_player_actors_flags;
	Player_Flags[playerid][DYNAMIC_CATEGORY] = reset_player_actors_flags;
	#if defined AP_OnPlayerConnect
	    return AP_OnPlayerConnect(playerid);
	#else
	    return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect AP_OnPlayerConnect
#if defined AP_OnPlayerConnect
	forward AP_OnPlayerConnect(playerid);
#endif

// =====================================================================================

#if defined OnPlayerTextNearActor
public OnPlayerText(playerid, text[])
{
	new actorid,
		bool:isdyna;
		
	actorid = GetNearestActorForPlayer(playerid, .isdynamic = isdyna);
	if(actorid != INVALID_ACTOR_ID && IsPlayerInRangeOfActor(playerid, actorid, DEFAULT_TEXT_RANGE_DETECTION, isdyna))
		CallRemoteFunction("OnPlayerTextNearActor", "iisi", playerid, actorid, text, isdyna);

	#if defined AP_OnPlayerText
	    return AP_OnPlayerText(playerid, text[]);
	#else
	    return 1;
	#endif
}

#if defined _ALS_OnPlayerText
    #undef OnPlayerText
#else
    #define _ALS_OnPlayerText
#endif
#define OnPlayerText AP_OnPlayerText
#if defined AP_OnPlayerText
	forward AP_OnPlayerText(playerid, text[]);
#endif

#endif // if defined OnPlayerTextNearActor

// =====================================================================================

#if !defined DONT_DETECT_OPTA
	#if !USING_Y_TIMERS
		forward @AP_AimingActor();
		@AP_AimingActor()
		{
			#if USING_Y_ITERATE
				foreach(new i : Player)
				{
					new actorid = INVALID_ACTOR_ID,
						bool:is_dyna = false;

					#if USING_STREAMER
					if(IsValidDynamicActor(GetPlayerTargetDynamicActor(i)))
					{
						is_dyna = true;
						actorid = GetPlayerTargetDynamicActor(i);
					}
					else
					#endif
					actorid = GetPlayerTargetActor(i);

					if(Player_Actor_Target[i][eaaActorID] != actorid || Player_Actor_Target[i][eaaIsDynamicActor] != is_dyna)
					{
						if(Player_Actor_Target[i][eaaActorID] != INVALID_ACTOR_ID)
							CallRemoteFunction("OnPlayerStopTargetActor", "iiii", i, Player_Actor_Target[i][eaaActorID], GetPlayerWeapon(i), Player_Actor_Target[i][eaaIsDynamicActor]);
						
						if(actorid != INVALID_ACTOR_ID)
							CallRemoteFunction("OnPlayerTargetActor", "iiii", i, actorid, GetPlayerWeapon(i), is_dyna);

						Player_Actor_Target[i][eaaActorID] = actorid;
						Player_Actor_Target[i][eaaIsDynamicActor] = is_dyna;
					}
				}
			#else
				for(new i, j = GetPlayerPoolSize(); i <= j; i++)
				{
					new actorid = INVALID_ACTOR_ID,
						bool:is_dyna = false;

					#if USING_STREAMER
					if(IsValidDynamicActor(GetPlayerTargetDynamicActor(i)))
					{
						is_dyna = true;
						actorid = GetPlayerTargetDynamicActor(i);
					}
					else
					#endif
					actorid = GetPlayerTargetActor(i);

					if(Player_Actor_Target[i][eaaActorID] != actorid || Player_Actor_Target[i][eaaIsDynamicActor] != is_dyna)
					{
						if(Player_Actor_Target[i][eaaActorID] != INVALID_ACTOR_ID)
							CallRemoteFunction("OnPlayerStopTargetActor", "iiii", i, Player_Actor_Target[i][eaaActorID], GetPlayerWeapon(i), Player_Actor_Target[i][eaaIsDynamicActor]);
						
						if(actorid != INVALID_ACTOR_ID)
							CallRemoteFunction("OnPlayerTargetActor", "iiii", i, actorid, GetPlayerWeapon(i), is_dyna);

						Player_Actor_Target[i][eaaActorID] = actorid;
						Player_Actor_Target[i][eaaIsDynamicActor] = is_dyna;
					}
				}
			#endif
			return 1;
		}
	#else
		ptask AP_AimingActor[DEFAULT_CHECKING_TIME](playerid)
		{
			new actorid = INVALID_ACTOR_ID,
				bool:is_dyna = false;

			#if USING_STREAMER
			if(IsValidDynamicActor(GetPlayerTargetDynamicActor(playerid)))
			{
				is_dyna = true;
				actorid = GetPlayerTargetDynamicActor(playerid);
			}
			else
			#endif
			actorid = GetPlayerTargetActor(playerid);

			if(Player_Actor_Target[playerid][eaaActorID] != actorid || Player_Actor_Target[playerid][eaaIsDynamicActor] != is_dyna)
			{
				if(Player_Actor_Target[playerid][eaaActorID] != INVALID_ACTOR_ID)
					CallRemoteFunction("OnPlayerStopTargetActor", "iiii", playerid, Player_Actor_Target[playerid][eaaActorID], GetPlayerWeapon(playerid), Player_Actor_Target[playerid][eaaIsDynamicActor]);

				if(actorid != INVALID_ACTOR_ID)
					CallRemoteFunction("OnPlayerTargetActor", "iiii", playerid, actorid, GetPlayerWeapon(playerid), is_dyna);

				Player_Actor_Target[playerid][eaaActorID] = actorid;
				Player_Actor_Target[playerid][eaaIsDynamicActor] = is_dyna;
			}
			return 1;	
		}
	#endif // if !USING_Y_TIMERS
#endif // if !defined DONT_DETECT_OPTA


#if !defined FILTERSCRIPT
	public OnGameModeInit()
	{
		#if !USING_Y_TIMERS && !defined DONT_DETECT_OPTA
		SetTimer("@AP_AimingActor", DEFAULT_CHECKING_TIME, true);
		#endif

		for(new i, j = GetActorPoolSize(); i != j; i++)
		{
			#if USING_STREAMER
			if(IsValidDynamicActor(i))
			{
				APD("Init | Gamemode ~ Dynamic actorid %i found & added.", i);
				#if USING_Y_ITERATE
					Iter_Add(Dynamic_Actor, i);
				#else
					Actors_Flags[i][DYNAMIC_CATEGORY] |= IS_EXISTING;
				#endif
				GetDynamicActorPos(i, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosX], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosY], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosZ]);
				Actors_Plus[i][DYNAMIC_CATEGORY][eapVW] = GetDynamicActorVirtualWorld(i);
				Actors_Plus[i][DYNAMIC_CATEGORY][eapInvulnerable] = IsDynamicActorInvulnerable(i);
				GetDynamicActorFacingAngle(i, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosAngle]);
				GetDynamicActorHealth(i, Actors_Plus[i][DYNAMIC_CATEGORY][eapHealth]);
				Actors_Plus[i][DYNAMIC_CATEGORY][eapSkin] = -1;
			}
			else
			#endif // if USING_STREAMER
			if(IsValidActor(i))
			{
				APD("Init | Gamemode ~ Static actorid %i found & added.", i);
				#if !USING_Y_ITERATE
					Actors_Flags[i][STATIC_CATEGORY] |= IS_EXISTING;
				#endif
				GetActorPos(i, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]);
				Actors_Plus[i][STATIC_CATEGORY][eapVW] = GetActorVirtualWorld(i);
				Actors_Plus[i][STATIC_CATEGORY][eapInvulnerable] = IsActorInvulnerable(i);
				GetActorFacingAngle(i, Actors_Plus[i][STATIC_CATEGORY][eapPosAngle]);
				GetActorHealth(i, Actors_Plus[i][STATIC_CATEGORY][eapHealth]);
				Actors_Plus[i][STATIC_CATEGORY][eapSkin] = -1;
			}
		}
		#if defined AP_OnGameModeInit
			return AP_OnGameModeInit();
		#else
			return 1;
		#endif
	}

	#if defined _ALS_OnGameModeInit
	    #undef OnGameModeInit
	#else
	    #define _ALS_OnGameModeInit
	#endif
	#if defined AP_OnGameModeInit
		forward AP_OnGameModeInit();
	#endif			
	#define OnGameModeInit AP_OnGameModeInit
#else
	public OnFilterScriptInit()
	{
		#if !USING_Y_TIMERS && !defined DONT_DETECT_OPTA
		SetTimer("@AP_AimingActor", DEFAULT_CHECKING_TIME, true);
		#endif
		
		for(new i, j = GetActorPoolSize(); i != j; i++)
		{
			#if USING_STREAMER
			if(IsValidDynamicActor(i))
			{
				APD("Init | Filterscript ~ Dynamic actorid %i found & added.", i);
				#if USING_Y_ITERATE
					Iter_Add(Dynamic_Actor, i);
				#else
					Actors_Flags[i][DYNAMIC_CATEGORY] |= IS_EXISTING;
				#endif
				GetDynamicActorPos(i, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosX], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosY], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosZ]);
				Actors_Plus[i][DYNAMIC_CATEGORY][eapVW] = GetDynamicActorVirtualWorld(i);
				Actors_Plus[i][DYNAMIC_CATEGORY][eapInvulnerable] = IsDynamicActorInvulnerable(i);
				GetDynamicActorFacingAngle(i, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosAngle]);
				GetDynamicActorHealth(i, Actors_Plus[i][DYNAMIC_CATEGORY][eapHealth]);
				Actors_Plus[i][DYNAMIC_CATEGORY][eapSkin] = -1;
			}
			else
			#endif // if USING_STREAMER
			if(IsValidActor(i))
			{
				APD("Init | Filterscript ~ Static actorid %i found & added.", i);
				#if !USING_Y_ITERATE
					Actors_Flags[i][STATIC_CATEGORY] |= IS_EXISTING;
				#endif
				GetActorPos(i, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]);
				Actors_Plus[i][STATIC_CATEGORY][eapVW] = GetActorVirtualWorld(i);
				Actors_Plus[i][STATIC_CATEGORY][eapInvulnerable] = IsActorInvulnerable(i);
				GetActorFacingAngle(i, Actors_Plus[i][STATIC_CATEGORY][eapPosAngle]);
				GetActorHealth(i, Actors_Plus[i][STATIC_CATEGORY][eapHealth]);
				Actors_Plus[i][STATIC_CATEGORY][eapSkin] = -1;
			}
		}
		#if defined AP_OnFilterScriptInit
		    return AP_OnFilterScriptInit();
		#else
		    return 1;
		#endif
	}

	#if defined _ALS_OnFilterScriptInit
	    #undef OnFilterScriptInit
	#else
	    #define _ALS_OnFilterScriptInit
	#endif
	#if defined AP_OnFilterScriptInit
		forward AP_OnFilterScriptInit();
	#endif
	#define OnFilterScriptInit AP_OnFilterScriptInit
#endif // !defined FILTERSCRIPT


// =======================================================================================================================================================================================
// =======================================================================================================================================================================================

stock RespawnActor(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(Actors_Flags[actorid][isdynamic] & IS_DEAD)
	{
		Actors_Plus[actorid][isdynamic][eapHealth] = 100.0;
		Actors_Flags[actorid][isdynamic] &= ~IS_DEAD;	
	}
	
	RecreateActor(actorid, isdynamic);
	return 1;
}

// =======================================================================================================================================================================================

stock SetActorName(actorid, actor_name[], bool:display, color = DEFAULT_ACTOR_COLOR_NAME, bool:contain_id = false, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!(3 <= strlen(actor_name) <= 24))
		return cellmin;

	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	new formatted_name[31];
	if(contain_id)
		format(formatted_name, sizeof(formatted_name), "%s (%i)", actor_name, actorid);
	else
		strcat(formatted_name, actor_name);
	
	#if !USING_STREAMER
		if(display)
			Actors_Flags[actorid][STATIC_CATEGORY] |= HAS_NAME_DISPLAYED;
		else
			Actors_Flags[actorid][STATIC_CATEGORY] &= ~HAS_NAME_DISPLAYED;
		
		if(!Actors_Plus[actorid][STATIC_CATEGORY][eapLabelNameColor])
			Actors_Plus[actorid][STATIC_CATEGORY][eapLabelNameColor] = color;

		if(!Actors_Plus[actorid][STATIC_CATEGORY][eapLabelColor])
			Actors_Plus[actorid][STATIC_CATEGORY][eapLabelColor] = DEFAULT_ACTOR_COLOR;

		strcpy(Actors_Plus[actorid][STATIC_CATEGORY][eapName], formatted_name);

		if(!(Actors_Flags[actorid][STATIC_CATEGORY] & HAS_TEXT_DISPLAYED))
		{
			Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosX] = 
			Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosY] = 0.0;
			Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosZ] = 1.0;
		}

		if(!Actors_Plus[actorid][STATIC_CATEGORY][eapLabelDrawDistance])
			Actors_Plus[actorid][STATIC_CATEGORY][eapLabelDrawDistance] = DEFAULT_ACTOR_DRAW_DISTANCE;

		if(Actors_Plus[actorid][STATIC_CATEGORY][eapLabel] != Text3D:INVALID_3DTEXT_ID)
		{
			new other_string[MAX_PLAYER_NAME + MAX_ACTOR_LABEL_LENGTH];
			format(other_string, sizeof(other_string), "%s\n{%x}%s", formatted_name, (Actors_Plus[actorid][STATIC_CATEGORY][eapLabelColor] >>> 8), Actors_Plus[actorid][STATIC_CATEGORY][eapLabelText]);
			if(display)
				return Attach3DTextLabelToActor(actorid, other_string, Actors_Plus[actorid][STATIC_CATEGORY][eapLabelNameColor], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosX], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosY], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosZ], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelDrawDistance], .store_string = false);
			
		}
		else if(display)
			return Attach3DTextLabelToActor(actorid, formatted_name, Actors_Plus[actorid][STATIC_CATEGORY][eapLabelNameColor], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosX], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosY], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosZ], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelDrawDistance], .store_string = false);
	
	#else
		if(display)
			Actors_Flags[actorid][isdynamic] |= HAS_NAME_DISPLAYED;
		else
			Actors_Flags[actorid][isdynamic] &= ~HAS_NAME_DISPLAYED;

		if(!Actors_Plus[actorid][isdynamic][eapLabelNameColor])
			Actors_Plus[actorid][isdynamic][eapLabelNameColor] = color;

		if(!Actors_Plus[actorid][isdynamic][eapLabelColor])
			Actors_Plus[actorid][isdynamic][eapLabelColor] = DEFAULT_ACTOR_COLOR;

		strcpy(Actors_Plus[actorid][isdynamic][eapName], formatted_name);

		if(!(Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED))
		{
			Actors_Plus[actorid][isdynamic][eapLabelPosX] = 
			Actors_Plus[actorid][isdynamic][eapLabelPosY] = 0.0;
			Actors_Plus[actorid][isdynamic][eapLabelPosZ] = 1.0;
		}

		if(!Actors_Plus[actorid][isdynamic][eapLabelDrawDistance])
			Actors_Plus[actorid][isdynamic][eapLabelDrawDistance] = DEFAULT_ACTOR_DRAW_DISTANCE;

		if(Actors_Plus[actorid][isdynamic][eapLabel] != Text3D:INVALID_3DTEXT_ID)
		{
			new other_string[MAX_PLAYER_NAME + MAX_ACTOR_LABEL_LENGTH];
			format(other_string, sizeof(other_string), "%s\n{%x}%s", formatted_name, (Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8), Actors_Plus[actorid][isdynamic][eapLabelText]);
			if(display)
				return Attach3DTextLabelToActor(actorid, other_string, isdynamic, Actors_Plus[actorid][isdynamic][eapLabelNameColor], Actors_Plus[actorid][isdynamic][eapLabelPosX], Actors_Plus[actorid][isdynamic][eapLabelPosY], Actors_Plus[actorid][isdynamic][eapLabelPosZ], Actors_Plus[actorid][isdynamic][eapLabelDrawDistance], .store_string = false);
		}
		else if(display)
			return Attach3DTextLabelToActor(actorid, formatted_name, isdynamic, Actors_Plus[actorid][isdynamic][eapLabelNameColor], Actors_Plus[actorid][isdynamic][eapLabelPosX], Actors_Plus[actorid][isdynamic][eapLabelPosY], Actors_Plus[actorid][isdynamic][eapLabelPosZ], Actors_Plus[actorid][isdynamic][eapLabelDrawDistance], .store_string = false);
	#endif
	return 1;
}

// =======================================================================================================================================================================================

stock RemoveActorName(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(isnull(Actors_Plus[actorid][isdynamic][eapName]))
		return cellmin;

	Actors_Flags[actorid][isdynamic] &= ~HAS_NAME_DISPLAYED;
	
	Actors_Plus[actorid][isdynamic][eapLabelNameColor] =
	Actors_Plus[actorid][isdynamic][eapLabelVW] =
	Actors_Plus[actorid][isdynamic][eapLabelInt] =
	Actors_Plus[actorid][isdynamic][eapLabelColor] = 0;

	Actors_Plus[actorid][isdynamic][eapName] = EOS;

	Actors_Plus[actorid][isdynamic][eapLabelPosX] = 
	Actors_Plus[actorid][isdynamic][eapLabelPosY] =
	Actors_Plus[actorid][isdynamic][eapLabelPosZ] =
	Actors_Plus[actorid][isdynamic][eapLabelDrawDistance] = 0.0;

	return 1;
}

// =======================================================================================================================================================================================

stock GetActorName(actorid, actor_name[],  length = sizeof(actor_name), bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;
	if(!isnull(Actors_Plus[actorid][isdynamic][eapName]))
		strcat(actor_name, Actors_Plus[actorid][isdynamic][eapName], length);
	else 
		return cellmin;

	return 1;
}

// =======================================================================================================================================================================================

stock GetActorTextLabel(actorid, text[], length = sizeof(text), bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(!isnull(Actors_Plus[actorid][isdynamic][eapLabelText]))
		strcat(text, Actors_Plus[actorid][isdynamic][eapLabelText], length);
	else 
		return cellmin;
	
	return 1;
}

// =======================================================================================================================================================================================

stock GetActorLabelColor(actorid, bool:ToRGB = false, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;
	if(ToRGB)
		return (Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8);
	else
		return Actors_Plus[actorid][isdynamic][eapLabelColor];
}

// =======================================================================================================================================================================================

stock GetActorNameColor(actorid, bool:ToRGB = false, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;
	if(ToRGB)
		return (Actors_Plus[actorid][isdynamic][eapLabelNameColor] >>> 8);
	else
		return Actors_Plus[actorid][isdynamic][eapLabelNameColor];
}

// =======================================================================================================================================================================================

stock SetActorLabelColor(actorid, color, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(isnull(Actors_Plus[actorid][isdynamic][eapLabelText]))
		return cellmin;
	
	#if USING_Y_TIMERS
		if(_:Actors_Plus[actorid][isdynamic][eapTimerChatBubble])
			return cellmin;
	#else
		if(Actors_Plus[actorid][isdynamic][eapTimerChatBubble])
			return cellmin;
	#endif
	Actors_Plus[actorid][isdynamic][eapLabelColor] = color;
	if(ActorHasTextDisplayed(actorid, isdynamic))
		return Internal_Update3DActorTextLabel(actorid, isdynamic);
	else
		return 1;
}

// =======================================================================================================================================================================================

stock SetActorNameColor(actorid, color, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(isnull(Actors_Plus[actorid][isdynamic][eapName]))
		return cellmin;
	
	#if USING_Y_TIMERS
		if(_:Actors_Plus[actorid][isdynamic][eapTimerChatBubble])
			return cellmin;
	#else
		if(Actors_Plus[actorid][isdynamic][eapTimerChatBubble])
			return cellmin;
	#endif
	Actors_Plus[actorid][isdynamic][eapLabelNameColor] = color;
	if(ActorHasNameDisplayed(actorid, isdynamic))
		return Internal_Update3DActorTextLabel(actorid, isdynamic);
	else
		return 1;
}

// =======================================================================================================================================================================================

#if USING_STREAMER
stock Attach3DTextLabelToActor(actorid, const text[], bool:isdynamic, color, Float:OffsetX, Float:OffsetY, Float:OffsetZ, Float:drawdistance, testlos = 0, worldid = DEFAULT_ACTOR_VALUE, interiorid = DEFAULT_ACTOR_VALUE, playerid = DEFAULT_ACTOR_VALUE, Float:streamdistance = STREAMER_3D_TEXT_LABEL_SD, areaid = DEFAULT_ACTOR_VALUE, priority = 0, bool:store_string = true)
#else
stock Attach3DTextLabelToActor(actorid, text[], color, Float:OffsetX, Float:OffsetY, Float:OffsetZ, Float:drawdistance, virtualworld = DEFAULT_ACTOR_VALUE, testlos = 0, bool:store_string = true)
#endif
{
	#if !USING_STREAMER
		if(!AP_IsValidActor(actorid))
			return 0;

		if(Actors_Plus[actorid][STATIC_CATEGORY][eapLabel] != Text3D:INVALID_3DTEXT_ID)
			Delete3DTextLabel(Actors_Plus[actorid][STATIC_CATEGORY][eapLabel]);

		if(store_string)
		{
			strcpy(Actors_Plus[actorid][STATIC_CATEGORY][eapLabelText], text);
			Actors_Flags[actorid][STATIC_CATEGORY] |= HAS_TEXT_DISPLAYED;
		}

		APD("(Attach3DTextLabelToActor) text: '%s' | actorid: %i | color: %x | drawdistance: %f", text, actorid, color, drawdistance);
		Actors_Plus[actorid][STATIC_CATEGORY][eapLabelColor] = color;
		Actors_Plus[actorid][STATIC_CATEGORY][eapLabelDrawDistance] = drawdistance;
		Actors_Plus[actorid][STATIC_CATEGORY][eapLabelVW] = virtualworld;
		Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosX] = OffsetX;
		Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosY] = OffsetY;
		Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosZ] = OffsetZ;
		#if USING_Y_TIMERS
			if(_:Actors_Plus[actorid][STATIC_CATEGORY][eapTimerChatBubble])
			{
				APD("[Attach3DTextLabelToActor] -> Returned 2 due to a running timer (timerid: %i).", _:Actors_Plus[actorid][STATIC_CATEGORY][eapTimerChatBubble]);
				return cellmin;
			}
		#else
			if(Actors_Plus[actorid][STATIC_CATEGORY][eapTimerChatBubble])
			{
				APD("[Attach3DTextLabelToActor] -> Returned 2 due to a running timer (timerid: %i).", _:Actors_Plus[actorid][STATIC_CATEGORY][eapTimerChatBubble]);
				return cellmin;
			}
		#endif

		Actors_Plus[actorid][STATIC_CATEGORY][eapLabel] = Create3DTextLabel(text, color, Actors_Plus[actorid][STATIC_CATEGORY][eapPosX] + OffsetX, Actors_Plus[actorid][STATIC_CATEGORY][eapPosY] + OffsetY, Actors_Plus[actorid][STATIC_CATEGORY][eapPosZ] + OffsetZ, drawdistance, virtualworld == DEFAULT_ACTOR_VALUE ? Actors_Plus[actorid][STATIC_CATEGORY][eapVW] : virtualworld, testlos);
	#else

		if(!AP_IsValidActor(actorid, isdynamic))
			return 0;
		
		APD("(Attach3DTextLabelToActor) text: '%s' | actorid: %i | color: %x | drawdistance: %f", text, actorid, color, drawdistance);

		if(IsValidDynamic3DTextLabel(Actors_Plus[actorid][isdynamic][eapLabel]))
			DestroyDynamic3DTextLabel(Actors_Plus[actorid][isdynamic][eapLabel]);
		
		if(store_string)
		{
			strcpy(Actors_Plus[actorid][isdynamic][eapLabelText], text);
			Actors_Flags[actorid][isdynamic] |= HAS_TEXT_DISPLAYED;
		}

		Actors_Plus[actorid][isdynamic][eapLabelColor] = color;
		Actors_Plus[actorid][isdynamic][eapLabelDrawDistance] = drawdistance;
		Actors_Plus[actorid][isdynamic][eapLabelVW] = worldid;
		Actors_Plus[actorid][isdynamic][eapLabelInt] = interiorid;
		Actors_Plus[actorid][isdynamic][eapLabelPosX] = OffsetX;
		Actors_Plus[actorid][isdynamic][eapLabelPosY] = OffsetY;
		Actors_Plus[actorid][isdynamic][eapLabelPosZ] = OffsetZ;
		#if USING_Y_TIMERS
			if(_:Actors_Plus[actorid][isdynamic][eapTimerChatBubble])
			{
				APD("[Attach3DTextLabelToActor] -> Returned 2 due to a running timer (timerid: %i).", _:Actors_Plus[actorid][isdynamic][eapTimerChatBubble]);
				return cellmin;
			}
		#else
			if(Actors_Plus[actorid][isdynamic][eapTimerChatBubble])
			{
				APD("[Attach3DTextLabelToActor] -> Returned 2 due to a running timer (timerid: %i).", Actors_Plus[actorid][isdynamic][eapTimerChatBubble]);
				return cellmin;
			}
		#endif
		Actors_Plus[actorid][isdynamic][eapLabel] = CreateDynamic3DTextLabel(text, color, Actors_Plus[actorid][isdynamic][eapPosX] + OffsetX, Actors_Plus[actorid][isdynamic][eapPosY] + OffsetY, Actors_Plus[actorid][isdynamic][eapPosZ] + OffsetZ, drawdistance,
			INVALID_PLAYER_ID, INVALID_VEHICLE_ID, testlos,
			worldid == DEFAULT_ACTOR_VALUE ? Actors_Plus[actorid][isdynamic][eapVW] : worldid, interiorid == DEFAULT_ACTOR_VALUE ? Actors_Plus[actorid][isdynamic][eapInt] : interiorid, playerid == DEFAULT_ACTOR_VALUE ? Actors_Plus[actorid][isdynamic][eapPlayerid] : playerid,
			streamdistance == DEFAULT_ACTOR_VALUE ? Actors_Plus[actorid][isdynamic][eapStreamDistance] : streamdistance, areaid == DEFAULT_ACTOR_VALUE ? Actors_Plus[actorid][isdynamic][eapAreaid] : areaid, priority);
		
	#endif
	return 1;
}

// =======================================================================================================================================================================================

stock ActorHasAttachedLabel(actorid, &bool:name_displayed = false, &bool:text_displayed = false, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(ActorHasNameDisplayed(actorid, isdynamic))
		name_displayed = true;

	if(ActorHasTextDisplayed(actorid, isdynamic))
		text_displayed = true;

	return (Actors_Plus[actorid][isdynamic][eapLabel] != Text3D:INVALID_3DTEXT_ID);
}

// =======================================================================================================================================================================================

stock UpdateAttachedActor3DTextLabel(actorid, const text[], color, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(Actors_Plus[actorid][isdynamic][eapLabel] == Text3D:INVALID_3DTEXT_ID)
		return 0;
	strcpy(Actors_Plus[actorid][isdynamic][eapLabelText], text);
	Actors_Plus[actorid][isdynamic][eapLabelColor] = color;
	Internal_Update3DActorTextLabel(actorid);

	return 1;
}

// =======================================================================================================================================================================================

stock SetActorChatBubble(actorid, text[], color, Float:drawdistance, expiretime, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	#if !USING_STREAMER
		if(Actors_Plus[actorid][isdynamic][eapLabel] == Text3D:INVALID_3DTEXT_ID)
			Attach3DTextLabelToActor(actorid, text, color, 0.0, 0.0, 1.0, drawdistance, .store_string = false);
		else
		{
			new formatted_string[MAX_ACTOR_LABEL_LENGTH*2 + MAX_PLAYER_NAME];
			strcat(formatted_string, text);
			if(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED)
				format(formatted_string, sizeof(formatted_string), "%s\n%s", formatted_string, (Actors_Plus[actorid][isdynamic][eapLabelNameColor] >>> 8), Actors_Plus[actorid][isdynamic][eapName]);

			if(Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED)
				format(formatted_string, sizeof(formatted_string), "%s\n{%x}%s", formatted_string, (Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8), Actors_Plus[actorid][isdynamic][eapLabelText]);

			Update3DTextLabelText(Actors_Plus[actorid][isdynamic][eapLabel], color, formatted_string);
		}			
		
		#if USING_Y_TIMERS
			Actors_Plus[actorid][STATIC_CATEGORY][eapTimerChatBubble] = defer AT_DeleteBubbleChat[expiretime](actorid, isdynamic);
		#else
			Actors_Plus[actorid][STATIC_CATEGORY][eapTimerChatBubble] = SetTimerEx("@AT_DeleteBubbleChat", expiretime, false, "ii", actorid, isdynamic);
		#endif
		return 1;
	#else
		if(Actors_Plus[actorid][isdynamic][eapLabel] == Text3D:INVALID_3DTEXT_ID)
			Attach3DTextLabelToActor(actorid, text, isdynamic, color, 0.0, 0.0, 1.0, drawdistance, .store_string = false);
		else
		{
			new formatted_string[MAX_ACTOR_LABEL_LENGTH*2 + MAX_PLAYER_NAME];
			strcat(formatted_string, text);
			if(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED)
				format(formatted_string, sizeof(formatted_string), "%s\n{%x}%s", formatted_string, (Actors_Plus[actorid][isdynamic][eapLabelNameColor] >>> 8), Actors_Plus[actorid][isdynamic][eapName]);

			if(Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED)
				format(formatted_string, sizeof(formatted_string), "%s\n{%x}%s", formatted_string, (Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8), Actors_Plus[actorid][isdynamic][eapLabelText]);

			UpdateDynamic3DTextLabelText(Actors_Plus[actorid][isdynamic][eapLabel], color, formatted_string);
		}

		#if USING_Y_TIMERS
			Actors_Plus[actorid][isdynamic][eapTimerChatBubble] = defer AT_DeleteBubbleChat[expiretime](actorid, isdynamic);
		#else
			Actors_Plus[actorid][isdynamic][eapTimerChatBubble] = SetTimerEx("@AT_DeleteBubbleChat", expiretime, false, "ii", actorid, isdynamic);
		#endif
		
		return 1;
	#endif
}

#if USING_Y_TIMERS
	timer AT_DeleteBubbleChat[2000](actorid, bool:isdynamic)
	{
		if(!AP_IsValidActor(actorid, isdynamic))
			return DestroyActor3DTextLabel(actorid, isdynamic);
		new formatted_label[MAX_ACTOR_LABEL_LENGTH*2 + MAX_PLAYER_NAME];
		Actors_Plus[actorid][isdynamic][eapTimerChatBubble] = Timer:0;
		#if !USING_STREAMER
			if(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED)
				format(formatted_label, sizeof(formatted_label), "{%x}%s", (Actors_Plus[actorid][isdynamic][eapLabelNameColor] >>> 8), Actors_Plus[actorid][isdynamic][eapName]);

			if(Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED)
				format(formatted_label, sizeof(formatted_label), "%s\n{%x}%s", formatted_label, (Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8), Actors_Plus[actorid][isdynamic][eapLabelText]);


			if(!isnull(formatted_label))
				Attach3DTextLabelToActor(actorid, formatted_label, Actors_Plus[actorid][STATIC_CATEGORY][eapLabelColor], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosX], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosY], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosZ], DEFAULT_ACTOR_DRAW_DISTANCE, .store_string = false);
			else
				DestroyActor3DTextLabel(actorid, isdynamic);

		#else
			if(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED)
				format(formatted_label, sizeof(formatted_label), "{%x}%s", (Actors_Plus[actorid][isdynamic][eapLabelNameColor] >>> 8), Actors_Plus[actorid][isdynamic][eapName]);

			if(Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED)
				format(formatted_label, sizeof(formatted_label), "%s\n{%x}%s", formatted_label, (Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8), Actors_Plus[actorid][isdynamic][eapLabelText]);

			if(!isnull(formatted_label))
				Attach3DTextLabelToActor(actorid, formatted_label, isdynamic, Actors_Plus[actorid][isdynamic][eapLabelColor], Actors_Plus[actorid][isdynamic][eapLabelPosX], Actors_Plus[actorid][isdynamic][eapLabelPosY], Actors_Plus[actorid][isdynamic][eapLabelPosZ], DEFAULT_ACTOR_DRAW_DISTANCE, .store_string = false);
			else
				DestroyActor3DTextLabel(actorid, isdynamic);
		#endif // #if USING_Y_TIMERS
		return 1;
	}
#else
	forward @AT_DeleteBubbleChat(actorid, bool:isdynamic);
	@AT_DeleteBubbleChat(actorid, bool:isdynamic)
	{
		if(!AP_IsValidActor(actorid, isdynamic))
			return DestroyActor3DTextLabel(actorid, isdynamic);
		new formatted_label[MAX_ACTOR_LABEL_LENGTH + MAX_PLAYER_NAME];
		Actors_Plus[actorid][isdynamic][eapTimerChatBubble] = 0;
		#if !USING_STREAMER
			if(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED)
				format(formatted_label, sizeof(formatted_label), "{%x}%s", (Actors_Plus[actorid][isdynamic][eapLabelNameColor] >>> 8), Actors_Plus[actorid][isdynamic][eapName]);

			if(Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED)
				format(formatted_label, sizeof(formatted_label), "%s\n{%x}%s", formatted_label, (Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8), Actors_Plus[actorid][isdynamic][eapLabelText]);


			if(!isnull(formatted_label))
				return Attach3DTextLabelToActor(actorid, formatted_label, Actors_Plus[actorid][STATIC_CATEGORY][eapLabelColor], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosX], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosY], Actors_Plus[actorid][STATIC_CATEGORY][eapLabelPosZ], DEFAULT_ACTOR_DRAW_DISTANCE, .store_string = false);
			else
				return DestroyActor3DTextLabel(actorid, isdynamic);

		#else
			if(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED)
				format(formatted_label, sizeof(formatted_label), "{%x}%s", (Actors_Plus[actorid][isdynamic][eapLabelNameColor] >>> 8), Actors_Plus[actorid][isdynamic][eapName]);

			if(Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED)
				format(formatted_label, sizeof(formatted_label), "%s\n{%x}%s", formatted_label, (Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8), Actors_Plus[actorid][isdynamic][eapLabelText]);

			if(!isnull(formatted_label))
				return Attach3DTextLabelToActor(actorid, formatted_label, isdynamic, Actors_Plus[actorid][isdynamic][eapLabelColor], Actors_Plus[actorid][isdynamic][eapLabelPosX], Actors_Plus[actorid][isdynamic][eapLabelPosY], Actors_Plus[actorid][isdynamic][eapLabelPosZ], DEFAULT_ACTOR_DRAW_DISTANCE, .store_string = false);
			else
				return DestroyActor3DTextLabel(actorid, isdynamic);
		#endif // #if USING_Y_TIMERS
	}
#endif // #if USING_Y_TIMERS

// =======================================================================================================================================================================================

stock DestroyActor3DTextLabel(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(Actors_Plus[actorid][isdynamic][eapLabel] == Text3D:INVALID_3DTEXT_ID)
		return cellmin;

	#if USING_Y_TIMERS
		if(_:Actors_Plus[actorid][isdynamic][eapTimerChatBubble])
			stop Actors_Plus[actorid][isdynamic][eapTimerChatBubble];
		Actors_Plus[actorid][isdynamic][eapTimerChatBubble] = Timer:0;
	#else
		if(Actors_Plus[actorid][isdynamic][eapTimerChatBubble])
			KillTimer(Actors_Plus[actorid][isdynamic][eapTimerChatBubble]);
		Actors_Plus[actorid][isdynamic][eapTimerChatBubble] = 0;
	#endif

	#if !USING_STREAMER
		APD("DestroyActor3DTextLabel called for actorid %i", actorid);
		Delete3DTextLabel(Actors_Plus[actorid][isdynamic][eapLabel]);
	#else
		APD("DestroyActor3DTextLabel called for actorid %i", actorid);
		if(IsValidDynamic3DTextLabel(Actors_Plus[actorid][isdynamic][eapLabel]))
			DestroyDynamic3DTextLabel(Actors_Plus[actorid][isdynamic][eapLabel]);
	#endif

	Actors_Plus[actorid][isdynamic][eapLabel] = Text3D:INVALID_3DTEXT_ID;
	Actors_Plus[actorid][isdynamic][eapLabelText][0] = EOS;
	if(isnull(Actors_Plus[actorid][isdynamic][eapName]))
		Actors_Plus[actorid][isdynamic][eapLabelColor] = 0;

	Actors_Flags[actorid][isdynamic] &= ~HAS_NAME_DISPLAYED;
	Actors_Flags[actorid][isdynamic] &= ~HAS_TEXT_DISPLAYED;
	return 1;
}

// =======================================================================================================================================================================================

stock ToggleActorName(actorid, bool:toggle, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(toggle)
	{
		if(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED)
			return cellmin;

		if(isnull(Actors_Plus[actorid][isdynamic][eapName]))
			return cellmin;

		#if USING_Y_TIMERS
			if(_:Actors_Plus[actorid][isdynamic][eapTimerChatBubble] || !AP_IsValidActor(actorid, isdynamic))
				return 0;
		#else
			if(Actors_Plus[actorid][isdynamic][eapTimerChatBubble] || !AP_IsValidActor(actorid, isdynamic))
				return 0;
		#endif

		if(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED || isnull(Actors_Plus[actorid][isdynamic][eapName]))
			return cellmin;

		Actors_Flags[actorid][isdynamic] |= HAS_NAME_DISPLAYED;
		Internal_Update3DActorTextLabel(actorid, isdynamic);
		return 1;
	}
	else
	{
		if(!(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED))
			return cellmin;

		#if USING_Y_TIMERS
			if(_:Actors_Plus[actorid][isdynamic][eapTimerChatBubble] || !AP_IsValidActor(actorid, isdynamic))
				return 0;
		#else
			if(Actors_Plus[actorid][isdynamic][eapTimerChatBubble] || !AP_IsValidActor(actorid, isdynamic))
				return 0;
		#endif

		if(!(Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED) || isnull(Actors_Plus[actorid][isdynamic][eapName]) || Actors_Plus[actorid][isdynamic][eapLabel] == Text3D:INVALID_3DTEXT_ID)
			return cellmin;

		Actors_Flags[actorid][isdynamic] &= ~HAS_NAME_DISPLAYED;
		if(!isnull(Actors_Plus[actorid][isdynamic][eapLabelText]))
			Internal_Update3DActorTextLabel(actorid, isdynamic);
		else
			DestroyActor3DTextLabel(actorid, isdynamic);
		return 1;
	}
}

// =======================================================================================================================================================================================

stock SetActorSkin(actorid, skinid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic) || !(0 <= skinid <= 311) || skinid == 74)
		return 0;

	Actors_Plus[actorid][isdynamic][eapSkin] = skinid;
	RecreateActor(actorid, isdynamic);
	return 1;
}

// =======================================================================================================================================================================================

stock IsActorDead(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;
	return (Actors_Flags[actorid][isdynamic] & IS_DEAD) == IS_DEAD;
}

// =======================================================================================================================================================================================

stock ActorPlaySound(actorid, soundid, Float:x, Float:y, Float:z, Float:max_range, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	new Float:pos_x,
		Float:pos_y,
		Float:pos_z;

	#if USING_STREAMER
		if(isdynamic)
		{
			GetDynamicActorPos(actorid, pos_x, pos_y, pos_z);
			pos_x += x;
			pos_y += y;
			pos_z += z;
			#if USING_Y_ITERATE
				foreach(new i : Player)
				{
					if(GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z) > max_range)
						continue;
					PlayerPlaySound(i, soundid, 0.0, 0.0, 0.0);
				}
			#else
				for(new i, j = GetPlayerPoolSize(); i <= j; i++)
				{
					if(!IsPlayerConnected(i) || IsPlayerNPC(i))
						continue;
					if(GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z) > max_range)
						continue;
					PlayerPlaySound(i, soundid, 0.0, 0.0, 0.0);
				}
			#endif
		}
		else
		{
			GetActorPos(actorid, pos_x, pos_y, pos_z);
			pos_x += x;
			pos_y += y;
			pos_z += z;
			#if USING_Y_ITERATE
				foreach(new i : Player)
				{
					if(GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z) > max_range)
						continue;
					PlayerPlaySound(i, soundid, 0.0, 0.0, 0.0);
				}
			#else
				for(new i, j = GetPlayerPoolSize(); i <= j; i++)
				{
					if(!IsPlayerConnected(i) || IsPlayerNPC(i))
						continue;
					if(GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z) > max_range)
						continue;
					PlayerPlaySound(i, soundid, 0.0, 0.0, 0.0);
				}
			#endif
		}
	#else
	GetActorPos(actorid, pos_x, pos_y, pos_z);
	pos_x += x;
	pos_y += y;
	pos_z += z;
	#if USING_Y_ITERATE
		foreach(new i : Player)
		{
			if(GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z) > max_range)
				continue;
			PlayerPlaySound(i, soundid, 0.0, 0.0, 0.0);
		}
	#else
		for(new i, j = GetPlayerPoolSize(); i <= j; i++)
		{
			if(!IsPlayerConnected(i) || IsPlayerNPC(i))
				continue;
			if(GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z) > max_range)
				continue;
			PlayerPlaySound(i, soundid, 0.0, 0.0, 0.0);
		}
	#endif // if USING_Y_ITERATE
	#endif // if USING_STREAMER
	return 1;
}


// =======================================================================================================================================================================================
// =======================================================================================================================================================================================

#if USING_STREAMER
	stock GetDynamicActorInterior(actorid)
	{
		if(!IsValidDynamicActor(actorid))
			return 0;
		return Actors_Plus[actorid][DYNAMIC_CATEGORY][eapInt];
	}

	stock SetDynamicActorInterior(actorid, interiorid)
	{
		if(!IsValidDynamicActor(actorid))
			return 0;
		CallRemoteFunction("OnDynamicActorInteriorChange", "iii", actorid, Actors_Plus[actorid][DYNAMIC_CATEGORY][eapInt], interiorid);
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapInt] = interiorid;
		return RecreateActor(actorid);
	}

	#define DestroyAllDynamicActors(%0)				Streamer_DestroyAllItems(STREAMER_TYPE_ACTOR, %0)
	#define CountDynamicActors(%0)					Streamer_CountItems(STREAMER_TYPE_ACTOR, %0)
	#define UpdateDynamicActorForPlayer(%0)			Streamer_Update(%0, STREAMER_TYPE_ACTOR)
	#define CountStreamedActorForPlayer(%0,%1)		Streamer_CountVisibleItems(%0, STREAMER_TYPE_ACTOR, %1)
	#define GetDynamicActorArea(%0)					STREAMER_TAG_AREA:Streamer_GetIntData(STREAMER_TYPE_ACTOR, (%0), E_STREAMER_AREA_ID)
	#define SetDynamicActorArea(%0,%1)				Streamer_SetIntData(STREAMER_TYPE_ACTOR, (%0), E_STREAMER_AREA_ID, STREAMER_TAG_AREA:(%1))
	#define GetDynamicActorPriority(%0)				Streamer_GetIntData(STREAMER_TYPE_ACTOR, (%0), E_STREAMER_PRIORITY)
	#define SetDynamicActorPriority(%0,%1)			Streamer_SetIntData(STREAMER_TYPE_ACTOR, (%0), E_STREAMER_PRIORITY, (%1))
	#define GetInternalActorIdForPlayer(%0,%1)		Streamer_GetItemInternalID(%0, STREAMER_TYPE_ACTOR, %1)
	#if USING_Y_ITERATE
		#define CountAllActors() 						(Iter_Count(Actor) + Iter_Count(Dynamic_Actor))
	#else
		stock CountAllActors()
		{
			new count;
			for(new i, j = GetActorPoolSize(); i <= j; i++)
			{
				if(!(Actors_Flags[i][STATIC_CATEGORY] & IS_EXISTING))
					continue;
				count ++;
			}
			return (count + Streamer_CountItems(STREAMER_TYPE_ACTOR, 0));
		}
	#endif
#else 
	#if USING_Y_ITERATE
		#define CountAllActors() 						(Iter_Count(Actor))
	#else
		stock CountAllActors()
		{
			new count;
			for(new i, j = GetActorPoolSize(); i <= j; i++)
			{
				if(!(Actors_Flags[i][STATIC_CATEGORY] & IS_EXISTING))
					continue;
				count ++;
			}
			return count;
		}
	#endif
#endif

// =======================================================================================================================================================================================
// ================================================================================== Useful functions ===================================================================================
// =======================================================================================================================================================================================

#if USING_Y_ITERATE
	#define CountStaticActors() (Iter_Count(Actor))
#else
	stock CountStaticActors()
	{
		new count;
		for(new i, j = GetActorPoolSize(); i <= j; i++)
		{
			if(!(Actors_Flags[i][STATIC_CATEGORY] & IS_EXISTING))
				continue;
			count ++;
		}
		return count;
	}
#endif


stock Float:GetActorDistanceFromPoint(actorid, Float:x, Float:y, Float:z, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid))
		return INVALID_RANGE_ID;

	return (GetDistanceBetween2Points(x, y, z, Actors_Plus[actorid][isdynamic][eapPosX], Actors_Plus[actorid][isdynamic][eapPosY], Actors_Plus[actorid][isdynamic][eapPosZ]));
}

stock IsPlayerInRangeOfActor(playerid, actorid, Float:range = 2.0, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(playerid) || !AP_IsValidActor(actorid))
		return 0;

	new Float:x,
		Float:y,
		Float:z;
	GetPlayerPos(playerid, x, y, z);
	return (GetDistanceBetween2Points(x, y, z, Actors_Plus[actorid][isdynamic][eapPosX], Actors_Plus[actorid][isdynamic][eapPosY], Actors_Plus[actorid][isdynamic][eapPosZ]) <= range);
}

stock IsPlayerAimingActor(playerid, actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	#if USING_STREAMER
		if(isdynamic)
			return (GetPlayerTargetDynamicActor(playerid) == actorid);
		else
			return (GetPlayerTargetActor(playerid) == actorid);
	#else
		#pragma unused isdynamic
		return (GetPlayerTargetActor(playerid) == actorid);
	#endif
}

stock IsActorInPlayerFacingAngle(playerid, actorid, Float:max_angle = 90.0, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(playerid) || !AP_IsValidActor(actorid))
		return 0;

	new Float:ang,
		Float:second_ang,
		Float:result;

	GetPlayerFacingAngle(playerid, ang);
	#if USING_STREAMER
		if(isdynamic)
			GetDynamicActorFacingAngle(actorid, second_ang);
		else
			GetActorFacingAngle(actorid, second_ang);
	#else
		#pragma unused isdynamic
		GetActorFacingAngle(actorid, second_ang);
	#endif

	if(ang < 180.0)
		result = 180.0 + ang;
	else
		result = ang - 180.0;
	
	if(second_ang + max_angle > 360.0 || second_ang - max_angle < 0.0)
		return ((360.0 - max_angle <= result <= 360.0) || (0.0 <= result <= max_angle));
	else
		return (second_ang - max_angle <= result <= second_ang + max_angle);
}

stock GetNearestActorForPlayer(playerid, &bool:isdynamic = false, type = SEARCH_TYPE_ALL, bool:return_multiple_target = false)
{
	if(!IsPlayerConnected(playerid))
		return cellmin;

	new actorid = INVALID_ACTOR_ID,
		Float:actor_range = INVALID_RANGE_ID,
		Float:x,
		Float:y,
		Float:z;
	GetPlayerPos(playerid, x, y, z);

	#if USING_Y_ITERATE
		#if USING_STREAMER

			if(type & SEARCH_TYPE_STATIC)
			{
				foreach(new i : Actor)
				{
					if(GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]) >= actor_range)
						continue;
					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actorid = i;
					actor_range = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]);
				}
			}
			if(type & SEARCH_TYPE_DYNAMIC)
			{
				foreach(new i : Dynamic_Actor)
				{
					if(GetDistanceBetween2Points(x, y, z, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosX], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosY], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosZ]) >= actor_range)
						continue;
					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actorid = i;
					actor_range = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosX], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosY], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosZ]); 
					isdynamic = true;
				}
			}
			return actorid;
		#else
			if(type & SEARCH_TYPE_STATIC)
			{
				foreach(new i : Actor)
				{
					if(GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]) >= actor_range)
						continue;
					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actorid = i;
					actor_range = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]); 
				}
			}
			return actorid;
		#endif // if USING_STREAMER 
	#else
		#if USING_STREAMER
			if(type & SEARCH_TYPE_STATIC)
			{
				for(new i, j = GetActorPoolSize(); i <= j; i++)
				{
					if(!IsValidActor(i))
						continue;
					if(GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]) >= actor_range)
						continue;

					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actor_range = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]); 
					actorid = i;
				}
			}
			if(type & SEARCH_TYPE_DYNAMIC)
			{
				for(new i, j = GetActorPoolSize(); i <= j; i++)
				{
					if(!IsValidDynamicActor(i))
						continue;
					if(GetDistanceBetween2Points(x, y, z, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosX], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosY], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosZ]) >= actor_range)
						continue;

					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actor_range = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosX], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosY], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosZ]); 
					actorid = i;
					isdynamic = true;
				}
			}
			return actorid;
		#else
			if(type & SEARCH_TYPE_STATIC)
			{
				for(new i, j = GetActorPoolSize(); i <= j; i++)
				{
					if(!IsValidActor(i))
						continue;
					if(GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]) >= actor_range)
						continue;

					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actor_range = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]); 
					actorid = i;
				}
			}
			return actorid;
		#endif // if USING_STREAMER 
	#endif // if USING_Y_ITERATE
}

stock GetNearestActorByCoord(Float:x, Float:y, Float:z, &bool:isdynamic = false, type = SEARCH_TYPE_ALL, bool:return_multiple_target = false, Float:max_range = INVALID_RANGE_ID)
{
	new actorid = INVALID_ACTOR_ID,
		Float:actor_range = INVALID_RANGE_ID,
		Float:actor_distance;

	#if USING_STREAMER
		#if USING_Y_ITERATE
			if(type & SEARCH_TYPE_STATIC)
			{
				foreach(new i : Actor)
				{
					actor_distance = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]);
					if(actor_distance >= actor_range || actor_distance >= max_range)
						continue;
					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actorid = i;
					actor_range = actor_distance;
				}
			}
			if(type & SEARCH_TYPE_DYNAMIC)
			{
				foreach(new i : Dynamic_Actor)
				{
					actor_distance = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosX], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosY], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosZ]);
					if(actor_distance >= actor_range || actor_distance >= max_range)
						continue;
					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actorid = i;
					actor_range = actor_distance;
					isdynamic = true;
				}
			}
			return actorid;
		#else
			if(type & SEARCH_TYPE_STATIC)
			{
				for(new i, j = GetActorPoolSize(); i <= j; i++)
				{
					if(!IsValidActor(i))
						continue;
					actor_distance = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]);
					if(actor_distance >= actor_range || actor_distance >= max_range)
						continue;
					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;

					actor_range = actor_distance;
					actorid = i;
				}
			}
			if(type & SEARCH_TYPE_DYNAMIC)
			{
				for(new i, j = GetActorPoolSize(); i <= j; i++)
				{
					if(!IsValidDynamicActor(i))
						continue;
					actor_distance = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][DYNAMIC_CATEGORY][eapPosX], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosY], Actors_Plus[i][DYNAMIC_CATEGORY][eapPosZ]);
					if(actor_distance >= actor_range || actor_distance >= max_range)
						continue;
					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;

					actor_range = actor_distance;
					actorid = i;
					isdynamic = true;
				}
			}
			return actorid;
		#endif
	#else
		#if USING_Y_ITERATE
			if(type & SEARCH_TYPE_STATIC)
			{
				foreach(new i : Actor)
				{
					actor_distance = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]);
					if(actor_distance >= actor_range || actor_distance >= max_range)
						continue;
					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actorid = i;
					actor_range = actor_distance; 
				}
			}
			return actorid;
		#else
			if(type & SEARCH_TYPE_STATIC)
			{
				for(new i, j = GetActorPoolSize(); i <= j; i++)
				{
					if(!IsValidActor(i))
						continue;
					actor_distance = GetDistanceBetween2Points(x, y, z, Actors_Plus[i][STATIC_CATEGORY][eapPosX], Actors_Plus[i][STATIC_CATEGORY][eapPosY], Actors_Plus[i][STATIC_CATEGORY][eapPosZ]);
					if(actor_distance >= actor_range || actor_distance >= max_range)
						continue;

					if(actorid != INVALID_ACTOR_ID && return_multiple_target)
						return MULTIPLE_TARGET_FOUND;
					actor_range = actor_distance;
					actorid = i;
				}
			}
			return actorid;
		#endif
	#endif
}

#if !defined GetActorSpawnInfo
stock GetActorSpawnInfo(actorid, &skinid, &Float:fX, &Float:fY, &Float:fZ, &Float:fAngle, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;

	skinid = Actors_Plus[actorid][isdynamic][eapSkin];
	fX = Actors_Plus[actorid][isdynamic][eapPosX];
	fY = Actors_Plus[actorid][isdynamic][eapPosY];
	fZ = Actors_Plus[actorid][isdynamic][eapPosZ];
	fAngle = Actors_Plus[actorid][isdynamic][eapPosAngle];
	return 1;
}
#endif

stock GetActorAnimationName(actorid, animlib[], size_animlib = sizeof(animlib), animname[], size_animname = sizeof(animname))
{
	if(!IsValidActor(actorid))
		return 0;

	if(isnull(Actors_Plus_Animations[actorid][apadAnimLib]) || isnull(Actors_Plus_Animations[actorid][apadAnimName]))
		return cellmin;

	strcpy(animlib, Actors_Plus_Animations[actorid][apadAnimLib], size_animlib);
	strcpy(animname, Actors_Plus_Animations[actorid][apadAnimName], size_animname);
	return 1;
}

stock GetActorAnimation(actorid, animlib[], size_animlib = sizeof(animlib), animname[], size_animname = sizeof(animname), &Float:fDelta, &loop, &lockx, &locky, &freeze, &time)
{
	if(!IsValidActor(actorid))
		return 0;

	if(isnull(Actors_Plus_Animations[actorid][apadAnimLib]) || isnull(Actors_Plus_Animations[actorid][apadAnimName]))
		return cellmin;

	strcpy(animlib, Actors_Plus_Animations[actorid][apadAnimLib], size_animlib);
	strcpy(animname, Actors_Plus_Animations[actorid][apadAnimName], size_animname);
	fDelta = Actors_Plus_Animations[actorid][apadDelta];
	locky = Actors_Plus_Animations[actorid][apadLocky];
	lockx = Actors_Plus_Animations[actorid][apadLockx];
	loop = Actors_Plus_Animations[actorid][apadLoop];
	freeze = Actors_Plus_Animations[actorid][apadFreeze];
	time = Actors_Plus_Animations[actorid][apadTime];
	return 1;
}

#if !defined GetActorSkin
stock GetActorSkin(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return 0;
	return Actors_Plus[actorid][isdynamic][eapSkin];
}
#endif

stock bool:IsActorPlayingAnimation(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!AP_IsValidActor(actorid, isdynamic))
		return false;

	return !(isnull(Actors_Plus_Animations[actorid][apadAnimLib]) && isnull(Actors_Plus_Animations[actorid][apadAnimName]));
}

stock ToggleActorAnimationLoop(actorid, bool:toggle)
{
	if(!IsValidActor(actorid))
		return 0;

	if(isnull(Actors_Plus_Animations[actorid][apadAnimLib]) || isnull(Actors_Plus_Animations[actorid][apadAnimName]))
		return cellmin;

	ClearActorAnimations(actorid);
	return ApplyActorAnimation(actorid, Actors_Plus_Animations[actorid][apadAnimLib], Actors_Plus_Animations[actorid][apadAnimName], Actors_Plus_Animations[actorid][apadDelta], _:toggle, Actors_Plus_Animations[actorid][apadLockx],
		Actors_Plus_Animations[actorid][apadLocky],  Actors_Plus_Animations[actorid][apadFreeze], Actors_Plus_Animations[actorid][apadTime]);
}

// =======================================================================================================================================================================================
// ================================================================================ Per player functions =================================================================================
// =============================================================================== PawnRakNet Dependencies ===============================================================================
// =======================================================================================================================================================================================

#if USING_PAWN_RAKNET

stock HideActorForPlayer(forplayerid, actorid, hide_type, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(!(hide_type & (HIDE_TYPE_PERMANENT | HIDE_TYPE_ONE_TIME)))
		return cellmin;

	if(hide_type & HIDE_TYPE_NONE)
		return Internal_BringBackActor(forplayerid, actorid, isdynamic);

	Player_Flags[forplayerid][isdynamic][actorid] = Player_Flags[forplayerid][isdynamic][actorid] & ~(HIDE_TYPE_NONE | HIDE_TYPE_PERMANENT | HIDE_TYPE_ONE_TIME) | hide_type;
	return Internal_HideAnActorForPlayer(forplayerid, actorid, isdynamic);
}

stock BringBackActorForPlayer(forplayerid, actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(Player_Flags[forplayerid][isdynamic][actorid] & HIDE_TYPE_NONE)
		return cellmin;

	return Internal_BringBackActor(forplayerid, actorid, isdynamic);
}

stock SetActorHideTypeForPlayer(forplayerid, actorid, hide_type, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(Player_Flags[forplayerid][isdynamic][actorid] & hide_type)
		return cellmin;

	if(hide_type & HIDE_TYPE_NONE)
		return Internal_BringBackActor(forplayerid, actorid, isdynamic);

	Player_Flags[forplayerid][isdynamic][actorid] = Player_Flags[forplayerid][isdynamic][actorid] & ~(HIDE_TYPE_PERMANENT | HIDE_TYPE_ONE_TIME) | hide_type;
	return 1;
}

stock IsActorHiddenForPlayer(forplayerid, actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;
	return (Player_Flags[forplayerid][isdynamic][actorid] & HIDE_TYPE_NONE != HIDE_TYPE_NONE);
}

stock RemoveAllHiddenActorForPlayer(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	#if USING_Y_ITERATE

		#if USING_STREAMER
			foreach(new i : Actor)
			{
				if((Player_Flags[playerid][STATIC_CATEGORY][i] & HIDE_TYPE_ONE_TIME) || (Player_Flags[playerid][STATIC_CATEGORY][i] & HIDE_TYPE_PERMANENT))
					Internal_BringBackActor(playerid, i, STATIC_CATEGORY);
			}

			foreach(new i : Dynamic_Actor)
			{
				if((Player_Flags[playerid][DYNAMIC_CATEGORY][i] & HIDE_TYPE_ONE_TIME) || (Player_Flags[playerid][DYNAMIC_CATEGORY][i] & HIDE_TYPE_PERMANENT))
					Internal_BringBackActor(playerid, i, DYNAMIC_CATEGORY);
			}
		#else
			foreach(new i : Actor)
			{
				if((Player_Flags[playerid][STATIC_CATEGORY][i] & HIDE_TYPE_ONE_TIME) || (Player_Flags[playerid][STATIC_CATEGORY][i] & HIDE_TYPE_PERMANENT))
					Internal_BringBackActor(playerid, i, STATIC_CATEGORY);	
			}
		#endif // if USING_STREAMER
	#else
		#if USING_STREAMER
			for(new i, j = GetActorPoolSize(); i <= j; i++)
			{
				if(IsValidDynamicActor(i))
				{
					if((Player_Flags[playerid][DYNAMIC_CATEGORY][i] & HIDE_TYPE_ONE_TIME) || (Player_Flags[playerid][DYNAMIC_CATEGORY][i] & HIDE_TYPE_PERMANENT))
						Internal_BringBackActor(playerid, i, DYNAMIC_CATEGORY);	
				}
				else if(IsValidActor(i))
				{
					if((Player_Flags[playerid][STATIC_CATEGORY][i] & HIDE_TYPE_ONE_TIME) || (Player_Flags[playerid][STATIC_CATEGORY][i] & HIDE_TYPE_PERMANENT))
						Internal_BringBackActor(playerid, i, DYNAMIC_CATEGORY);	
				}
			}
		#else
			for(new i, j = GetActorPoolSize(); i <= j; i++)
			{
				if(!IsValidActor(i))
					continue;

				if((Player_Flags[playerid][STATIC_CATEGORY][i] & HIDE_TYPE_ONE_TIME) || (Player_Flags[playerid][STATIC_CATEGORY][i] & HIDE_TYPE_PERMANENT))
					Internal_BringBackActor(playerid, i, STATIC_CATEGORY);	
			}
		#endif // if USING_STREAMER
	#endif
	return 1;
}

// =======================================================================================================================================================================================

stock ApplyActorAnimationForPlayer(forplayerid, actorid, repeated_animation, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(!(repeated_animation & (ANIMATION_PLAY_PERMANENT | ANIMATION_PLAY_ONE_TIME)))
		return cellmin;

	if(repeated_animation & ANIMATION_PLAY_NONE)
		return ClearActorAnimationsForPlayer(forplayerid, actorid, isdynamic);

	Player_Flags[forplayerid][isdynamic][actorid] = Player_Flags[forplayerid][isdynamic][actorid] & ~(ANIMATION_PLAY_NONE | ANIMATION_PLAY_ONE_TIME | ANIMATION_PLAY_PERMANENT) | repeated_animation;

	if(!isdynamic)
	{
		strcpy(PAttributes_StaticActor[forplayerid][actorid][appAnimLib], animlib, MAX_ANIMATION_LIBRARY_LENGTH);
		strcpy(PAttributes_StaticActor[forplayerid][actorid][appAnimName], animname, MAX_ANIMATION_NAME_LENGTH);
		PAttributes_StaticActor[forplayerid][actorid][appLibLength] = strlen(animlib);
		PAttributes_StaticActor[forplayerid][actorid][appAnimLength] = strlen(animname);
		PAttributes_StaticActor[forplayerid][actorid][appDelta] = fDelta;
		PAttributes_StaticActor[forplayerid][actorid][appDelta] = fDelta;
		PAttributes_StaticActor[forplayerid][actorid][appLoop] = loop;
		PAttributes_StaticActor[forplayerid][actorid][appLockx] = lockx;
		PAttributes_StaticActor[forplayerid][actorid][appLocky] = locky;
		PAttributes_StaticActor[forplayerid][actorid][appFreeze] = freeze;
		PAttributes_StaticActor[forplayerid][actorid][appTime] = time;
	}
	else
	{
		strcpy(PAttributes_DynamicActor[forplayerid][actorid][appAnimLib], animlib, MAX_ANIMATION_LIBRARY_LENGTH);
		strcpy(PAttributes_DynamicActor[forplayerid][actorid][appAnimName], animname, MAX_ANIMATION_NAME_LENGTH);
		PAttributes_DynamicActor[forplayerid][actorid][appLibLength] = strlen(animlib);
		PAttributes_DynamicActor[forplayerid][actorid][appAnimLength] = strlen(animname);
		PAttributes_DynamicActor[forplayerid][actorid][appDelta] = fDelta;
		PAttributes_DynamicActor[forplayerid][actorid][appDelta] = fDelta;
		PAttributes_DynamicActor[forplayerid][actorid][appLoop] = loop;
		PAttributes_DynamicActor[forplayerid][actorid][appLockx] = lockx;
		PAttributes_DynamicActor[forplayerid][actorid][appLocky] = locky;
		PAttributes_DynamicActor[forplayerid][actorid][appFreeze] = freeze;
		PAttributes_DynamicActor[forplayerid][actorid][appTime] = time;
		actorid = GetInternalActorIDForPlayer(forplayerid, actorid);
	}

	if(actorid == INVALID_ACTOR_ID)
	{
		APD("[ApplyActorAnimationForPlayer] actorid %i isn't streamed (he's probably dynamic) for player: %i", actorid, forplayerid);
		return 2;
	}

	new BitStream:bit_stream = BS_New(); 
	BS_WriteValue(bit_stream,
		PR_UINT16, actorid,
		PR_UINT8, strlen(animlib),
		PR_STRING, animlib,

		PR_UINT8, strlen(animname),
		PR_STRING, animname,

		PR_FLOAT, fDelta,
		PR_BOOL, loop,
		PR_BOOL, lockx,
		PR_BOOL, locky,
		PR_BOOL, loop,
		PR_UINT32, time);

	BS_RPC(bit_stream, forplayerid, 0xAD); 
	BS_Delete(bit_stream);
	return 1;
}

stock ClearActorAnimationsForPlayer(forplayerid, actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(Player_Flags[forplayerid][isdynamic][actorid] & ANIMATION_PLAY_NONE)
		return cellmin;

	Player_Flags[forplayerid][isdynamic][actorid] = Player_Flags[forplayerid][isdynamic][actorid] & ~(ANIMATION_PLAY_ONE_TIME | ANIMATION_PLAY_PERMANENT) | ANIMATION_PLAY_NONE;

	if(isdynamic)
		actorid = GetInternalActorIDForPlayer(forplayerid, actorid);
	
	if(actorid == INVALID_ACTOR_ID)
	{
		APD("[ClearActorAnimationsForPlayer] actorid %i isn't streamed (he's probably dynamic) for player: %i", actorid, forplayerid);
		return 2;
	}

	new BitStream:bit_stream = BS_New(); 
	BS_WriteInt16(bit_stream, actorid);
	BS_RPC(bit_stream, forplayerid, 0xAE); 
	BS_Delete(bit_stream);
	return 1;
}

stock IsActorPlayingAnimForPlayer(forplayerid, actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;
	return (Player_Flags[forplayerid][isdynamic][actorid] & ANIMATION_PLAY_NONE != ANIMATION_PLAY_NONE);	
}

// =======================================================================================================================================================================================

stock SetActorPosForPlayer(forplayerid, actorid, fake_position_type, Float:x, Float:y, Float:z, Float:angle, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(!(fake_position_type & (FAKE_POSITION_PERMANENT | FAKE_POSITION_ONE_TIME)))
		return cellmin;

	Player_Flags[forplayerid][isdynamic][actorid] = Player_Flags[forplayerid][isdynamic][actorid] & ~(FAKE_POSITION_NONE | FAKE_POSITION_ONE_TIME | FAKE_POSITION_PERMANENT) | fake_position_type;
	
	if(!(-360.0 <= angle <= 360.0))
	{
		new real_angle = floatround(angle);
		if(real_angle)
			real_angle -= real_angle % 360;
		else
			real_angle -= real_angle % -360;
		angle = float(real_angle);
	}

	new internal_actorid;

	if(!isdynamic)
	{
		PAttributes_StaticActor[forplayerid][actorid][appPosX] = x;
		PAttributes_StaticActor[forplayerid][actorid][appPosY] = y;
		PAttributes_StaticActor[forplayerid][actorid][appPosZ] = z;
		PAttributes_StaticActor[forplayerid][actorid][appPosAngle] = angle;
	}
	else
	{
		PAttributes_DynamicActor[forplayerid][actorid][appPosX] = x;
		PAttributes_DynamicActor[forplayerid][actorid][appPosY] = y;
		PAttributes_DynamicActor[forplayerid][actorid][appPosZ] = z;
		PAttributes_DynamicActor[forplayerid][actorid][appPosAngle] = angle;
		internal_actorid = GetInternalActorIDForPlayer(forplayerid, actorid);
	}

	Internal_HideAnActorForPlayer(forplayerid, actorid, isdynamic);

	if(internal_actorid == INVALID_ACTOR_ID)
	{
		APD("[SetActorPosForPlayer] actorid %i isn't streamed (he's probably dynamic) for player: %i", actorid, forplayerid);
		return 2;
	}

	new BitStream:bit_stream = BS_New();
	BS_WriteValue(bit_stream, 
		PR_UINT16, internal_actorid,
		PR_UINT32, Actors_Plus[actorid][isdynamic][eapSkin],
		PR_FLOAT, x,
		PR_FLOAT, y,
		PR_FLOAT, z,
		PR_FLOAT, angle,
		PR_FLOAT, Actors_Plus[actorid][isdynamic][eapHealth]);
	BS_RPC(bit_stream, forplayerid, 0xAB);
	BS_Delete(bit_stream);
	return 1;
}

stock BringBackActorPosForPlayer(forplayerid, actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;

	if(Player_Flags[forplayerid][isdynamic][actorid] & FAKE_POSITION_NONE)
		return cellmin;

	Player_Flags[forplayerid][isdynamic][actorid] = Player_Flags[forplayerid][isdynamic][actorid] & ~(FAKE_POSITION_PERMANENT | FAKE_POSITION_ONE_TIME) | FAKE_POSITION_NONE;

	Internal_HideAnActorForPlayer(forplayerid, actorid, isdynamic);
	Internal_BringBackActor(forplayerid, actorid, isdynamic);
	return 1;
}

stock IsActorAtDiffPosForPlayer(forplayerid, actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(!IsPlayerConnected(forplayerid) || !AP_IsValidActor(actorid, isdynamic))
		return 0;
	return ((Player_Flags[forplayerid][isdynamic][actorid] & FAKE_POSITION_NONE) != FAKE_POSITION_NONE);	
}


// =======================================================================================================================================================================================
// ================================================================================== Hooked callbacks ===================================================================================
// =======================================================================================================================================================================================

public OnActorStreamIn(actorid, forplayerid)
{
	new Float:x,
		Float:y,
		Float:z,
		bool:isdynamic;

	GetActorPos(actorid, x, y, z);
	new related_actorid = GetNearestActorByCoord(x, y, z, isdynamic, .max_range = 1.0);
	if(related_actorid == INVALID_ACTOR_ID)
	{
		#if defined AP_OnActorStreamIn
			return AP_OnActorStreamIn(actorid, forplayerid);
		#else
			return 1;
		#endif
	}

	if(Player_Flags[forplayerid][isdynamic][related_actorid] & ANIMATION_PLAY_PERMANENT)
	{
		APD("Applying custom (per-player) animation for actorid %i (from realid: %i).", related_actorid, actorid);
		new BitStream:bit_stream = BS_New(); 

		if(isdynamic)
		{
			BS_WriteValue(bit_stream,
				PR_UINT16, actorid,

				PR_UINT8, PAttributes_DynamicActor[forplayerid][related_actorid][appLibLength],
				PR_STRING, PAttributes_DynamicActor[forplayerid][related_actorid][appAnimLib],

				PR_UINT8, PAttributes_DynamicActor[forplayerid][related_actorid][appAnimLength],
				PR_STRING, PAttributes_DynamicActor[forplayerid][related_actorid][appAnimName],

				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appDelta],
				PR_BOOL, PAttributes_DynamicActor[forplayerid][related_actorid][appLoop],
				PR_BOOL, PAttributes_DynamicActor[forplayerid][related_actorid][appLockx],
				PR_BOOL, PAttributes_DynamicActor[forplayerid][related_actorid][appLocky],
				PR_BOOL, PAttributes_DynamicActor[forplayerid][related_actorid][appFreeze],
				PR_UINT32, PAttributes_DynamicActor[forplayerid][related_actorid][appTime]);
		}
		else
		{
			BS_WriteValue(bit_stream,
				PR_UINT16, actorid,	

				PR_UINT8, PAttributes_StaticActor[forplayerid][related_actorid][appLibLength],
				PR_STRING, PAttributes_StaticActor[forplayerid][related_actorid][appAnimLib],

				PR_UINT8, PAttributes_StaticActor[forplayerid][related_actorid][appAnimLength],
				PR_STRING, PAttributes_StaticActor[forplayerid][related_actorid][appAnimName],

				PR_FLOAT, PAttributes_StaticActor[forplayerid][related_actorid][appDelta],
				PR_BOOL, PAttributes_StaticActor[forplayerid][related_actorid][appLoop],
				PR_BOOL, PAttributes_StaticActor[forplayerid][related_actorid][appLockx],
				PR_BOOL, PAttributes_StaticActor[forplayerid][related_actorid][appLocky],
				PR_BOOL, PAttributes_StaticActor[forplayerid][related_actorid][appFreeze],
				PR_UINT32, PAttributes_StaticActor[forplayerid][related_actorid][appTime]);
		}
		BS_RPC(bit_stream, forplayerid, 0xAD); 
		BS_Delete(bit_stream);
	}
	else if(Player_Flags[forplayerid][isdynamic][related_actorid] & ANIMATION_PLAY_ONE_TIME)
		Player_Flags[forplayerid][isdynamic][related_actorid] &= ~ANIMATION_PLAY_ONE_TIME;

	if(Player_Flags[forplayerid][isdynamic][related_actorid] & FAKE_POSITION_PERMANENT)
	{
		APD("Setting custom (per-player) positions for actorid %i (from realid: %i). The actor is dynamic? %i", related_actorid, actorid, isdynamic);
		Internal_HideAnActorForPlayer(forplayerid, related_actorid, isdynamic);
		new BitStream:bit_stream = BS_New(); 
		if(isdynamic)
		{
			APD("Coordinates: %.4f | %.4f | %.4f", PAttributes_DynamicActor[forplayerid][related_actorid][appPosX], PAttributes_DynamicActor[forplayerid][related_actorid][appPosY], PAttributes_DynamicActor[forplayerid][related_actorid][appPosZ]);
			BS_WriteValue(bit_stream, 
				PR_UINT16, actorid,
				PR_UINT32, Actors_Plus[related_actorid][isdynamic][eapSkin],
				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appPosX],
				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appPosY],
				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appPosZ],
				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appPosAngle],
				PR_FLOAT, Actors_Plus[related_actorid][isdynamic][eapHealth]);
		}
		else
		{
			APD("Coordinates: %.4f | %.4f | %.4f", PAttributes_StaticActor[forplayerid][related_actorid][appPosX], PAttributes_StaticActor[forplayerid][related_actorid][appPosY], PAttributes_StaticActor[forplayerid][related_actorid][appPosZ]);
			BS_WriteValue(bit_stream, 
				PR_UINT16, actorid,
				PR_UINT32, Actors_Plus[related_actorid][isdynamic][eapSkin],
				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appPosX],
				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appPosY],
				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appPosZ],
				PR_FLOAT, PAttributes_DynamicActor[forplayerid][related_actorid][appPosAngle],
				PR_FLOAT, Actors_Plus[related_actorid][isdynamic][eapHealth]);
		}

		BS_RPC(bit_stream, forplayerid, 0xAB);
		BS_Delete(bit_stream);
	}
	else if(Player_Flags[forplayerid][isdynamic][related_actorid] & FAKE_POSITION_ONE_TIME)
		Player_Flags[forplayerid][isdynamic][related_actorid] &= ~FAKE_POSITION_ONE_TIME;

	#if defined AP_OnActorStreamIn
		return AP_OnActorStreamIn(actorid, forplayerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnActorStreamIn
    #undef OnActorStreamIn
#else
    #define _ALS_OnActorStreamIn
#endif
#define OnActorStreamIn AP_OnActorStreamIn
#if defined AP_OnActorStreamIn
	forward AP_OnActorStreamIn(actorid, forplayerid);
#endif

// =======================================================================================================================================================================================

public OnOutcomingRPC(playerid, rpcid, BitStream:bs)
{
	if(rpcid == 0xAB)
	{
		new actorid,
			internal_actorid,
			Float:x,
			Float:y,
			Float:z,
			bool:isdynamic;

		BS_ReadUint16(bs, internal_actorid);
		BS_ResetReadPointer(bs);
		GetActorPos(internal_actorid, x, y, z);
		actorid = GetNearestActorByCoord(x, y, z, isdynamic, .max_range = 1.0);
		if(actorid == INVALID_ACTOR_ID)
		{
			#if defined AP_OnOutcomingRPC
				return AP_OnOutcomingRPC(playerid, rpcid, bs);
			#else
				return 1;
			#endif
		}

		CallRemoteFunction("OnPlayerStreamForActor", "iiii", playerid, actorid, Player_Flags[playerid][isdynamic][actorid], isdynamic);
		if(Player_Flags[playerid][isdynamic][actorid] & HIDE_TYPE_PERMANENT)
		{
			APD("%i (real id: %i) detected as a permanent hidden actor for playerid: %i", actorid, internal_actorid, playerid);
			#if USING_STREAMER
				if(Streamer_IsToggleItem(playerid, STREAMER_TYPE_ACTOR, actorid) && isdynamic)
					Streamer_ToggleItem(playerid, STREAMER_TYPE_ACTOR, actorid, false);
			#endif
			return 0;
		}

		if((Player_Flags[playerid][isdynamic][actorid] & HIDE_TYPE_ONE_TIME))
		{
			Player_Flags[playerid][isdynamic][actorid] &= ~HIDE_TYPE_ONE_TIME;
			APD("%i (real id: %i) detected as a temporary hidden actor for playerid: %i", actorid, internal_actorid, playerid);
		}

		#if defined AP_OnOutcomingRPC
			return AP_OnOutcomingRPC(playerid, rpcid, bs);
		#else
			return 1;
		#endif
	}
	#if defined AP_OnOutcomingRPC
		return AP_OnOutcomingRPC(playerid, rpcid, bs);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnOutcomingRPC
    #undef OnOutcomingRPC
#else
    #define _ALS_OnOutcomingRPC
#endif
#define OnOutcomingRPC AP_OnOutcomingRPC
#if defined AP_OnOutcomingRPC
	forward AP_OnOutcomingRPC(playerid, rpcid, BitStream:bs);
#endif

#endif // #if USING_PAWN_RAKNET

// =======================================================================================================================================================================================
// ================================================================================= Internal functions ==================================================================================
// =======================================================================================================================================================================================
// =======================================================================================================================================================================================

static stock AP_IsValidActor(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	if(Actors_Plus[actorid][isdynamic][eapSkin] == -1)
		return 0;

	#if !USING_STREAMER
		#if USING_Y_ITERATE
			if(!Iter_Contains(Actor, actorid) || !IsValidActor(actorid))
				return 0;
		#else
			if(!(0 <= actorid <= MAX_ACTORS) || !(Actors_Flags[actorid][isdynamic] & IS_EXISTING) || !IsValidActor(actorid))
				return 0;
		#endif
		return 1;

	#else

		#if !USING_Y_ITERATE
			if(!(0 <= actorid <= MAX_ACTORS) || !(Actors_Flags[actorid][isdynamic] & IS_EXISTING))
				return 0;
		#endif

		if(!isdynamic)
		{
			if(!IsValidActor(actorid))
				return 0;

			#if USING_Y_ITERATE
				if(!Iter_Contains(Actor, actorid))
					return 0;
			#endif
		}

		else
		{
			if(!IsValidDynamicActor(actorid))
				return 0;

			#if USING_Y_ITERATE
				if(!Iter_Contains(Dynamic_Actor, actorid))
					return 0;
			#endif
		}
		return 1;
	#endif
}

// =======================================================================================================================================================================================

static stock Internal_HideAnActorForPlayer(playerid, actorid, bool:isdynamic)
{
	if(isdynamic)
		actorid = GetInternalActorIDForPlayer(playerid, actorid);

	if(actorid == INVALID_ACTOR_ID)
	{
		APD("[Internal_HideAnActorForPlayer] actorid %i isn't streamed (he's probably dynamic) for player: %i", actorid, playerid);
		return 2;
	}

	new BitStream:bit_stream = BS_New(); 
	BS_WriteValue(bit_stream, 
		PR_UINT16, actorid);

	BS_RPC(bit_stream, playerid, 0xAC); 
	BS_Delete(bit_stream);
	return 1;
}

static stock Internal_BringBackActor(forplayerid, actorid, isdynamic)
{
	APD("[%s] Bringing actor %i for playerid: %i", (isdynamic ? "Dynamic" : "Static"), actorid, forplayerid);
	Player_Flags[forplayerid][isdynamic][actorid] = Player_Flags[forplayerid][isdynamic][actorid] & ~(HIDE_TYPE_PERMANENT | HIDE_TYPE_ONE_TIME) | HIDE_TYPE_NONE;
	#if USING_STREAMER
		if(!Streamer_IsToggleItem(forplayerid, STREAMER_TYPE_ACTOR, actorid) && isdynamic)
			Streamer_ToggleItem(forplayerid, STREAMER_TYPE_ACTOR, actorid, true);
	#endif
	new internal_actorid;
	if(isdynamic)
		internal_actorid = GetInternalActorIDForPlayer(forplayerid, actorid);

	APD("Internal actorid is : %i", internal_actorid);
	if(internal_actorid == INVALID_ACTOR_ID)
	{
		APD("[Internal_BringBackActor] actorid %i isn't streamed (he's probably dynamic) for player: %i", actorid, forplayerid);
		return 2;
	}

	new BitStream:bit_stream = BS_New(); 
	BS_WriteValue(bit_stream, 
		PR_UINT16, internal_actorid,
		PR_UINT32, Actors_Plus[actorid][isdynamic][eapSkin],
		PR_FLOAT, Actors_Plus[actorid][isdynamic][eapPosX],
		PR_FLOAT, Actors_Plus[actorid][isdynamic][eapPosY],
		PR_FLOAT, Actors_Plus[actorid][isdynamic][eapPosZ],
		PR_FLOAT, Actors_Plus[actorid][isdynamic][eapPosAngle],
		PR_FLOAT, Actors_Plus[actorid][isdynamic][eapHealth]); 

	BS_RPC(bit_stream, forplayerid, 0xAB);
	BS_Delete(bit_stream);
	return 1;
}

// =======================================================================================================================================================================================

static stock RecreateActor(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	#if !USING_STREAMER
		DestroyActor(actorid);
		CreateActor(Actors_Plus[actorid][isdynamic][eapSkin], Actors_Plus[actorid][isdynamic][eapPosX], Actors_Plus[actorid][isdynamic][eapPosY], Actors_Plus[actorid][isdynamic][eapPosZ], Actors_Plus[actorid][isdynamic][eapPosAngle]);
		
		if(Actors_Plus[actorid][isdynamic][eapLabel] != Text3D:INVALID_3DTEXT_ID)
			Internal_Update3DActorTextLabel(actorid);

		SetActorHealth(actorid, Actors_Plus[actorid][isdynamic][eapHealth]);
		SetActorInvulnerable(actorid, ((Actors_Flags[actorid][DYNAMIC_CATEGORY] & IS_INVULNERABLE) == IS_INVULNERABLE));
		return 1;
	#else
	if(!isdynamic)
	{
		DestroyActor(actorid);
		CreateActor(Actors_Plus[actorid][isdynamic][eapSkin], Actors_Plus[actorid][isdynamic][eapPosX], Actors_Plus[actorid][isdynamic][eapPosY], Actors_Plus[actorid][isdynamic][eapPosZ], Actors_Plus[actorid][isdynamic][eapPosAngle]);
		
		if(Actors_Plus[actorid][isdynamic][eapLabel] != Text3D:INVALID_3DTEXT_ID)
			Internal_Update3DActorTextLabel(actorid);

		SetActorHealth(actorid, Actors_Plus[actorid][isdynamic][eapHealth]);
		SetActorInvulnerable(actorid, ((Actors_Flags[actorid][DYNAMIC_CATEGORY] & IS_INVULNERABLE) == IS_INVULNERABLE));
	}
	else
	{
		DestroyDynamicActor(actorid);
		CreateDynamicActor(Actors_Plus[actorid][isdynamic][eapSkin], Actors_Plus[actorid][isdynamic][eapPosX], Actors_Plus[actorid][isdynamic][eapPosY], Actors_Plus[actorid][isdynamic][eapPosZ], Actors_Plus[actorid][isdynamic][eapPosAngle], Actors_Plus[actorid][isdynamic][eapInvulnerable], Actors_Plus[actorid][isdynamic][eapHealth], Actors_Plus[actorid][isdynamic][eapVW],
			Actors_Plus[actorid][isdynamic][eapInt], Actors_Plus[actorid][isdynamic][eapPlayerid], Actors_Plus[actorid][isdynamic][eapStreamDistance], Actors_Plus[actorid][isdynamic][eapAreaid], Actors_Plus[actorid][isdynamic][eapPriority]);

		if(Actors_Plus[actorid][isdynamic][eapLabel] != Text3D:INVALID_3DTEXT_ID)
			Internal_Update3DActorTextLabel(actorid);
		SetDynamicActorHealth(actorid, Actors_Plus[actorid][isdynamic][eapHealth]);
		SetDynamicActorInvulnerable(actorid, ((Actors_Flags[actorid][isdynamic] & IS_INVULNERABLE) == IS_INVULNERABLE));
	}
	return 1;
	#endif
}

static stock Format3DActorTextLabel(actorid, bool:name, bool:text, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	new formatted_label[300];
	if(name)
		strcat(formatted_label, Actors_Plus[actorid][isdynamic][eapName]);

	if(text)
	{
		if(isnull(formatted_label))
			strcat(formatted_label, Actors_Plus[actorid][isdynamic][eapLabelText]);
		else
			format(formatted_label, sizeof(formatted_label), "{%x}%s\n{%x}%s", Actors_Plus[actorid][isdynamic][eapLabelNameColor] >>> 8, Actors_Plus[actorid][isdynamic][eapName], Actors_Plus[actorid][isdynamic][eapLabelColor] >>> 8, Actors_Plus[actorid][isdynamic][eapLabelText]);
	}
	return formatted_label;
}

static stock Internal_Update3DActorTextLabel(actorid, bool:isdynamic = DEFAULT_IS_DYNAMIC_PARAMETER)
{
	#if USING_STREAMER

		if(Actors_Plus[actorid][isdynamic][eapLabel] == Text3D:INVALID_3DTEXT_ID)
			return Attach3DTextLabelToActor(actorid, Format3DActorTextLabel(actorid, !isnull(Actors_Plus[actorid][isdynamic][eapName]) && (Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED), !isnull(Actors_Plus[actorid][isdynamic][eapLabelText]) && (Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED)), isdynamic, Actors_Plus[actorid][isdynamic][eapLabelColor], Actors_Plus[actorid][isdynamic][eapLabelPosX], Actors_Plus[actorid][isdynamic][eapLabelPosY], Actors_Plus[actorid][isdynamic][eapLabelPosZ], Actors_Plus[actorid][isdynamic][eapLabelDrawDistance], .store_string = false);
		else
			return UpdateDynamic3DTextLabelText(Actors_Plus[actorid][isdynamic][eapLabel], Actors_Plus[actorid][isdynamic][eapLabelColor], Format3DActorTextLabel(actorid, !isnull(Actors_Plus[actorid][isdynamic][eapName]) && (Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED), !isnull(Actors_Plus[actorid][DYNAMIC_CATEGORY][eapLabelText]) && (Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED)));
	#else
		if(Actors_Plus[actorid][isdynamic][eapLabel] == Text3D:INVALID_3DTEXT_ID)
			return Attach3DTextLabelToActor(actorid, Format3DActorTextLabel(actorid, !isnull(Actors_Plus[actorid][isdynamic][eapName]) && (Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED), !isnull(Actors_Plus[actorid][isdynamic][eapLabelText]) && (Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED), false), Actors_Plus[actorid][isdynamic][eapLabelColor], Actors_Plus[actorid][DYNAMIC_CATEGORY][eapLabelPosX], Actors_Plus[actorid][DYNAMIC_CATEGORY][eapLabelPosY], Actors_Plus[actorid][DYNAMIC_CATEGORY][eapLabelPosZ], Actors_Plus[actorid][DYNAMIC_CATEGORY][eapLabelDrawDistance], .store_string = false);
		else
			return Update3DTextLabelText(Actors_Plus[actorid][isdynamic][eapLabel], Actors_Plus[actorid][isdynamic][eapLabelColor], Format3DActorTextLabel(actorid, !isnull(Actors_Plus[actorid][isdynamic][eapName]) && (Actors_Flags[actorid][isdynamic] & HAS_NAME_DISPLAYED), !isnull(Actors_Plus[actorid][isdynamic][eapLabelText]) && (Actors_Flags[actorid][isdynamic] & HAS_TEXT_DISPLAYED), false));
	#endif
}

// =======================================================================================================================================================================================

static stock ReSynchActor(actorid)
{
	SetActorPos(actorid, 999.0, 999.0, 999.0);
	#if USING_Y_TIMERS
		defer AP_ReplaceActor(actorid);
	#else
		SetTimerEx("@AP_ReplaceActor", DEFAULT_ACTOR_REPLACEMENT, false, "i", actorid);
	#endif
}

// =======================================================================================================================================================================================

static stock GetInternalActorIDForPlayer(forplayerid, actorid)
{
	#if USING_STREAMER
		return Streamer_GetItemInternalID(forplayerid, STREAMER_TYPE_ACTOR, actorid);
	#else
		#pragma unused forplayerid
		return actorid;
	#endif
}

// =======================================================================================================================================================================================

#if USING_Y_TIMERS
	timer AP_ReplaceActor[DEFAULT_ACTOR_REPLACEMENT](actorid)
	{
		SetActorPos(actorid, Actors_Plus[actorid][STATIC_CATEGORY][eapPosX], Actors_Plus[actorid][STATIC_CATEGORY][eapPosY], Actors_Plus[actorid][STATIC_CATEGORY][eapPosZ]+0.1);
		SetActorFacingAngle(actorid, Actors_Plus[actorid][STATIC_CATEGORY][eapPosAngle]);
		return 1;
	}
#else
	forward @AP_ReplaceActor(actorid);
	@AP_ReplaceActor(actorid)
	{
		SetActorPos(actorid, Actors_Plus[actorid][STATIC_CATEGORY][eapPosX], Actors_Plus[actorid][STATIC_CATEGORY][eapPosY], Actors_Plus[actorid][STATIC_CATEGORY][eapPosZ]+0.1);
		SetActorFacingAngle(actorid, Actors_Plus[actorid][STATIC_CATEGORY][eapPosAngle]);
		return 1;
	}
#endif

// =======================================================================================================================================================================================
// =========================================================================== Hooked native functions ===================================================================================
// =======================================================================================================================================================================================
// =======================================================================================================================================================================================

#if USING_STREAMER

	stock AP_CreateDynamicActor(modelid, Float:x, Float:y, Float:z, Float:r, invulnerable = 1, Float:health = 100.0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_ACTOR_SD, STREAMER_TAG_AREA:areaid = STREAMER_TAG_AREA:-1, priority = 0)
	{
		new actorid;
		actorid = CreateDynamicActor(modelid, x, y, z, r, invulnerable, health, worldid, interiorid, playerid, streamdistance, areaid, priority);
		if(actorid == INVALID_ACTOR_ID)
			return INVALID_ACTOR_ID;

		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapSkin] = modelid;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosX] = x;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosY] = y;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosZ] = z;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosAngle] = r;

		#if !USING_Y_ITERATE
			Actors_Flags[actorid][DYNAMIC_CATEGORY] |= IS_EXISTING;
		#else
			Iter_Add(Dynamic_Actor, actorid);
		#endif

		if(invulnerable)
			Actors_Flags[actorid][DYNAMIC_CATEGORY] |= IS_INVULNERABLE;

		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapHealth] = health;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapVW] = worldid;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapInt] = interiorid;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPlayerid] = playerid;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapStreamDistance] = streamdistance;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapAreaid] = areaid;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPriority] = priority;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapLabel] = Text3D:INVALID_3DTEXT_ID;
		
		CallRemoteFunction("OnActorSpawn", "ii", actorid, true);
		APD("CreateDynamicActor: %i created", actorid);
		return actorid;
	}

	#if defined _ALS_CreateDynamicActor
	    #undef CreateDynamicActor
	#else
	    #define _ALS_CreateDynamicActor
	#endif
	#define CreateDynamicActor AP_CreateDynamicActor


	stock AP_CreateDynamicActorEx(modelid, Float:x, Float:y, Float:z, Float:r, invulnerable = 1, Float:health = 100.0, Float:streamdistance = STREAMER_ACTOR_SD, worlds[] = { -1 }, interiors[] = { -1 }, players[] = { -1 }, STREAMER_TAG_AREA:areas[] = { STREAMER_TAG_AREA:-1 }, priority = 0, maxworlds = sizeof worlds, maxinteriors = sizeof interiors, maxplayers = sizeof players, maxareas = sizeof areas)
	{
		new actorid;
		actorid = CreateDynamicActorEx(modelid, x, y, z, r, invulnerable, health, streamdistance, worlds, interiors, players, areas, priority, maxworlds, maxinteriors, maxplayers, maxareas);
		if(actorid == INVALID_ACTOR_ID)
			return INVALID_ACTOR_ID;

		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapSkin] = modelid;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosX] = x;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosY] = y;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosZ] = z;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosAngle] = r;

		#if !USING_Y_ITERATE
			Actors_Flags[actorid][DYNAMIC_CATEGORY] |= IS_EXISTING;
		#else
			Iter_Add(Dynamic_Actor, actorid);
		#endif

		if(invulnerable)
			Actors_Flags[actorid][DYNAMIC_CATEGORY] |= IS_INVULNERABLE;

		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapHealth] = health;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapVW] = -1;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapInt] = -1;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPlayerid] = -1;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapStreamDistance] = streamdistance;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapAreaid] = STREAMER_TAG_AREA:-1;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPriority] = priority;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapLabel] = Text3D:INVALID_3DTEXT_ID;
		
		CallRemoteFunction("OnActorSpawn", "ii", actorid, true);
		APD("CreateDynamicActor: %i created", actorid);
		return actorid;
	}

	#if defined _ALS_CreateDynamicActorEx
	    #undef CreateDynamicActorEx
	#else
	    #define _ALS_CreateDynamicActorEx
	#endif
	#define CreateDynamicActorEx AP_CreateDynamicActorEx

	stock AP_DestroyDynamicActor(STREAMER_TAG_ACTOR:actorid)
	{
		DestroyActor3DTextLabel(actorid, true);
		APD("Dynamic actorid %i has been destroyed.", actorid);
		new reset_var[E_ACTOR_PLUS_DATA];

		#if USING_Y_ITERATE
			Iter_Remove(Dynamic_Actor, actorid);
			foreach(new i : Player)
				Player_Flags[i][DYNAMIC_CATEGORY][actorid] = 0;
		#else
			Actors_Flags[actorid][DYNAMIC_CATEGORY] &= ~IS_EXISTING;
			for(new i, j = GetPlayerPoolSize(); i <= j; i++)
				Player_Flags[i][DYNAMIC_CATEGORY][actorid] = 0;
		#endif

		Actors_Plus[actorid][DYNAMIC_CATEGORY] = reset_var;
		Actors_Flags[actorid][DYNAMIC_CATEGORY] = E_ACTOR_PLUS_FLAGS:0;
		return DestroyDynamicActor(actorid);
	}

	#if defined _ALS_DestroyDynamicActor
	    #undef DestroyDynamicActor
	#else
	    #define _ALS_DestroyDynamicActor
	#endif
	#define DestroyDynamicActor AP_DestroyDynamicActor


	stock AP_SetDynamicActorHealth(STREAMER_TAG_ACTOR:actorid, Float:health)
	{
		if(!IsValidDynamicActor(actorid))
			return 0;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapHealth] = health;
		if((Actors_Flags[actorid][DYNAMIC_CATEGORY] & IS_DEAD) && health > 0.0)
			Actors_Flags[actorid][DYNAMIC_CATEGORY] &= ~IS_DEAD;

		if(health <= 0.0)
		{
			#if defined OnActorDeath
				OnActorDeath(actorid, INVALID_ACTOR_ID, WEAPON_DROWN, true);
			#endif
			Actors_Flags[actorid][DYNAMIC_CATEGORY] |= IS_DEAD;
		}

		return SetDynamicActorHealth(actorid, health);
	}

	#if defined _ALS_SetDynamicActorHealth
	    #undef SetDynamicActorHealth
	#else
	    #define _ALS_SetDynamicActorHealth
	#endif
	#define SetDynamicActorHealth AP_SetDynamicActorHealth

	stock AP_SetDynamicActorInvulnerable(STREAMER_TAG_ACTOR:actorid, invulnerable = 1)
	{
		if(!SetDynamicActorInvulnerable(actorid, invulnerable))
			return 0;
		if(invulnerable)
			Actors_Flags[actorid][DYNAMIC_CATEGORY] |= IS_INVULNERABLE;
		else
			Actors_Flags[actorid][DYNAMIC_CATEGORY] &= ~IS_INVULNERABLE;
		return 1;
	}

	#if defined ALS_SetDynamicActorInvulnerable
	    #undef SetDynamicActorInvulnerable
	#else
	    #define ALS_SetDynamicActorInvulnerable
	#endif
	#define SetDynamicActorInvulnerable AP_SetDynamicActorInvulnerable

	stock AP_SetDynamicActorVirtualWorld(actorid, vworld)
	{
		if(!SetDynamicActorVirtualWorld(actorid, vworld))
			return 0;
		CallRemoteFunction("OnActorVirtualWorldChange", "iiii", actorid, Actors_Plus[actorid][DYNAMIC_CATEGORY][eapVW], vworld, true);
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapVW] = vworld;
		return 1;
	}

	#if defined _ALS_SetDynActorVirtualWorld
	    #undef SetDynamicActorVirtualWorld
	#else
	    #define _ALS_SetDynActorVirtualWorld
	#endif
	#define SetDynamicActorVirtualWorld AP_SetDynamicActorVirtualWorld

	stock AP_SetDynamicActorFacingAngle(actorid, Float:ang)
	{
		if(!SetDynamicActorFacingAngle(actorid, ang))
			return 0;
		Actors_Plus[actorid][DYNAMIC_CATEGORY][eapPosAngle] = ang;
		return 1;
	}

	#if defined _ALS_SetDynamicActorFacingAngle
	    #undef SetDynamicActorFacingAngle
	#else
	    #define _ALS_SetDynamicActorFacingAngle
	#endif
	#define SetDynamicActorFacingAngle AP_SetDynamicActorFacingAngle

#endif // #if USING_STREAMER



stock AP_CreateActor(modelid, Float:X, Float:Y, Float:Z, Float:Rotation)
{
	new actorid;
	actorid = CreateActor(modelid, X, Y, Z, Rotation);
	if(actorid == INVALID_ACTOR_ID)
		return INVALID_ACTOR_ID;

	#if USING_Y_ITERATE
		Iter_Add(Actor, actorid);
	#else
		Actors_Flags[actorid][STATIC_CATEGORY] |= IS_EXISTING;
	#endif

	Actors_Plus[actorid][STATIC_CATEGORY][eapSkin] = modelid;
	Actors_Plus[actorid][STATIC_CATEGORY][eapPosX] = X;
	Actors_Plus[actorid][STATIC_CATEGORY][eapPosY] = Y;
	Actors_Plus[actorid][STATIC_CATEGORY][eapPosZ] = Z;
	Actors_Plus[actorid][STATIC_CATEGORY][eapHealth] = 100.0;
	Actors_Plus[actorid][STATIC_CATEGORY][eapPosAngle] = Rotation;
	Actors_Plus[actorid][STATIC_CATEGORY][eapLabel] = Text3D:INVALID_3DTEXT_ID;

	#if defined OnActorSpawn
		OnActorSpawn(actorid, false);
	#endif

	APD("CreateActor: %i created.", actorid);
	return actorid;
}

stock AP_DestroyActor(actorid)
{
	DestroyActor3DTextLabel(actorid, false);
	APD("Normal actorid %i has been destroyed.", actorid);
	#if USING_Y_ITERATE
		foreach(new i : Player)
			Player_Flags[i][STATIC_CATEGORY][actorid] = 0;
	#else
		Actors_Flags[actorid][STATIC_CATEGORY] &= ~IS_EXISTING;
		for(new i, j = GetPlayerPoolSize(); i <= j; i++)
			Player_Flags[i][STATIC_CATEGORY][actorid] = 0;
	#endif
	new reset_var[E_ACTOR_PLUS_DATA];
	Actors_Plus[actorid][STATIC_CATEGORY] = reset_var;
	Actors_Flags[actorid][STATIC_CATEGORY] = E_ACTOR_PLUS_FLAGS:0;
	return DestroyActor(actorid);
}


#if defined _ALS_CreateActor
    #undef CreateActor
#else
    #define _ALS_CreateActor
#endif
#define CreateActor AP_CreateActor

#if defined _ALS_DestroyActor
    #undef DestroyActor
#else
    #define _ALS_DestroyActor
#endif
#define DestroyActor AP_DestroyActor

stock AP_SetActorHealth(actorid, Float:health)
{
	if(!IsValidActor(actorid))
		return 0;
	Actors_Plus[actorid][STATIC_CATEGORY][eapHealth] = health;
	if((Actors_Flags[actorid][STATIC_CATEGORY] & IS_DEAD) && health > 0.0)
		Actors_Flags[actorid][STATIC_CATEGORY] &= ~IS_DEAD;

	if(health <= 0.0)
	{
		#if defined OnActorDeath
			OnActorDeath(actorid, INVALID_ACTOR_ID, WEAPON_DROWN, false);
		#endif
		Actors_Flags[actorid][STATIC_CATEGORY] |= IS_DEAD;
	}

	return SetActorHealth(actorid, health);
}

#if defined _ALS_SetActorHealth
    #undef SetActorHealth
#else
    #define _ALS_SetActorHealth
#endif
#define SetActorHealth AP_SetActorHealth


stock AP_SetActorInvulnerable(actorid, invulnerable = true)
{
	if(!SetActorInvulnerable(actorid, invulnerable))
		return 0;
	if(invulnerable)
		Actors_Flags[actorid][STATIC_CATEGORY] |= IS_INVULNERABLE;
	else
		Actors_Flags[actorid][STATIC_CATEGORY] &= ~IS_INVULNERABLE;
	ReSynchActor(actorid);
	return 1;
}

#if defined _ALS_SetActorInvulnerable
    #undef SetActorInvulnerable
#else
    #define _ALS_SetActorInvulnerable
#endif
#define SetActorInvulnerable AP_SetActorInvulnerable

stock AP_SetActorVirtualWorld(actorid, vworld)
{
	if(!SetActorVirtualWorld(actorid, vworld))
		return 0;
	CallRemoteFunction("OnActorVirtualWorldChange", "iiii", actorid, Actors_Plus[actorid][STATIC_CATEGORY][eapVW], vworld, false);
	Actors_Plus[actorid][STATIC_CATEGORY][eapVW] = vworld;
	return 1;
}

#if defined _ALS_SetActorVirtualWorld
    #undef SetActorVirtualWorld
#else
    #define _ALS_SetActorVirtualWorld
#endif
#define SetActorVirtualWorld AP_SetActorVirtualWorld


stock AP_SetActorFacingAngle(actorid, Float:ang)
{
	if(!SetActorFacingAngle(actorid, ang))
		return 0;
	Actors_Plus[actorid][STATIC_CATEGORY][eapPosAngle] = ang;
	ReSynchActor(actorid);
	return 1;
}

#if defined _ALS_SetActorFacingAngle
    #undef SetActorFacingAngle
#else
    #define _ALS_SetActorFacingAngle
#endif
#define SetActorFacingAngle AP_SetActorFacingAngle


stock AP_ApplyActorAnimation(actorid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time)
{
	if(!ApplyActorAnimation(actorid, animlib, animname, fDelta, loop, lockx, locky, freeze, time))
		return 0;
	strcpy(Actors_Plus_Animations[actorid][apadAnimLib], animlib);
	strcpy(Actors_Plus_Animations[actorid][apadAnimName], animname);
	APD("[hook - %i] Lib : %s & Name: %s", actorid, Actors_Plus_Animations[actorid][apadAnimLib], Actors_Plus_Animations[actorid][apadAnimName]);
	Actors_Plus_Animations[actorid][apadDelta] = fDelta;
	Actors_Plus_Animations[actorid][apadLoop] = loop;
	Actors_Plus_Animations[actorid][apadLocky] = locky;
	Actors_Plus_Animations[actorid][apadLockx] = lockx;
	Actors_Plus_Animations[actorid][apadFreeze] = freeze;
	Actors_Plus_Animations[actorid][apadTime] = time;
	return 1;
}

#if defined _ALS_ApplyActorAnimation
    #undef ApplyActorAnimation
#else
    #define _ALS_ApplyActorAnimation
#endif