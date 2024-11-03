/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\obj_capture.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 12
 * Decompile Time: 631 ms
 * Timestamp: 10/27/2023 12:12:53 AM
*******************************************************************/

//Function Number: 1
init()
{
	var_00 = spawnstruct();
	var_00.pickuptime = 0.5;
	var_00.usetextfriendly = &"MP_RETURNING_FLAG";
	var_00.usetextenemy = &"MP_GRABBING_FLAG";
	var_00.onpickupfn = ::onobjectpickup;
	var_00.ondropfn = ::onobjectdrop;
	var_00.onresetfn = ::onobjectreset;
	var_00.ondelivered = ::onobjectdelivered;
	var_00.pickupicon = "waypoint_capture_take";
	var_00.delivertime = 0.5;
	level.objectivesettings["ctf"] = var_00;
}

//Function Number: 2
createcaptureobjective(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = level.objectivesettings["ctf"];
	}

	var_03 = createcarryobject(param_00,param_01,param_02);
	var_04 = creategoal(var_03.visuals[0].target,var_03,param_01,param_02);
	var_03.objective_icon = var_04;
}

//Function Number: 3
createcarryobject(param_00,param_01,param_02)
{
	var_03 = getent(param_00,"targetname");
	if(!isdefined(var_03))
	{
		scripts\engine\utility::error("No model named " + param_00 + " found!");
		return;
	}

	var_04 = spawn("trigger_radius",var_03.origin,0,96,120);
	var_05 = scripts\mp\_gameobjects::createcarryobject(param_01,var_04,[var_03],(0,0,85));
	var_05 scripts\mp\_gameobjects::setteamusetime("friendly",param_02.pickuptime);
	var_05 scripts\mp\_gameobjects::setteamusetime("enemy",param_02.pickuptime);
	var_05 scripts\mp\_gameobjects::setteamusetext("enemy",param_02.usetextfriendly);
	var_05 scripts\mp\_gameobjects::setteamusetext("friendly",param_02.usetextenemy);
	var_05 scripts\mp\_gameobjects::allowcarry("enemy");
	var_05 scripts\mp\_gameobjects::set2dicon("enemy",param_02.pickupicon);
	var_05 scripts\mp\_gameobjects::set3dicon("enemy",param_02.pickupicon);
	var_05 scripts\mp\_gameobjects::setvisibleteam("enemy");
	var_05.objidpingenemy = 1;
	var_05.allowweapons = 1;
	var_05.onpickup = param_02.onpickupfn;
	var_05.onpickupfailed = param_02.onpickupfailfn;
	var_05.ondrop = param_02.ondropfn;
	var_05.onreset = param_02.onresetfn;
	var_05.settings = param_02;
	if(!isdefined(param_02.carrymodel))
	{
		param_02.carrymodel = var_03.model;
	}

	var_05 give_player_tickets(1);
	var_05 setnonstick(1);
	return var_05;
}

//Function Number: 4
creategoal(param_00,param_01,param_02,param_03)
{
	var_04 = getent(param_00,"targetname");
	if(!isdefined(var_04))
	{
		scripts\engine\utility::error("No goal trigger named " + var_04 + " found!");
		return;
	}

	var_05 = scripts\mp\_gameobjects::createuseobject(param_02,var_04,[],(0,0,85));
	var_05 scripts\mp\_gameobjects::allowuse("enemy");
	var_05 scripts\mp\_gameobjects::setvisibleteam("any");
	var_05 scripts\mp\_gameobjects::set2dicon("friendly","waypoint_blitz_defend");
	var_05 scripts\mp\_gameobjects::set3dicon("friendly","waypoint_blitz_defend");
	var_05 scripts\mp\_gameobjects::set2dicon("enemy","waypoint_blitz_goal");
	var_05 scripts\mp\_gameobjects::set3dicon("enemy","waypoint_blitz_goal");
	var_05 scripts\mp\_gameobjects::setusetime(param_03.delivertime);
	var_05 scripts\mp\_gameobjects::setkeyobject(param_01);
	var_05.onuse = param_03.ondelivered;
	var_05.settings = param_03;
	return var_05;
}

//Function Number: 5
onobjectpickup(param_00)
{
	if(param_00.team == scripts\mp\_gameobjects::getownerteam())
	{
		scripts\mp\_gameobjects::returnobjectiveid();
		return;
	}

	param_00 attachobjecttocarrier(self.settings.carrymodel);
	scripts\mp\_gameobjects::setvisibleteam("any");
	scripts\mp\_gameobjects::set2dicon("friendly","waypoint_capture_kill");
	scripts\mp\_gameobjects::set3dicon("friendly","waypoint_capture_kill");
	scripts\mp\_gameobjects::set2dicon("enemy","waypoint_escort");
	scripts\mp\_gameobjects::set3dicon("enemy","waypoint_escort");
}

//Function Number: 6
onobjectdrop(param_00)
{
	scripts\mp\_gameobjects::allowcarry("any");
	scripts\mp\_gameobjects::setvisibleteam("any");
	scripts\mp\_gameobjects::set2dicon("friendly","waypoint_capture_recover");
	scripts\mp\_gameobjects::set3dicon("friendly","waypoint_capture_recover");
	scripts\mp\_gameobjects::set2dicon("enemy","waypoint_capture_take");
	scripts\mp\_gameobjects::set3dicon("enemy","waypoint_capture_take");
}

//Function Number: 7
returnaftertime()
{
	if(!isdefined(self.settings.returntime))
	{
		return;
	}

	self endon("picked_up");
	wait(self.settings.returntime);
	scripts\mp\_gameobjects::returnobjectiveid();
}

//Function Number: 8
onobjectreset()
{
}

//Function Number: 9
onobjectdelivered(param_00)
{
	self.keyobject scripts\mp\_gameobjects::allowcarry("none");
	self.keyobject scripts\mp\_gameobjects::setvisibleteam("none");
	param_00 detachobjectifcarried();
	scripts\mp\_gameobjects::deleteuseobject();
}

//Function Number: 10
attachobjecttocarrier(param_00)
{
	self attach(param_00,"j_spine4",1);
	self.carriedobject = param_00;
}

//Function Number: 11
detachobjectifcarried()
{
	if(isdefined(self.carriedobject))
	{
		self detach(self.carriedobject,"j_spine4");
		self.carriedobject = undefined;
	}
}

//Function Number: 12
onplayerkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	detachobjectifcarried();
}