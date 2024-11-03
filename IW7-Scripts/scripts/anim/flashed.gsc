/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\flashed.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 5
 * Decompile Time: 307 ms
 * Timestamp: 10\27\2023 12:00:36 AM
*******************************************************************/

//Function Number: 1
func_9514()
{
}

//Function Number: 2
func_7FE4()
{
	var_00 = "soldier";
	if(isdefined(self.var_1F62) && isdefined(level.var_6EC0[self.var_1F62]))
	{
		var_00 = self.var_1F62;
	}

	level.var_6EC0[var_00]++;
	if(level.var_6EC0[var_00] >= level.archetypes[var_00]["flashed"]["flashed"].size)
	{
		level.var_6EC0[var_00] = 0;
		level.archetypes[var_00]["flashed"]["flashed"] = scripts\common\utility::array_randomize(level.archetypes[var_00]["flashed"]["flashed"]);
	}

	return level.archetypes[var_00]["flashed"]["flashed"][level.var_6EC0[var_00]];
}

//Function Number: 3
func_6EC1(param_00)
{
	self endon("killanimscript");
	self _meth_82E3("flashed_anim",param_00,%body,0.2,randomfloatrange(0.9,1.1));
	scripts\anim\shared::donotetracks("flashed_anim");
}

//Function Number: 4
main()
{
	self endon("death");
	self endon("killanimscript");
	scripts\anim\utility::func_9832("flashed");
	var_00 = scripts\sp\_utility::func_6EC3();
	if(var_00 <= 0)
	{
		return;
	}

	scripts\anim\face::saygenericdialogue("flashbang");
	if(isdefined(self.var_10959))
	{
		self [[ self.var_10959 ]]();
		return;
	}

	var_01 = func_7FE4();
	func_6EC2(var_01,var_00);
}

//Function Number: 5
func_6EC2(param_00,param_01)
{
	self endon("death");
	self endon("killanimscript");
	if(self.var_1491.pose == "prone")
	{
		scripts\anim\utility::exitpronewrapper(1);
	}

	self.var_1491.pose = "stand";
	self.opcode::OP_ClearLocalVariableFieldCached0 = 1;
	thread func_6EC1(param_00);
	wait(param_01);
	self notify("stop_flashbang_effect");
	self.var_6EC9 = 0;
}