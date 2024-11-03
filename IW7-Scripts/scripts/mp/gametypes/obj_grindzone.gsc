/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\obj_grindzone.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 17
 * Decompile Time: 909 ms
 * Timestamp: 10/27/2023 12:12:57 AM
*******************************************************************/

//Function Number: 1
init()
{
	setuphudelements();
}

//Function Number: 2
setuphudelements()
{
	level.iconneutral3d = "waypoint_bank";
	level.iconneutral2d = "waypoint_bank";
	level.iconcapture3d = "waypoint_scoring_foe";
	level.iconcapture2d = "waypoint_scoring_foe";
	level.icondefend3d = "waypoint_scoring_friend";
	level.icondefend2d = "waypoint_scoring_friend";
	level.iconenemycontested3d = "waypoint_contested";
	level.iconenemycontested2d = "waypoint_contested";
	level.iconfriendlycontested2d = "waypoint_contested";
	level.iconfriendlycontested3d = "waypoint_contested";
}

//Function Number: 3
setupobjective(param_00)
{
	var_01 = level.objectives[param_00];
	if(isdefined(var_01.target))
	{
		var_02[0] = getent(var_01.target,"targetname");
	}
	else
	{
		param_00[0] = spawn("script_model",var_02.origin);
		var_02[0].angles = var_01.angles;
	}

	var_03 = spawn("trigger_radius",var_01.origin,0,90,128);
	var_03.script_label = var_01.script_label;
	var_01 = var_03;
	var_04 = scripts\mp\_gameobjects::createuseobject("neutral",var_01,var_02,(0,0,90));
	var_04 scripts\mp\_gameobjects::allowuse("enemy");
	var_04 scripts\mp\_gameobjects::setusetime(level.bankcapturetime);
	var_04 scripts\mp\_gameobjects::setvisibleteam("any");
	var_04 scripts\mp\_gameobjects::cancontestclaim(1);
	var_04 scripts\mp\_gameobjects::mustmaintainclaim(1);
	var_04 scripts\mp\_gameobjects::setusetext(&"MP_SECURING_POSITION");
	var_05 = var_04 scripts\mp\_gameobjects::getlabel();
	var_04.label = var_05;
	var_04.onbeginuse = ::zone_onusebegin;
	var_04.onuseupdate = ::zone_onuseupdate;
	var_04.onenduse = ::zone_onuseend;
	var_04.onuse = ::zone_onuse;
	var_04.onunoccupied = ::zone_onunoccupied;
	var_04.oncontested = ::zone_oncontested;
	var_04.onuncontested = ::zone_onuncontested;
	var_04.id = "domFlag";
	var_04.claimgracetime = level.bankcapturetime * 1000;
	var_06 = var_02[0].origin + (0,0,32);
	var_07 = var_02[0].origin + (0,0,-32);
	var_08 = scripts\common\trace::create_contents(1,1,1,1,0,1,1);
	var_09 = [];
	var_0A = scripts\common\trace::ray_trace(var_06,var_07,var_09,var_08);
	var_04.baseeffectpos = var_0A["position"];
	var_0B = vectortoangles(var_0A["normal"]);
	var_04.baseeffectforward = anglestoforward(var_0B);
	var_0C = spawn("script_model",var_04.baseeffectpos);
	var_0C setmodel("grind_flag_scriptable");
	var_0C.angles = function_02D7(var_04.baseeffectforward,var_0C.angles);
	var_04.physics_capsulecast = var_0C;
	var_04 scripts\engine\utility::delaythread(1,::setneutral);
	return var_04;
}

//Function Number: 4
setneutral()
{
	scripts\mp\_gameobjects::setownerteam("neutral");
	setneutralicons();
	updateflagstate("idle",0);
}

//Function Number: 5
zone_onusebegin(param_00)
{
	self.didstatusnotify = 0;
	thread scripts\mp\_gameobjects::useobjectdecay(param_00.team);
}

//Function Number: 6
zone_onuseupdate(param_00,param_01,param_02,param_03)
{
	var_04 = scripts\mp\_gameobjects::getownerteam();
	if(param_01 > 0.05 && param_02 && !self.didstatusnotify)
	{
		if(!isagent(param_03))
		{
			updateflagcapturestate(param_00);
		}

		self.didstatusnotify = 1;
	}
}

//Function Number: 7
zone_onuseend(param_00,param_01,param_02)
{
	var_03 = scripts\mp\_gameobjects::getownerteam();
	if(var_03 == "neutral")
	{
		setneutralicons();
		updateflagstate("idle",0);
		return;
	}

	setteamicons();
	updateflagstate(var_03,0);
}

//Function Number: 8
zone_onuse(param_00)
{
	var_01 = param_00.team;
	var_02 = scripts\mp\_gameobjects::getownerteam();
	var_03 = scripts\mp\_utility::getotherteam(var_01);
	var_04 = gettime();
	setteamicons();
	updateflagstate(var_01,0);
	scripts\mp\_gameobjects::setownerteam(var_01);
}

//Function Number: 9
zone_onunoccupied()
{
	setneutralicons();
	setneutral();
}

//Function Number: 10
zone_oncontested()
{
	setcontestedicons();
	updateflagstate("contested",0);
}

//Function Number: 11
zone_onuncontested(param_00)
{
	var_01 = scripts\mp\_gameobjects::getownerteam();
	if(param_00 == "none" || var_01 == "neutral")
	{
		setneutralicons();
	}
	else
	{
		setteamicons();
	}

	var_02 = scripts\engine\utility::ter_op(var_01 == "neutral","idle",var_01);
	updateflagstate(var_02,0);
}

//Function Number: 12
setcrankedtimerzonecap(param_00)
{
	if(isdefined(level.supportcranked) && level.supportcranked && isdefined(param_00.cranked) && param_00.cranked)
	{
		param_00 scripts\mp\_utility::setcrankedplayerbombtimer("assist");
	}
}

//Function Number: 13
setneutralicons()
{
	scripts\mp\_gameobjects::set2dicon("friendly",level.iconneutral2d + self.label);
	scripts\mp\_gameobjects::set3dicon("friendly",level.iconneutral3d + self.label);
	scripts\mp\_gameobjects::set2dicon("enemy",level.iconneutral2d + self.label);
	scripts\mp\_gameobjects::set3dicon("enemy",level.iconneutral3d + self.label);
}

//Function Number: 14
setteamicons()
{
	scripts\mp\_gameobjects::set2dicon("friendly",level.icondefend2d + self.label);
	scripts\mp\_gameobjects::set3dicon("friendly",level.icondefend3d + self.label);
	scripts\mp\_gameobjects::set2dicon("enemy",level.iconcapture2d + self.label);
	scripts\mp\_gameobjects::set3dicon("enemy",level.iconcapture3d + self.label);
}

//Function Number: 15
setcontestedicons()
{
	scripts\mp\_gameobjects::set2dicon("friendly",level.iconfriendlycontested2d + self.label);
	scripts\mp\_gameobjects::set3dicon("friendly",level.iconfriendlycontested3d + self.label);
	scripts\mp\_gameobjects::set2dicon("enemy",level.iconenemycontested2d + self.label);
	scripts\mp\_gameobjects::set3dicon("enemy",level.iconenemycontested3d + self.label);
}

//Function Number: 16
updateflagstate(param_00,param_01)
{
	self.physics_capsulecast setscriptablepartstate("flag",param_00);
	if(!scripts\mp\_utility::istrue(param_01))
	{
		self.physics_capsulecast setscriptablepartstate("pulse","off");
	}
}

//Function Number: 17
updateflagcapturestate(param_00)
{
	self.physics_capsulecast setscriptablepartstate("pulse",param_00);
}