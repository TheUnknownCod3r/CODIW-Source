/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\_agent_common.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 12
 * Decompile Time: 466 ms
 * Timestamp: 10/27/2023 12:32:09 AM
*******************************************************************/

//Function Number: 1
codecallback_agentadded()
{
	self [[ level.initagentscriptvariables ]]();
	var_00 = "axis";
	if(level.numagents % 2 == 0)
	{
		var_00 = "allies";
	}

	level.var_C20F++;
	self sethitlocdamagetable("locdmgtable/mp_lochit_dmgtable");
	self [[ level.setagentteam ]](var_00);
	level.agentarray[level.agentarray.size] = self;
}

//Function Number: 2
codecallback_agentdamaged(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	param_01 = [[ level.agentvalidateattacker ]](param_01);
	var_0C = self [[ level.agentfunc ]]("on_damaged");
	if(isdefined(var_0C))
	{
		self [[ var_0C ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
	}
}

//Function Number: 3
codecallback_agentimpaled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	if(isdefined(level.callbackplayerimpaled))
	{
		[[ level.callbackplayerimpaled ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07);
	}
}

//Function Number: 4
codecallback_agentkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	param_01 = [[ level.agentvalidateattacker ]](param_01);
	var_0A = self [[ level.agentfunc ]]("on_killed");
	if(isdefined(var_0A))
	{
		self thread [[ var_0A ]](param_00,param_01,param_02,param_04,param_05,param_06,param_07,param_08,param_09);
	}
}

//Function Number: 5
func_00A7(param_00,param_01,param_02,param_03)
{
}

//Function Number: 6
func_00A8(param_00,param_01)
{
}

//Function Number: 7
func_00A9(param_00,param_01,param_02,param_03)
{
}

//Function Number: 8
init()
{
	initagentlevelvariables();
	scripts\mp\agents\_scriptedagents::registernotetracks();
	level thread add_agents_to_game();
}

//Function Number: 9
connectnewagent(param_00,param_01,param_02)
{
	var_03 = [[ level.getfreeagent ]](param_00);
	if(isdefined(var_03))
	{
		var_03.connecttime = gettime();
		if(isdefined(param_01))
		{
			var_03 [[ level.setagentteam ]](param_01);
		}
		else
		{
			var_03 [[ level.setagentteam ]](var_03.team);
		}

		if(isdefined(param_02))
		{
			var_03.class_override = param_02;
		}

		if(isdefined(level.agent_funcs[param_00]["onAIConnect"]))
		{
			var_03 [[ var_03 [[ level.agentfunc ]]("onAIConnect") ]]();
		}

		var_03 [[ level.addtocharactersarray ]]();
	}

	return var_03;
}

//Function Number: 10
initagentlevelvariables()
{
	level.agentarray = [];
	level.numagents = 0;
}

//Function Number: 11
add_agents_to_game()
{
	level endon("game_ended");
	level waittill("connected",var_00);
	var_01 = function_00AF();
	while(level.agentarray.size < var_01)
	{
		var_02 = addagent();
		if(!isdefined(var_02))
		{
			scripts\engine\utility::waitframe();
			continue;
		}
	}
}

//Function Number: 12
set_agent_health(param_00)
{
	self.var_1E = param_00;
	self.health = param_00;
	self.maxhealth = param_00;
}