/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2285.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:23:18 AM
*******************************************************************/

//Function Number: 1
main()
{
	self setmodel("body_hero_gator");
	self attach("head_hero_gator","",1);
	self.headmodel = "head_hero_gator";
	self.var_1FEC = "generic_human";
	self.var_1FA8 = "hero_gator";
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
	precachemodel("body_hero_gator");
	precachemodel("head_hero_gator");
}