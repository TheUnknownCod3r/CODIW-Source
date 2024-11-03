/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\first_frame.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 122 ms
 * Timestamp: 10\27\2023 12:00:35 AM
*******************************************************************/

//Function Number: 1
main()
{
	self endon("death");
	self endon("stop_first_frame");
	self notify("killanimscript");
	self.closefile = 0;
	if(getdvarint("ai_iw7") == 1)
	{
		self aiclearanim(lib_0A1E::asm_getbodyknob(),0.3);
	}
	else
	{
		self aiclearanim(self.var_E6E6,0.3);
	}

	if(scripts\common\utility::actor_is3d())
	{
		self orientmode("face angle 3d",self.angles);
	}
	else
	{
		self orientmode("face angle",self.angles[1]);
	}

	self give_attacker_kill_rewards(self.var_1286,1,0,0);
	self.var_1286 = undefined;
	self waittill("killanimscript");
}