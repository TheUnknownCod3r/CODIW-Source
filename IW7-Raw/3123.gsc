/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3123.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:26:11 AM
*******************************************************************/

//Function Number: 1
bb_requestcombatmovetype_facemotion()
{
	self._blackboard.combatmode_old = 0;
	self._blackboard.bwantstostrafe = 0;
}

//Function Number: 2
bb_requestcombatmovetype_strafe()
{
	self._blackboard.combatmode_old = 1;
	self._blackboard.bwantstostrafe = 1;
}

//Function Number: 3
func_295B()
{
	self._blackboard.combatmode_old = 2;
	self._blackboard.bwantstostrafe = 0;
}

//Function Number: 4
func_298C()
{
	if(!isdefined(self._blackboard.combatmode_old) || self._blackboard.combatmode_old == 0)
	{
		return 1;
	}

	return 0;
}

//Function Number: 5
func_298D()
{
	if(isdefined(self._blackboard.combatmode_old) && self._blackboard.combatmode_old == 2)
	{
		return 1;
	}

	return 0;
}

//Function Number: 6
func_2979(param_00)
{
	self._blackboard.var_2AA1 = param_00;
	if(param_00)
	{
		self.dontevershoot = 1;
	}
}

//Function Number: 7
func_2921()
{
	if(!isdefined(self._blackboard.var_2AA1))
	{
		return 0;
	}

	return self._blackboard.var_2AA1;
}