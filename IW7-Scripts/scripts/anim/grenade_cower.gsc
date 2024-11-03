/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\grenade_cower.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 189 ms
 * Timestamp: 10\27\2023 12:00:36 AM
*******************************************************************/

//Function Number: 1
main()
{
	if(getdvarint("ai_iw7",0) == 1)
	{
		scripts\asm\asm::asm_fireephemeralevent("grenade response","avoid");
		self endon("killanimscript");
		self endon("death");
		self waittill("killanimscript");
	}

	self endon("killanimscript");
	scripts\anim\utility::func_9832("grenadecower");
	if(isdefined(self.setnavlayer))
	{
		self [[ self.setnavlayer ]]();
		return;
	}

	if(self.var_1491.pose == "prone")
	{
		scripts\anim\stop::main();
		return;
	}

	self animmode("zonly_physics");
	self orientmode("face angle",self.angles[1]);
	var_00 = 0;
	if(isdefined(self.objective_position))
	{
		var_00 = angleclamp180(vectortoangles(self.var_15F.origin - self.origin)[1] - self.angles[1]);
	}
	else
	{
		var_00 = self.angles[1];
	}

	if(self.var_1491.pose == "stand")
	{
		if(isdefined(self.objective_position) && func_12895(var_00))
		{
			return;
		}

		self _meth_82E4("cowerstart",scripts\anim\utility::func_B027("grenade","cower_squat"),%body,1,0.2);
		scripts\anim\shared::donotetracks("cowerstart");
	}

	self.var_1491.pose = "crouch";
	self.var_1491.movement = "stop";
	self _meth_82E4("cower",scripts\anim\utility::func_B027("grenade","cower_squat_idle"),%body,1,0.2);
	scripts\anim\shared::donotetracks("cower");
	self waittill("never");
}

//Function Number: 2
end_script()
{
	self.navtrace = 1;
}

//Function Number: 3
func_12895(param_00)
{
	if(randomint(2) == 0)
	{
		return 0;
	}

	if(self.getcsplinepointtargetname != "none")
	{
		return 0;
	}

	var_01 = undefined;
	if(abs(param_00) > 90)
	{
		var_01 = scripts\anim\utility::func_B027("grenade","cower_dive_back");
	}
	else
	{
		var_01 = scripts\anim\utility::func_B027("grenade","cower_dive_front");
	}

	var_02 = getmovedelta(var_01,0,0.5);
	var_03 = self gettweakablevalue(var_02);
	if(!self maymovetopoint(var_03))
	{
		return 0;
	}

	self.navtrace = 0;
	self _meth_82E4("cowerstart",var_01,%body,1,0.2);
	scripts\anim\shared::donotetracks("cowerstart");
	self.navtrace = 1;
	return 1;
}