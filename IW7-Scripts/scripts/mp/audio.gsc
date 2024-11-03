/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\audio.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 6
 * Decompile Time: 339 ms
 * Timestamp: 10/27/2023 12:14:28 AM
*******************************************************************/

//Function Number: 1
init_audio()
{
	if(!isdefined(level.audio))
	{
		level.audio = spawnstruct();
	}

	init_reverb();
	level.onplayerconnectaudioinit = ::onplayerconnectaudioinit;
}

//Function Number: 2
onplayerconnectaudioinit()
{
	apply_reverb("default");
}

//Function Number: 3
init_reverb()
{
	add_reverb("default","generic",0.15,0.9,2);
}

//Function Number: 4
add_reverb(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = [];
	is_roomtype_valid(param_01);
	var_05["roomtype"] = param_01;
	var_05["wetlevel"] = param_02;
	var_05["drylevel"] = param_03;
	var_05["fadetime"] = param_04;
	level.audio.reverb_settings[param_00] = var_05;
}

//Function Number: 5
is_roomtype_valid(param_00)
{
}

//Function Number: 6
apply_reverb(param_00)
{
	if(!isdefined(level.audio.reverb_settings[param_00]))
	{
		var_01 = level.audio.reverb_settings["default"];
		return;
	}

	var_01 = level.audio.reverb_settings[var_01];
}