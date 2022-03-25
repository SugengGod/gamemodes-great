
#define MAX_VOUCHER 50

enum E_VOUCHER
{
	voucID,
	voucCode,
	voucVIP,
	voucVIPTime,
	voucMoney,
	voucGold,
	voucAdmin[16],
	voucDonature[16],
	voucClaim,
};
new VoucData[MAX_VOUCHER][E_VOUCHER],
	Iterator: Vouchers<MAX_VOUCHER>;
	
function LoadVouchers()
{
    new voucid, admin[16], donature[16];
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", voucid);
			cache_get_value_name_int(i, "code", VoucData[voucid][voucCode]);
			cache_get_value_name_int(i, "vip", VoucData[voucid][voucVIP]);
			cache_get_value_name_int(i, "vip_time", VoucData[voucid][voucVIPTime]);
			cache_get_value_name_int(i, "money", VoucData[voucid][voucMoney]);
			cache_get_value_name_int(i, "gold", VoucData[voucid][voucGold]);
			cache_get_value_name(i, "admin", admin);
			format(VoucData[voucid][voucAdmin], 16, admin);
			cache_get_value_name(i, "donature", donature);
			format(VoucData[voucid][voucDonature], 16, donature);
			cache_get_value_name_int(i, "claim", VoucData[voucid][voucClaim]);
			Iter_Add(Vouchers, voucid);
		}
		printf("[Vouchers]: %d Loaded.", rows);
	}
}
	
Voucher_Save(voucid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE vouchers SET code='%d', vip='%d', vip_time='%d', money='%d', gold='%d', admin='%s', donature='%s', claim='%d' WHERE id='%d'",
	VoucData[voucid][voucCode],
	VoucData[voucid][voucVIP],
	VoucData[voucid][voucVIPTime],
	VoucData[voucid][voucMoney],
	VoucData[voucid][voucGold],
	VoucData[voucid][voucAdmin],
	VoucData[voucid][voucDonature],
	VoucData[voucid][voucClaim],
	voucid
	);
	return mysql_tquery(g_SQL, cQuery);
}

CMD:createvoucher(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new voucid = Iter_Free(Vouchers), query[128];
	if(voucid == -1) return Error(playerid, "You cant create more voucher!");
	new code, vip, viptime, gold, money;
	if(sscanf(params, "ddddd", code, vip, viptime, money, gold)) return Usage(playerid, "/createvoucher [CODE(73821)] [VIP] [VIP-TIME(Days)] [MONEY] [GOLD]");
	if(code < 10000 || code > 99999) 
		return Error(playerid, "Invalid code 10000-99999");
	if(vip < 0 || vip > 3) 
		return Error(playerid, "Invalid vip 0-3.");
	if(viptime < 0 || viptime > 60) 
		return Error(playerid, "Invalid vip time 0 - 60 days.");
	if(money < 0 || money > 100000) 
		return Error(playerid, "Invalid money $0 - $100.000.");
	if(gold < 0 || gold > 1000) 
		return Error(playerid, "Invalid gold 0-1000.");
	foreach(new vo : Vouchers)
	{
		if(VoucData[vo][voucCode] == code)
		{
			return Error(playerid, "Voucher code already registered! try another code!");
		}
	}
	
	VoucData[voucid][voucCode] = code;
	VoucData[voucid][voucVIP] = vip;
	VoucData[voucid][voucVIPTime] = viptime;
	VoucData[voucid][voucMoney] = money;
	VoucData[voucid][voucGold] = gold;
	format(VoucData[voucid][voucAdmin], 16, pData[playerid][pAdminname]);
	format(VoucData[voucid][voucDonature], 16, "None");
	VoucData[voucid][voucClaim] = 0;
	Iter_Add(Vouchers, voucid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO vouchers SET id='%d', code='%d', vip='%d', vip_time='%d', money='%d', gold='%d', admin='%s'", voucid, VoucData[voucid][voucCode], VoucData[voucid][voucVIP], VoucData[voucid][voucVIPTime], VoucData[voucid][voucMoney], VoucData[voucid][voucGold], pData[playerid][pAdminname]);
	mysql_tquery(g_SQL, query, "OnVoucherCreated", "i", voucid);
	
	Servers(playerid, "Voucher created id: %d | code: %d | vip: %d | vip-time: %d | money: %s | gold: %d | admin: %s", voucid, VoucData[voucid][voucCode], VoucData[voucid][voucVIP], VoucData[voucid][voucVIPTime], FormatMoney(VoucData[voucid][voucMoney]), VoucData[voucid][voucGold], pData[playerid][pAdminname]);
	return 1;
}

function OnVoucherCreated(voucid)
{
	Voucher_Save(voucid);
	return 1;
}

CMD:voucher(playerid, params[])
{
	new code;
	if(sscanf(params, "d", code)) return Usage(playerid, "/voucher [CODE]");
	
	foreach(new vo : Vouchers)
	{
		if(VoucData[vo][voucCode] == code)
		{
			if(VoucData[vo][voucClaim] == 0)
			{
				if(VoucData[vo][voucVIP] == 0)
				{
					pData[playerid][pGold] += VoucData[vo][voucGold];
					
					VoucData[vo][voucClaim] = 1;
					format(VoucData[vo][voucDonature], 16, pData[playerid][pName]);
					Voucher_Save(vo);
					
					Info(playerid, "Voucher claimed. gold: %d | claimby: %s.", VoucData[vo][voucGold], pData[playerid][pName]);
				}
				else
				{
					new dayz = VoucData[vo][voucVIPTime];
					pData[playerid][pGold] += VoucData[vo][voucGold];
					pData[playerid][pMoney] += VoucData[vo][voucMoney];
					pData[playerid][pVip] = VoucData[vo][voucVIP];
					pData[playerid][pVipTime] = gettime() + (dayz * 86400);
					
					VoucData[vo][voucClaim] = 1;
					format(VoucData[vo][voucDonature], 16, pData[playerid][pName]);
					Voucher_Save(vo);
					
					Info(playerid, "Voucher claimed. VIP: %d | VIP TIME: %d days | money: %s | gold: %d | claimby: %s.", VoucData[vo][voucVIP], dayz, FormatMoney(VoucData[vo][voucMoney]), VoucData[vo][voucGold], pData[playerid][pName]);
				}
			}
			else return Error(playerid, "Voucher has been expired!");
		}
	}
	return 1;
}




