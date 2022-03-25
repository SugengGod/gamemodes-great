#define BARRIER_SPEED 	0.015
#define TEAM_NONE       (0)
#define Toll(%1,%2) SendClientMessage(%1, COLOR_YELLOW , "[TOLL]: "WHITE_E""%2)

new gBarrier[8];

enum brInfo
{
	brOrg,
    Float:brPos_X,
    Float:brPos_Y,
    Float:brPos_Z,
    Float:brPos_A,
    bool:brOpen,
    brForBarrierID
};

new BarrierInfo[8][brInfo] =
{
    {TEAM_NONE,     57.626400,  	-1536.844482,   3.944200,   81.9535,    false, -1},
	{TEAM_NONE, 	59.734100,  	-1521.458862,   3.944200,   81.9535,    false, -1},
	{TEAM_NONE, 	1808.153442,	811.798828,     9.793500,   0.00,       false, -1},
	{TEAM_NONE, 	1792.503540,	811.798828,     9.843500,   0.00,       false, -1},
	{TEAM_NONE, 	428.671,    	615.601,        17.941,     34.000,     false, -1},
	{TEAM_NONE, 	423.585,    	599.148,        17.941,     213.997,    false, -1},
	{TEAM_NONE, 	-144.712,   	482.638,        11.078,     165.997,    false, -1},
	{TEAM_NONE, 	-128.746,   	490.219,        10.383,     345.992,    false, -1}
};

function BarrierClose(barrier)
{
	BarrierInfo[barrier][brOpen] = false;
	MoveDynamicObject(gBarrier[barrier],BarrierInfo[barrier][brPos_X],BarrierInfo[barrier][brPos_Y],BarrierInfo[barrier][brPos_Z]+0.75,BARRIER_SPEED,0.0,90.0,BarrierInfo[barrier][brPos_A]+180);
	new barrierid = BarrierInfo[barrier][brForBarrierID];
	if(barrierid != -1)
	{
		BarrierInfo[barrierid][brOpen] = false;
		MoveDynamicObject(gBarrier[barrierid],BarrierInfo[barrierid][brPos_X],BarrierInfo[barrierid][brPos_Y],BarrierInfo[barrierid][brPos_Z]+0.75,BARRIER_SPEED,0.0,90.0,BarrierInfo[barrierid][brPos_A]+180);
	}
	return true;
}

ShiftCords(style, &Float:x, &Float:y, Float:a, Float:distance)
{
	switch(style)
	{
	case 0:
		{
			x += (distance * floatsin(-a, degrees));
			y += (distance * floatcos(-a, degrees));
		}
	case 1:
		{
			x -= (distance * floatsin(-a, degrees));
			y -= (distance * floatcos(-a, degrees));
		}
	default: return false;
	}
	return true;
}

MuchNumber(...)
{
	new count = numargs(), maxnum;
	for(new i; i < count; i ++)
	{
		new temp = getarg(i);
		if(temp > maxnum) maxnum = temp;
	}
	return maxnum;
}

CMD:opengate(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		new forcount = MuchNumber(sizeof(BarrierInfo));
		for(new i;i < forcount;i ++)
		{
			if(i < sizeof(BarrierInfo))
			{
				if(IsPlayerInRangeOfPoint(playerid,8,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]))
				{
					if(BarrierInfo[i][brOrg] == TEAM_NONE)
					{
						if(!BarrierInfo[i][brOpen])
						{
							if(pData[playerid][pMoney] < 5)
							{
								Toll(playerid, "Uangmu tidak cukup untuk membayar toll");
							}
							else
							{
								MoveDynamicObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
								SetTimerEx("BarrierClose",15000,0,"i",i);
								BarrierInfo[i][brOpen] = true;
								Toll(playerid, "Cepat!!! Toll akan menutup Kembali setelah 15 detik");
								GivePlayerMoneyEx(playerid, -5);
								if(BarrierInfo[i][brForBarrierID] != -1)
								{
									new barrierid = BarrierInfo[i][brForBarrierID];
									MoveDynamicObject(gBarrier[barrierid],BarrierInfo[barrierid][brPos_X],BarrierInfo[barrierid][brPos_Y],BarrierInfo[barrierid][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[barrierid][brPos_A]+180);
									BarrierInfo[barrierid][brOpen] = true;

								}
							}
						}
					}
					else Toll(playerid, "Kamu tidak bisa membuka pintu Toll ini!");
					break;
				}
			}
		}
	}
	return true;
}