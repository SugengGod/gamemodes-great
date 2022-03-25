//Business
#define MAX_BISNIS 500

enum bisinfo
{
	bOwner[MAX_PLAYER_NAME],
	bOwnerID,
	bName[128],
	bPrice,
	bType,
	bLocked,
	bMoney,
	bProd,
	bP[10],
	bInt,
	Float:bExtposX,
	Float:bExtposY,
	Float:bExtposZ,
	Float:bExtposA,
	Float:bIntposX,
	Float:bIntposY,
	Float:bIntposZ,
	Float:bIntposA,
	bVisit,
	bRestock,
	Float:bPointX,
	Float:bPointY,
	Float:bPointZ,
	//Not Saved
	bPickPoint,
	Text3D:bLabelPoint,
	bPickup,
	bPickup2,
	bCP,
	bMap,
	Text3D:bLabel,
};

new bData[MAX_BISNIS][bisinfo],
	Iterator: Bisnis<MAX_BISNIS>;

Bisnis_Save(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE bisnis SET owner='%s', ownerid='%d', name='%s', price='%d', type='%d', locked='%d', money='%d', prod='%d', bprice0='%d', bprice1='%d', bprice2='%d', bprice3='%d', bprice4='%d', bprice5='%d', bprice6='%d', bprice7='%d', bprice8='%d', bprice9='%d', bint='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', intposx='%f', intposy='%f', intposz='%f', intposa='%f', pointx='%f', pointy='%f', pointz='%f', visit='%d', restock='%d' WHERE ID='%d'",
	bData[id][bOwner],
	bData[id][bOwnerID],
	bData[id][bName],
	bData[id][bPrice],
	bData[id][bType],
	bData[id][bLocked],
	bData[id][bMoney],
	bData[id][bProd],
	bData[id][bP][0],
	bData[id][bP][1],
	bData[id][bP][2],
	bData[id][bP][3],
	bData[id][bP][4],
	bData[id][bP][5],
	bData[id][bP][6],
	bData[id][bP][7],
	bData[id][bP][8],
	bData[id][bP][9],
	bData[id][bInt],
	bData[id][bExtposX],
	bData[id][bExtposY],
	bData[id][bExtposZ],
	bData[id][bExtposA],
	bData[id][bIntposX],
	bData[id][bIntposY],
	bData[id][bIntposZ],
	bData[id][bIntposA],
	bData[id][bPointX],
	bData[id][bPointY],
	bData[id][bPointZ],
	bData[id][bVisit],
	bData[id][bRestock],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}
	
Player_OwnsBisnis(playerid, id)
{
	return (bData[id][bOwnerID] == pData[playerid][pID]) || (!strcmp(bData[id][bOwner], pData[playerid][pName], true));
}

Player_BisnisCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Bisnis)
	{
		if(Player_OwnsBisnis(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

Bisnis_Reset(id)
{
	format(bData[id][bOwner], MAX_PLAYER_NAME, "-");
	format(bData[id][bName], 128, "-");
	bData[id][bOwnerID] = 0;
	bData[id][bLocked] = 1;
    bData[id][bMoney] = 0;
	bData[id][bProd] = 0;
	bData[id][bVisit] = 0;
	bData[id][bRestock] = 0;
	bData[id][bP][0] = 0;
	bData[id][bP][1] = 0;
	bData[id][bP][2] = 0;
	bData[id][bP][3] = 0;
	bData[id][bP][4] = 0;
	bData[id][bP][5] = 0;
	bData[id][bP][6] = 0;
	bData[id][bP][7] = 0;
	bData[id][bP][8] = 0;
	bData[id][bP][9] = 0;
	Bisnis_Refresh(id);
}
	
/*GetBisnisOwnerID(id)
{
	foreach(new i : Player)
	{
		if(!strcmp(bData[id][bOwner], pData[i][pName], true)) return i;
	}
	return INVALID_PLAYER_ID;
}*/

GetOwnedBisnis(playerid)
{
	new tmpcount;
	foreach(new bid : Bisnis)
	{
	    if(!strcmp(bData[bid][bOwner], pData[playerid][pName], true) || (bData[bid][bOwnerID] == pData[playerid][pID]))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
ReturnPlayerBisnisID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new bid : Bisnis)
	{
	    if(!strcmp(pData[playerid][pName], bData[bid][bOwner], true) || (bData[bid][bOwnerID] == pData[playerid][pID]))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return bid;
  			}
	    }
	}
	return -1;
}

Bisnis_BuyMenu(playerid, bizid)
{
    if(bizid <= -1 )
        return 0;

    static
        string[512];

    switch(bData[bizid][bType])
    {
        case 1:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}Fried Chicken\t{7fff00}%s\n{ffffff}Pizza Stack\t{7fff00}%s\n{ffffff}Patty Burger\t{7fff00}%s\n{ffffff}Sprunk\t{7fff00}%s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_TABLIST_HEADERS, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 2:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}Snack\t{7fff00}%s\n{ffffff}Sprunk\t{7fff00}%s\n{ffffff}Gas Fuel\t{7fff00}%s\n{ffffff}Bandage\t{7fff00}%s\n",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_TABLIST_HEADERS, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 3:
        {
            format(string, sizeof(string), "Aksesoris\tHarga\n{ffffff}Clothes\t{7fff00}%s\n{ffffff}Toys\t{7fff00}%s\n{ffffff}Mask\t{7fff00}%s\n{ffffff}Helmet\t{7fff00}%s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_TABLIST_HEADERS, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 4:
        {
            format(string, sizeof(string), "Alat\tHarga\n{ffffff}Brass Knuckles\t{7fff00}%s\n{ffffff}Knife\t{7fff00}%s\n{ffffff}Baseball Bat\t{7fff00}%s\n{ffffff}Shovel\t{7fff00}%s\n{ffffff}Chainsaw\t{7fff00}%s\n{ffffff}Cane\t{7fff00}%s\n{ffffff}Fishing Tool\t{7fff00}%s\n{ffffff}Worm\t{7fff00}%s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3]),
				FormatMoney(bData[bizid][bP][4]),
				FormatMoney(bData[bizid][bP][5]),
				FormatMoney(bData[bizid][bP][6]),
				FormatMoney(bData[bizid][bP][7])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_TABLIST_HEADERS, bData[bizid][bName], string, "Buy", "Cancel");
        }
		case 5:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}GPS\t{7fff00}%s\n{ffffff}Phone\t{7fff00}%s\n{ffffff}Phone Credit\t{7fff00}%s\n{ffffff}Phone Book\t{7fff00}%s\n{ffffff}Walkie Talkie\t{7fff00}%s\n{ffffff}Kuota 10gb\t{7fff00}%s\n",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3]),
				FormatMoney(bData[bizid][bP][4]),
				FormatMoney(bData[bizid][bP][5])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_TABLIST_HEADERS, bData[bizid][bName], string, "Buy", "Cancel");
        }
    }
    return 1;
}

Bisnis_ProductMenu(playerid, bizid)
{
    if(bizid <= -1)
        return 0;

    static
        string[512];

    switch (bData[bizid][bType])
    {
        case 1:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}Fried Chicken\t{7fff00}%s\n{ffffff}Pizza Stack\t{7fff00}%s\n{ffffff}Patty Burger\t{7fff00}%s\n{ffffff}Sprunk\t{7fff00}%s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD, DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
        case 2:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}Snack\t{7fff00}%s\n{ffffff}Sprunk\t{7fff00}%s\n{ffffff}Gas Fuel\t{7fff00}%s\n{ffffff}Bandage\t{7fff00}%s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3]),
				FormatMoney(bData[bizid][bP][4]),
				FormatMoney(bData[bizid][bP][5]),
				FormatMoney(bData[bizid][bP][6]),
				FormatMoney(bData[bizid][bP][7]),
				FormatMoney(bData[bizid][bP][8]),
				FormatMoney(bData[bizid][bP][9])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD,DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
        case 3:
        {
            format(string, sizeof(string), "Aksesoris\tHarga\n{ffffff}Clothes\t{7fff00}%s\n{ffffff}Toys\t{7fff00}%s\n{ffffff}Mask\t{7fff00}%s\n{ffffff}Helmet\t{7fff00}%s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD,DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
        case 4:
        {
            format(string, sizeof(string), "Alat\tHarga\n{ffffff}Brass Knuckles\t{7fff00}%s\n{ffffff}Knife\t{7fff00}%s\n{ffffff}Baseball Bat\t{7fff00}%s\n{ffffff}Shovel\t{7fff00}%s\n{ffffff}Chainsaw\t{7fff00}%s\n{ffffff}Cane\t{7fff00}%s\n{ffffff}Fishing Tool\t{7fff00}%s\n{ffffff}Worm\t{7fff00}%s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3]),
				FormatMoney(bData[bizid][bP][4]),
				FormatMoney(bData[bizid][bP][5]),
				FormatMoney(bData[bizid][bP][6]),
				FormatMoney(bData[bizid][bP][7])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD,DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
		case 5:
        {
            format(string, sizeof(string), "Produk\tHarga\n{ffffff}GPS\t{7fff00}%s\n{ffffff}Phone\t{7fff00}%s\n{ffffff}Phone Credit\t{7fff00}%s\n{ffffff}Phone Book\t{7fff00}%s\n{ffffff}Walkie Talkie\t{7fff00}%s\n{ffffff}Kuota 10gb\t{7fff00}%s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3]),
				FormatMoney(bData[bizid][bP][4]),
				FormatMoney(bData[bizid][bP][5])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD,DIALOG_STYLE_TABLIST_HEADERS, "Business: Modify Item", string, "Modify", "Cancel");
        }
    }
    return 1;
}

Bisnis_Type(bisid)
{
	if(bData[bisid][bType] == 1) // Fast Food
	{
	    switch(random(2))
		{
			case 0:
			{
				bData[bisid][bIntposX] = 363.22;
				bData[bisid][bIntposY] = -74.86;
				bData[bisid][bIntposZ] = 1001.50;
				bData[bisid][bIntposA] = 319.72;
				bData[bisid][bInt] = 10;
			}
			case 1:
			{
				bData[bisid][bIntposX] = 372.34;
				bData[bisid][bIntposY] = -133.25;
				bData[bisid][bIntposZ] = 1001.49;
				bData[bisid][bIntposA] = 4.80;
				bData[bisid][bInt] = 5;
			}
		}
	}
	if(bData[bisid][bType] == 2) //Market
	{
	    switch(random(2))
		{
			case 0:
			{
				bData[bisid][bIntposX] = 5.73;
				bData[bisid][bIntposY] = -31.04;
				bData[bisid][bIntposZ] = 1003.54;
				bData[bisid][bIntposA] = 355.73;
				bData[bisid][bInt] = 10;
			}
			case 1:
			{
				bData[bisid][bIntposX] = -26.68;
				bData[bisid][bIntposY] = -57.92;
				bData[bisid][bIntposZ] = 1003.54;
				bData[bisid][bIntposA] = 357.58;
				bData[bisid][bInt] = 6;
			}
		}
	}
	if(bData[bisid][bType] == 3) //Clothes
	{
	    switch(random(3))
		{
			case 0:
			{
				bData[bisid][bIntposX] = 207.55;
				bData[bisid][bIntposY] = -110.67;
				bData[bisid][bIntposZ] = 1005.13;
				bData[bisid][bIntposA] = 0.16;
				bData[bisid][bInt] = 15;
			}
			case 1:
			{
				bData[bisid][bIntposX] = 204.49;
				bData[bisid][bIntposY] = -168.26;
				bData[bisid][bIntposZ] = 1000.52;
				bData[bisid][bIntposA] = 358.74;
				bData[bisid][bInt] = 14;
			}
			case 2:
			{
				bData[bisid][bIntposX] = -401.7269;
				bData[bisid][bIntposY] = 2227.2236;
				bData[bisid][bIntposZ] = 1801.0859;
				bData[bisid][bIntposA] = 269.4387;
				bData[bisid][bInt] = 19;
			}
		}
	}
	if(bData[bisid][bType] == 4) // Equipment
	{
	    switch(random(2))
		{
			case 0:
			{
				bData[bisid][bIntposX] = 285.93;
				bData[bisid][bIntposY] = -86.00;
				bData[bisid][bIntposZ] = 1001.52;
				bData[bisid][bIntposA] = 352.95;
				bData[bisid][bInt] = 4;
			}
			case 1:
			{
				bData[bisid][bIntposX] = 316.34;
				bData[bisid][bIntposY] = -169.60;
				bData[bisid][bIntposZ] = 999.60;
				bData[bisid][bIntposA] =  357.73;
				bData[bisid][bInt] = 6;
			}
		}
	}
	if(bData[bisid][bType] == 5) // Electronic
	{
		switch(random(2))
		{
			case 0:
			{
				bData[bisid][bIntposX] = 1421.95;
				bData[bisid][bIntposY] = -1180.97;
				bData[bisid][bIntposZ] = 26.00;
				bData[bisid][bIntposA] =  176.57;
				bData[bisid][bInt] = 1;
			}
			case 1:
			{
				bData[bisid][bIntposX] = 1421.95;
				bData[bisid][bIntposY] = -1180.97;
				bData[bisid][bIntposZ] = 26.00;
				bData[bisid][bIntposA] =  176.57;
				bData[bisid][bInt] = 2;
			}
		}
	}

	new query[374];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET intposx='%f', intposy='%f', intposz='%f', intposa='%f', bint='%d' WHERE ID='%d'", bData[bisid][bIntposX], bData[bisid][bIntposY], bData[bisid][bIntposZ], bData[bisid][bIntposA], bData[bisid][bInt], bisid);
	mysql_tquery(g_SQL, query);
}

Bisnis_Refresh(id)
{
    if(id != -1)
    {
        if(IsValidDynamic3DTextLabel(bData[id][bLabel]))
            DestroyDynamic3DTextLabel(bData[id][bLabel]);

        if(IsValidDynamicPickup(bData[id][bPickup]))
            DestroyDynamicPickup(bData[id][bPickup]);

		if(IsValidDynamicPickup(bData[id][bPickup2]))
            DestroyDynamicPickup(bData[id][bPickup2]);
			
		if(IsValidDynamic3DTextLabel(bData[id][bLabelPoint]))
            DestroyDynamic3DTextLabel(bData[id][bLabelPoint]);

        if(IsValidDynamicPickup(bData[id][bPickPoint]))
            DestroyDynamicPickup(bData[id][bPickPoint]);
		
		if(IsValidDynamicCP(bData[id][bCP]))
			DestroyDynamicCP(bData[id][bCP]);
			
		DestroyDynamicMapIcon(bData[id][bMap]);

        static
        string[255], tstr[128];
		
		new type[128];
		if(bData[id][bType] == 1)
		{
			type= "Fast Food";
		}
		else if(bData[id][bType] == 2)
		{
			type= "Market";
		}
		else if(bData[id][bType] == 3)
		{
			type= "Clothes";
		}
		else if(bData[id][bType] == 4)
		{
			type= "Equipment";
		}
		else if(bData[id][bType] == 5)
		{
			type= "Electronics";
		}
		else
		{
			type= "Unknown";
		}
        if(strcmp(bData[id][bOwner], "-") || bData[id][bOwnerID] != 0)
		{
			format(string, sizeof(string), "[ID: %d]\n"WHITE_E"Name: {FFFF00}%s\n"WHITE_E"Owned by %s\nType: %s\nPress '{FF0000}ENTER{FFFFFF}' to enter", id, bData[id][bName], bData[id][bOwner], type);
			bData[id][bPickup] = CreateDynamicPickup(19133, 23, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]+0.2, 0, 0, _, 25.0);
			bData[id][bPickup2] = CreateDynamicPickup(19133, 23, bData[id][bIntposX], bData[id][bIntposY], bData[id][bIntposZ]+0.2, id, bData[id][bInt], _, 25.0);
        }
        else
        {
            format(string, sizeof(string), "[ID: %d]\n{00FF00}This bisnis for sell\n{FFFFFF}Location: {FFFF00}%s\n{FFFFFF}Price: {FFFF00}%s\n{FFFFFF}Type: {FFFF00}%s\n"WHITE_E"Type /buy to purchase", id, GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]), FormatMoney(bData[id][bPrice]), type);
            bData[id][bPickup] = CreateDynamicPickup(19133, 23, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]+0.2, 0, 0, _, 25.0);
			bData[id][bPickup2] = CreateDynamicPickup(19133, 23, bData[id][bIntposX], bData[id][bIntposY], bData[id][bIntposZ]+0.2, id, bData[id][bInt], _, 25.0);
		}
		bData[id][bPickPoint] = CreateDynamicPickup(1274, 23, bData[id][bPointX], bData[id][bPointY], bData[id][bPointZ]+0.2, id, bData[id][bInt], _, 8);
		
		format(tstr, 128, "[ID: %d]\n{7fffd4}Bisnis Point\n"LG_E"use '/buy' here", id);
		bData[id][bLabelPoint] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, bData[id][bPointX], bData[id][bPointY], bData[id][bPointZ]+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, id, bData[id][bInt]);
		
		//bData[id][bCP] = CreateDynamicCP(bData[id][bIntposX], bData[id][bIntposY], bData[id][bIntposZ], 1.0, id, bData[id][bInt], -1, 3.0);
        bData[id][bLabel] = CreateDynamic3DTextLabel(string, COLOR_GREEN, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
		
		if(bData[id][bType] == 1)
		{
			bData[id][bMap] = CreateDynamicMapIcon(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 50, -1, -1, -1, -1, 70.0);
		}
		else if(bData[id][bType] == 2)
		{
			bData[id][bMap] = CreateDynamicMapIcon(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 17, -1, -1, -1, -1, 70.0);
		}
		else if(bData[id][bType] == 3)
		{
			bData[id][bMap] = CreateDynamicMapIcon(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 45, -1, -1, -1, -1, 70.0);
		}
		else if(bData[id][bType] == 4)
		{
			bData[id][bMap] = CreateDynamicMapIcon(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 25, -1, -1, -1, -1, 70.0);
		}
		else if(bData[id][bType] == 5)
		{
			bData[id][bMap] = CreateDynamicMapIcon(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 35, -1, -1, -1, -1, 70.0);
		}
		else
		{
			DestroyDynamicMapIcon(bData[id][bMap]);
		}
    }
    return 1;
}

function LoadBisnis()
{
    static bid;
	
	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", bid);
			cache_get_value_name(i, "owner", owner);
			format(bData[bid][bOwner], 128, owner);
			cache_get_value_name_int(i, "ownerid", bData[bid][bOwnerID]);
			cache_get_value_name(i, "name", name);
			format(bData[bid][bName], 128, name);
			cache_get_value_name_int(i, "type", bData[bid][bType]);
			cache_get_value_name_int(i, "price", bData[bid][bPrice]);
			cache_get_value_name_float(i, "extposx", bData[bid][bExtposX]);
			cache_get_value_name_float(i, "extposy", bData[bid][bExtposY]);
			cache_get_value_name_float(i, "extposz", bData[bid][bExtposZ]);
			cache_get_value_name_float(i, "extposa", bData[bid][bExtposA]);
			cache_get_value_name_float(i, "intposx", bData[bid][bIntposX]);
			cache_get_value_name_float(i, "intposy", bData[bid][bIntposY]);
			cache_get_value_name_float(i, "intposz", bData[bid][bIntposZ]);
			cache_get_value_name_float(i, "intposa", bData[bid][bIntposA]);
			cache_get_value_name_int(i, "bint", bData[bid][bInt]);
			cache_get_value_name_int(i, "money", bData[bid][bMoney]);
			cache_get_value_name_int(i, "locked", bData[bid][bLocked]);
			cache_get_value_name_int(i, "prod", bData[bid][bProd]);
			cache_get_value_name_int(i, "bprice0", bData[bid][bP][0]);
			cache_get_value_name_int(i, "bprice1", bData[bid][bP][1]);
			cache_get_value_name_int(i, "bprice2", bData[bid][bP][2]);
			cache_get_value_name_int(i, "bprice3", bData[bid][bP][3]);
			cache_get_value_name_int(i, "bprice4", bData[bid][bP][4]);
			cache_get_value_name_int(i, "bprice5", bData[bid][bP][5]);
			cache_get_value_name_int(i, "bprice6", bData[bid][bP][6]);
			cache_get_value_name_int(i, "bprice7", bData[bid][bP][7]);
			cache_get_value_name_int(i, "bprice8", bData[bid][bP][8]);
			cache_get_value_name_int(i, "bprice9", bData[bid][bP][9]);
			cache_get_value_name_float(i, "pointx", bData[bid][bPointX]);
			cache_get_value_name_float(i, "pointy", bData[bid][bPointY]);
			cache_get_value_name_float(i, "pointz", bData[bid][bPointZ]);
			cache_get_value_name_int(i, "visit", bData[bid][bVisit]);
			cache_get_value_name_int(i, "restock", bData[bid][bRestock]);
			Bisnis_Refresh(bid);
			Iter_Add(Bisnis, bid);
		}
		printf("[Business]: %d Loaded.", rows);
	}
}

GetAnyBusiness()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
     	tmpcount++;
	}
	return tmpcount;
}

ReturnBusinessID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}

//------------[ Bisnis Command ]------------
//Bisnis System
CMD:createbiz(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
	
	new query[512];
	new bid = Iter_Free(Bisnis), address[128];
	if(bid == -1) return Error(playerid, "You cant create more door!");
	new price, type;
	if(sscanf(params, "dd", price, type)) return Usage(playerid, "/createbusiness [price] [type, 1.Fastfood 2.Market 3.Clothes 4.Equipment 5.Electronics]");
	format(bData[bid][bOwner], 128, "-");
	bData[bid][bOwnerID] = 0;
	GetPlayerPos(playerid, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]);
	GetPlayerFacingAngle(playerid, bData[bid][bExtposA]);
	bData[bid][bPrice] = price;
	bData[bid][bType] = type;
	address = GetLocation(bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]);
	format(bData[bid][bName], 128, address);
	bData[bid][bLocked] = 1;
	bData[bid][bMoney] = 0;
	bData[bid][bProd] = 0;
	bData[bid][bP][0] = 0;
	bData[bid][bP][1] = 0;
	bData[bid][bP][2] = 0;
	bData[bid][bP][3] = 0;
	bData[bid][bP][4] = 0;
	bData[bid][bP][5] = 0;
	bData[bid][bP][6] = 0;
	bData[bid][bP][7] = 0;
	bData[bid][bP][8] = 0;
	bData[bid][bP][9] = 0;
	bData[bid][bInt] = 0;
	bData[bid][bIntposX] = 0;
	bData[bid][bIntposY] = 0;
	bData[bid][bIntposZ] = 0;
	bData[bid][bIntposA] = 0;
	bData[bid][bVisit] = 0;
	bData[bid][bRestock] = 0;

	Iter_Add(Bisnis, bid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO bisnis SET ID='%d', owner='%s', ownerid='%d', price='%d', type='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', name='%s'", bid, bData[bid][bOwner], bData[bid][bOwnerID], bData[bid][bPrice], bData[bid][bType], bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], bData[bid][bExtposA], bData[bid][bName]);
	mysql_tquery(g_SQL, query, "OnBisnisCreated", "ii", playerid, bid);
	return 1;
}

function OnBisnisCreated(playerid, bid)
{
	Bisnis_Type(bid);
    Bisnis_Refresh(bid);
	Servers(playerid, "Business [%d] berhasil di buat!", bid);
	new str[150];
	format(str,sizeof(str),"[Biz]: %s membuat business id %d!", GetRPName(playerid), bid);
	LogServer("Admin", str);
	return 1;
}

function GetClosestBusiness(playerid, type)
{
	new
	    Float:distance[2] = {99999.0, 0.0},
	    index = -1;

	for(new i = 0; i < MAX_BISNIS; i ++)
	{
		if((bData[i][bType] == type))
		{
			distance[1] = GetPlayerDistanceFromPoint(playerid, bData[i][bExtposX], bData[i][bExtposY], bData[i][bExtposZ]);

			if(distance[0] > distance[1])
			{
			    distance[0] = distance[1];
			    index = i;
			}
		}
	}

	return index;
}

CMD:gotobiz(playerid, params[])
{
	new bid;
	if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
		
	if(sscanf(params, "d", bid))
		return Usage(playerid, "/gotobiz [id]");
	if(!Iter_Contains(Bisnis, bid)) return Error(playerid, "The Bisnis you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], bData[bid][bExtposA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to bisnis id %d", bid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;
	return 1;
}

CMD:editbiz(playerid, params[])
{
    static
        bid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", bid, type, string))
    {
        Usage(playerid, "/editbiz [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, locked, owner, point, price, type, product, restock, reset");
        return 1;
    }
    if((bid < 0 || bid >= MAX_BISNIS))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Bisnis, bid)) return Error(playerid, "The bisnis you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]);
		GetPlayerFacingAngle(playerid, bData[bid][bExtposA]);

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET extposx='%f', extposy='%f', extposz='%f', extposa='%f' WHERE ID='%d'", bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], bData[bid][bExtposA], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the location of bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
    else if(!strcmp(type, "interior", true))
    {
        GetPlayerPos(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ]);
		GetPlayerFacingAngle(playerid, bData[bid][bIntposA]);
		bData[bid][bInt] = GetPlayerInterior(playerid);

		new query[200];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET bint='%d', intposx='%f', intposy='%f', intposz='%f', intposa='%f' WHERE ID='%d'", bData[bid][bInt], bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the interior spawn of bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
    else if(!strcmp(type, "locked", true))
    {
        new locked;

        if(sscanf(string, "d", locked))
            return Usage(playerid, "/editbisnis [id] [locked] [0/1]");

        if(locked < 0 || locked > 1)
            return Error(playerid, "You must specify at least 0 or 1.");

        bData[bid][bLocked] = locked;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET locked='%d' WHERE ID='%d'", bData[bid][bLocked], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh(bid);

        if(locked) {
            SendAdminMessage(COLOR_RED, "%s has locked bisnis ID: %d.", pData[playerid][pAdminname], bid);
        }
        else {
            SendAdminMessage(COLOR_RED, "%s has unlocked bisnis ID: %d.", pData[playerid][pAdminname], bid);
        }
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editbisnis [id] [Price] [Amount]");

        bData[bid][bPrice] = price;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET price='%d' WHERE ID='%d'", bData[bid][bPrice], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the price of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, price);
    }
	else if(!strcmp(type, "type", true))
    {
        new btype;

        if(sscanf(string, "d", btype))
            return Usage(playerid, "/editbisnis [id] [Type] [1.Fastfood 2.Market 3.Clothes 4.Equipment 5.Electronics]");

        bData[bid][bType] = btype;

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET type='%d' WHERE ID='%d'", bData[bid][bType], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Type(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the type of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, btype);
    }
	else if(!strcmp(type, "product", true))
    {
        new prod;

        if(sscanf(string, "d", prod))
            return Usage(playerid, "/editbisnis [id] [product] [Ammount]");

        bData[bid][bProd] = prod;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d' WHERE ID='%d'", bData[bid][bProd], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the product of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, prod);
    }
	else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return Usage(playerid, "/editbisnis [id] [money] [Ammount]");

        bData[bid][bMoney] = money;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET money='%d' WHERE ID='%d'", bData[bid][bMoney], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the money of bisnis ID: %d to %s.", pData[playerid][pAdminname], bid, FormatMoney(money));
    }
	else if(!strcmp(type, "restock", true))
    {
        new prod;

        if(sscanf(string, "d", prod))
            return Usage(playerid, "/editbisnis [id] [restock] [0-1]");
		
		if(prod == 0)
		{
			bData[bid][bRestock] = 0;
			
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET restock='%d' WHERE ID='%d'", bData[bid][bRestock], bid);
			mysql_tquery(g_SQL, query);

			Bisnis_Refresh(bid);
			SendAdminMessage(COLOR_RED, "%s has adjusted the restock of bisnis ID: %d to disable.", pData[playerid][pAdminname], bid);
		}
		else if(prod == 1)
		{
			bData[bid][bRestock] = 1;
			
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET restock='%d' WHERE ID='%d'", bData[bid][bRestock], bid);
			mysql_tquery(g_SQL, query);

			Bisnis_Refresh(bid);
			SendAdminMessage(COLOR_RED, "%s has adjusted the restock of bisnis ID: %d to enable.", pData[playerid][pAdminname], bid);
		}
		else return Error(playerid, "Hanya id 0-1");
    }
	else if(!strcmp(type, "owner", true))
    {
		new otherid;
        if(sscanf(string, "d", otherid))
            return Usage(playerid, "/editbiz [id] [owner] [playerid] (use '-1' to no owner/ reset)");
		if(otherid == -1)
			return format(bData[bid][bOwner], MAX_PLAYER_NAME, "-");

        format(bData[bid][bOwner], MAX_PLAYER_NAME, pData[otherid][pName]);
		bData[bid][bOwnerID] = pData[otherid][pID];

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s', ownerid='%d' WHERE ID='%d'", bData[bid][bOwner], bData[bid][bOwnerID], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of business ID: %d to %s", pData[playerid][pAdminname], bid, pData[otherid][pName]);
    }
    else if(!strcmp(type, "reset", true))
    {
        Bisnis_Reset(bid);
		Bisnis_Save(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has reset bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
	else if(!strcmp(type, "point", true))
    {
		new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
		bData[bid][bPointX] = x;
		bData[bid][bPointY] = y;
		bData[bid][bPointZ] = z;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET pointx='%f', pointy='%f', pointz='%f' WHERE ID='%d'", bData[bid][bPointX], bData[bid][bPointY], bData[bid][bPointZ], bid);
		mysql_tquery(g_SQL, query);

		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has edit bisnis point ID: %d.", pData[playerid][pAdminname], bid);
    }
	else if(!strcmp(type, "delete", true))
    {
		Bisnis_Reset(bid);
		
		DestroyDynamic3DTextLabel(bData[bid][bLabel]);
        DestroyDynamicPickup(bData[bid][bPickup]);
		DestroyDynamicPickup(bData[bid][bPickup2]);
        DestroyDynamicCP(bData[bid][bCP]);
		DestroyDynamicMapIcon(bData[bid][bMap]);
		
		bData[bid][bExtposX] = 0;
		bData[bid][bExtposY] = 0;
		bData[bid][bExtposZ] = 0;
		bData[bid][bExtposA] = 0;
		bData[bid][bPrice] = 0;
		bData[bid][bInt] = 0;
		bData[bid][bIntposX] = 0;
		bData[bid][bIntposY] = 0;
		bData[bid][bIntposZ] = 0;
		bData[bid][bIntposA] = 0;
		bData[bid][bLabel] = Text3D: INVALID_3DTEXT_ID;
		bData[bid][bPickup] = -1;
		bData[bid][bPickup2] = -1;
		
		Iter_Remove(Bisnis, bid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM bisnis WHERE ID=%d", bid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete bisnis ID: %d.", pData[playerid][pAdminname], bid);
		new str[150];
		format(str,sizeof(str),"[Biz]: %s menghapus business id %d!", GetRPName(playerid), bid);
		LogServer("Admin", str);
	}
    return 1;
}
/*
CMD:buybisnis(playerid, params[])
{
	foreach(new id : Bisnis)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, bData[id][bExtpos][0], bData[id][bExtpos][1], bData[id][bExtpos][2]))
		{
			if(bData[id][bPrice] > GetPlayerMoney(playerid)) return Error(playerid, "Not enough money, you can't afford this bisnis.");
			if(strcmp(bData[id][bOwner], "-")) return Error(playerid, "Someone already owns this bisnis.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 2) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 3) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 4) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -bData[id][bPrice]);
			GetPlayerName(playerid, bData[id][bOwner], MAX_PLAYER_NAME);
			bData[id][bVisit] = gettime();
			
			Bisnis_Refresh(id);
		}
	}
	return 1;
}*/

CMD:lockbisnis(playerid, params[])
{
	foreach(new bid : Bisnis)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
		{
			if(!Player_OwnsBisnis(playerid, bid)) return Error(playerid, "Kamu tidak memiliki Bisnis ini.");
			if(!bData[bid][bLocked])
			{
				bData[bid][bLocked] = 1;
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET locked='%d' WHERE ID='%d'", bData[bid][bLocked], bid);
				mysql_tquery(g_SQL, query);

				InfoTD_MSG(playerid, 4000, "Bisnis anda berhasil ~r~Dikunci!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				bData[bid][bLocked] = 0;
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET locked='%d' WHERE ID='%d'", bData[bid][bLocked], bid);
				mysql_tquery(g_SQL, query);

				InfoTD_MSG(playerid, 4000,"Bisnis anda berhasil ~g~Dibuka");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

CMD:sellbusiness(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2082.9756, 2675.5081, 1500.9647)) return Error(playerid, "Anda harus berada di City Hall!");
	if(GetOwnedBisnis(playerid) == -1) return Error(playerid, "Anda tidak memiliki bisnis.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedBisnis(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerBisnisID(playerid, itt);
		if(hData[hid][hLocked] == 1)
		{
			lock = "{FF0000}Terbuka";
		
		}
		else
		{
			lock = "{00FF00}Terkunci";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, bData[hid][bName], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, bData[hid][bName], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_SELL_BISNISS, DIALOG_STYLE_LIST, "Sell Bisnis", CMDSString, "Sell", "Cancel");
	return 1;
}

CMD:mybusiness(playerid)
{
	if(GetOwnedBisnis(playerid) == -1) return Error(playerid, "Anda tidak memiliki bisnis.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedBisnis(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerBisnisID(playerid, itt);
		if(hData[hid][hLocked] == 1)
		{
			lock = "{FF0000}Dikunci{ffffff}";
		
		}
		else
		{
			lock = "{00FF00}Dibuka{ffffff}";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   {ffffff}(%s)\n", itt, bData[hid][bName], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  {ffffff}(%s)\n", itt, bData[hid][bName], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_BISNIS, DIALOG_STYLE_LIST, "{0000FF}My Business", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:bm(playerid, params[])
{
	if(pData[playerid][pInBiz] == -1) return 0;
	if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return Error(playerid, "Kamu tidak memiliki bisnis ini.");
    ShowPlayerDialog(playerid, BISNIS_MENU, DIALOG_STYLE_LIST, "Bisnis Menu","Bisnis Info\nChange Name\nBisnis Vault\nProduct Menu\nRequest Restock","Next","Close");
    return 1;
}

CMD:givebusiness(playerid, params[])
{
	new bid, otherid;
	if(sscanf(params, "ud", otherid, bid)) return Usage(playerid, "/givebisnis [playerid/name] [id] | /mybusiness - for show info");
	if(bid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "Player tersebut telah disconnect/tidak berada didekat dirimu.");
	
	if(!Player_OwnsBisnis(playerid, bid)) return Error(playerid, "Kamu tidak memiliki Bisnis ini.");
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount(otherid) + 1 > 2) return Error(playerid, "Target Player tidak dapat memiliki bisnis lebih.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount(otherid) + 1 > 3) return Error(playerid, "Target Player tidak dapat memiliki bisnis lebih.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount(otherid) + 1 > 4) return Error(playerid, "Target Player tidak dapat memiliki bisnis lebih.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount(otherid) + 1 > 1) return Error(playerid, "Target Player tidak dapat memiliki bisnis lebih.");
		#endif
	}
	GetPlayerName(otherid, bData[bid][bOwner], MAX_PLAYER_NAME);
	bData[bid][bOwnerID] = pData[otherid][pID];
	bData[bid][bVisit] = gettime();
	
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s', ownerid='%d', visit='%d' WHERE ID='%d'", bData[bid][bOwner], bData[bid][bOwnerID], bData[bid][bVisit], bid);
	mysql_tquery(g_SQL, query);

	Bisnis_Refresh(bid);
	Info(playerid, "Anda memberikan bisnis id: %d kepada %s", bid, ReturnName(otherid));
	Info(otherid, "%s memberikan bisnis id: %d kepada anda", bid, ReturnName(playerid));
	new str[150];
	format(str,sizeof(str),"[BIZ]: %s memberikan business id %d ke %s!", GetRPName(playerid), bid, GetRPName(otherid));
	LogServer("Property", str);
	return 1;
}
