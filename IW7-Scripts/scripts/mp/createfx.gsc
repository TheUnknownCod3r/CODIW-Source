/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\createfx.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 6
 * Decompile Time: 331 ms
 * Timestamp: 10/27/2023 12:14:55 AM
*******************************************************************/

//Function Number: 1
createfx()
{
	level.func_position_player = ::scripts\engine\utility::void;
	level.func_position_player_get = ::func_position_player_get;
	level.func_loopfxthread = ::scripts\common\fx::loopfxthread;
	level.func_oneshotfxthread = ::scripts\common\fx::oneshotfxthread;
	level.func_create_loopsound = ::scripts\common\fx::create_loopsound;
	level.func_updatefx = ::scripts\common\createfx::restart_fx_looper;
	level.func_process_fx_rotater = ::scripts\common\createfx::process_fx_rotater;
	level.func_player_speed = ::func_player_speed;
	level.mp_createfx = 1;
	level.callbackstartgametype = ::scripts\engine\utility::void;
	level.callbackplayerconnect = ::scripts\engine\utility::void;
	level.callbackplayerdisconnect = ::scripts\engine\utility::void;
	level.callbackplayerdamage = ::scripts\engine\utility::void;
	level.callbackplayerkilled = ::scripts\engine\utility::void;
	level.callbackplayerlaststand = ::scripts\engine\utility::void;
	level.callbackplayerconnect = ::callback_playerconnect;
	level.callbackplayermigrated = ::scripts\engine\utility::void;
	thread reflectionprobe_hide_hp();
	thread reflectionprobe_hide_front();
	thread scripts\common\createfx::func_get_level_fx();
	scripts\common\createfx::createfx_common();
	level waittill("eternity");
}

//Function Number: 2
func_position_player_get(param_00)
{
	return level.player.origin;
}

//Function Number: 3
callback_playerconnect()
{
	self waittill("begin");
	if(!isdefined(level.player))
	{
		var_00 = getentarray("mp_global_intermission","classname");
		self spawn(var_00[0].origin,var_00[0].angles);
		scripts\mp\utility::updatesessionstate("playing","");
		self.maxhealth = 10000000;
		self.health = 10000000;
		level.player = self;
		thread scripts\common\createfx::createfxlogic();
		return;
	}

	kick(self getentitynumber());
}

//Function Number: 4
func_player_speed()
{
	var_00 = level._createfx.player_speed / 190;
	level.player setmovespeedscale(var_00);
}

//Function Number: 5
reflectionprobe_hide_hp()
{
}

//Function Number: 6
reflectionprobe_hide_front()
{
}