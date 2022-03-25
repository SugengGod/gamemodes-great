//=============== [ ACTOR SYSTEM ] ===============//
#define MAX_ACTOR 	  500

enum Actor
{
	actorID,
	Text3D: actorText,
	actorSkin,
	actorAnim,
	Float:actorX,
	Float:actorY,
	Float:actorZ,
	Float:actorR,
	actorName[80],
	actorWorld,
	actorInt
}

new ActorData[MAX_ACTOR][Actor],
    Iterator:Actors<MAX_ACTOR>;

function LoadActor()
{
	new aid;
	
	new rows = cache_num_rows(), name[128];
	if(rows)
	{
	    for(new i; i < rows; i++)
	    {
	        cache_get_value_name_int(i, "ID", aid);
            cache_get_value_name(i, "name", name);
			format(ActorData[aid][actorName], 128, name);
	        cache_get_value_name_int(i, "skin", ActorData[aid][actorSkin]);
	        cache_get_value_name_int(i, "anim", ActorData[aid][actorAnim]);
            cache_get_value_name_float(i, "posx", ActorData[aid][actorX]);
            cache_get_value_name_float(i, "posy", ActorData[aid][actorY]);
            cache_get_value_name_float(i, "posz", ActorData[aid][actorZ]);
            cache_get_value_name_float(i, "posr", ActorData[aid][actorR]);
            cache_get_value_name_int(i, "interior", ActorData[aid][actorInt]);
            cache_get_value_name_int(i, "world", ActorData[aid][actorWorld]);
	        
	        new label[200];
	        format(label, sizeof label, "[ID: %d]\n{FFFF00}%s", aid, ActorData[aid][actorName]);
	        ActorData[aid][actorID] = CreateActor(ActorData[aid][actorSkin], ActorData[aid][actorX], ActorData[aid][actorY], ActorData[aid][actorZ], ActorData[aid][actorR]);
	        ActorData[aid][actorText] = CreateDynamic3DTextLabel(label, -1, ActorData[aid][actorX], ActorData[aid][actorY], ActorData[aid][actorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ActorData[aid][actorWorld], ActorData[aid][actorInt], -1);
			ActorData[aid][actorWorld] = SetActorVirtualWorld(ActorData[aid][actorID], ActorData[aid][actorWorld]);
			Actor_Anim(aid);
            Iter_Add(Actors, aid);
		}
		printf("[Actor]: %d Loaded.", rows);
	}
}

Actor_Save(aid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE `actor` SET `name` = '%s', `skin` = '%d', `anim` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `posr` = '%f', `interior` = '%d', `world` = '%d' WHERE `ID` = '%d'",
	ActorData[aid][actorName],
	ActorData[aid][actorSkin],
	ActorData[aid][actorAnim],
	ActorData[aid][actorX],
	ActorData[aid][actorY],
    ActorData[aid][actorZ],
    ActorData[aid][actorR],
    ActorData[aid][actorInt],
    ActorData[aid][actorWorld],
	aid
	);
	return mysql_tquery(g_SQL, cQuery);
}

Actor_Anim(aid)
{
    switch(ActorData[aid][actorAnim])
    {
        case 1: {ApplyActorAnimation(aid,"ped","SEAT_down",4.0,0,0,0,1,0);}
        case 2: {ApplyActorAnimation(aid,"ped","Idlestance_fat",4.0,0,0,0,1,0);}
        case 3: {ApplyActorAnimation(aid,"ped","Idlestance_old",4.0,0,0,0,1,0);}
        case 4: {ApplyActorAnimation(aid,"POOL","POOL_Idle_Stance",4.0,0,0,0,1,0);}
        case 5: {ApplyActorAnimation(aid,"ped","woman_idlestance",4.0,0,0,0,1,0);}
        case 6: {ApplyActorAnimation(aid,"ped","IDLE_stance",4.0,0,0,0,1,0);}
        case 7: {ApplyActorAnimation(aid,"COP_AMBIENT","Copbrowse_in",4.0,0,0,0,1,0);}
        case 8: {ApplyActorAnimation(aid,"COP_AMBIENT","Copbrowse_loop",4.0,0,0,0,1,0);}
        case 9: {ApplyActorAnimation(aid,"COP_AMBIENT","Copbrowse_nod",4.0,0,0,0,1,0);}
        case 10: {ApplyActorAnimation(aid,"COP_AMBIENT","Copbrowse_out",4.0,0,0,0,1,0);}
        case 11: {ApplyActorAnimation(aid,"COP_AMBIENT","Copbrowse_shake",4.0,0,0,0,1,0);}
        case 12: {ApplyActorAnimation(aid,"COP_AMBIENT","Coplook_in",4.0,0,0,0,1,0);}
        case 13: {ApplyActorAnimation(aid,"COP_AMBIENT","Coplook_loop",4.0,0,0,0,1,0);}
        case 14: {ApplyActorAnimation(aid,"COP_AMBIENT","Coplook_nod",4.0,0,0,0,1,0);}
        case 15: {ApplyActorAnimation(aid,"COP_AMBIENT","Coplook_out",4.0,0,0,0,1,0);}
        case 16: {ApplyActorAnimation(aid,"COP_AMBIENT","Coplook_shake",4.0,0,0,0,1,0);}
        case 17: {ApplyActorAnimation(aid,"COP_AMBIENT","Coplook_think",4.0,0,0,0,1,0);}
        case 18: {ApplyActorAnimation(aid,"COP_AMBIENT","Coplook_watch",4.0,0,0,0,1,0);}
        case 19: {ApplyActorAnimation(aid,"GANGS","leanIDLE",4.1,0,0,0,1,0);}
        case 20: {ApplyActorAnimation(aid,"MISC","Plyrlean_loop",4.1,0,0,0,1,0);}
        case 21: {ApplyActorAnimation(aid,"KNIFE", "KILL_Knife_Ped_Die",4.1,0,0,0,1,0);}
        case 22: {ApplyActorAnimation(aid,"PED", "KO_shot_face",4.0,0,0,0,1,0);}
        case 23: {ApplyActorAnimation(aid,"PED", "KO_shot_stom",4.0,0,0,0,1,0);}
        case 24: {ApplyActorAnimation(aid,"PED", "BIKE_fallR",4.0,0,0,0,1,0);}
        case 25: {ApplyActorAnimation(aid,"PED", "BIKE_fall_off",4.0,0,0,0,1,0);}
        case 26: {ApplyActorAnimation(aid,"SWAT","gnstwall_injurd",4.0,0,0,0,1,0);}
        case 27: {ApplyActorAnimation(aid,"SWEET","Sweet_injuredloop",4.0,0,0,0,1,0);}
    }
}

function OnCreateActor(playerid, tid)
{
	Actor_Save(tid);
	Servers(playerid, "Actor [%d] berhasil di buat!", tid);
	new str[150];
	format(str,sizeof(str),"[Actor]: %s membuat actor id %d!", GetRPName(playerid), tid);
	LogServer("Admin", str);
}

//=============== [ COMMAND ACTOR ] ===============//

CMD:createactor(playerid, params[])
{
	new skin, name[80]; 
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

	if (sscanf(params, "is[80]", skin, name))
		return Usage(playerid, "/createactor [skin] [name]");

	if (skin < 0 || skin > 299)
	    return Error(playerid, "Invalid skin ID. Skins range from 0 to 299.");

	new tid = Iter_Free(Actors), query[512];
	if(tid == -1) return Error(playerid, "Actor Has Reached The Max Number");
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	
	ActorData[tid][actorX] = x;
	ActorData[tid][actorY] = y;
	ActorData[tid][actorZ] = z;
	ActorData[tid][actorR] = a;
	ActorData[tid][actorSkin] = skin;
	format(ActorData[tid][actorName], 80, "%s", name);
	ActorData[tid][actorID] = tid;
    ActorData[tid][actorInt] = GetPlayerInterior(playerid);
    ActorData[tid][actorWorld] = GetPlayerVirtualWorld(playerid);

    SetPlayerPos(playerid, x + 5, y, z);

	new label[100];
	format(label, sizeof label, "[ID: %d]\n{FFFF00}%s", tid, ActorData[tid][actorName]);
	ActorData[tid][actorID] = CreateActor(ActorData[tid][actorSkin], ActorData[tid][actorX], ActorData[tid][actorY], ActorData[tid][actorZ], ActorData[tid][actorR]);
	ActorData[tid][actorText] = CreateDynamic3DTextLabel(label, -1, ActorData[tid][actorX], ActorData[tid][actorY], ActorData[tid][actorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ActorData[tid][actorWorld], ActorData[tid][actorInt], -1);
	ActorData[tid][actorWorld] = SetActorVirtualWorld(ActorData[tid][actorID], GetPlayerVirtualWorld(playerid));
	Iter_Add(Actors, tid);
	mysql_format(g_SQL, query, sizeof query, "INSERT INTO actor SET ID = '%d', skin = '%d', name = '%s', anim = '%d', posx = '%f', posy = '%f', posz = '%f', posr = '%f', interior = '%d', world = '%d'", ActorData[tid][actorID], ActorData[tid][actorSkin], ActorData[tid][actorName], ActorData[tid][actorAnim], ActorData[tid][actorX], ActorData[tid][actorY], ActorData[tid][actorZ], ActorData[tid][actorR], ActorData[tid][actorInt], ActorData[tid][actorWorld]);
	mysql_tquery(g_SQL, query, "OnCreateActor", "di", playerid, tid);
	return 1;
	
}

CMD:editactor(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

	new id, name[24], param[50], ammount, text[24];
	if(sscanf(params, "is[24]S()[32]", id, name, param)) 
	{
		Usage(playerid, "/editactor [id] [name]");
		Info(playerid, "Names: Anim, Name, Skin, Pos, ClearAnim");
		return 1;
	}	
	if(!Iter_Contains(Actors, id)) return Error(playerid, "Invalid ID.");

    if(!strcmp(name, "skin", true)) 
	{			
		if(sscanf(param, "i", ammount))
			return Usage(playerid, "/editactor [id] [skin] [skin id]");

        if(IsValidDynamic3DTextLabel(ActorData[id][actorText]))
            DestroyDynamic3DTextLabel(ActorData[id][actorText]);
            
        if(IsValidActor(ActorData[id][actorID]))    
            DestroyActor(ActorData[id][actorID]);

        ActorData[id][actorSkin] = ammount;

        new label[100];
	    format(label, sizeof label, "[ID: %d]\n{FFFF00}%s", id, ActorData[id][actorName]);
	    ActorData[id][actorID] = CreateActor(ActorData[id][actorSkin], ActorData[id][actorX], ActorData[id][actorY], ActorData[id][actorZ], ActorData[id][actorR]);
	    ActorData[id][actorText] = CreateDynamic3DTextLabel(label, -1, ActorData[id][actorX], ActorData[id][actorY], ActorData[id][actorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ActorData[id][actorWorld], ActorData[id][actorInt], -1);

        Actor_Anim(id);
        Actor_Save(id);
    } 
    else if(!strcmp(name, "name", true)) 
	{			
		if(sscanf(param, "s[24]", text))
			return Usage(playerid, "/editactor [id] [name] [name]");

        if(IsValidDynamic3DTextLabel(ActorData[id][actorText]))
            DestroyDynamic3DTextLabel(ActorData[id][actorText]);
            
        if(IsValidActor(ActorData[id][actorID]))    
            DestroyActor(ActorData[id][actorID]);

        format(ActorData[id][actorName], 24, "%s", text);

        new label[100];
	    format(label, sizeof label, "[ID: %d]\n{FFFF00}%s", id, ActorData[id][actorName]);
	    ActorData[id][actorID] = CreateActor(ActorData[id][actorSkin], ActorData[id][actorX], ActorData[id][actorY], ActorData[id][actorZ], ActorData[id][actorR]);
	    ActorData[id][actorText] = CreateDynamic3DTextLabel(label, -1, ActorData[id][actorX], ActorData[id][actorY], ActorData[id][actorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ActorData[id][actorWorld], ActorData[id][actorInt], -1);

        Actor_Anim(id);
        Actor_Save(id);
    }
    else if(!strcmp(name, "pos", true)) 
	{	
        new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

        if(IsValidDynamic3DTextLabel(ActorData[id][actorText]))
            DestroyDynamic3DTextLabel(ActorData[id][actorText]);

        if(IsValidActor(ActorData[id][actorID]))    
            DestroyActor(ActorData[id][actorID]);

        ActorData[id][actorX] = x;
        ActorData[id][actorY] = y;
        ActorData[id][actorZ] = z;
        ActorData[id][actorR] = a;

        SetPlayerPos(playerid, x + 5, y, z); 

        new label[100];
	    format(label, sizeof label, "[ID: %d]\n{FFFF00}%s", id, ActorData[id][actorName]);
	    ActorData[id][actorID] = CreateActor(ActorData[id][actorSkin], ActorData[id][actorX], ActorData[id][actorY], ActorData[id][actorZ], ActorData[id][actorR]);
	    ActorData[id][actorText] = CreateDynamic3DTextLabel(label, -1, ActorData[id][actorX], ActorData[id][actorY], ActorData[id][actorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ActorData[id][actorWorld], ActorData[id][actorInt], -1);
		ActorData[id][actorWorld] = SetActorVirtualWorld(ActorData[id][actorID], GetPlayerVirtualWorld(playerid));

        Actor_Anim(id);
        Actor_Save(id);
    }
    else if(!strcmp(name, "clearanim", true)) 
	{	
        ActorData[id][actorAnim] = 0;
		ClearActorAnimations(id);

        new string[200];
		format(string, sizeof(string), "ACTORS: "WHITE_E"You have clear animation actorid "YELLOW_E"}%d", id);
		SendClientMessageEx(playerid, -1, string);

        Actor_Save(id);
    }     
    else if(!strcmp(name, "anim", true)) 
	{	
        SetPVarInt(playerid, "aPlayAnim", id);

        ShowPlayerDialog(playerid, DIALOG_ACTORANIM, DIALOG_STYLE_LIST, "Actor Anim",
        "Seat down\nIdlestance Fat\nIdlestance Old\nPool Idle Stance\nWoman Idlestance\nIdle Stance\nCopbrowse In\nCopbrowse Loop\nCopbrowse Nod\nCopbrowse Out\nCopbrowse shake\nCoplook In\nCoplook Loop\nCoplook Nod\nCoplook Out\nCoplook Shake\nCoplook Think\nCoplook Watch\nLean Idle\nPlyrlean Loop\nKILL Knife Ped Die\nKO Shot Face\nKO Shot Stom\nBike FallR\nBike Fall Off\nGnstwall Injurd\nSweet Injuredloop"
        , "Pilih", "Close");
    }    
    return 1;   
}

CMD:deleteactor(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/deleteactor [id]");
	if(!Iter_Contains(Actors, id)) return Error(playerid, "Invalid ID.");

	DestroyActor(ActorData[id][actorID]);
	DestroyDynamic3DTextLabel(ActorData[id][actorText]);

    ActorData[id][actorX] = 0;
	ActorData[id][actorY] = 0;
	ActorData[id][actorZ] = 0;
    ActorData[id][actorR] = 0;
    format(ActorData[id][actorName], 80, "");
	ActorData[id][actorText] = Text3D: -1;
	Iter_Remove(Actors, id);

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM actor WHERE ID = %d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus ID Actor %d.", id);
	new str[150];
	format(str,sizeof(str),"[Actor]: %s menghapus actor id!", GetRPName(playerid), id);
	LogServer("Admin", str);
	return 1;
}

CMD:gotoactor(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotoactor [id]");
	if(!Iter_Contains(Actors, id)) return Error(playerid, "Actor ID tidak ada.");

	SetPlayerPos(playerid, ActorData[id][actorX] + 1, ActorData[id][actorY], ActorData[id][actorZ]);
    SetPlayerInterior(playerid, ActorData[id][actorInt]);
	SetPlayerVirtualWorld(playerid, ActorData[id][actorWorld]);
	SetCameraBehindPlayer(playerid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;	
	Servers(playerid, "Teleport ke Actor ID: %d", id);
	return 1;
}