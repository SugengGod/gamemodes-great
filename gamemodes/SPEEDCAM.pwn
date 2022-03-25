//=============== [ SPEEDCAM SYSTEM ] ===============//
#define MAX_CAM 50

enum Cam {
	CamID,
	CamExists,
	Float:CamPos[4],
	Float:CamRange,
	Float:CamLimit,
	CamObject,
	Text3D:CamText3D,
	CamMapIcon
};
new CamData[MAX_CAM][Cam],
	Iterator:Cem<MAX_CAM>;

function LoadSpeedCam()
{
	new sid;
	
	new rows = cache_num_rows();
	if(rows)
	{
	    for(new i; i < rows; i++)
	    {
	        cache_get_value_name_int(i, "speedID", sid);
	        cache_get_value_name_float(i, "speedLimit", CamData[sid][CamLimit]);
	        cache_get_value_name_float(i, "speedRange", CamData[sid][CamRange]);
	        cache_get_value_name_float(i, "speedX", CamData[sid][CamPos][0]);
	        cache_get_value_name_float(i, "speedY", CamData[sid][CamPos][1]);
	        cache_get_value_name_float(i, "speedZ", CamData[sid][CamPos][2]);
            cache_get_value_name_float(i, "speedAngle", CamData[sid][CamPos][3]);
	        
	        new label[200];
	        format(label, sizeof label, "[ID: %d]\n{FFFF00}[SpeedCam]\n{FF0000}Max Speed: {FFFF00}%.0f {ffffff}KM/H", sid, CamData[sid][CamLimit]);
	        CamData[sid][CamObject] = CreateDynamicObject(18880, CamData[sid][CamPos][0], CamData[sid][CamPos][1], CamData[sid][CamPos][2], 0.00000, 0.00000, CamData[sid][CamPos][3]);
	        CamData[sid][CamText3D] = CreateDynamic3DTextLabel(label, -1, CamData[sid][CamPos][0], CamData[sid][CamPos][1], CamData[sid][CamPos][2] + 1.5, 5.0);
			Iter_Add(Cem, sid);
		}
		printf("[SpeedCam]: %d Loaded.", rows);
	}
}

SpeedCam_Save(sid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE `speedcameras` SET `speedRange` = '%.4f', `speedLimit` = '%.4f', `speedX` = '%.4f', `speedY` = '%.4f', `speedZ` = '%.4f', `speedAngle` = '%.4f' WHERE `speedID` = '%d'",
	CamData[sid][CamRange],
	CamData[sid][CamLimit],
	CamData[sid][CamPos][0],
	CamData[sid][CamPos][1],
	CamData[sid][CamPos][2],
    CamData[sid][CamPos][3],
	sid
	);
	return mysql_tquery(g_SQL, cQuery);
}

function SpeedCam_Nearest(playerid)
{
	for (new i = 0; i < MAX_CAM; i ++) if(IsPlayerInRangeOfPoint(playerid, CamData[i][CamRange], CamData[i][CamPos][0], CamData[i][CamPos][1], CamData[i][CamPos][2]))
	    return i;

	return -1;
}

stock Float:GetPlayerSpeedCam(playerid)
{
	static Float:velocity[3];

	if (IsPlayerInAnyVehicle(playerid))
	    GetVehicleVelocity(GetPlayerVehicleID(playerid), velocity[0], velocity[1], velocity[2]);
	else
	    GetPlayerVelocity(GetPlayerVehicleID(playerid), velocity[0], velocity[1], velocity[2]);

	return floatsqroot((velocity[0] * velocity[0]) + (velocity[1] * velocity[1]) + (velocity[2] * velocity[2])) * 100.0;
}

function HidePlayerBox(playerid, PlayerText:boxid)
{
	if (!IsPlayerConnected(playerid))
	    return 0;

	PlayerTextDrawHide(playerid, boxid);
	PlayerTextDrawDestroy(playerid, boxid);

	return 1;
}

function PlayerText:ShowPlayerBox(playerid, color)
{
	new
	    PlayerText:textid;

    textid = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "_");
	PlayerTextDrawFont(playerid, textid, 1);
	PlayerTextDrawLetterSize(playerid, textid, 0.500000, 50.000000);
	PlayerTextDrawColor(playerid, textid, -1);
	PlayerTextDrawUseBox(playerid, textid, 1);
	PlayerTextDrawBoxColor(playerid, textid, color);
	PlayerTextDrawTextSize(playerid, textid, 640.000000, 30.000000);
	PlayerTextDrawShow(playerid, textid);

	return textid;
}

function OnCreatedCams(playerid, tid)
{
	SpeedCam_Save(tid);
	Servers(playerid, "SpeedCam [%d] berhasil di buat!", tid);
	new str[150];
	format(str,sizeof(str),"[SpeedCam] %s membuat speedcam id %d!", GetRPName(playerid), tid);
	LogServer("Admin", str);
}

//=============== [ COMMAND SPEEDCAM ] ===============//

CMD:createsc(playerid, params[])
{
	static
	    Float:limit,
	    Float:range;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

	if (sscanf(params, "ff", limit, range))
		return Usage(playerid, "/createspeedcam [speed limit] [range] (default range: 30)");

	if (limit < 5.0 || limit > 200.0)
	    return Error(playerid, "Batas kecepatan tidak dapat di bawah 5 atau di atas 200.");

	if (range < 5.0 || range > 50.0)
	    return Error(playerid, "Kisaran tidak dapat di bawah 5 atau di atas 50.");

	new tid = Iter_Free(Cem), query[512];
	if(tid == -1) return Error(playerid, "Cams Has Reached The Max Number");
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	
	CamData[tid][CamPos][0] = x + (1.5 * floatsin(-a, degrees));
	CamData[tid][CamPos][1] = y + (1.5 * floatsin(-a, degrees));
	CamData[tid][CamPos][2] = z - 1.2;
	CamData[tid][CamPos][3] = a;
	CamData[tid][CamLimit] = limit;
	CamData[tid][CamRange] = range;
	CamData[tid][CamID] = tid;

	new label[200];
	format(label, sizeof label, "[ID: %d]\n{FFFF00}[SpeedCam]\n{FF0000}Max Speed: {FFFF00}%.0f {ffffff}KM/H", tid, CamData[tid][CamLimit]);
	CamData[tid][CamObject] = CreateDynamicObject(18880, CamData[tid][CamPos][0], CamData[tid][CamPos][1], CamData[tid][CamPos][2], 0.00000, 0.00000, CamData[tid][CamPos][3]);
	CamData[tid][CamText3D] = CreateDynamic3DTextLabel(label, -1, CamData[tid][CamPos][0], CamData[tid][CamPos][1], CamData[tid][CamPos][2] + 1.5, 5.0);
	Iter_Add(Cem, tid);
	mysql_format(g_SQL, query, sizeof query, "INSERT INTO speedcameras SET speedID='%d', speedX='%.4f', speedY='%.4f', speedZ='%.4f', speedAngle='%.4f', speedLimit='%.4f', speedRange='%.4f'", CamData[tid][CamID], CamData[tid][CamPos][0], CamData[tid][CamPos][1], CamData[tid][CamPos][2], CamData[tid][CamPos][3], CamData[tid][CamLimit], CamData[tid][CamRange]);
	mysql_tquery(g_SQL, query, "OnCreatedCams", "di", playerid, tid);
	return 1;
	
}

CMD:editsc(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

	new id, name[24], param[50], ammount;
	if(sscanf(params, "is[24]S()[32]", id, name, param)) 
	{
		Usage(playerid, "/editsc [id] [name]");
		Info(playerid, "Names: Speed, Range, Pos");
		return 1;
	}	
	if(!Iter_Contains(Cem, id)) return Error(playerid, "Invalid ID.");

	if(!strcmp(name, "speed", true)) 
	{			
		if(sscanf(param, "i", ammount))
			return Usage(playerid, "/editsc [id] [speed] [ammount]");

		DestroyDynamic3DTextLabel(CamData[id][CamText3D]);

		CamData[id][CamLimit] = ammount;
		Info(playerid, "Kamu telah mengubah batas kecepatan SpeedCam %d menjadi %.4f", CamData[id][CamID], CamData[id][CamLimit]);

		new label[200];
	    format(label, sizeof label, "[ID: %d]\n{FFFF00}[SpeedCam]\n{FF0000}Max Speed: {FFFF00}%.0f {ffffff}KM/H", id, CamData[id][CamLimit]);
	    CamData[id][CamText3D] = CreateDynamic3DTextLabel(label, -1, CamData[id][CamPos][0], CamData[id][CamPos][1], CamData[id][CamPos][2] + 1.5, 5.0);
		
		SpeedCam_Save(id);
	}
	else if(!strcmp(name, "range", true)) 
	{			
		if(sscanf(param, "i", ammount))
			return Usage(playerid, "/editsc [id] [range] [ammount]");
		
		CamData[id][CamRange] = ammount;
		Info(playerid, "Kamu telah mengubah batas kejauhan SpeedCam %d menjadi %.4f", CamData[id][CamID], CamData[id][CamRange]);

		SpeedCam_Save(id);
	}
	else  if(!strcmp(name, "pos", true)) 
	{	
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		CamData[id][CamPos][0] = x + (1.5 * floatsin(-a, degrees));
		CamData[id][CamPos][1] = y + (1.5 * floatsin(-a, degrees));
		CamData[id][CamPos][2] = z - 1.2;
		CamData[id][CamPos][3] = a;

		if(IsValidDynamic3DTextLabel(CamData[id][CamText3D]))
			DestroyDynamic3DTextLabel(CamData[id][CamText3D]);

		if(IsValidDynamicObject(CamData[id][CamObject]))
			DestroyDynamicObject(CamData[id][CamObject]);	

		new label[200];
		format(label, sizeof label, "[ID: %d]\n{FFFF00}[SpeedCam]\n{FF0000}Max Speed: {FFFF00}%.0f {ffffff}KM/H", id, CamData[id][CamLimit]);
		CamData[id][CamObject] = CreateDynamicObject(18880, CamData[id][CamPos][0], CamData[id][CamPos][1], CamData[id][CamPos][2], 0.00000, 0.00000, CamData[id][CamPos][3]);
		CamData[id][CamText3D] = CreateDynamic3DTextLabel(label, -1, CamData[id][CamPos][0], CamData[id][CamPos][1], CamData[id][CamPos][2] + 1.5, 5.0);
		
		SpeedCam_Save(id);
	}
	return 1;
}

CMD:deletesc(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/deletesc [id]");
	if(!Iter_Contains(Cem, id)) return Error(playerid, "Invalid ID.");

	DestroyDynamicObject(CamData[id][CamObject]);
	DestroyDynamic3DTextLabel(CamData[id][CamText3D]);

	CamData[id][CamPos][0] = CamData[id][CamPos][1] = CamData[id][CamPos][2] = 0.0;
	CamData[id][CamObject] = -1;
	CamData[id][CamText3D] = Text3D: -1;
	Iter_Remove(Cem, id);

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM speedcam WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus ID Speedcam %d.", id);
	new str[150];
	format(str,sizeof(str),"[SpeedCam] %s menghapus speedcam id %d!", GetRPName(playerid), id);
	LogServer("Admin", str);
	return 1;
}
CMD:gotosc(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotosc [id]");
	if(!Iter_Contains(Cem, id)) return Error(playerid, "SPEEDCAM ID tidak ada.");

	SetPlayerPosition(playerid, CamData[id][CamPos][0], CamData[id][CamPos][1], CamData[id][CamPos][2], 2.0);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;	
	Servers(playerid, "Teleport ke SpeedCam ID: %d", id);
	return 1;
}
