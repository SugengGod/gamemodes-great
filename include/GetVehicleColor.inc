/*
        @Release:               GetVehicleColor
        @Release Type:  Include
        @Author:                RyDeR`
        @Last Update:   05/03/2011 - 17:49
        @Version:               2.0
*/
 
stock __AddStaticVehicle(modelid, Float: spawn_x, Float: spawn_y, Float: spawn_z, Float: z_angle, color1, color2)
{
        new
                vehicleID,
                string[16]
        ;
        vehicleID = AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2);
       
        format(string, sizeof(string), "%d-%d", color1, color2);
        setproperty(0, "", ((vehicleID * (vehicleID * 2)) / 2) + 65536, string);
       
        return vehicleID;
}
 
stock __AddStaticVehicleEx(modelid, Float: spawn_x, Float: spawn_y, Float: spawn_z, Float: z_angle, color1, color2, respawn_delay)
{
        new
                vehicleID,
                string[16]
        ;
        vehicleID = AddStaticVehicleEx(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2, respawn_delay);
       
        format(string, sizeof(string), "%d-%d", color1, color2);
        setproperty(0, "", ((vehicleID * (vehicleID * 2)) / 2) + 65536, string);
       
        return vehicleID;
}
 
stock __CreateVehicle(vehicletype, Float: x, Float: y, Float: z, Float: rotation, color1, color2, respawn_delay)
{
        new
                vehicleID,
                string[16]
        ;
        vehicleID = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay);
       
        format(string, sizeof(string), "%d-%d", color1, color2);
        setproperty(0, "", ((vehicleID * (vehicleID * 2)) / 2) + 65536, string);
       
        return vehicleID;
}
 
stock __DestroyVehicle(vehicleid)
{
        setproperty(0, "", ((vehicleid * (vehicleid * 2)) / 2) + 65536, "0-0");
        return DestroyVehicle(vehicleid);
}
 
stock __ChangeVehicleColor(vehicleid, color1, color2)
{
        new
                string[16]
        ;
        format(string, sizeof(string), "%d-%d", color1, color2);
        setproperty(0, "", ((vehicleid * (vehicleid * 2)) / 2) + 65536, string);
       
        return ChangeVehicleColor(vehicleid, color1, color2);
}
 
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
        new
                string[16]
        ;
        format(string, sizeof(string), "%d-%d", color1, color2);
        setproperty(0, "", ((vehicleid * (vehicleid * 2)) / 2) + 65536, string);
       
        if(funcidx("__OnVehicleRespray") != -1)
        {
                return CallLocalFunction("__OnVehicleRespray", "iiii", playerid, vehicleid, color1, color2);
        }
        return 1;
}
 
stock GetVehicleColor(vehicleid, &color1, &color2)
{
        if(existproperty(0, "", ((vehicleid * (vehicleid * 2)) / 2) + 65536))
        {
                new
                        string[16],
                        stringParts[2][8],
                        index
                ;
                getproperty(0, "", ((vehicleid * (vehicleid * 2)) / 2) + 65536, string);
                strunpack(string, string);
               
                if((index = strfind(string, "-", false)) != -1)
                {
                        strmid(stringParts[0], string, 0, index);
                        strmid(stringParts[1], string, (index + 1), strlen(string));
                       
                        color1 = strval(stringParts[0]);
                        color2 = strval(stringParts[1]);
                        return 1;
                }
        }
        return 0;
}
 
#define AddStaticVehicle \
        __AddStaticVehicle
 
#define AddStaticVehicleEx \
        __AddStaticVehicleEx
       
#define CreateVehicle \
        __CreateVehicle
       
#define DestroyVehicle \
        __DestroyVehicle
       
#define ChangeVehicleColor \
        __ChangeVehicleColor
       
#if defined _ALS_OnVehicleRespray
        #undef OnVehicleRespray
#else
        #define _ALS_OnVehicleRespray
#endif
 
#define OnVehicleRespray \
        __OnVehicleRespray
       
forward __OnVehicleRespray(playerid, vehicleid, color1, color2);