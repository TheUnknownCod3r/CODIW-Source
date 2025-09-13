/************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: 3534.gsc
************************/

func_139F9() {
	self endon("death");
	self endon("disconnect");
	self notify("setDodge");
	self endon("setDodge");
	self endon("removeArchetype");
	thread func_5802();
	for(;;) {
		self waittill("dodgeBegin");
		scripts\mp\utility::printgameaction("dodge",self);
		if(isdefined(self.controlsfrozen) && self.controlsfrozen == 1) {
			continue;
		}

		if(isdefined(self.usingremote) && self.usingremote != "") {
			continue;
		}

		self.dodging = 1;
		scripts\mp\missions::func_D991("ch_scout_dodge_uses");
		if(scripts\mp\utility::_hasperk("specialty_dodge_defense")) {
			self setclientomnvar("ui_light_armor",1);
		}

		thread func_139FB();
		var_00 = self getnormalizedmovement();
		for(;;) {
			if(var_00[0] > 0) {
				if(var_00[1] <= 0.7 && var_00[1] >= -0.7) {
					self setscriptablepartstate("dodge","dodge_forward");
					break;
				}

				if(var_00[0] > 0.5 && var_00[1] > 0.7) {
					self setscriptablepartstate("dodge","dodge_forward_right");
					break;
				}

				if(var_00[0] > 0.5 && var_00[1] < -0.7) {
					self setscriptablepartstate("dodge","dodge_forward_left");
					break;
				}
			}

			if(var_00[0] < 0) {
				if(var_00[1] < 0.4 && var_00[1] > -0.4) {
					self setscriptablepartstate("dodge","dodge_back");
					break;
				}

				if(var_00[0] < -0.5 && var_00[1] > 0.5) {
					self setscriptablepartstate("dodge","dodge_back_right");
					break;
				}

				if(var_00[0] < -0.5 && var_00[1] < -0.5) {
					self setscriptablepartstate("dodge","dodge_back_left");
					break;
				}
			}

			if(var_00[1] > 0.4) {
				self setscriptablepartstate("dodge","dodge_right");
				break;
			}

			if(var_00[1] < -0.4) {
				self setscriptablepartstate("dodge","dodge_left");
				break;
			}
			else
			{
				break;
			}
		}

		if(isdefined(self.var_5809)) {
			triggerfx(self.var_5809);
		}

		foreach(var_02 in level.players) {
			if(isdefined(var_02) && var_02 != self) {
				playfxontagforclients(level._effect["dash_trail"],self,"tag_shield_back",var_02);
			}
		}

		if(!self isjumping()) {
		}

		self playlocalsound("synaptic_dash");
		self playsound("synaptic_dash_npc");
		wait(1.5);
		self setscriptablepartstate("dodge","default");
	}
}

func_5802() {
	self endon("death");
	self endon("disconnect");
	self endon("removeArchetype");
	self endon("setDodge");
	for(;;) {
		var_00 = self goal_position(1);
		var_01 = self energy_getmax(1);
		if(var_00 >= var_01) {
			self setclientomnvar("ui_dodge_charges",1);
		}
		else
		{
			self setclientomnvar("ui_dodge_charges",0);
		}

		wait(0.05);
	}
}

func_139FB() {
	level endon("game_ended");
	scripts\engine\utility::waittill_any_3("dodgeEnd","death","disconnect");
	self.dodging = 0;
	if(scripts\mp\utility::_hasperk("specialty_dodge_defense")) {
		self setclientomnvar("ui_light_armor",0);
	}

	if(isdefined(self)) {
		stopfxontag(level._effect["dash_trail"],self,"tag_shield_back");
	}

	if(isdefined(self.var_5809)) {
		self.var_5809 delete();
	}
}