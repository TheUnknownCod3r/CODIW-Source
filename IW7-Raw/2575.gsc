/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2575.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:23:22 AM
*******************************************************************/

//Function Number: 1
func_9898(param_00)
{
	self.acceptablemeleefraction = 0.95;
	self.var_B627 = 36;
	self.fnismeleevalid = ::ismeleevalid;
	self.fnmeleecharge_init = ::meleecharge_init_mp;
	self.fnmeleecharge_terminate = ::meleecharge_terminate_mp;
	self.fnmeleevsplayer_init = ::meleevsplayer_init_mp;
	self.fnmeleevsplayer_terminate = ::meleevsplayer_terminate_mp;
	self.fncanmovefrompointtopoint = ::canmovefrompointtopoint;
	return level.success;
}

//Function Number: 2
canmovefrompointtopoint(param_00,param_01)
{
	var_02 = navtrace(param_00,param_01,self,1);
	var_03 = var_02["fraction"];
	if(var_03 >= self.acceptablemeleefraction)
	{
		var_04 = 0;
	}
	else
	{
		var_04 = 1;
	}

	return !var_04;
}

//Function Number: 3
ismeleevalid(param_00,param_01)
{
	if(scripts/asm/asm_bb::bb_ismissingaleg())
	{
		return 0;
	}

	if(!scripts/aitypes/melee::ismeleevalid_common(param_00,param_01))
	{
		return 0;
	}

	var_02 = scripts/aitypes/melee::gettargetchargepos(param_00);
	if(!isdefined(var_02))
	{
		return 0;
	}

	if(!canmovefrompointtopoint(self.origin,var_02))
	{
		return 0;
	}

	return 1;
}

//Function Number: 4
meleecharge_init_mp(param_00)
{
	self scragentsetscripted(1);
}

//Function Number: 5
meleecharge_terminate_mp(param_00)
{
	self scragentsetscripted(0);
	self _meth_8484();
}

//Function Number: 6
meleevsplayer_init_mp(param_00)
{
	self scragentsetscripted(1);
}

//Function Number: 7
meleevsplayer_terminate_mp(param_00)
{
	self scragentsetscripted(0);
	self _meth_8484();
}