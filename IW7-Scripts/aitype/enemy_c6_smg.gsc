/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: aitype\enemy_c6_smg.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 166 ms
 * Timestamp: 10\26\2023 11:58:16 PM
*******************************************************************/

//Function Number: 1
main()
{
	self.var_17DB = "ai//c6_assets.csv";
	self.team = "axis";
	self.type = "human";
	self.unittype = "C6";
	self.subclass = "C6";
	self.accuracy = 0.2;
	self.health = 400;
	self.objective_team = lib_0A2F::func_7BEB();
	self.objective_state = 1;
	self.secondaryweapon = "";
	self.var_101B4 = lib_0A2F::func_7BEC("pistol");
	self.behaviortreeasset = "c6";
	self.var_1FA9 = "c6";
	if(isai(self))
	{
		self _meth_82DC(250,0);
		self _meth_82DB(600,600);
	}

	self.var_394 = lib_0A2F::func_7BEC("smg");
	lib_03B7::main();
}

//Function Number: 2
spawner()
{
	self _meth_833A("axis");
}

//Function Number: 3
precache()
{
	lib_03B7::precache();
	scripts\aitypes\bt_util::init();
	lib_09FD::func_3353();
	lib_03A8::func_DEE8();
	lib_0C32::func_2371();
}