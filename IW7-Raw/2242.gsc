/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2242.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:23:17 AM
*******************************************************************/

//Function Number: 1
main()
{
	scripts\code\character::setmodelfromarray(lib_0942::main());
	scripts\code\character::attachhead("heads_un_marines_male",lib_09F6::main());
	self.var_A489 = "pack_un_jackal_pilots";
	self attach(self.var_A489);
	self.var_1FEC = "generic_human";
	self.var_1FA8 = "soldier";
	self.voice = "unitednations";
	self give_explosive_touch_on_revived("vestlight");
	if(issentient(self))
	{
		self sethitlocdamagetable("locdmgtable/ai_lochit_dmgtable");
	}

	self glinton(#animtree);
}

//Function Number: 2
precache()
{
	scripts\code\character::precachemodelarray(lib_0942::main());
	scripts\code\character::precachemodelarray(lib_09F6::main());
	precachemodel("pack_un_jackal_pilots");
}