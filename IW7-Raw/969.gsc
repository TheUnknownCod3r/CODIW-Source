/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 969.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:32:16 AM
*******************************************************************/

//Function Number: 1
main()
{
	self setmodel("body_civ_facility_worker_drk");
	self attach("head_bg_var_head_bg_male_06_head_male_bc_04_blast_damage","",1);
	self.headmodel = "head_bg_var_head_bg_male_06_head_male_bc_04_blast_damage";
	self.var_1FEC = "generic_human";
	self.var_1FA8 = "civilian";
	self.voice = "unitednations";
	self give_explosive_touch_on_revived("cloth");
	if(issentient(self))
	{
		self sethitlocdamagetable("locdmgtable/ai_lochit_dmgtable");
	}

	self glinton(#animtree);
}

//Function Number: 2
precache()
{
	precachemodel("body_civ_facility_worker_drk");
	precachemodel("head_bg_var_head_bg_male_06_head_male_bc_04_blast_damage");
}