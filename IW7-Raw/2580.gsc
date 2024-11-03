/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2580.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 6
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:23:23 AM
*******************************************************************/

//Function Number: 1
func_98C5(param_00)
{
	self.var_10264 = 1;
	setupdestructibledoors();
	return level.success;
}

//Function Number: 2
setupdestructibledoors()
{
	if(isdefined(self.var_2AB4))
	{
		thread func_4D5E();
	}

	if(isdefined(self.var_2AB5))
	{
		thread func_5670();
	}
}

//Function Number: 3
func_4D5E()
{
	self endon("death");
	self endon("terminate_ai_threads");
	var_00 = 0;
	for(;;)
	{
		self waittill("damage_part_died",var_01);
		for(var_02 = 0;var_02 < var_01.size;var_02++)
		{
			var_03 = var_01[var_02];
			var_04 = var_02 < 3;
			func_C924(var_03,var_04);
			var_01[var_02] = undefined;
		}

		var_01 = undefined;
	}
}

//Function Number: 4
func_C924(param_00,param_01)
{
	var_02 = param_00.var_4E;
	self hidepart(param_00.updategamerprofileall);
	var_03 = anglestoup(self gettagangles(param_00.updategamerprofileall));
}

//Function Number: 5
func_5670()
{
	self endon("death");
	self endon("terminate_ai_threads");
	for(;;)
	{
		self waittill("dismemberment_part_died",var_00);
		foreach(var_02 in var_00)
		{
			func_5673(var_02);
		}

		var_00 = undefined;
	}
}

//Function Number: 6
func_5673(param_00)
{
	switch(param_00.updategamerprofileall)
	{
		case "right_arm":
			break;
	}

	self._blackboard.var_5663 = 1;
	scripts/asm/asm_bb::bb_dismemberedpart(param_00.updategamerprofileall);
	self _meth_8189(param_00.var_332);
}