/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\frontend.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 10
 * Decompile Time: 503 ms
 * Timestamp: 10/27/2023 12:12:32 AM
*******************************************************************/

//Function Number: 1
main()
{
	level.callbackstartgametype = ::callback_frontendstartgametype;
	level.callbackplayerconnect = ::callback_frontendplayerconnect;
	level.callbackplayerdisconnect = ::callback_frontendplayerdisconnect;
	level.callbackplayerdamage = ::callback_frontendplayerdamage;
	level.callbackplayerimpaled = ::callback_frontendplayerimpaled;
	level.callbackplayerkilled = ::callback_frontendplayerkilled;
	level.callbackplayerlaststand = ::callback_frontendplayerlaststand;
	level.callbackplayermigrated = ::callback_frontendplayermigrated;
	level.callbackhostmigration = ::callback_frontendhostmigration;
}

//Function Number: 2
callback_frontendstartgametype()
{
}

//Function Number: 3
callback_frontendplayerconnect()
{
}

//Function Number: 4
callback_frontendplayerdisconnect(param_00)
{
}

//Function Number: 5
callback_frontendplayerdamage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
}

//Function Number: 6
callback_frontendplayerimpaled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
}

//Function Number: 7
callback_frontendplayerkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
}

//Function Number: 8
callback_frontendplayerlaststand(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
}

//Function Number: 9
callback_frontendplayermigrated()
{
}

//Function Number: 10
callback_frontendhostmigration()
{
}