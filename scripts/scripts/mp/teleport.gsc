/***********************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: scripts\mp\teleport.gsc
***********************************/

init() {}

func_F87E() {
	thread func_13A73();
}

func_12D44() {
	self notify("teleportUnset");
	if(self.loadoutarchetype == "archetype_assassin") {
		self setscriptablepartstate("teleporttrail","neutral",0);
	}

	self motionblurhqdisable();
	scripts\mp\utility::removedamagemodifier("teleport",0);
}

func_10DFA(param_00,param_01) {
	self playanimscriptevent("power_active","teleport");
	self setscriptablepartstate("teleporttrail","active",0);
	self motionblurhqenable();
	level thread scripts\mp\battlechatter_mp::saytoself(self,"plr_perk_ftl",undefined,0.75);
	thread func_4524(0.5);
}

func_6391() {
	self playsound("ftl_teleport_npc_in");
	self playanimscriptevent("power_exit","teleport");
	self setscriptablepartstate("teleporttrail","neutral",0);
	self motionblurhqdisable();
}

func_13A73() {
	self endon("disconnect");
	self endon("teleportUnset");
	self notify("watchForTeleport");
	self endon("watchForTeleport");
	for(;;) {
		var_00 = spawnstruct();
		childthread func_13A77(var_00);
		childthread func_13A75(var_00);
		childthread func_13A74(var_00);
		childthread func_13A76(var_00);
		self waittill("teleportBeginRace");
		waittillframeend;
		if(isdefined(var_00.var_6ACF)) {
			if(isplayer(self)) {
				scripts\mp\hud_message::showerrormessage("MP_TELEPORT_FAILED");
			}

			scripts\mp\supers::refundsuper();
		}
		else if(isdefined(var_00.var_10DE6) && isdefined(var_00.var_4E59)) {
			scripts\mp\supers::refundsuper();
		}
		else if(isdefined(var_00.var_637B)) {
			self notify("teleport_success");
			func_6391();
		}
		else if(isdefined(var_00.var_10DE6)) {
			self notify("teleport_success");
			func_10DFA(var_00.areanynavvolumesloaded,var_00.var_6378);
		}

		self notify("teleportEndRace");
	}
}

func_13A77(param_00) {
	self endon("teleportEndRace");
	self waittill("teleportStart",var_01,var_02);
	param_00.var_10DE6 = 1;
	param_00.areanynavvolumesloaded = var_01;
	param_00.var_6378 = var_02;
	self notify("teleportBeginRace");
}

func_13A75(param_00) {
	self endon("teleportEndRace");
	self waittill("teleportEnd");
	param_00.var_637B = 1;
	self notify("teleportBeginRace");
}

func_13A74(param_00) {
	self endon("teleportEndRace");
	self waittill("death");
	param_00.var_4E59 = 1;
	self notify("teleportBeginRace");
}

func_13A76(param_00) {
	self endon("teleportEndRace");
	self waittill("teleportFailed");
	param_00.var_6ACF = 1;
	self notify("teleportBeginRace");
}

func_4524(param_00) {
	self endon("death");
	self endon("disconnect");
	scripts\mp\utility::giveperk("specialty_no_target");
	wait(param_00);
	scripts\mp\utility::removeperk("specialty_no_target");
}