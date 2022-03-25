#define MAX_CHARS 3

new PlayerChar[MAX_PLAYERS][MAX_CHARS][MAX_PLAYER_NAME + 1];
new LevelChar[MAX_PLAYERS][MAX_CHARS];

function CheckPlayerChar(playerid)
{
	cache_get_value_name_int(0, "extrac", pData[playerid][pExtraChar]);
	new query[256];
	format(query, sizeof(query), "SELECT `username`, `level` FROM `players` WHERE `ucp`='%s' LIMIT %d;", pData[playerid][pUCP], MAX_CHARS + pData[playerid][pExtraChar]);
	mysql_tquery(g_SQL, query, "LoadCharacter", "d", playerid);
	return 1;
}
function LoadCharacter(playerid)
{
	for (new i = 0; i < MAX_CHARS; i ++)
	{
		PlayerChar[playerid][i][0] = EOS;
	}
	for (new i = 0; i < cache_num_rows(); i ++)
	{
		cache_get_value_name(i, "username", PlayerChar[playerid][i]);
		cache_get_value_name_int(i, "level", LevelChar[playerid][i]);
	}
  	ShowCharacterList(playerid);
  	return 1;
}
ShowCharacterList(playerid)
{
	new name[256], count, sgstr[128];	
	for (new i; i < MAX_CHARS; i ++) if(PlayerChar[playerid][i][0] != EOS)
	{
	    format(sgstr, sizeof(sgstr), "{ffffff}%s\t%d\n", PlayerChar[playerid][i], LevelChar[playerid][i]);
		strcat(name, sgstr);
		count++;
	}
	if(count < MAX_CHARS)
		strcat(name, "{15D4ED}Create Character");
	strins(name, "Character Name\tLevel\n", 0);
	ShowPlayerDialog(playerid, DIALOG_CHARLIST, DIALOG_STYLE_TABLIST_HEADERS, "Character List", name, "Select", "Quit");
	return 1;
}