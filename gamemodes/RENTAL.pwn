#define MAX_RENTVEH 20

new Float:rentVehicle[][3] =
{
    {1754.4746, -1862.2030, 13.5766},
    {804.8683, -1358.5912, 13.5469},
    {1693.9724, -2312.2305, 13.5469}
};

new Float:unrentVehicle[][3] =
{
    {1689.7552, -2311.7261, 13.5469},
    {804.9299, -1362.8210, 13.5469},
    {1757.7032, -1864.0552, 13.5743}
};

new Float:rentBoat[][3] =
{
    {213.6747, -1986.3925, 1.4154}
};

CMD:rentbike(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1754.4746, -1862.2030, 13.5766) && !IsPlayerInRangeOfPoint(playerid, 3.0, 804.8683, -1358.5912, 13.5469) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1693.9724, -2312.2305, 13.5469)) 
        return Error(playerid, "Kamu tidak berada di dekat penyewaan sepeda!");
        
    new str[1024];
    format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$50 / one days\n%s\t"LG_E"$200 / one days",
    GetVehicleModelName(481), 
    GetVehicleModelName(462));
                
    ShowPlayerDialog(playerid, DIALOG_RENT_BIKE, DIALOG_STYLE_TABLIST_HEADERS, "Rent Bike", str, "Rent", "Close");
    return 1;
}    

CMD:rentboat(playerid, params)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 213.6747, -1986.3925, 1.4154)) return Error(playerid, "Kamu tidak berada di dekat penyewaan Kapal!");

    new str[1024];
    format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$750 / one days\n%s\t"LG_E"$1.250 / one days\n%s\t"LG_E"$1.500 / one days",
    GetVehicleModelName(473), 
    GetVehicleModelName(453),
    GetVehicleModelName(452));
           
    ShowPlayerDialog(playerid, DIALOG_RENT_BOAT, DIALOG_STYLE_TABLIST_HEADERS, "Rent Boat", str, "Rent", "Close");
    return 1;
}