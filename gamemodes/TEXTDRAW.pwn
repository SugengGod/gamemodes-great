//------------[ Textdraw ]------------


//Info textdraw
new PlayerText:InfoTD[MAX_PLAYERS];
new Text:TextTime, Text:TextDate;

//Server Name textdraw
new Text:ServerName;
//Animation
new Text:AnimationTD;

// Phone Textdraws IndoGreat
new Text:PhoneTD[33];
new Text:phoneclosetd;
new Text:mesaagetd;
new Text:contactstd;
new Text:calltd;
new Text:twittertd;
new Text:banktd;
new Text:apptd;
new Text:gpstd;
new Text:settingtd;
new Text:cameratd;

//Welcome Textdraws
new Text:WelcomeTD[5];

new TD_Random_Messages_Intro[ ][ ] =
{
	"Great ~w~Roleplay"
};

function TDUpdates()
{
	TextDrawSetString(Text:ServerName, TD_Random_Messages_Intro[random(sizeof(TD_Random_Messages_Intro))]);
}

//Vehicle textdraw
new Text:VehicleTD[7];
//Stats td
new Text:StatsTD[8];

new Text:DPvehfare[MAX_PLAYERS];

//HBE textdraw Simple
new PlayerText:SPvehname[MAX_PLAYERS];
new PlayerText:SPvehengine[MAX_PLAYERS];
new PlayerText:SPvehspeed[MAX_PLAYERS];
new PlayerText:VModelTD[MAX_PLAYERS];

new PlayerText:PNameStats[MAX_PLAYERS];
new PlayerText:PSkinStats[MAX_PLAYERS];
new PlayerText:ActiveTD[MAX_PLAYERS];


CreatePlayerTextDraws(playerid)
{
	//Info textdraw
	InfoTD[playerid] = CreatePlayerTextDraw(playerid, 148.888, 361.385, "Selamat Datang!");
 	PlayerTextDrawLetterSize(playerid, InfoTD[playerid], 0.326, 1.654);
	PlayerTextDrawAlignment(playerid, InfoTD[playerid], 1);
	PlayerTextDrawColor(playerid, InfoTD[playerid], -1);
	PlayerTextDrawSetOutline(playerid, InfoTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, InfoTD[playerid], 0x000000FF);
	PlayerTextDrawFont(playerid, InfoTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfoTD[playerid], 1);
	
	ActiveTD[playerid] = CreatePlayerTextDraw(playerid, 274.000000, 176.583435, "Mengisi Ulang...");
	PlayerTextDrawLetterSize(playerid, ActiveTD[playerid], 0.374000, 1.349166);
	PlayerTextDrawAlignment(playerid, ActiveTD[playerid], 1);
	PlayerTextDrawColor(playerid, ActiveTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ActiveTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ActiveTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, ActiveTD[playerid], 255);
	PlayerTextDrawFont(playerid, ActiveTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ActiveTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ActiveTD[playerid], 0);
	
	DPvehfare[playerid] = TextDrawCreate(462.000000, 401.166687, "$500.000");
	TextDrawLetterSize(DPvehfare[playerid], 0.216000, 0.952498);
	TextDrawAlignment(DPvehfare[playerid], 1);
	TextDrawColor(DPvehfare[playerid], 16711935);
	TextDrawSetShadow(DPvehfare[playerid], 0);
	TextDrawSetOutline(DPvehfare[playerid], 1);
	TextDrawBackgroundColor(DPvehfare[playerid], 255);
	TextDrawFont(DPvehfare[playerid], 1);
	TextDrawSetProportional(DPvehfare[playerid], 1);
	TextDrawSetShadow(DPvehfare[playerid], 0);
	
	//HBE textdraw Simple
	SPvehname[playerid] = CreatePlayerTextDraw(playerid, 398.000000, 367.000000, "Washington");
	PlayerTextDrawFont(playerid, SPvehname[playerid], 0);
	PlayerTextDrawLetterSize(playerid, SPvehname[playerid], 0.395832, 1.350000);
	PlayerTextDrawTextSize(playerid, SPvehname[playerid], 640.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SPvehname[playerid], 0);
	PlayerTextDrawSetShadow(playerid, SPvehname[playerid], 1);
	PlayerTextDrawAlignment(playerid, SPvehname[playerid], 1);
	PlayerTextDrawColor(playerid, SPvehname[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, SPvehname[playerid], 255);
	PlayerTextDrawBoxColor(playerid, SPvehname[playerid], 50);
	PlayerTextDrawUseBox(playerid, SPvehname[playerid], 0);
	PlayerTextDrawSetProportional(playerid, SPvehname[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, SPvehname[playerid], 0);

	SPvehspeed[playerid] = CreatePlayerTextDraw(playerid, 369.000000, 389.000000, "0 Mph");
	PlayerTextDrawFont(playerid, SPvehspeed[playerid], 1);
	PlayerTextDrawLetterSize(playerid, SPvehspeed[playerid], 0.324997, 1.299998);
	PlayerTextDrawTextSize(playerid, SPvehspeed[playerid], 640.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SPvehspeed[playerid], 1);
	PlayerTextDrawSetShadow(playerid, SPvehspeed[playerid], 0);
	PlayerTextDrawAlignment(playerid, SPvehspeed[playerid], 1);
	PlayerTextDrawColor(playerid, SPvehspeed[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, SPvehspeed[playerid], 255);
	PlayerTextDrawBoxColor(playerid, SPvehspeed[playerid], 50);
	PlayerTextDrawUseBox(playerid, SPvehspeed[playerid], 0);
	PlayerTextDrawSetProportional(playerid, SPvehspeed[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, SPvehspeed[playerid], 0);

	SPvehengine[playerid] = CreatePlayerTextDraw(playerid, 388.000000, 403.000000, "off");
	PlayerTextDrawFont(playerid, SPvehengine[playerid], 3);
	PlayerTextDrawLetterSize(playerid, SPvehengine[playerid], 0.395832, 1.350000);
	PlayerTextDrawTextSize(playerid, SPvehengine[playerid], 640.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SPvehengine[playerid], 1);
	PlayerTextDrawSetShadow(playerid, SPvehengine[playerid], 0);
	PlayerTextDrawAlignment(playerid, SPvehengine[playerid], 1);
	PlayerTextDrawColor(playerid, SPvehengine[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, SPvehengine[playerid], 255);
	PlayerTextDrawBoxColor(playerid, SPvehengine[playerid], 50);
	PlayerTextDrawUseBox(playerid, SPvehengine[playerid], 0);
	PlayerTextDrawSetProportional(playerid, SPvehengine[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, SPvehengine[playerid], 0);

	//TD Name Stats
	PNameStats[playerid] = CreatePlayerTextDraw(playerid, 503.000000, 367.000000, "James Peterson");
	PlayerTextDrawFont(playerid, PNameStats[playerid], 0);
	PlayerTextDrawLetterSize(playerid, PNameStats[playerid], 0.395832, 1.350000);
	PlayerTextDrawTextSize(playerid, PNameStats[playerid], 640.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PNameStats[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PNameStats[playerid], 1);
	PlayerTextDrawAlignment(playerid, PNameStats[playerid], 1);
	PlayerTextDrawColor(playerid, PNameStats[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PNameStats[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PNameStats[playerid], 50);
	PlayerTextDrawUseBox(playerid, PNameStats[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PNameStats[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PNameStats[playerid], 0);

	PSkinStats[playerid] = CreatePlayerTextDraw(playerid, 556.000000, 369.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, PSkinStats[playerid], 5);
	PlayerTextDrawLetterSize(playerid, PSkinStats[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PSkinStats[playerid], 124.000000, 140.000000);
	PlayerTextDrawSetOutline(playerid, PSkinStats[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PSkinStats[playerid], 0);
	PlayerTextDrawAlignment(playerid, PSkinStats[playerid], 1);
	PlayerTextDrawColor(playerid, PSkinStats[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PSkinStats[playerid], 0);
	PlayerTextDrawBoxColor(playerid, PSkinStats[playerid], 255);
	PlayerTextDrawUseBox(playerid, PSkinStats[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PSkinStats[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PSkinStats[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, PSkinStats[playerid], 2);
	PlayerTextDrawSetPreviewRot(playerid, PSkinStats[playerid], -10.000000, 0.000000, -27.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, PSkinStats[playerid], 1, 1);

	VModelTD[playerid] = CreatePlayerTextDraw(playerid, 434.000000, 363.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, VModelTD[playerid], 5);
	PlayerTextDrawLetterSize(playerid, VModelTD[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, VModelTD[playerid], 66.000000, 98.000000);
	PlayerTextDrawSetOutline(playerid, VModelTD[playerid], 0);
	PlayerTextDrawSetShadow(playerid, VModelTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, VModelTD[playerid], 1);
	PlayerTextDrawColor(playerid, VModelTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, VModelTD[playerid], 0);
	PlayerTextDrawBoxColor(playerid, VModelTD[playerid], 255);
	PlayerTextDrawUseBox(playerid, VModelTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, VModelTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, VModelTD[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, VModelTD[playerid], 515);
	PlayerTextDrawSetPreviewRot(playerid, VModelTD[playerid], -10.000000, 0.000000, -27.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, VModelTD[playerid], 1, 1);
}

CreateTextDraw()
{
	//Date and Time
	TextDate = TextDrawCreate(71.000000, 430.000000, "24 - March - 2021");
	TextDrawFont(TextDate, 1);
	TextDrawLetterSize(TextDate, 0.308332, 1.349998);
	TextDrawTextSize(TextDate, 404.500000, 114.500000);
	TextDrawSetOutline(TextDate, 1);
	TextDrawSetShadow(TextDate, 0);
	TextDrawAlignment(TextDate, 2);
	TextDrawColor(TextDate, -1);
	TextDrawBackgroundColor(TextDate, 255);
	TextDrawBoxColor(TextDate, 50);
	TextDrawSetProportional(TextDate, 1);
	TextDrawSetSelectable(TextDate, 0);

	TextTime = TextDrawCreate(547.000000, 28.000000, "-:-:-");
    TextDrawFont(TextTime, 1);
    TextDrawLetterSize(TextTime, 0.400000, 2.000000);
    TextDrawTextSize(TextTime, 400.000000, 1.399999);
    TextDrawSetOutline(TextTime, 1);
    TextDrawSetShadow(TextTime, 0);
    TextDrawAlignment(TextTime, 1);
    TextDrawColor(TextTime, -1);
    TextDrawBackgroundColor(TextTime, 255);
    TextDrawBoxColor(TextTime, 50);
    TextDrawUseBox(TextTime, 0);
    TextDrawSetProportional(TextTime, 1);
    TextDrawSetSelectable(TextTime, 0);
	
	//Server Name
	ServerName = TextDrawCreate(490.000000, 8.000038, "Great ~w~Roleplay");
    TextDrawLetterSize(ServerName, 0.269998, 1.405864);
    TextDrawAlignment(ServerName, 1);
    TextDrawColor(ServerName, -16776961);
    TextDrawSetShadow(ServerName, 0);
    TextDrawSetOutline(ServerName, 1);
    TextDrawBackgroundColor(ServerName, 0x000000FF);
    TextDrawFont(ServerName, 1);
    TextDrawSetProportional(ServerName, 1);

	// Animation textdraw
	AnimationTD = TextDrawCreate(261.000000, 395.000000, "Gunakan ~b~H~w~ untuk stop anim");
	TextDrawFont(AnimationTD, 2);
	TextDrawLetterSize(AnimationTD, 0.199996, 1.649996);
	TextDrawTextSize(AnimationTD, 636.500000, -174.500000);
	TextDrawSetOutline(AnimationTD, 1);
	TextDrawSetShadow(AnimationTD, 0);
	TextDrawAlignment(AnimationTD, 1);
	TextDrawColor(AnimationTD, -1);
	TextDrawBackgroundColor(AnimationTD, 255);
	TextDrawBoxColor(AnimationTD, 50);
	TextDrawUseBox(AnimationTD, 0);
	TextDrawSetProportional(AnimationTD, 1);
	TextDrawSetSelectable(AnimationTD, 0);
	
	StatsTD[0] = TextDrawCreate(585.000000, 364.000000, "_");
	TextDrawFont(StatsTD[0], 1);
	TextDrawLetterSize(StatsTD[0], 0.600000, 9.550009);
	TextDrawTextSize(StatsTD[0], 296.000000, 172.500000);
	TextDrawSetOutline(StatsTD[0], 1);
	TextDrawSetShadow(StatsTD[0], 0);
	TextDrawAlignment(StatsTD[0], 2);
	TextDrawColor(StatsTD[0], -1);
	TextDrawBackgroundColor(StatsTD[0], 255);
	TextDrawBoxColor(StatsTD[0], 125);
	TextDrawUseBox(StatsTD[0], 1);
	TextDrawSetProportional(StatsTD[0], 1);
	TextDrawSetSelectable(StatsTD[0], 0);

	StatsTD[1] = TextDrawCreate(587.000000, 366.000000, "_");
	TextDrawFont(StatsTD[1], 1);
	TextDrawLetterSize(StatsTD[1], 0.600000, 9.550009);
	TextDrawTextSize(StatsTD[1], 296.000000, 172.500000);
	TextDrawSetOutline(StatsTD[1], 1);
	TextDrawSetShadow(StatsTD[1], 0);
	TextDrawAlignment(StatsTD[1], 2);
	TextDrawColor(StatsTD[1], -1);
	TextDrawBackgroundColor(StatsTD[1], 255);
	TextDrawBoxColor(StatsTD[1], -1);
	TextDrawUseBox(StatsTD[1], 1);
	TextDrawSetProportional(StatsTD[1], 1);
	TextDrawSetSelectable(StatsTD[1], 0);

	StatsTD[2] = TextDrawCreate(622.000000, 368.000000, "_");
	TextDrawFont(StatsTD[2], 1);
	TextDrawLetterSize(StatsTD[2], 0.600000, 9.200004);
	TextDrawTextSize(StatsTD[2], 298.500000, 42.500000);
	TextDrawSetOutline(StatsTD[2], 1);
	TextDrawSetShadow(StatsTD[2], 0);
	TextDrawAlignment(StatsTD[2], 2);
	TextDrawColor(StatsTD[2], -1);
	TextDrawBackgroundColor(StatsTD[2], 255);
	TextDrawBoxColor(StatsTD[2], 135);
	TextDrawUseBox(StatsTD[2], 1);
	TextDrawSetProportional(StatsTD[2], 1);
	TextDrawSetSelectable(StatsTD[2], 0);

	StatsTD[3] = TextDrawCreate(549.000000, 388.000000, "_");
	TextDrawFont(StatsTD[3], 1);
	TextDrawLetterSize(StatsTD[3], 0.600000, 9.200004);
	TextDrawTextSize(StatsTD[3], 298.500000, 94.000000);
	TextDrawSetOutline(StatsTD[3], 1);
	TextDrawSetShadow(StatsTD[3], 0);
	TextDrawAlignment(StatsTD[3], 2);
	TextDrawColor(StatsTD[3], -1);
	TextDrawBackgroundColor(StatsTD[3], 255);
	TextDrawBoxColor(StatsTD[3], 135);
	TextDrawUseBox(StatsTD[3], 1);
	TextDrawSetProportional(StatsTD[3], 1);
	TextDrawSetSelectable(StatsTD[3], 0);

	StatsTD[4] = TextDrawCreate(549.000000, 368.000000, "_");
	TextDrawFont(StatsTD[4], 1);
	TextDrawLetterSize(StatsTD[4], 0.600000, 1.600005);
	TextDrawTextSize(StatsTD[4], 298.500000, 94.000000);
	TextDrawSetOutline(StatsTD[4], 1);
	TextDrawSetShadow(StatsTD[4], 0);
	TextDrawAlignment(StatsTD[4], 2);
	TextDrawColor(StatsTD[4], -1);
	TextDrawBackgroundColor(StatsTD[4], 255);
	TextDrawBoxColor(StatsTD[4], 135);
	TextDrawUseBox(StatsTD[4], 1);
	TextDrawSetProportional(StatsTD[4], 1);
	TextDrawSetSelectable(StatsTD[4], 0);

	StatsTD[5] = TextDrawCreate(508.000000, 421.000000, "HUD:radar_diner");
	TextDrawFont(StatsTD[5], 4);
	TextDrawLetterSize(StatsTD[5], 0.600000, 2.000000);
	TextDrawTextSize(StatsTD[5], 13.500000, 15.000000);
	TextDrawSetOutline(StatsTD[5], 1);
	TextDrawSetShadow(StatsTD[5], 0);
	TextDrawAlignment(StatsTD[5], 1);
	TextDrawColor(StatsTD[5], -1);
	TextDrawBackgroundColor(StatsTD[5], 0);
	TextDrawBoxColor(StatsTD[5], 0);
	TextDrawUseBox(StatsTD[5], 1);
	TextDrawSetProportional(StatsTD[5], 1);
	TextDrawSetSelectable(StatsTD[5], 0);

	StatsTD[6] = TextDrawCreate(508.000000, 398.000000, "HUD:radar_datefood");
	TextDrawFont(StatsTD[6], 4);
	TextDrawLetterSize(StatsTD[6], 0.600000, 2.000000);
	TextDrawTextSize(StatsTD[6], 13.500000, 14.000000);
	TextDrawSetOutline(StatsTD[6], 1);
	TextDrawSetShadow(StatsTD[6], 0);
	TextDrawAlignment(StatsTD[6], 1);
	TextDrawColor(StatsTD[6], -1);
	TextDrawBackgroundColor(StatsTD[6], 255);
	TextDrawBoxColor(StatsTD[6], 50);
	TextDrawUseBox(StatsTD[6], 1);
	TextDrawSetProportional(StatsTD[6], 1);
	TextDrawSetSelectable(StatsTD[6], 0);

	//Vehicle textdraw
	VehicleTD[0] = TextDrawCreate(427.000000, 364.000000, "_");
	TextDrawFont(VehicleTD[0], 1);
	TextDrawLetterSize(VehicleTD[0], 0.600000, 9.550004);
	TextDrawTextSize(VehicleTD[0], 296.000000, 132.000000);
	TextDrawSetOutline(VehicleTD[0], 1);
	TextDrawSetShadow(VehicleTD[0], 0);
	TextDrawAlignment(VehicleTD[0], 2);
	TextDrawColor(VehicleTD[0], -1);
	TextDrawBackgroundColor(VehicleTD[0], 255);
	TextDrawBoxColor(VehicleTD[0], 125);
	TextDrawUseBox(VehicleTD[0], 1);
	TextDrawSetProportional(VehicleTD[0], 1);
	TextDrawSetSelectable(VehicleTD[0], 0);

	VehicleTD[1] = TextDrawCreate(427.000000, 366.000000, "_");
	TextDrawFont(VehicleTD[1], 1);
	TextDrawLetterSize(VehicleTD[1], 0.600000, 9.550004);
	TextDrawTextSize(VehicleTD[1], 296.000000, 127.500000);
	TextDrawSetOutline(VehicleTD[1], 1);
	TextDrawSetShadow(VehicleTD[1], 0);
	TextDrawAlignment(VehicleTD[1], 2);
	TextDrawColor(VehicleTD[1], -1);
	TextDrawBackgroundColor(VehicleTD[1], 255);
	TextDrawBoxColor(VehicleTD[1], -1);
	TextDrawUseBox(VehicleTD[1], 1);
	TextDrawSetProportional(VehicleTD[1], 1);
	TextDrawSetSelectable(VehicleTD[1], 0);

	VehicleTD[2] = TextDrawCreate(460.000000, 388.000000, "_");
	TextDrawFont(VehicleTD[2], 1);
	TextDrawLetterSize(VehicleTD[2], 0.600000, 9.199997);
	TextDrawTextSize(VehicleTD[2], 298.500000, 59.000000);
	TextDrawSetOutline(VehicleTD[2], 1);
	TextDrawSetShadow(VehicleTD[2], 0);
	TextDrawAlignment(VehicleTD[2], 2);
	TextDrawColor(VehicleTD[2], -1);
	TextDrawBackgroundColor(VehicleTD[2], 255);
	TextDrawBoxColor(VehicleTD[2], 135);
	TextDrawUseBox(VehicleTD[2], 1);
	TextDrawSetProportional(VehicleTD[2], 1);
	TextDrawSetSelectable(VehicleTD[2], 0);

	VehicleTD[3] = TextDrawCreate(427.000000, 368.000000, "_");
	TextDrawFont(VehicleTD[3], 1);
	TextDrawLetterSize(VehicleTD[3], 0.600000, 1.600005);
	TextDrawTextSize(VehicleTD[3], 298.500000, 124.500000);
	TextDrawSetOutline(VehicleTD[3], 1);
	TextDrawSetShadow(VehicleTD[3], 0);
	TextDrawAlignment(VehicleTD[3], 2);
	TextDrawColor(VehicleTD[3], -1);
	TextDrawBackgroundColor(VehicleTD[3], 255);
	TextDrawBoxColor(VehicleTD[3], 135);
	TextDrawUseBox(VehicleTD[3], 1);
	TextDrawSetProportional(VehicleTD[3], 1);
	TextDrawSetSelectable(VehicleTD[3], 0);

	VehicleTD[4] = TextDrawCreate(362.000000, 429.000000, "Preview_Model");
	TextDrawFont(VehicleTD[4], 5);
	TextDrawLetterSize(VehicleTD[4], 0.600000, 2.000000);
	TextDrawTextSize(VehicleTD[4], 18.000000, 18.000000);
	TextDrawSetOutline(VehicleTD[4], 0);
	TextDrawSetShadow(VehicleTD[4], 0);
	TextDrawAlignment(VehicleTD[4], 1);
	TextDrawColor(VehicleTD[4], -1);
	TextDrawBackgroundColor(VehicleTD[4], 0);
	TextDrawBoxColor(VehicleTD[4], 255);
	TextDrawUseBox(VehicleTD[4], 0);
	TextDrawSetProportional(VehicleTD[4], 1);
	TextDrawSetSelectable(VehicleTD[4], 0);
	TextDrawSetPreviewModel(VehicleTD[4], 1650);
	TextDrawSetPreviewRot(VehicleTD[4], -1.000000, 0.000000, 170.000000, 1.000000);
	TextDrawSetPreviewVehCol(VehicleTD[4], 1, 1);

	VehicleTD[5] = TextDrawCreate(395.000000, 388.000000, "_");
	TextDrawFont(VehicleTD[5], 1);
	TextDrawLetterSize(VehicleTD[5], 0.600000, 9.199997);
	TextDrawTextSize(VehicleTD[5], 299.500000, 60.500000);
	TextDrawSetOutline(VehicleTD[5], 1);
	TextDrawSetShadow(VehicleTD[5], 0);
	TextDrawAlignment(VehicleTD[5], 2);
	TextDrawColor(VehicleTD[5], -1);
	TextDrawBackgroundColor(VehicleTD[5], 255);
	TextDrawBoxColor(VehicleTD[5], 135);
	TextDrawUseBox(VehicleTD[5], 1);
	TextDrawSetProportional(VehicleTD[5], 1);
	TextDrawSetSelectable(VehicleTD[5], 0);

	VehicleTD[6] = TextDrawCreate(362.000000, 413.000000, "Preview_Model");
	TextDrawFont(VehicleTD[6], 5);
	TextDrawLetterSize(VehicleTD[6], 0.600000, 2.000000);
	TextDrawTextSize(VehicleTD[6], 18.000000, 18.000000);
	TextDrawSetOutline(VehicleTD[6], 0);
	TextDrawSetShadow(VehicleTD[6], 0);
	TextDrawAlignment(VehicleTD[6], 1);
	TextDrawColor(VehicleTD[6], -1);
	TextDrawBackgroundColor(VehicleTD[6], 0);
	TextDrawBoxColor(VehicleTD[6], 255);
	TextDrawUseBox(VehicleTD[6], 0);
	TextDrawSetProportional(VehicleTD[6], 1);
	TextDrawSetSelectable(VehicleTD[6], 0);
	TextDrawSetPreviewModel(VehicleTD[6], 1240);
	TextDrawSetPreviewRot(VehicleTD[6], -1.000000, 0.000000, 170.000000, 1.000000);
	TextDrawSetPreviewVehCol(VehicleTD[6], 1, 1);

//------------[ Phone Textdraws IndoGreat ]
	PhoneTD[0] = TextDrawCreate(512.000000, 111.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[0], 4);
	TextDrawLetterSize(PhoneTD[0], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[0], 25.000000, 25.000000);
	TextDrawSetOutline(PhoneTD[0], 1);
	TextDrawSetShadow(PhoneTD[0], 0);
	TextDrawAlignment(PhoneTD[0], 1);
	TextDrawColor(PhoneTD[0], 255);
	TextDrawBackgroundColor(PhoneTD[0], 255);
	TextDrawBoxColor(PhoneTD[0], 50);
	TextDrawUseBox(PhoneTD[0], 1);
	TextDrawSetProportional(PhoneTD[0], 1);
	TextDrawSetSelectable(PhoneTD[0], 0);

	PhoneTD[1] = TextDrawCreate(410.000000, 111.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[1], 4);
	TextDrawLetterSize(PhoneTD[1], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[1], 25.000000, 25.000000);
	TextDrawSetOutline(PhoneTD[1], 1);
	TextDrawSetShadow(PhoneTD[1], 0);
	TextDrawAlignment(PhoneTD[1], 1);
	TextDrawColor(PhoneTD[1], 255);
	TextDrawBackgroundColor(PhoneTD[1], 255);
	TextDrawBoxColor(PhoneTD[1], 50);
	TextDrawUseBox(PhoneTD[1], 1);
	TextDrawSetProportional(PhoneTD[1], 1);
	TextDrawSetSelectable(PhoneTD[1], 0);

	PhoneTD[2] = TextDrawCreate(410.000000, 321.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[2], 4);
	TextDrawLetterSize(PhoneTD[2], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[2], 25.000000, 25.000000);
	TextDrawSetOutline(PhoneTD[2], 1);
	TextDrawSetShadow(PhoneTD[2], 0);
	TextDrawAlignment(PhoneTD[2], 1);
	TextDrawColor(PhoneTD[2], 255);
	TextDrawBackgroundColor(PhoneTD[2], 255);
	TextDrawBoxColor(PhoneTD[2], 50);
	TextDrawUseBox(PhoneTD[2], 1);
	TextDrawSetProportional(PhoneTD[2], 1);
	TextDrawSetSelectable(PhoneTD[2], 0);

	PhoneTD[3] = TextDrawCreate(512.000000, 321.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[3], 4);
	TextDrawLetterSize(PhoneTD[3], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[3], 25.000000, 25.000000);
	TextDrawSetOutline(PhoneTD[3], 1);
	TextDrawSetShadow(PhoneTD[3], 0);
	TextDrawAlignment(PhoneTD[3], 1);
	TextDrawColor(PhoneTD[3], 255);
	TextDrawBackgroundColor(PhoneTD[3], 255);
	TextDrawBoxColor(PhoneTD[3], 50);
	TextDrawUseBox(PhoneTD[3], 1);
	TextDrawSetProportional(PhoneTD[3], 1);
	TextDrawSetSelectable(PhoneTD[3], 0);

	PhoneTD[4] = TextDrawCreate(473.000000, 117.500000, "_");
	TextDrawFont(PhoneTD[4], 1);
	TextDrawLetterSize(PhoneTD[4], 0.554166, 24.650011);
	TextDrawTextSize(PhoneTD[4], 261.000000, 101.500000);
	TextDrawSetOutline(PhoneTD[4], 1);
	TextDrawSetShadow(PhoneTD[4], 0);
	TextDrawAlignment(PhoneTD[4], 2);
	TextDrawColor(PhoneTD[4], -1);
	TextDrawBackgroundColor(PhoneTD[4], 255);
	TextDrawBoxColor(PhoneTD[4], 255);
	TextDrawUseBox(PhoneTD[4], 1);
	TextDrawSetProportional(PhoneTD[4], 1);
	TextDrawSetSelectable(PhoneTD[4], 0);

	PhoneTD[5] = TextDrawCreate(473.500000, 123.500000, "_");
	TextDrawFont(PhoneTD[5], 1);
	TextDrawLetterSize(PhoneTD[5], 0.554166, 23.050035);
	TextDrawTextSize(PhoneTD[5], 252.500000, 114.500000);
	TextDrawSetOutline(PhoneTD[5], 1);
	TextDrawSetShadow(PhoneTD[5], 0);
	TextDrawAlignment(PhoneTD[5], 2);
	TextDrawColor(PhoneTD[5], -1);
	TextDrawBackgroundColor(PhoneTD[5], 255);
	TextDrawBoxColor(PhoneTD[5], 255);
	TextDrawUseBox(PhoneTD[5], 1);
	TextDrawSetProportional(PhoneTD[5], 1);
	TextDrawSetSelectable(PhoneTD[5], 0);

	PhoneTD[6] = TextDrawCreate(419.000000, 318.000000, "ld_dual:backgnd");
	TextDrawFont(PhoneTD[6], 4);
	TextDrawLetterSize(PhoneTD[6], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[6], 109.500000, -198.000000);
	TextDrawSetOutline(PhoneTD[6], 1);
	TextDrawSetShadow(PhoneTD[6], 0);
	TextDrawAlignment(PhoneTD[6], 1);
	TextDrawColor(PhoneTD[6], -1);
	TextDrawBackgroundColor(PhoneTD[6], 255);
	TextDrawBoxColor(PhoneTD[6], 50);
	TextDrawUseBox(PhoneTD[6], 1);
	TextDrawSetProportional(PhoneTD[6], 1);
	TextDrawSetSelectable(PhoneTD[6], 0);

	PhoneTD[7] = TextDrawCreate(473.500000, 120.500000, "_");
	TextDrawFont(PhoneTD[7], 1);
	TextDrawLetterSize(PhoneTD[7], 0.554166, 1.700037);
	TextDrawTextSize(PhoneTD[7], 252.500000, 105.000000);
	TextDrawSetOutline(PhoneTD[7], 1);
	TextDrawSetShadow(PhoneTD[7], 0);
	TextDrawAlignment(PhoneTD[7], 2);
	TextDrawColor(PhoneTD[7], -1);
	TextDrawBackgroundColor(PhoneTD[7], 255);
	TextDrawBoxColor(PhoneTD[7], 255);
	TextDrawUseBox(PhoneTD[7], 1);
	TextDrawSetProportional(PhoneTD[7], 1);
	TextDrawSetSelectable(PhoneTD[7], 0);

	PhoneTD[8] = TextDrawCreate(474.000000, 123.000000, "_");
	TextDrawFont(PhoneTD[8], 1);
	TextDrawLetterSize(PhoneTD[8], 0.600000, -0.199993);
	TextDrawTextSize(PhoneTD[8], 326.000000, 21.000000);
	TextDrawSetOutline(PhoneTD[8], 1);
	TextDrawSetShadow(PhoneTD[8], 0);
	TextDrawAlignment(PhoneTD[8], 2);
	TextDrawColor(PhoneTD[8], -1);
	TextDrawBackgroundColor(PhoneTD[8], 255);
	TextDrawBoxColor(PhoneTD[8], -1);
	TextDrawUseBox(PhoneTD[8], 1);
	TextDrawSetProportional(PhoneTD[8], 1);
	TextDrawSetSelectable(PhoneTD[8], 0);

	PhoneTD[9] = TextDrawCreate(512.000000, 321.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[9], 4);
	TextDrawLetterSize(PhoneTD[9], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[9], 25.000000, 25.000000);
	TextDrawSetOutline(PhoneTD[9], 1);
	TextDrawSetShadow(PhoneTD[9], 0);
	TextDrawAlignment(PhoneTD[9], 1);
	TextDrawColor(PhoneTD[9], 255);
	TextDrawBackgroundColor(PhoneTD[9], 255);
	TextDrawBoxColor(PhoneTD[9], 50);
	TextDrawUseBox(PhoneTD[9], 1);
	TextDrawSetProportional(PhoneTD[9], 1);
	TextDrawSetSelectable(PhoneTD[9], 0);

	PhoneTD[10] = TextDrawCreate(480.000000, 119.500000, "ld_beat:chit");
	TextDrawFont(PhoneTD[10], 4);
	TextDrawLetterSize(PhoneTD[10], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[10], 10.000000, 5.000000);
	TextDrawSetOutline(PhoneTD[10], 1);
	TextDrawSetShadow(PhoneTD[10], 0);
	TextDrawAlignment(PhoneTD[10], 1);
	TextDrawColor(PhoneTD[10], -1);
	TextDrawBackgroundColor(PhoneTD[10], 255);
	TextDrawBoxColor(PhoneTD[10], 50);
	TextDrawUseBox(PhoneTD[10], 1);
	TextDrawSetProportional(PhoneTD[10], 1);
	TextDrawSetSelectable(PhoneTD[10], 0);

	PhoneTD[11] = TextDrawCreate(457.000000, 119.500000, "ld_beat:chit");
	TextDrawFont(PhoneTD[11], 4);
	TextDrawLetterSize(PhoneTD[11], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[11], 10.000000, 5.000000);
	TextDrawSetOutline(PhoneTD[11], 1);
	TextDrawSetShadow(PhoneTD[11], 0);
	TextDrawAlignment(PhoneTD[11], 1);
	TextDrawColor(PhoneTD[11], -1);
	TextDrawBackgroundColor(PhoneTD[11], 255);
	TextDrawBoxColor(PhoneTD[11], 50);
	TextDrawUseBox(PhoneTD[11], 1);
	TextDrawSetProportional(PhoneTD[11], 1);
	TextDrawSetSelectable(PhoneTD[11], 0);

	PhoneTD[12] = TextDrawCreate(452.000000, 119.500000, "ld_beat:chit");
	TextDrawFont(PhoneTD[12], 4);
	TextDrawLetterSize(PhoneTD[12], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[12], 5.000000, 5.000000);
	TextDrawSetOutline(PhoneTD[12], 1);
	TextDrawSetShadow(PhoneTD[12], 0);
	TextDrawAlignment(PhoneTD[12], 1);
	TextDrawColor(PhoneTD[12], -1);
	TextDrawBackgroundColor(PhoneTD[12], 255);
	TextDrawBoxColor(PhoneTD[12], 50);
	TextDrawUseBox(PhoneTD[12], 1);
	TextDrawSetProportional(PhoneTD[12], 1);
	TextDrawSetSelectable(PhoneTD[12], 0);

	PhoneTD[13] = TextDrawCreate(422.000000, 138.000000, "00:00");
	TextDrawFont(PhoneTD[13], 3);
	TextDrawLetterSize(PhoneTD[13], 0.220833, 1.100000);
	TextDrawTextSize(PhoneTD[13], 550.000000, 17.000000);
	TextDrawSetOutline(PhoneTD[13], 1);
	TextDrawSetShadow(PhoneTD[13], 0);
	TextDrawAlignment(PhoneTD[13], 1);
	TextDrawColor(PhoneTD[13], -1);
	TextDrawBackgroundColor(PhoneTD[13], 255);
	TextDrawBoxColor(PhoneTD[13], 50);
	TextDrawUseBox(PhoneTD[13], 0);
	TextDrawSetProportional(PhoneTD[13], 1);
	TextDrawSetSelectable(PhoneTD[13], 0);

	PhoneTD[14] = TextDrawCreate(416.000000, 151.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[14], 4);
	TextDrawLetterSize(PhoneTD[14], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[14], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[14], 1);
	TextDrawSetShadow(PhoneTD[14], 0);
	TextDrawAlignment(PhoneTD[14], 1);
	TextDrawColor(PhoneTD[14], 1687547391);
	TextDrawBackgroundColor(PhoneTD[14], 1097458175);
	TextDrawBoxColor(PhoneTD[14], 1687547186);
	TextDrawUseBox(PhoneTD[14], 1);
	TextDrawSetProportional(PhoneTD[14], 1);
	TextDrawSetSelectable(PhoneTD[14], 0);

	PhoneTD[15] = TextDrawCreate(454.000000, 151.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[15], 4);
	TextDrawLetterSize(PhoneTD[15], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[15], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[15], 1);
	TextDrawSetShadow(PhoneTD[15], 0);
	TextDrawAlignment(PhoneTD[15], 1);
	TextDrawColor(PhoneTD[15], -65281);
	TextDrawBackgroundColor(PhoneTD[15], 255);
	TextDrawBoxColor(PhoneTD[15], 50);
	TextDrawUseBox(PhoneTD[15], 1);
	TextDrawSetProportional(PhoneTD[15], 1);
	TextDrawSetSelectable(PhoneTD[15], 0);

	PhoneTD[16] = TextDrawCreate(491.000000, 151.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[16], 4);
	TextDrawLetterSize(PhoneTD[16], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[16], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[16], 1);
	TextDrawSetShadow(PhoneTD[16], 0);
	TextDrawAlignment(PhoneTD[16], 1);
	TextDrawColor(PhoneTD[16], 1296911871);
	TextDrawBackgroundColor(PhoneTD[16], 255);
	TextDrawBoxColor(PhoneTD[16], -16777166);
	TextDrawUseBox(PhoneTD[16], 1);
	TextDrawSetProportional(PhoneTD[16], 1);
	TextDrawSetSelectable(PhoneTD[16], 0);

	PhoneTD[17] = TextDrawCreate(491.000000, 193.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[17], 4);
	TextDrawLetterSize(PhoneTD[17], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[17], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[17], 1);
	TextDrawSetShadow(PhoneTD[17], 0);
	TextDrawAlignment(PhoneTD[17], 1);
	TextDrawColor(PhoneTD[17], -16776961);
	TextDrawBackgroundColor(PhoneTD[17], 255);
	TextDrawBoxColor(PhoneTD[17], -16777166);
	TextDrawUseBox(PhoneTD[17], 1);
	TextDrawSetProportional(PhoneTD[17], 1);
	TextDrawSetSelectable(PhoneTD[17], 0);

	PhoneTD[18] = TextDrawCreate(491.000000, 238.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[18], 4);
	TextDrawLetterSize(PhoneTD[18], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[18], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[18], 1);
	TextDrawSetShadow(PhoneTD[18], 0);
	TextDrawAlignment(PhoneTD[18], 1);
	TextDrawColor(PhoneTD[18], 9145343);
	TextDrawBackgroundColor(PhoneTD[18], 255);
	TextDrawBoxColor(PhoneTD[18], -16777166);
	TextDrawUseBox(PhoneTD[18], 1);
	TextDrawSetProportional(PhoneTD[18], 1);
	TextDrawSetSelectable(PhoneTD[18], 0);

	PhoneTD[19] = TextDrawCreate(416.000000, 193.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[19], 4);
	TextDrawLetterSize(PhoneTD[19], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[19], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[19], 1);
	TextDrawSetShadow(PhoneTD[19], 0);
	TextDrawAlignment(PhoneTD[19], 1);
	TextDrawColor(PhoneTD[19], -1);
	TextDrawBackgroundColor(PhoneTD[19], 1097458175);
	TextDrawBoxColor(PhoneTD[19], 1687547186);
	TextDrawUseBox(PhoneTD[19], 1);
	TextDrawSetProportional(PhoneTD[19], 1);
	TextDrawSetSelectable(PhoneTD[19], 0);

	PhoneTD[20] = TextDrawCreate(416.000000, 238.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[20], 4);
	TextDrawLetterSize(PhoneTD[20], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[20], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[20], 1);
	TextDrawSetShadow(PhoneTD[20], 0);
	TextDrawAlignment(PhoneTD[20], 1);
	TextDrawColor(PhoneTD[20], 65535);
	TextDrawBackgroundColor(PhoneTD[20], 1097458175);
	TextDrawBoxColor(PhoneTD[20], 1687547186);
	TextDrawUseBox(PhoneTD[20], 1);
	TextDrawSetProportional(PhoneTD[20], 1);
	TextDrawSetSelectable(PhoneTD[20], 0);

	PhoneTD[21] = TextDrawCreate(454.000000, 193.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[21], 4);
	TextDrawLetterSize(PhoneTD[21], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[21], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[21], 1);
	TextDrawSetShadow(PhoneTD[21], 0);
	TextDrawAlignment(PhoneTD[21], 1);
	TextDrawColor(PhoneTD[21], 1433087999);
	TextDrawBackgroundColor(PhoneTD[21], 255);
	TextDrawBoxColor(PhoneTD[21], 50);
	TextDrawUseBox(PhoneTD[21], 1);
	TextDrawSetProportional(PhoneTD[21], 1);
	TextDrawSetSelectable(PhoneTD[21], 0);

	PhoneTD[22] = TextDrawCreate(454.000000, 238.000000, "ld_beat:chit");
	TextDrawFont(PhoneTD[22], 4);
	TextDrawLetterSize(PhoneTD[22], 0.600000, 2.000000);
	TextDrawTextSize(PhoneTD[22], 40.000000, 40.000000);
	TextDrawSetOutline(PhoneTD[22], 1);
	TextDrawSetShadow(PhoneTD[22], 0);
	TextDrawAlignment(PhoneTD[22], 1);
	TextDrawColor(PhoneTD[22], -1962934017);
	TextDrawBackgroundColor(PhoneTD[22], 255);
	TextDrawBoxColor(PhoneTD[22], 50);
	TextDrawUseBox(PhoneTD[22], 1);
	TextDrawSetProportional(PhoneTD[22], 1);
	TextDrawSetSelectable(PhoneTD[22], 0);

	PhoneTD[23] = TextDrawCreate(428.000000, 186.000000, "SMS");
	TextDrawFont(PhoneTD[23], 1);
	TextDrawLetterSize(PhoneTD[23], 0.224998, 1.000000);
	TextDrawTextSize(PhoneTD[23], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[23], 1);
	TextDrawSetShadow(PhoneTD[23], 0);
	TextDrawAlignment(PhoneTD[23], 1);
	TextDrawColor(PhoneTD[23], -1);
	TextDrawBackgroundColor(PhoneTD[23], 255);
	TextDrawBoxColor(PhoneTD[23], 50);
	TextDrawUseBox(PhoneTD[23], 0);
	TextDrawSetProportional(PhoneTD[23], 1);
	TextDrawSetSelectable(PhoneTD[23], 0);

	PhoneTD[24] = TextDrawCreate(458.000000, 186.000000, "CONTACT");
	TextDrawFont(PhoneTD[24], 1);
	TextDrawLetterSize(PhoneTD[24], 0.224998, 1.000000);
	TextDrawTextSize(PhoneTD[24], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[24], 1);
	TextDrawSetShadow(PhoneTD[24], 0);
	TextDrawAlignment(PhoneTD[24], 1);
	TextDrawColor(PhoneTD[24], -1);
	TextDrawBackgroundColor(PhoneTD[24], 255);
	TextDrawBoxColor(PhoneTD[24], 50);
	TextDrawUseBox(PhoneTD[24], 0);
	TextDrawSetProportional(PhoneTD[24], 1);
	TextDrawSetSelectable(PhoneTD[24], 0);

	PhoneTD[25] = TextDrawCreate(502.000000, 186.000000, "CALL");
	TextDrawFont(PhoneTD[25], 1);
	TextDrawLetterSize(PhoneTD[25], 0.224998, 1.000000);
	TextDrawTextSize(PhoneTD[25], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[25], 1);
	TextDrawSetShadow(PhoneTD[25], 0);
	TextDrawAlignment(PhoneTD[25], 1);
	TextDrawColor(PhoneTD[25], -1);
	TextDrawBackgroundColor(PhoneTD[25], 255);
	TextDrawBoxColor(PhoneTD[25], 50);
	TextDrawUseBox(PhoneTD[25], 0);
	TextDrawSetProportional(PhoneTD[25], 1);
	TextDrawSetSelectable(PhoneTD[25], 0);

	PhoneTD[26] = TextDrawCreate(497.000000, 227.000000, "SETTING");
	TextDrawFont(PhoneTD[26], 1);
	TextDrawLetterSize(PhoneTD[26], 0.224998, 1.000000);
	TextDrawTextSize(PhoneTD[26], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[26], 1);
	TextDrawSetShadow(PhoneTD[26], 0);
	TextDrawAlignment(PhoneTD[26], 1);
	TextDrawColor(PhoneTD[26], -1);
	TextDrawBackgroundColor(PhoneTD[26], 255);
	TextDrawBoxColor(PhoneTD[26], 50);
	TextDrawUseBox(PhoneTD[26], 0);
	TextDrawSetProportional(PhoneTD[26], 1);
	TextDrawSetSelectable(PhoneTD[26], 0);

	PhoneTD[27] = TextDrawCreate(497.000000, 272.000000, "CAMERA");
	TextDrawFont(PhoneTD[27], 1);
	TextDrawLetterSize(PhoneTD[27], 0.224998, 1.000000);
	TextDrawTextSize(PhoneTD[27], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[27], 1);
	TextDrawSetShadow(PhoneTD[27], 0);
	TextDrawAlignment(PhoneTD[27], 1);
	TextDrawColor(PhoneTD[27], -1);
	TextDrawBackgroundColor(PhoneTD[27], 255);
	TextDrawBoxColor(PhoneTD[27], 50);
	TextDrawUseBox(PhoneTD[27], 0);
	TextDrawSetProportional(PhoneTD[27], 1);
	TextDrawSetSelectable(PhoneTD[27], 0);

	PhoneTD[28] = TextDrawCreate(423.000000, 227.000000, "I-BANK");
	TextDrawFont(PhoneTD[28], 1);
	TextDrawLetterSize(PhoneTD[28], 0.224998, 1.000000);
	TextDrawTextSize(PhoneTD[28], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[28], 1);
	TextDrawSetShadow(PhoneTD[28], 0);
	TextDrawAlignment(PhoneTD[28], 1);
	TextDrawColor(PhoneTD[28], -1);
	TextDrawBackgroundColor(PhoneTD[28], 255);
	TextDrawBoxColor(PhoneTD[28], 50);
	TextDrawUseBox(PhoneTD[28], 0);
	TextDrawSetProportional(PhoneTD[28], 1);
	TextDrawSetSelectable(PhoneTD[28], 0);

	PhoneTD[29] = TextDrawCreate(421.000000, 272.000000, "TWITTER");
	TextDrawFont(PhoneTD[29], 1);
	TextDrawLetterSize(PhoneTD[29], 0.224998, 1.000000);
	TextDrawTextSize(PhoneTD[29], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[29], 1);
	TextDrawSetShadow(PhoneTD[29], 0);
	TextDrawAlignment(PhoneTD[29], 1);
	TextDrawColor(PhoneTD[29], -1);
	TextDrawBackgroundColor(PhoneTD[29], 255);
	TextDrawBoxColor(PhoneTD[29], 50);
	TextDrawUseBox(PhoneTD[29], 0);
	TextDrawSetProportional(PhoneTD[29], 1);
	TextDrawSetSelectable(PhoneTD[29], 0);

	PhoneTD[30] = TextDrawCreate(467.000000, 227.000000, "GPS");
	TextDrawFont(PhoneTD[30], 1);
	TextDrawLetterSize(PhoneTD[30], 0.224998, 1.000000);
	TextDrawTextSize(PhoneTD[30], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[30], 1);
	TextDrawSetShadow(PhoneTD[30], 0);
	TextDrawAlignment(PhoneTD[30], 1);
	TextDrawColor(PhoneTD[30], -1);
	TextDrawBackgroundColor(PhoneTD[30], 255);
	TextDrawBoxColor(PhoneTD[30], 50);
	TextDrawUseBox(PhoneTD[30], 0);
	TextDrawSetProportional(PhoneTD[30], 1);
	TextDrawSetSelectable(PhoneTD[30], 0);

	PhoneTD[31] = TextDrawCreate(462.000000, 272.000000, "APP");
	TextDrawFont(PhoneTD[31], 1);
	TextDrawLetterSize(PhoneTD[31], 0.224997, 1.000000);
	TextDrawTextSize(PhoneTD[31], 555.500000, 17.000000);
	TextDrawSetOutline(PhoneTD[31], 1);
	TextDrawSetShadow(PhoneTD[31], 0);
	TextDrawAlignment(PhoneTD[31], 1);
	TextDrawColor(PhoneTD[31], -1);
	TextDrawBackgroundColor(PhoneTD[31], 255);
	TextDrawBoxColor(PhoneTD[31], 50);
	TextDrawUseBox(PhoneTD[31], 0);
	TextDrawSetProportional(PhoneTD[31], 1);
	TextDrawSetSelectable(PhoneTD[31], 0);


	phoneclosetd = TextDrawCreate(459.000000, 316.500000, "ld_beat:chit");//close
	TextDrawFont(phoneclosetd, 4);
	TextDrawLetterSize(phoneclosetd, 0.600000, 2.000000);
	TextDrawTextSize(phoneclosetd, 27.000000, 27.000000);
	TextDrawSetOutline(phoneclosetd, 1);
	TextDrawSetShadow(phoneclosetd, 0);
	TextDrawAlignment(phoneclosetd, 1);
	TextDrawColor(phoneclosetd, -1);
	TextDrawBackgroundColor(phoneclosetd, 255);
	TextDrawBoxColor(phoneclosetd, 50);
	TextDrawUseBox(phoneclosetd, 1);
	TextDrawSetProportional(phoneclosetd, 1);
	TextDrawSetSelectable(phoneclosetd, 1);

	mesaagetd = TextDrawCreate(429.000000, 163.000000, "ld_chat:goodcha");
	TextDrawFont(mesaagetd, 4);
	TextDrawLetterSize(mesaagetd, 0.600000, 2.000000);
	TextDrawTextSize(mesaagetd, 14.000000, 14.000000);
	TextDrawSetOutline(mesaagetd, 1);
	TextDrawSetShadow(mesaagetd, 0);
	TextDrawAlignment(mesaagetd, 1);
	TextDrawColor(mesaagetd, -1);
	TextDrawBackgroundColor(mesaagetd, 255);
	TextDrawBoxColor(mesaagetd, 50);
	TextDrawUseBox(mesaagetd, 1);
	TextDrawSetProportional(mesaagetd, 1);
	TextDrawSetSelectable(mesaagetd, 1);

	contactstd = TextDrawCreate(467.000000, 163.000000, "ld_chat:badchat");
	TextDrawFont(contactstd, 4);
	TextDrawLetterSize(contactstd, 0.600000, 2.000000);
	TextDrawTextSize(contactstd, 14.000000, 14.000000);
	TextDrawSetOutline(contactstd, 1);
	TextDrawSetShadow(contactstd, 0);
	TextDrawAlignment(contactstd, 1);
	TextDrawColor(contactstd, -1);
	TextDrawBackgroundColor(contactstd, 255);
	TextDrawBoxColor(contactstd, 50);
	TextDrawUseBox(contactstd, 1);
	TextDrawSetProportional(contactstd, 1);
	TextDrawSetSelectable(contactstd, 1);

	cameratd = TextDrawCreate(504.000000, 251.000000, "ld_grav:flwr");
	TextDrawFont(cameratd, 4);
	TextDrawLetterSize(cameratd, 0.600000, 2.000000);
	TextDrawTextSize(cameratd, 14.000000, 14.000000);
	TextDrawSetOutline(cameratd, 1);
	TextDrawSetShadow(cameratd, 0);
	TextDrawAlignment(cameratd, 1);
	TextDrawColor(cameratd, -1);
	TextDrawBackgroundColor(cameratd, 255);
	TextDrawBoxColor(cameratd, 50);
	TextDrawUseBox(cameratd, 1);
	TextDrawSetProportional(cameratd, 1);
	TextDrawSetSelectable(cameratd, 1);

	banktd = TextDrawCreate(429.000000, 205.000000, "HUD:radar_cash");
	TextDrawFont(banktd, 4);
	TextDrawLetterSize(banktd, 0.600000, 2.000000);
	TextDrawTextSize(banktd, 14.000000, 14.000000);
	TextDrawSetOutline(banktd, 1);
	TextDrawSetShadow(banktd, 0);
	TextDrawAlignment(banktd, 1);
	TextDrawColor(banktd, -1);
	TextDrawBackgroundColor(banktd, 255);
	TextDrawBoxColor(banktd, 50);
	TextDrawUseBox(banktd, 1);
	TextDrawSetProportional(banktd, 1);
	TextDrawSetSelectable(banktd, 1);

	settingtd = TextDrawCreate(504.000000, 205.000000, "HUD:radar_waypoint");
	TextDrawFont(settingtd, 4);
	TextDrawLetterSize(settingtd, 0.600000, 2.000000);
	TextDrawTextSize(settingtd, 14.000000, 14.000000);
	TextDrawSetOutline(settingtd, 1);
	TextDrawSetShadow(settingtd, 0);
	TextDrawAlignment(settingtd, 1);
	TextDrawColor(settingtd, -1);
	TextDrawBackgroundColor(settingtd, 255);
	TextDrawBoxColor(settingtd, 50);
	TextDrawUseBox(settingtd, 1);
	TextDrawSetProportional(settingtd, 1);
	TextDrawSetSelectable(settingtd, 1);

	twittertd = TextDrawCreate(431.000000, 249.000000, "T");
	TextDrawFont(twittertd, 1);
	TextDrawLetterSize(twittertd, 0.562500, 1.799998);
	TextDrawTextSize(twittertd, 441.000000, 49.000000);
	TextDrawSetOutline(twittertd, 1);
	TextDrawSetShadow(twittertd, 0);
	TextDrawAlignment(twittertd, 1);
	TextDrawColor(twittertd, -1);
	TextDrawBackgroundColor(twittertd, 255);
	TextDrawBoxColor(twittertd, 50);
	TextDrawUseBox(twittertd, 0);
	TextDrawSetProportional(twittertd, 1);
	TextDrawSetSelectable(twittertd, 1);

	gpstd = TextDrawCreate(467.000000, 203.000000, "G");
	TextDrawFont(gpstd, 1);
	TextDrawLetterSize(gpstd, 0.495833, 1.799998);
	TextDrawTextSize(gpstd, 480.500000, 52.500000);
	TextDrawSetOutline(gpstd, 1);
	TextDrawSetShadow(gpstd, 0);
	TextDrawAlignment(gpstd, 1);
	TextDrawColor(gpstd, -1);
	TextDrawBackgroundColor(gpstd, 255);
	TextDrawBoxColor(gpstd, 50);
	TextDrawUseBox(gpstd, 0);
	TextDrawSetProportional(gpstd, 1);
	TextDrawSetSelectable(gpstd, 1);

	calltd = TextDrawCreate(505.000000, 161.000000, "C");
	TextDrawFont(calltd, 1);
	TextDrawLetterSize(calltd, 0.495833, 1.799998);
	TextDrawTextSize(calltd, 516.000000, 17.000000);
	TextDrawSetOutline(calltd, 1);
	TextDrawSetShadow(calltd, 0);
	TextDrawAlignment(calltd, 1);
	TextDrawColor(calltd, -1);
	TextDrawBackgroundColor(calltd, 255);
	TextDrawBoxColor(calltd, 50);
	TextDrawUseBox(calltd, 0);
	TextDrawSetProportional(calltd, 1);
	TextDrawSetSelectable(calltd, 1);

	apptd = TextDrawCreate(467.000000, 249.000000, "HUD:radar_datedisco");
	TextDrawFont(apptd, 4);
	TextDrawLetterSize(apptd, 0.495833, 1.799998);
	TextDrawTextSize(apptd, 15.000000, 16.500000);
	TextDrawSetOutline(apptd, 1);
	TextDrawSetShadow(apptd, 0);
	TextDrawAlignment(apptd, 1);
	TextDrawColor(apptd, -1);
	TextDrawBackgroundColor(apptd, 255);
	TextDrawBoxColor(apptd, 50);
	TextDrawUseBox(apptd, 0);
	TextDrawSetProportional(apptd, 1);
	TextDrawSetSelectable(apptd, 1);

	//Welcome Textdraw
	WelcomeTD[0] = TextDrawCreate(320.000000, 379.000000, "_");
	TextDrawFont(WelcomeTD[0], 1);
	TextDrawLetterSize(WelcomeTD[0], 1.016666, 5.199995);
	TextDrawTextSize(WelcomeTD[0], 353.500000, 785.000000);
	TextDrawSetOutline(WelcomeTD[0], 1);
	TextDrawSetShadow(WelcomeTD[0], 0);
	TextDrawAlignment(WelcomeTD[0], 2);
	TextDrawColor(WelcomeTD[0], -1);
	TextDrawBackgroundColor(WelcomeTD[0], 255);
	TextDrawBoxColor(WelcomeTD[0], -206);
	TextDrawUseBox(WelcomeTD[0], 1);
	TextDrawSetProportional(WelcomeTD[0], 1);
	TextDrawSetSelectable(WelcomeTD[0], 0);

	WelcomeTD[1] = TextDrawCreate(320.000000, 378.000000, "_");
	TextDrawFont(WelcomeTD[1], 1);
	TextDrawLetterSize(WelcomeTD[1], 0.600000, -0.350005);
	TextDrawTextSize(WelcomeTD[1], 298.500000, 210.000000);
	TextDrawSetOutline(WelcomeTD[1], 1);
	TextDrawSetShadow(WelcomeTD[1], 0);
	TextDrawAlignment(WelcomeTD[1], 2);
	TextDrawColor(WelcomeTD[1], -1);
	TextDrawBackgroundColor(WelcomeTD[1], 255);
	TextDrawBoxColor(WelcomeTD[1], -65281);
	TextDrawUseBox(WelcomeTD[1], 1);
	TextDrawSetProportional(WelcomeTD[1], 1);
	TextDrawSetSelectable(WelcomeTD[1], 0);

	WelcomeTD[2] = TextDrawCreate(320.000000, 429.000000, "_");
	TextDrawFont(WelcomeTD[2], 1);
	TextDrawLetterSize(WelcomeTD[2], 0.600000, -0.350005);
	TextDrawTextSize(WelcomeTD[2], 298.500000, 312.500000);
	TextDrawSetOutline(WelcomeTD[2], 1);
	TextDrawSetShadow(WelcomeTD[2], 0);
	TextDrawAlignment(WelcomeTD[2], 2);
	TextDrawColor(WelcomeTD[2], -1);
	TextDrawBackgroundColor(WelcomeTD[2], 255);
	TextDrawBoxColor(WelcomeTD[2], -65281);
	TextDrawUseBox(WelcomeTD[2], 1);
	TextDrawSetProportional(WelcomeTD[2], 1);
	TextDrawSetSelectable(WelcomeTD[2], 0);

	WelcomeTD[3] = TextDrawCreate(265.000000, 381.000000, "Welcome back to");
	TextDrawFont(WelcomeTD[3], 0);
	TextDrawLetterSize(WelcomeTD[3], 0.562500, 2.000000);
	TextDrawTextSize(WelcomeTD[3], 671.500000, 67.000000);
	TextDrawSetOutline(WelcomeTD[3], 0);
	TextDrawSetShadow(WelcomeTD[3], 2);
	TextDrawAlignment(WelcomeTD[3], 1);
	TextDrawColor(WelcomeTD[3], -1);
	TextDrawBackgroundColor(WelcomeTD[3], 255);
	TextDrawBoxColor(WelcomeTD[3], 50);
	TextDrawUseBox(WelcomeTD[3], 0);
	TextDrawSetProportional(WelcomeTD[3], 1);
	TextDrawSetSelectable(WelcomeTD[3], 0);

	WelcomeTD[4] = TextDrawCreate(255.000000, 400.000000, "Great Roleplay");
	TextDrawFont(WelcomeTD[4], 0);
	TextDrawLetterSize(WelcomeTD[4], 0.562500, 2.000000);
	TextDrawTextSize(WelcomeTD[4], 671.500000, 67.000000);
	TextDrawSetOutline(WelcomeTD[4], 0);
	TextDrawSetShadow(WelcomeTD[4], 2);
	TextDrawAlignment(WelcomeTD[4], 1);
	TextDrawColor(WelcomeTD[4], -1);
	TextDrawBackgroundColor(WelcomeTD[4], 255);
	TextDrawBoxColor(WelcomeTD[4], 50);
	TextDrawUseBox(WelcomeTD[4], 0);
	TextDrawSetProportional(WelcomeTD[4], 1);
	TextDrawSetSelectable(WelcomeTD[4], 0);
}
