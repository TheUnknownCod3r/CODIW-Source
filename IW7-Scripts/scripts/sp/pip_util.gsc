/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\sp\pip_util.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 452 ms
 * Timestamp: 10/27/2023 12:24:53 AM
*******************************************************************/

//Function Number: 1
func_CBAA()
{
}

//Function Number: 2
func_CBB5(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(getdvarint("e3"))
	{
		return;
	}

	if(gettime() < 500)
	{
		wait(0.5);
	}

	if(!isdefined(param_01))
	{
		return;
	}

	if(!isdefined(level.var_CB9C))
	{
		level.var_CB9C = level.player getweaponattachmentarray();
	}

	if(func_CBAC())
	{
		return;
	}

	level.var_CB9C.isglassdestroyed = 1;
	level.var_CB9C.print = 1;
	level.var_CB9C.var_9E = 5000;
	level.var_CB9C.tablelookupistringbyrow = 2;
	level.var_CB9C.var_4C = 1;
	level.var_CB9C.origin_offset = (0,0,0);
	level.var_CB9C.var_42 = (0,0,0);
	level.var_CB9C.physics_setgravitydynentscalar = param_01;
	level.var_CB9C.missionsuccess = scripts\engine\utility::ter_op(isdefined(param_02),param_02,30);
	if(isdefined(param_03))
	{
		level.var_CB9C.origin_offset = param_03;
	}

	if(isdefined(param_04))
	{
		level.var_CB9C.var_42 = param_04;
	}

	level.var_CB9C.issplitscreen = param_00;
	level.var_CB9C.isenemyteam = 1;
	level.var_CB9C.nodesvisible = 1;
	setomnvar("ui_pip_static",0);
	setomnvar("ui_pip_message_text_top","script_pip_default_top");
	setomnvar("ui_pip_message_text_bottom","script_pip_default_bottom");
	setomnvar("ui_pip_message_type",1);
	if(!isdefined(param_05))
	{
		setomnvar("ui_show_pip",1);
		if(isdefined(level.player _meth_8473()))
		{
			setomnvar("ui_jackal_hide_follow_pip",1);
			return;
		}

		setomnvar("ui_jackal_hide_follow_pip",0);
	}
}

//Function Number: 3
func_2ADF(param_00)
{
	level.player playsound("ui_pip_on_hud_right");
	setomnvar("ui_pip_message_text_top","script_pip_default_top");
	setomnvar("ui_pip_message_text_bottom","script_pip_default_bottom");
	function_01F1();
	function_01C5("bg_cinematicFullScreen","0");
	function_01C5("bg_cinematicCanPause","1");
	setomnvar("ui_show_pip",1);
	wait(0.05);
	setomnvar("ui_show_pip",0);
	wait(0.05);
	setomnvar("ui_show_pip",1);
	function_003D(param_00);
	while(!function_0102())
	{
		wait(0.05);
	}

	while(function_0102())
	{
		wait(0.05);
	}

	function_01F1();
	setomnvar("ui_show_pip",0);
	level.player playsound("ui_pip_off_hud_right");
	function_01C5("bg_cinematicFullScreen","1");
	function_01C5("bg_cinematicCanPause","1");
}

//Function Number: 4
func_CBC3(param_00)
{
	level.var_CB9C.var_1A = "naked";
	level.var_CB9C.var_1B = 0.5;
	level.var_CB9C.var_386 = param_00;
}

//Function Number: 5
func_CBA3()
{
	if(getdvarint("e3"))
	{
		return;
	}

	if(!isdefined(level.var_CB9C))
	{
		return;
	}

	setomnvar("ui_show_pip",0);
	setomnvar("ui_jackal_hide_follow_pip",1);
	level.var_CB9C.isenemyteam = 0;
	level notify("pip_closed");
}

//Function Number: 6
func_CBAC()
{
	return isdefined(level.var_CB9C) && isdefined(level.var_CB9C.isenemyteam) && level.var_CB9C.isenemyteam;
}

//Function Number: 7
func_CBA5(param_00)
{
	func_6A67();
	scripts\sp\_utility::func_10347(param_00);
	func_CBA3();
}

//Function Number: 8
func_6A67(param_00)
{
	switch(tolower(self.unittype))
	{
		case "c6i":
			func_CBB5(self,"tag_eye",29,(18,7,1),(0,200,3),param_00);
			break;

		case "jackal":
			func_CBB5(self,"tag_barrel",13,(150,0,20),(8.5,180,0),param_00);
			break;

		default:
			func_CBB5(self,"tag_eye",29,(18,7,-1),(0,200,3),param_00);
			level.var_CB9C.tablelookupistringbyrow = 17;
			break;
	}
}

//Function Number: 9
func_CBC4()
{
	func_6A67();
	self waittill("close_pip");
	func_CBA3();
}