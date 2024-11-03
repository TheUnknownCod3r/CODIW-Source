/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\zombie_skeleton\zombie_skeleton.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 8
 * Decompile Time: 431 ms
 * Timestamp: 10/27/2023 12:11:30 AM
*******************************************************************/

//Function Number: 1
zombie_skeleton_init()
{
	registerscriptedagent();
	level.agent_funcs["skeleton"]["on_damaged"] = ::scripts/cp/agents/gametype_zombie::onzombiedamaged;
	level.agent_funcs["skeleton"]["gametype_on_damage_finished"] = ::scripts/cp/agents/gametype_zombie::onzombiedamagefinished;
	level.agent_funcs["skeleton"]["gametype_on_killed"] = ::scripts/cp/agents/gametype_zombie::onzombiekilled;
	level.movemodefunc["skeleton"] = ::scripts/cp/agents/gametype_zombie::run_if_last_zombie;
}

//Function Number: 2
registerscriptedagent()
{
	scripts/aitypes/bt_util::init();
	func_AEB0();
	thread func_FAB0();
}

//Function Number: 3
func_FAB0()
{
	level endon("game_ended");
	if(!isdefined(level.agent_definition))
	{
		level waittill("scripted_agents_initialized");
	}

	level.agent_definition["skeleton"]["setup_func"] = ::setupagent;
	level.agent_definition["skeleton"]["setup_model_func"] = ::func_FACE;
	level.agent_funcs["skeleton"]["on_damaged_finished"] = ::scripts\mp\agents\zombie\zmb_zombie_agent::onzombiedamagefinished;
	level.agent_funcs["skeleton"]["on_killed"] = ::scripts\mp\agents\zombie\zmb_zombie_agent::onzombiekilled;
}

//Function Number: 4
setupagent()
{
	scripts\mp\agents\zombie\zmb_zombie_agent::setupagent();
	self.is_skeleton = 1;
}

//Function Number: 5
func_899C()
{
	self endon("death");
	level waittill("game_ended");
	self clearpath();
	foreach(var_04, var_01 in self.var_164D)
	{
		var_02 = var_01.var_4BC0;
		var_03 = level.asm[var_04].states[var_02];
		scripts/asm/asm::func_2388(var_04,var_02,var_03,var_03.var_116FB);
		scripts/asm/asm::func_238A(var_04,"idle",0.2,undefined,undefined,undefined);
	}
}

//Function Number: 6
func_FACE(param_00)
{
	if(isdefined(level.skeleton_model_override))
	{
		self setmodel(level.skeleton_model_override);
	}
	else
	{
		self setmodel("fullbody_zmb_skeleton");
	}

	thread scripts\mp\agents\zombie\zmb_zombie_agent::func_50EF();
}

//Function Number: 7
func_AEB0()
{
}

//Function Number: 8
should_spawn_skeleton()
{
	return undefined;
}