/*==============================================================================
         					     Colors
===============================================================================*/
#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_WHITEP 		0xFFE4C4FF
#define COLOR_ORANGE   		0xDB881AFF
#define COLOR_ORANGE2		0xFF5000FF
#define COLOR_IVORY 		0xFFFF82FF
#define COLOR_LIME 			0xD2D2ABFF
#define COLOR_BLUE			0x004BFFFF
#define COLOR_SBLUE			0x56A4E4FF
#define COLOR_LBLUE 		0x33CCFFFF
#define COLOR_RCONBLUE      0x0080FF99
#define COLOR_PURPLE2 		0x5A00FFFF
#define COLOR_PURPLE      	0xD0AEEBFF
#define COLOR_RED 			0xFF0000FF
#define COLOR_LRED 			0xE65555FF
#define COLOR_LIGHTGREEN 	0x00FF00FF
#define COLOR_YELLOW 		0xFFFF00FF
#define COLOR_YELLOW2 		0xF5DEB3FF
#define COLOR_LB 			0x15D4EDFF
#define COLOR_PINK			0xEE82EEFF
#define COLOR_PINK2		 	0xFF828200
#define COLOR_GOLD			0xFFD700FF
#define COLOR_FIREBRICK 	0xB22222FF
#define COLOR_GREEN 		0x3BBD44FF
#define COLOR_GREY			0xBABABAFF
#define COLOR_GREY2 		0x778899FF
#define COLOR_GREY3			0xC8C8C8FF
#define COLOR_DARK 			0x7A7A7AFF
#define COLOR_BROWN 		0x8B4513FF
#define COLOR_SYSTEM 		0xEFEFF7FF
#define COLOR_RADIO       	0x8D8DFFFF
#define COLOR_FAMILY		0x00F77AFF
#define ARWIN				0xC6E2FFFF
#define COLOR_CLIENT      	0xAAC4E5FF

#define FAMILY_E	"{F77AFF}"
#define PURPLE_E2	"{7348EB}"
#define RED_E 		"{FF0000}"
#define BLUE_E 		"{004BFF}"
#define SBLUE_E 	"{56A4E4}"
#define PINK_E 		"{FFB6C1}"
#define YELLOW_E 	"{FFFF00}"
#define LG_E 		"{00FF00}"
#define LB_E 		"{15D4ED}"
#define LB2_E 		"{87CEFA}"
#define GREY_E 		"{BABABA}"
#define GREY2_E 	"{778899}"
#define GREY3_E 	"{C8C8C8}"
#define DARK_E 		"{7A7A7A}"
#define WHITE_E 	"{FFFFFF}"
#define WHITEP_E 	"{FFE4C4}"
#define IVORY_E 	"{FFFF82}"
#define ORANGE_E 	"{DB881A}"
#define ORANGE_E2	"{FF5000}"
#define GREEN_E 	"{3BBD44}"
#define PURPLE_E 	"{5A00FF}"
#define LIME_E 		"{D2D2AB}"
#define LRED_E		"{E65555}"
#define DOOM_		"{F4A460}"
#define MATHS       "{3571FC}"
#define REACTIONS   "{FD4141}"
#define COLOR_GPS	"{9AD0EC}"

#define dot "{F2F853}> {F0F0F0}"

//=== Color ===
#define COLOR_RGB(%1,%2,%3,%4) (((((%1) & 0xff) << 24) | (((%2) & 0xff) << 16) | (((%3) & 0xff) << 8) | ((%4) & 0xff)))
#define StripAlpha(%0) ((%0) >>> 8)