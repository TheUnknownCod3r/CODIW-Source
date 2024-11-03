/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2089.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:23:16 AM
*******************************************************************/

//Function Number: 1
main()
{
	self setmodel("body_un_jackal_pilots");
	scripts\code\character::attachhead("alias_heads_un_jackal_pilots_pt1",lib_09CA::main());
	self.hatmodel = "helmet_un_jackal_pilots_generic";
	self attach(self.hatmodel);
	self.var_A489 = "pack_un_jackal_pilots";
	self attach(self.var_A489);
	self.var_1FEC = "generic_human";
	self.var_1FA8 = "soldier";
	self.voice = "unitednationshelmet";
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
	precachemodel("body_un_jackal_pilots");
	scripts\code\character::precachemodelarray(lib_09CA::main());
	precachemodel("helmet_un_jackal_pilots_generic");
	precachemodel("pack_un_jackal_pilots");
}