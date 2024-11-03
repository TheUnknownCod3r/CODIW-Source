/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2094.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:23:17 AM
*******************************************************************/

//Function Number: 1
main()
{
	self setmodel("body_hero_sipes");
	self attach("head_hero_sipes","",1);
	self.headmodel = "head_hero_sipes";
	self.hatmodel = "helmet_head_hero_sipes";
	self attach(self.hatmodel);
	self.var_A489 = "pack_un_jackal_pilots_zerog";
	self attach(self.var_A489);
	self.var_1FEC = "generic_human";
	self.var_1FA8 = "hero_sipes";
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
	precachemodel("body_hero_sipes");
	precachemodel("head_hero_sipes");
	precachemodel("helmet_head_hero_sipes");
	precachemodel("pack_un_jackal_pilots_zerog");
}