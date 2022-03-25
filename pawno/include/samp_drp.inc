/*
  SA-MP - Discord Rich Presence plugin
*/


#if defined _SAMP_DRP_
	#endinput
#endif
#define _SAMP_DRP_

native DRP_InitializeDiscordPlugin(const application_id[], const details[], const drp_state[], const large_image[], const large_image_text[], const small_image[], const small_image_text[]);
native DRP_IsPlayerUsingClientPlugin(const playerid);
native DRP_GetPlayerDetails(const playerid, details[], const length);
native DRP_GetPlayerLargeImageKey(const playerid, large_imagekey[], const length);
native DRP_GetPlayerSmallImageKey(const playerid, small_imagekey[], const length);
native DRP_GetPlayerSmallImageText(const playerid, small_image_text[], const length);
native DRP_GetPlayerLargeImageText(const playerid, large_image_text[], const length);
native DRP_GetPlayerState(const playerid, drp_state[], const length);
native DRP_SetPlayerDetails(const playerid, const details[]);
native DRP_SetPlayerLargeImageKey(const playerid, const large_image_key[]);
native DRP_SetPlayerLargeImageText(const playerid, const large_image_text[]);
native DRP_SetPlayerSmallImageKey(const playerid, const small_image_key[]);
native DRP_SetPlayerSmallImageText(const playerid, const small_image_text[]);
native DRP_SetPlayerState(const playerid, const drp_state[]);