#if defined _037_compat_included
    #endinput
#endif
#define _037_compat_included

#include <a_samp>
#include <Pawn.RakNet>
#include <037-compat-fix>

/*Variables*/
static bool:_037_compat_IsClient037[MAX_PLAYERS char];

/*Consts*/
const RPC_ClientJoin = 25;
const RPC_SetPlayerSkin = 153;
const RPC_WorldPlayerAdd = 32;
const RPC_RequestClass = 128;
const RPC_SetSpawnInfo = 68;
const RPC_ShowActor = 171;
const RPC_CreateObject = 44;
const RPC_ModelData = 179;
	
/*Callbacks*/
public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
	if(playerid == -1) return false;

	if(rpcid == RPC_ClientJoin)
	{
		new iVersion,
			byteMod,
			byteNameLen,
			NickName[257],
			uiClientChallengeResponse,
			byteAuthBSLen,
			auth_bs[4*16],
			iClientVerLen,
			ClientVersion[12];

		BS_ReadValue(
			bs,
			PR_INT32, iVersion,
			PR_UINT8, byteMod,
			PR_UINT8, byteNameLen,
			PR_STRING, NickName, byteNameLen,
			PR_UINT32, uiClientChallengeResponse,
			PR_UINT8, byteAuthBSLen,
			PR_STRING, auth_bs, byteAuthBSLen,
			PR_UINT8, iClientVerLen,
			PR_STRING, ClientVersion, iClientVerLen
		);

		_037_compat_IsClient037{playerid} = false;

		if(iVersion == 4057)
		{
			_037_compat_IsClient037{playerid} = true;
			
			iVersion = 4062;

			//fix and solve challenge
			uiClientChallengeResponse = (uiClientChallengeResponse ^ 4057) ^ iVersion;

			BS_Reset(bs);

			BS_WriteValue(
				bs,
				PR_INT32, iVersion,
				PR_UINT8, byteMod,
				PR_UINT8, byteNameLen,
				PR_STRING, NickName,
				PR_UINT32, uiClientChallengeResponse,
				PR_UINT8, byteAuthBSLen,
				PR_STRING, auth_bs,
				PR_UINT8, iClientVerLen,
				PR_STRING, ClientVersion
			);
		}

		BS_ResetReadPointer(bs);
		BS_ResetWritePointer(bs);
		
	}
	
	#if defined _037_compat_OnIncomingRPC
		return _037_compat_OnIncomingRPC(playerid, rpcid, BitStream:bs);
	#else
		return 1;
	#endif
}

public OnOutcomingRPC(playerid, rpcid, BitStream:bs)
{
	if(playerid < 0)
	#if defined _037_compat_OnOutcomingRPC
		return _037_compat_OnOutcomingRPC(playerid, rpcid, BitStream:bs);
	#else
		return 1;
	#endif
	
	if(_037_compat_IsClient037{playerid})
	{
		switch(rpcid)
		{
			case RPC_ModelData:
				return 0;

			case RPC_SetPlayerSkin:
			{
				new wPlayerID,
					dSkinID,
                    dCustomSkinID;

                BS_ReadValue(
                    bs,
					PR_UINT16, wPlayerID,
					PR_UINT32, dSkinID,
                    PR_UINT32, dCustomSkinID
				);

				new BitStream:bsn = BS_New();

                BS_WriteValue(
					bsn,
					PR_UINT32, wPlayerID,
					PR_UINT32, dSkinID
				);

                #if defined _037_compat_OnOutcomingRPC
				new offset;
				BS_GetWriteOffset(bsn, offset);

				BS_ResetReadPointer(bsn);
				BS_ResetWritePointer(bsn);
				
				if(_037_compat_OnOutcomingRPC(playerid, rpcid, bsn))
				{
					BS_SetWriteOffset(bsn, offset);
					PR_SendRPC(bsn, playerid, rpcid);
				}
				#else
				PR_SendRPC(bsn, playerid, rpcid);
				#endif

				BS_Delete(bsn);

				return 0;
			}

			case RPC_WorldPlayerAdd:
			{
				new wPlayerID,
					team,
					dSkinID,
					Float:PosX,
					Float:PosY,
					Float:PosZ,
					Float:facing_angle,
					player_color,
					fighting_style;

				BS_ReadValue(
					bs,
					PR_UINT16, wPlayerID,
					PR_UINT8, team,
					PR_UINT32, dSkinID
                );

                BS_IgnoreBits(bs, 32);
					
                BS_ReadValue(
					bs,
                    PR_FLOAT, PosX,
					PR_FLOAT, PosY,
					PR_FLOAT, PosZ,
					PR_FLOAT, facing_angle,
					PR_UINT32, player_color,
					PR_UINT8, fighting_style
				);

				new BitStream:bsn = BS_New();

                BS_WriteValue(
					bsn,
					PR_UINT16, wPlayerID,
					PR_UINT8, team,
					PR_UINT32, dSkinID,
					PR_FLOAT, PosX,
					PR_FLOAT, PosY,
					PR_FLOAT, PosZ,
					PR_FLOAT, facing_angle,
					PR_UINT32, player_color,
					PR_UINT8, fighting_style
				);

				#if defined _037_compat_OnOutcomingRPC
				new offset;
				BS_GetWriteOffset(bsn, offset);

				BS_ResetReadPointer(bsn);
				BS_ResetWritePointer(bsn);
				
				if(_037_compat_OnOutcomingRPC(playerid, rpcid, bsn))
				{
					BS_SetWriteOffset(bsn, offset);
					PR_SendRPC(bsn, playerid, rpcid);
				}
				#else
				PR_SendRPC(bsn, playerid, rpcid);
				#endif

				BS_Delete(bsn);

				return 0;
			}

			case RPC_ShowActor:
			{
				new wActorID,
					SkinID,
					Float:X,
					Float:Y,
					Float:Z,
					Float:Angle,
					Float:health,
					bInvulnerable;

				BS_ReadValue(
					bs,
					PR_UINT16, wActorID,
					PR_UINT32, SkinID
				);

				BS_IgnoreBits(bs, 32);
					
				BS_ReadValue(
					bs,
					PR_FLOAT, X,
					PR_FLOAT, Y,
					PR_FLOAT, Z,
					PR_FLOAT, Angle,
					PR_FLOAT, health,
					PR_BOOL, bInvulnerable
				);

				new BitStream:bsn = BS_New();

				BS_WriteValue(
					bsn,
					PR_UINT16, wActorID,
					PR_UINT32, SkinID,
					PR_FLOAT, X,
					PR_FLOAT, Y,
					PR_FLOAT, Z,
					PR_FLOAT, Angle,
					PR_FLOAT, health,
					PR_BOOL, bInvulnerable
				);

				#if defined _037_compat_OnOutcomingRPC
				new offset;
				BS_GetWriteOffset(bsn, offset);

				BS_ResetReadPointer(bsn);
				BS_ResetWritePointer(bsn);
				
				if(_037_compat_OnOutcomingRPC(playerid, rpcid, bsn))
				{
					BS_SetWriteOffset(bsn, offset);
					PR_SendRPC(bsn, playerid, rpcid);
				}
				#else
				PR_SendRPC(bsn, playerid, rpcid);
				#endif

				BS_Delete(bsn);

				return 0;
			}

			case RPC_RequestClass:
			{
				new byteRequestOutcome,
					byteTeam,
					iSkin,
					unk,
					Float:vecPos[3],
					Float:fRotation,
					iSpawnWeapons[3],
					iSpawnWeaponsAmmo[3];

                BS_ReadValue(
					bs,
					PR_UINT8, byteRequestOutcome,
					PR_UINT8, byteTeam,
					PR_INT32, iSkin
                );

                BS_IgnoreBits(bs, 32);
					
                BS_ReadValue(
					bs,
					PR_UINT8, unk,
					PR_FLOAT, vecPos[0],
					PR_FLOAT, vecPos[1],
					PR_FLOAT, vecPos[2],
					PR_FLOAT, fRotation,
					PR_INT32, iSpawnWeapons[0],
					PR_INT32, iSpawnWeapons[1],
					PR_INT32, iSpawnWeapons[2],
					PR_INT32, iSpawnWeaponsAmmo[0],
					PR_INT32, iSpawnWeaponsAmmo[1],
					PR_INT32, iSpawnWeaponsAmmo[2]
				);

				new BitStream:bsn = BS_New();
				
                BS_WriteValue(
					bsn,
					PR_UINT8, byteRequestOutcome,
					PR_UINT8, byteTeam,
					PR_INT32, iSkin,
					PR_UINT8, unk,
					PR_FLOAT, vecPos[0],
					PR_FLOAT, vecPos[1],
					PR_FLOAT, vecPos[2],
					PR_FLOAT, fRotation,
					PR_INT32, iSpawnWeapons[0],
					PR_INT32, iSpawnWeapons[1],
					PR_INT32, iSpawnWeapons[2],
					PR_INT32, iSpawnWeaponsAmmo[0],
					PR_INT32, iSpawnWeaponsAmmo[1],
					PR_INT32, iSpawnWeaponsAmmo[2]
				);

				#if defined _037_compat_OnOutcomingRPC
				new offset;
				BS_GetWriteOffset(bsn, offset);

				BS_ResetReadPointer(bsn);
				BS_ResetWritePointer(bsn);
				
				if(_037_compat_OnOutcomingRPC(playerid, rpcid, bsn))
				{
					BS_SetWriteOffset(bsn, offset);
					PR_SendRPC(bsn, playerid, rpcid);
				}
				#else
				PR_SendRPC(bsn, playerid, rpcid);
				#endif

				BS_Delete(bsn);

				return 0;
			}

			case RPC_SetSpawnInfo:
			{
				new byteTeam,
					iSkin,
					unk,
					Float:vecPos[3],
					Float:fRotation,
					iSpawnWeapons[3],
					iSpawnWeaponsAmmo[3];

                BS_ReadValue(
					bs,
					PR_UINT8, byteTeam,
					PR_INT32, iSkin
                );

                BS_IgnoreBits(bs, 32);
					
                BS_ReadValue(
					bs,
					PR_UINT8, unk,
					PR_FLOAT, vecPos[0],
					PR_FLOAT, vecPos[1],
					PR_FLOAT, vecPos[2],
					PR_FLOAT, fRotation,
					PR_INT32, iSpawnWeapons[0],
					PR_INT32, iSpawnWeapons[1],
					PR_INT32, iSpawnWeapons[2],
					PR_INT32, iSpawnWeaponsAmmo[0],
					PR_INT32, iSpawnWeaponsAmmo[1],
					PR_INT32, iSpawnWeaponsAmmo[2]
				);

				new BitStream:bsn = BS_New();

                BS_WriteValue(
					bsn,
					PR_UINT8, byteTeam,
					PR_INT32, iSkin,
					PR_UINT8, unk,
					PR_FLOAT, vecPos[0],
					PR_FLOAT, vecPos[1],
					PR_FLOAT, vecPos[2],
					PR_FLOAT, fRotation,
					PR_INT32, iSpawnWeapons[0],
					PR_INT32, iSpawnWeapons[1],
					PR_INT32, iSpawnWeapons[2],
					PR_INT32, iSpawnWeaponsAmmo[0],
					PR_INT32, iSpawnWeaponsAmmo[1],
					PR_INT32, iSpawnWeaponsAmmo[2]
				);

				#if defined _037_compat_OnOutcomingRPC
				new offset;
				BS_GetWriteOffset(bsn, offset);

				BS_ResetReadPointer(bsn);
				BS_ResetWritePointer(bsn);
				
				if(_037_compat_OnOutcomingRPC(playerid, rpcid, bsn))
				{
					BS_SetWriteOffset(bsn, offset);
					PR_SendRPC(bsn, playerid, rpcid);
				}
				#else
				PR_SendRPC(bsn, playerid, rpcid);
				#endif

				BS_Delete(bsn);

				return 0;
			}

			case RPC_CreateObject:
			{
				new
					ModelID;

				BS_IgnoreBits(bs, 16); //ignore UINT16 wObjectID

				BS_ReadValue(
					bs,
					PR_INT32, ModelID
				);

				if(ModelID < 0)
				{
					BS_SetWriteOffset(bs, 16);

					BS_WriteValue(
						bs,
						PR_INT32, 18631 // NoModelFile
					);
				}
			}

		}

		BS_ResetReadPointer(bs);
		BS_ResetWritePointer(bs);
	}

	#if defined _037_compat_OnOutcomingRPC
		return _037_compat_OnOutcomingRPC(playerid, rpcid, BitStream:bs);
	#else
		return 1;
	#endif
}

/*Functions*/
stock IsClient037(playerid)
{
	if(0 <= playerid < MAX_PLAYERS)
	{
		return _037_compat_IsClient037{playerid};
	}
	else
	{
		printf("[error] Run time error: IsClient037(%d): index out of bounds");
		#if defined PrintBacktrace //check if Crashdetect is present
			PrintBacktrace();
		#endif
		return -1;
	}
}

/*Hooks*/
#if defined _ALS_OnIncomingRPC
#undef OnIncomingRPC
#else
#define _ALS_OnIncomingRPC
#endif
#define OnIncomingRPC _037_compat_OnIncomingRPC

#if defined _037_compat_OnIncomingRPC
forward _037_compat_OnIncomingRPC(playerid, rpcid, BitStream:bs);
#endif

#if defined _ALS_OnOutcomingRPC
#undef OnOutcomingRPC
#else
#define _ALS_OnOutcomingRPC
#endif
#define OnOutcomingRPC _037_compat_OnOutcomingRPC

#if defined _037_compat_OnOutcomingRPC
forward _037_compat_OnOutcomingRPC(playerid, rpcid, BitStream:bs);
#endif
