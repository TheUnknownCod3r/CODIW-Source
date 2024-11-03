/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3167.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:26:23 AM
*******************************************************************/

//Function Number: 1
func_10097(param_00,param_01,param_02,param_03)
{
	return isdefined(self.asm.var_4C86.var_92FA) && scripts/asm/asm::func_232B(param_01,"end");
}

//Function Number: 2
func_FFDE(param_00,param_01,param_02,param_03)
{
	return scripts/asm/asm_bb::bb_moverequested() && isdefined(self.asm.var_4C86.var_697F);
}

//Function Number: 3
func_1009B(param_00,param_01,param_02,param_03)
{
	return !isdefined(self.asm.var_4C86.var_92FA);
}

//Function Number: 4
func_3E9C(param_00,param_01,param_02)
{
	var_03 = lib_0A1E::func_235D(self.asm.var_4C86.var_92FA);
	return scripts/asm/asm::asm_lookupanimfromalias(self.asm.var_4C86.var_92FA,var_03);
}